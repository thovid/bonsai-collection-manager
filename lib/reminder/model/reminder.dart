/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import '../../shared/model/model_id.dart';

import '../../worktype/model/work_type.dart';
import 'package:flutter/foundation.dart';

class DummyReminder with Reminder {
  LogWorkType get workType => LogWorkType.custom;

  String get workTypeName => "Do bonsai work";

  int dueInFrom(DateTime now) => 2;

  @override
  String resolveSubjectName(SubjectNameResolver resolver) => "Tree Name";
}

mixin Reminder {
  LogWorkType get workType;
  String get workTypeName;
  int dueInFrom(DateTime date);
  String resolveSubjectName(SubjectNameResolver resolver);
}

abstract class ReminderRepository {
  Future<List<ReminderConfiguration>> loadReminderFor(ModelID subjectId);
  Future add(ReminderConfiguration reminderConfiguration);
}

typedef SubjectNameResolver = String Function(ModelID);

class ReminderList with ChangeNotifier {
  static Future<ReminderList> load(ReminderRepository repository,
          {ModelID subjectId}) async =>
      repository.loadReminderFor(subjectId).then((reminders) =>
          ReminderList._internal(
              reminders: reminders,
              subjectId: subjectId,
              repository: repository));

  final ReminderRepository _repository;
  final List<ReminderConfiguration> _configurations;
  final ModelID subjectId;
  ReminderList._internal(
      {List<ReminderConfiguration> reminders,
      ModelID subjectId,
      ReminderRepository repository})
      : _configurations = new List<ReminderConfiguration>.from(reminders),
        subjectId = subjectId,
        _repository = repository;

  List<Reminder> get entries =>
      _configurations.map((e) => e.getReminder()).toList();

  Future<ReminderConfiguration> add(ReminderConfiguration configuration) async {
    final result = await _addToCacheAndRepository(configuration);
    notifyListeners();
    return result;
  }

  Future<ReminderConfiguration> _addToCacheAndRepository(
      ReminderConfiguration configuration) async {
    await _repository.add(configuration);
    final int index =
        _configurations.indexWhere((element) => element.id == configuration.id);
    if (index >= 0) {
      _configurations[index] = configuration;
    } else {
      _configurations.add(configuration);
    }
    _configurations.sort((a, b) => a.nextReminder.compareTo(b.nextReminder));
    return configuration;
  }
}

class UpdateableReminderConfiguration with ChangeNotifier {
  ReminderConfiguration _reminderConfiguration;

  UpdateableReminderConfiguration(ReminderConfiguration reminderConfiguration)
      : _reminderConfiguration = reminderConfiguration;

  ReminderConfiguration get value => _reminderConfiguration;
  set value(ReminderConfiguration v) {
    _reminderConfiguration = v;
    notifyListeners();
  }
}

class ReminderConfiguration with Reminder {
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

  Reminder getReminder() {
    return this;
  }

  @override
  int dueInFrom(DateTime date) => nextReminder.difference(date).inDays;

  @override
  String resolveSubjectName(SubjectNameResolver resolver) {
    return resolver(subjectID);
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
