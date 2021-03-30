/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import '../../shared/model/model_id.dart';

import '../../worktype/model/work_type.dart';
import 'package:flutter/foundation.dart';

typedef SubjectNameResolver = String Function(ModelID);

abstract class ReminderRepository {
  Future<List<ReminderConfiguration>> loadReminderFor(ModelID subjectId);
  Future add(ReminderConfiguration reminderConfiguration);
  Future<void> remove(ModelID<ReminderConfiguration> id);
}

class ReminderList with ChangeNotifier {
  static Future<ReminderList> load(ReminderRepository repository,
          {ModelID subjectId}) async =>
      repository.loadReminderFor(subjectId).then((reminders) =>
          ReminderList._internal(
              reminders: reminders,
              subjectId: subjectId,
              repository: repository));

  final ReminderRepository _repository;
  final List<Reminder> _reminders;
  final ModelID subjectId;

  ReminderList._internal(
      {List<ReminderConfiguration> reminders,
      ModelID subjectId,
      ReminderRepository repository})
      : _reminders = reminders.map((e) => Reminder(e)).toList(),
        subjectId = subjectId,
        _repository = repository;

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

  Future<void> discardReminder(Reminder entry) async {
    final id = entry.configuration.id;
    final advancedReminder = entry.configuration.advanceCurrentReminder();
    if (advancedReminder.hasEnded()) {
      _remove(id);
      return;
    }

    await add(advancedReminder);
    entry.configuration = advancedReminder;
  }

  Future<void> _remove(ModelID<ReminderConfiguration> id) async {
    _reminders.removeWhere((element) => element.configuration.id == id);
    await _repository.remove(id);
    notifyListeners();
  }

  Future<void> delete(Reminder reminder) async {
    return _remove(reminder.configuration.id);
  }
}

class Reminder with ChangeNotifier {
  ReminderConfiguration _reminderConfiguration;

  Reminder(ReminderConfiguration reminderConfiguration)
      : _reminderConfiguration = reminderConfiguration;

  LogWorkType get workType => _reminderConfiguration.workType;

  String get workTypeName => _reminderConfiguration.workTypeName;

  int dueInFrom(DateTime date) =>
      _reminderConfiguration.nextReminder.difference(date).inDays;

  String resolveSubjectName(SubjectNameResolver resolver) {
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
  final DateTime firstReminder;
  final DateTime nextReminder;
  final int numberOfPreviousReminders;
  final bool repeat;
  final int frequency;
  final FrequencyUnit frequencyUnit;
  final EndingConditionType endingConditionType;
  final DateTime endingAtDate;
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
        nextReminder.isAfter(endingAtDate)) {
      return true;
    }
    if (endingConditionType == EndingConditionType.after_repetitions &&
        numberOfPreviousReminders > endingAfterRepetitions) {
      return true;
    }

    return false;
  }

  DateTime _calculateNextReminder() {
    if (!repeat) {
      return null;
    }

    switch (frequencyUnit) {
      case FrequencyUnit.days:
        return nextReminder.add(Duration(days: frequency));
      case FrequencyUnit.weeks:
        return nextReminder.add(Duration(days: frequency * 7));
      case FrequencyUnit.months:
        return DateTime(nextReminder.year, nextReminder.month + frequency,
            nextReminder.day);
      case FrequencyUnit.years:
        return DateTime(nextReminder.year + frequency, nextReminder.month,
            nextReminder.day);
    }
    return null;
  }
}

class ReminderConfigurationBuilder with HasWorkType {
  final ModelID<ReminderConfiguration> _id;
  ModelID subjectID;
  LogWorkType workType;
  String workTypeName;
  DateTime firstReminder;
  DateTime nextReminder;
  int numberOfPreviousReminders;
  bool repeat;
  int frequency;
  FrequencyUnit frequencyUnit;
  EndingConditionType endingConditionType;
  DateTime endingAtDate;
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
            DateTime.now().add(Duration(days: 1)),
        repeat = fromConfiguration?.repeat ?? false,
        frequency = fromConfiguration?.frequency ?? 1,
        frequencyUnit = fromConfiguration?.frequencyUnit ?? FrequencyUnit.days,
        endingConditionType =
            fromConfiguration?.endingConditionType ?? EndingConditionType.never,
        endingAtDate = fromConfiguration?.endingAtDate ??
            DateTime.now().add(Duration(days: 1)),
        endingAfterRepetitions = fromConfiguration?.endingAfterRepetitions ?? 1;

  ReminderConfiguration build() {
    if (nextReminder == null) {
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
