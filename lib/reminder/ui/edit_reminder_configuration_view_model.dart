/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/foundation.dart';

import '../../shared/model/model_id.dart';
import '../../worktype/model/work_type.dart';
import '../model/reminder.dart';

typedef SetState = void Function(VoidCallback);

class EditReminderConfigurationViewModel with HasWorkType {
  final ReminderConfigurationBuilder _configurationBuilder;
  final SetState setState;

  EditReminderConfigurationViewModel(this.setState,
      {ReminderConfiguration reminderConfiguration, ModelID subjectID})
      : _configurationBuilder = ReminderConfigurationBuilder(
            fromConfiguration: reminderConfiguration)
          ..subjectID = subjectID;

  String get pageTitle => 'Create reminder';

  DateTime get firstReminder => _configurationBuilder.firstReminder;

  ValueChanged<DateTime> get firstReminderChanged => (value) => setState(() {
        _configurationBuilder.firstReminder = value;
        if (_configurationBuilder.firstReminder
            .isAfter(_configurationBuilder.endingAtDate)) {
          _configurationBuilder.endingAtDate =
              _configurationBuilder.firstReminder;
        }
      });

  DateTime get earliestFirstReminder => DateTime.now().add(Duration(days: 1));

  bool get repeat => _configurationBuilder.repeat;

  ValueChanged<bool> get repeatChanged => (value) => setState(() {
        _configurationBuilder.repeat = value;
      });

  bool get frequencyEditable => _configurationBuilder.repeat;

  String get frequency => "${_configurationBuilder.frequency}";

  ValueChanged<String> get frequencyChanged => (value) {
        final result = int.tryParse(value);
        if (result != null) {
          setState(() {
            _configurationBuilder.frequency = result;
          });
        }
      };

  FrequencyUnit get frequencyUnit => _configurationBuilder.frequencyUnit;

  ValueChanged<FrequencyUnit> get frequencyUnitChanged =>
      (value) => setState(() {
            _configurationBuilder.frequencyUnit = value;
          });

  bool get endingConditionEditable => _configurationBuilder.repeat;

  EndingConditionType get endingConditionType =>
      _configurationBuilder.endingConditionType;

  ValueChanged<EndingConditionType> get endingConditionTypeChanged =>
      (value) => setState(() {
            _configurationBuilder.endingConditionType = value;
          });

  bool get endingAtDateEditable =>
      _configurationBuilder.repeat &&
      EndingConditionType.after_date ==
          _configurationBuilder.endingConditionType;

  DateTime get endingAtDate => _configurationBuilder.endingAtDate;

  DateTime get earliestEndingAtDate => _configurationBuilder.firstReminder;

  ValueChanged<DateTime> get endingAtDateChanged => (value) => setState(() {
        _configurationBuilder.endingAtDate = value;
      });

  bool get endingAfterRepetitionsEditable =>
      _configurationBuilder.repeat &&
      EndingConditionType.after_repetitions ==
          _configurationBuilder.endingConditionType;

  String get endingAfterRepetitions =>
      "${_configurationBuilder.endingAfterRepetitions}";

  int get endingAfterRepetitionsValue =>
      _configurationBuilder.endingAfterRepetitions;

  ValueChanged<String> get endingAfterRepetitionsChanged => (value) {
        final result = int.tryParse(value);
        if (result != null) {
          setState(() {
            _configurationBuilder.endingAfterRepetitions = result;
          });
        }
      };

  @override
  LogWorkType get workType => _configurationBuilder.workType;

  @override
  String get workTypeName => _configurationBuilder.workTypeName;

  Future<ReminderConfiguration> save(ReminderList reminderList) async {
    final result = _configurationBuilder.build();
    await reminderList.add(result);
    return result;
  }

  @override
  void updateWorkType(LogWorkType workType, String workTypeName) {
    // setState(() {
    _configurationBuilder.updateWorkType(workType, workTypeName);
    //});
  }
}
