/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';

import 'package:test/test.dart';


main() {
  final ModelID subjectId = ModelID.newId();
  test('can create reminder configuration', () async {
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..treeName = "My Tree"
              ..subjectID = subjectId
              ..workType = LogWorkType.fertilized
              ..workTypeName = "fertilize"
              ..frequency = 4
              ..frequencyUnit = FrequencyUnit.weeks
              ..firstReminder = DateTime.now())
            .build();

    expect(reminderConfiguration.frequency, equals(4));
    expect(reminderConfiguration.frequencyUnit, equals(FrequencyUnit.weeks));
  });

  test('can get next reminder from configuration', () async {
    final DateTime today = DateTime.now();
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..treeName = "My Tree"
              ..subjectID = subjectId
              ..workType = LogWorkType.fertilized
              ..workTypeName = "Some work"
              ..firstReminder = today.add(Duration(days: 2)))
            .build();

    final Reminder reminder = reminderConfiguration.getReminder();
    expect(reminder.workType, equals(LogWorkType.fertilized));
    expect(reminder.workTypeName, equals("Some work"));
    expect(reminder.treeName, equals("My Tree"));
    expect(reminder.dueInFrom(today), equals(2));
  });
}
