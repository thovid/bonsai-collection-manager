/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import '../../shared/model/model_id.dart';

import '../../worktype/model/work_type.dart';
import 'package:flutter/foundation.dart';

class DummyReminder {
  String get treeName => "Tree Name";

  LogWorkType get workType => LogWorkType.custom;

  String get workTypeName => "Do bonsai work";

  int dueInFrom(DateTime now) => 2;
}

class Reminder {
  final String treeName;
  final LogWorkType workType;
  final String workTypeName;
  Reminder._internal({this.treeName, this.workType, this.workTypeName});

  int dueInFrom(DateTime date) => 2;
}

class ReminderList with ChangeNotifier {
  List<Reminder> get entries => [];
}

class ReminderConfiguration {
  final ModelID<ReminderConfiguration> id;
  final String treeName;
  final ModelID subjectID;
  final LogWorkType workType;
  final String workTypeName;
  final DateTime firstReminder;
  final bool repeat;
  final int frequency;
  final FrequencyUnit frequencyUnit;
  final EndingConditionType endingConditionType;
  final DateTime endingAtDate;
  final int endingAfterRepetitions;

  ReminderConfiguration._builder(ReminderConfigurationBuilder builder)
      : id = builder._id,
        treeName = builder.treeName,
        subjectID = builder.subjectID,
        workType = builder.workType,
        workTypeName = builder.workTypeName,
        firstReminder = builder.firstReminder,
        repeat = builder.repeat,
        frequency = builder.frequency,
        frequencyUnit = builder.frequencyUnit,
        endingConditionType = builder.endingConditionType,
        endingAtDate = builder.endingAtDate,
        endingAfterRepetitions = builder.endingAfterRepetitions;

  Reminder getReminder() {
    return Reminder._internal(
        treeName: treeName, workType: workType, workTypeName: workTypeName);
  }
}

class ReminderConfigurationBuilder with HasWorkType {
  final ModelID<ReminderConfiguration> _id;
  String treeName;
  ModelID subjectID;
  LogWorkType workType;
  String workTypeName;
  DateTime firstReminder;
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
        treeName = fromConfiguration?.treeName ?? '',
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

  ReminderConfiguration build() => ReminderConfiguration._builder(this);
}

enum FrequencyUnit { days, weeks, months, years }
enum EndingConditionType { never, after_date, after_repetitions }
