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
    final currentReminder = entry;
    final currentReminderId = currentReminder.configuration.id;
    final advancedReminder = currentReminder.advanceCurrentReminder();
    if (advancedReminder != null) {
      return add(advancedReminder);
    }
    _remove(currentReminderId);
  }

  Future<void> _remove(ModelID<ReminderConfiguration> id) async {
    //_reminders.removeWhere((element) => element.configuration.id == id);
    _reminders.removeWhere((element) => element.configuration == null);
    return _repository.remove(id);
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

  ReminderConfiguration advanceCurrentReminder() {
    if (!configuration.repeat) {
      configuration = null;
      return null;
    }

    final advancedReminder =
        (ReminderConfigurationBuilder(fromConfiguration: configuration)
              ..nextReminder = _calculateNextReminder()
              ..numberOfPreviousReminders =
                  configuration.numberOfPreviousReminders + 1)
            .build();

    if (advancedReminder.endingConditionType ==
            EndingConditionType.after_date &&
        advancedReminder.nextReminder.isAfter(advancedReminder.endingAtDate)) {
      configuration = null;
      return null;
    }
    if (advancedReminder.endingConditionType ==
            EndingConditionType.after_repetitions &&
        advancedReminder.numberOfPreviousReminders >
            advancedReminder.endingAfterRepetitions) {
      configuration = null;
      return null;
    }

    configuration = advancedReminder;
    return configuration;
  }

  DateTime _calculateNextReminder() {
    switch (configuration.frequencyUnit) {
      case FrequencyUnit.days:
        return configuration.nextReminder
            .add(Duration(days: configuration.frequency));
      case FrequencyUnit.weeks:
        return configuration.nextReminder
            .add(Duration(days: configuration.frequency * 7));
      case FrequencyUnit.months:
        return DateTime(
            configuration.nextReminder.year,
            configuration.nextReminder.month + configuration.frequency,
            configuration.nextReminder.day);
      case FrequencyUnit.years:
        return DateTime(
            configuration.nextReminder.year + configuration.frequency,
            configuration.nextReminder.month,
            configuration.nextReminder.day);
    }
    return configuration.nextReminder;
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
