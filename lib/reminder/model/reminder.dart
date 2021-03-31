/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:date_calendar/date_calendar.dart';
import 'package:flutter/foundation.dart';

import '../../shared/dates/date_functions.dart';
import '../../shared/model/model_id.dart';
import '../../logbook/model/logbook.dart';
import '../../worktype/model/work_type.dart';

typedef SubjectNameResolver = Future<String> Function(ModelID);
typedef LookupLogbook = Future<Logbook> Function(ModelID);
typedef WorkTypeTranslator = String Function(LogWorkType, Tenses);

abstract class ReminderRepository {
  Future<List<ReminderConfiguration>> loadReminderFor(ModelID subjectId);
  Future add(ReminderConfiguration reminderConfiguration);
  Future<void> remove(ModelID<ReminderConfiguration> id);

  Future<void> removeAll(ModelID subjectId);

  Future<List<ReminderConfiguration>> loadReminders({Calendar until});
}

abstract class ReminderList {
  List<Reminder> get reminders;
  Future<void> discardReminder(Reminder reminder);
  Future<LogbookEntry> confirmReminder(
      Reminder reminder, LookupLogbook lookupLogbook,
      {WorkTypeTranslator workTypeTranslator});
}

class SingleSubjectReminderList with ReminderList, ChangeNotifier {
  static Future<SingleSubjectReminderList> load(ReminderRepository repository,
          {ModelID subjectId}) async =>
      repository.loadReminderFor(subjectId).then((reminders) =>
          SingleSubjectReminderList(
              reminders: reminders,
              subjectId: subjectId,
              repository: repository));

  final ReminderRepository _repository;
  final List<Reminder> _reminders;
  final ModelID subjectId;

  SingleSubjectReminderList(
      {List<ReminderConfiguration> reminders,
      ModelID subjectId,
      ReminderRepository repository})
      : _reminders = reminders.map((e) => Reminder(e)).toList(),
        subjectId = subjectId,
        _repository = repository;

  @override
  List<Reminder> get reminders => _reminders;

  Future<ReminderConfiguration> add(ReminderConfiguration configuration) async {
    final result = await _addToCacheAndRepository(configuration);
    notifyListeners();
    return result;
  }

  Future<ReminderConfiguration> _addToCacheAndRepository(
      ReminderConfiguration configuration) async {
    await _repository.add(configuration);
    final int index = _reminders
        .indexWhere((element) => element.configuration.id == configuration.id);
    if (index >= 0) {
      _reminders[index].configuration = configuration;
    } else {
      _reminders.add(Reminder(configuration));
    }
    _reminders.sort((a, b) =>
        a.configuration.nextReminder.compareTo(b.configuration.nextReminder));
    return configuration;
  }

  @override
  Future<void> discardReminder(Reminder reminder) async =>
      _advanceReminder(reminder);

  @override
  Future<LogbookEntry> confirmReminder(
      Reminder reminder, LookupLogbook lookupLogbook,
      {WorkTypeTranslator workTypeTranslator}) async {
    final LogbookEntry result =
        _createLogbookEntry(reminder, workTypeTranslator);
    await lookupLogbook(reminder.configuration.subjectID)
        .then((lb) => lb.add(result));
    await _advanceReminder(reminder);
    return result;
  }

  Future _advanceReminder(Reminder reminder) async {
    final id = reminder.configuration.id;
    final advancedReminder = reminder.configuration.advanceCurrentReminder();
    if (advancedReminder.hasEnded()) {
      _delete(id);
      return;
    }
    await add(advancedReminder);
    reminder.configuration = advancedReminder;
    return;
  }

  Future<void> _delete(ModelID<ReminderConfiguration> id) async {
    _reminders.removeWhere((element) => element.configuration.id == id);
    await _repository.remove(id);
    notifyListeners();
  }

  Future<void> remove(Reminder reminder) async {
    return _delete(reminder.configuration.id);
  }

  LogbookEntry _createLogbookEntry(
      Reminder reminder, WorkTypeTranslator workTypeTranslator) {
    String workTypeName = reminder.workTypeName;
    if (workTypeTranslator != null &&
        workTypeTranslator(reminder.workType, Tenses.present) == workTypeName) {
      workTypeName = workTypeTranslator(reminder.workType, Tenses.past);
    }

    return (LogbookEntryBuilder()
          ..workType = reminder.workType
          ..workTypeName = workTypeName
          ..date = GregorianCalendar.now())
        .build();
  }

  Future removeAll() async {
    _reminders.clear();
    await _repository.removeAll(subjectId);
    notifyListeners();
  }
}

class MultiSubjectReminderList with ReminderList, ChangeNotifier {
  static Future<MultiSubjectReminderList> load(ReminderRepository repository,
      {Calendar until}) async {
    final List<ReminderConfiguration> allReminders =
        await repository.loadReminders(until: until);

    final Map<ModelID, List<ReminderConfiguration>> bySubject =
        allReminders.fold(Map(), (m, e) {
      if (m[e.subjectID] == null) m[e.subjectID] = [];
      m[e.subjectID].add(e);
      return m;
    });

    return MultiSubjectReminderList._internal(
      remindersBySubject: bySubject.map(
        (key, value) => MapEntry(
          key,
          SingleSubjectReminderList(
            reminders: value,
            subjectId: key,
            repository: repository,
          ),
        ),
      ),
    );
  }

  final Map<ModelID, SingleSubjectReminderList> _remindersBySubject;

  MultiSubjectReminderList._internal(
      {Map<ModelID, SingleSubjectReminderList> remindersBySubject})
      : _remindersBySubject = remindersBySubject;

  @override
  Future<LogbookEntry> confirmReminder(
      Reminder reminder, LookupLogbook lookupLogbook,
      {WorkTypeTranslator workTypeTranslator}) async {
    final result = await _remindersBySubject[reminder.configuration.subjectID]
        .confirmReminder(reminder, lookupLogbook,
            workTypeTranslator: workTypeTranslator);
    notifyListeners();
    return result;
  }

  @override
  Future<void> discardReminder(Reminder reminder) async {
    final result = await _remindersBySubject[reminder.configuration.subjectID]
        .discardReminder(reminder);
    notifyListeners();
    return result;
  }

  @override
  List<Reminder> get reminders =>
      _remindersBySubject.values.expand((element) => element.reminders).toList()
        ..sort((a, b) => a.configuration.nextReminder
            .compareTo(b.configuration.nextReminder));
}

class Reminder with ChangeNotifier {
  ReminderConfiguration _reminderConfiguration;

  Reminder(ReminderConfiguration reminderConfiguration)
      : _reminderConfiguration = reminderConfiguration;

  LogWorkType get workType => _reminderConfiguration.workType;

  String get workTypeName => _reminderConfiguration.workTypeName;

  int dueInFrom(Calendar date) =>
      differenceInDays(_reminderConfiguration.nextReminder, date);

  Future<String> resolveSubjectName(SubjectNameResolver resolver) {
    return resolver(_reminderConfiguration.subjectID);
  }

  ReminderConfiguration get configuration => _reminderConfiguration;

  set configuration(ReminderConfiguration v) {
    _reminderConfiguration = v;
    notifyListeners();
  }
}

class ReminderConfiguration {
  final ModelID<ReminderConfiguration> id;
  final ModelID subjectID;
  final LogWorkType workType;
  final String workTypeName;
  final Calendar firstReminder;
  final Calendar nextReminder;
  final int numberOfPreviousReminders;
  final bool repeat;
  final int frequency;
  final FrequencyUnit frequencyUnit;
  final EndingConditionType endingConditionType;
  final Calendar endingAtDate;
  final int endingAfterRepetitions;

  ReminderConfiguration._builder(ReminderConfigurationBuilder builder)
      : id = builder._id,
        subjectID = builder.subjectID,
        workType = builder.workType,
        workTypeName = builder.workTypeName,
        firstReminder = builder.firstReminder,
        nextReminder = builder.nextReminder,
        numberOfPreviousReminders = builder.numberOfPreviousReminders,
        repeat = builder.repeat,
        frequency = builder.frequency,
        frequencyUnit = builder.frequencyUnit,
        endingConditionType = builder.endingConditionType,
        endingAtDate = builder.endingAtDate,
        endingAfterRepetitions = builder.endingAfterRepetitions;

  ReminderConfiguration advanceCurrentReminder() {
    return (ReminderConfigurationBuilder(fromConfiguration: this)
          ..nextReminder = _calculateNextReminder()
          ..numberOfPreviousReminders = numberOfPreviousReminders + 1)
        .build();
  }

  bool hasEnded() {
    if (!repeat && numberOfPreviousReminders > 0) {
      return true;
    }

    if (endingConditionType == EndingConditionType.after_date &&
        nextReminder.compareTo(endingAtDate) > 0) {
      return true;
    }
    if (endingConditionType == EndingConditionType.after_repetitions &&
        numberOfPreviousReminders > endingAfterRepetitions) {
      return true;
    }

    return false;
  }

  Calendar _calculateNextReminder() {
    if (!repeat) {
      return null;
    }

    switch (frequencyUnit) {
      case FrequencyUnit.days:
        return nextReminder.addDays(frequency);
      case FrequencyUnit.weeks:
        return nextReminder.addWeeks(frequency);
      case FrequencyUnit.months:
        return GregorianCalendar(nextReminder.year,
            nextReminder.month + frequency, nextReminder.day);
      case FrequencyUnit.years:
        return GregorianCalendar(nextReminder.year + frequency,
            nextReminder.month, nextReminder.day);
    }
    return null;
  }
}

class ReminderConfigurationBuilder with HasWorkType {
  final ModelID<ReminderConfiguration> _id;
  ModelID subjectID;
  LogWorkType workType;
  String workTypeName;
  Calendar firstReminder;
  Calendar nextReminder;
  int numberOfPreviousReminders;
  bool repeat;
  int frequency;
  FrequencyUnit frequencyUnit;
  EndingConditionType endingConditionType;
  Calendar endingAtDate;
  int endingAfterRepetitions;

  ReminderConfigurationBuilder(
      {ReminderConfiguration fromConfiguration, String id})
      : _id = ModelID<ReminderConfiguration>.fromID(id) ??
            fromConfiguration?.id ??
            ModelID<ReminderConfiguration>.newId(),
        subjectID = fromConfiguration?.subjectID,
        workType = fromConfiguration?.workType ?? LogWorkType.custom,
        workTypeName = fromConfiguration?.workTypeName,
        firstReminder = fromConfiguration?.firstReminder ??
            GregorianCalendar.now().addDays(1),
        nextReminder = fromConfiguration?.nextReminder,
        numberOfPreviousReminders =
            fromConfiguration?.numberOfPreviousReminders,
        repeat = fromConfiguration?.repeat ?? false,
        frequency = fromConfiguration?.frequency ?? 1,
        frequencyUnit = fromConfiguration?.frequencyUnit ?? FrequencyUnit.days,
        endingConditionType =
            fromConfiguration?.endingConditionType ?? EndingConditionType.never,
        endingAtDate = fromConfiguration?.endingAtDate ??
            GregorianCalendar.now().addDays(1),
        endingAfterRepetitions = fromConfiguration?.endingAfterRepetitions ?? 1;

  ReminderConfiguration build() {
    if (nextReminder == null || nextReminder.compareTo(firstReminder) < 0) {
      nextReminder = firstReminder;
    }
    if (numberOfPreviousReminders == null) {
      numberOfPreviousReminders = 0;
    }
    return ReminderConfiguration._builder(this);
  }

  @override
  void updateWorkType(LogWorkType workType, String workTypeName) {
    this.workType = workType;
    this.workTypeName = workTypeName;
  }
}

enum FrequencyUnit { days, weeks, months, years }
enum EndingConditionType { never, after_date, after_repetitions }
