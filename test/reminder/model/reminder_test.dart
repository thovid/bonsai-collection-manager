/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';

import 'package:test/test.dart';

main() {
  final ModelID subjectId = ModelID.newId();
  test('can create reminder configuration', () {
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..frequency = 4
              ..frequencyUnit = FrequencyUnit.weeks
              ..firstReminder = DateTime.now())
            .build();

    expect(reminderConfiguration.frequency, equals(4));
    expect(reminderConfiguration.frequencyUnit, equals(FrequencyUnit.weeks));
  });

  test('sets next reminder to first reminder if not explicitly given', () {
    DateTime aDate = DateTime.now();
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()..firstReminder = aDate).build();

    expect(reminderConfiguration.nextReminder, equals(aDate));
  });

  test('keeps next reminder if explicitly given', () {
    DateTime aDate = DateTime.now();
    DateTime next = aDate.add(Duration(days: 10));
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..firstReminder = aDate
              ..nextReminder = next)
            .build();

    expect(reminderConfiguration.nextReminder, equals(next));
  });

  test('sets number of previous reminders to zero if not explicitly given', () {
    DateTime aDate = DateTime.now();
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()..firstReminder = aDate).build();

    expect(reminderConfiguration.numberOfPreviousReminders, equals(0));
  });

  test('keeps number of previous reminders if explicitly given', () {
    DateTime aDate = DateTime.now();
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..firstReminder = aDate
              ..numberOfPreviousReminders = 2)
            .build();

    expect(reminderConfiguration.numberOfPreviousReminders, equals(2));
  });

  test('can get reminder from configuration', () async {
    final DateTime today = DateTime.now();
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..subjectID = subjectId
              ..workType = LogWorkType.fertilized
              ..workTypeName = "Some work"
              ..firstReminder = today.add(Duration(days: 2)))
            .build();

    final Reminder reminder = reminderConfiguration.getReminder();
    expect(reminder.workType, equals(LogWorkType.fertilized));
    expect(reminder.workTypeName, equals("Some work"));
    expect(reminder.dueInFrom(today), equals(2));
  });

  test('uses next reminder date for due in calculation', () {
    DateTime aDate = DateTime.now();
    DateTime next = aDate.add(Duration(days: 10));
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..firstReminder = aDate
              ..nextReminder = next)
            .build();
    Reminder reminder = reminderConfiguration.getReminder();
    expect(reminder.dueInFrom(aDate), equals(10));
  });

  test('can advance day-based reminder', () {
    final today = DateTime.now();
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = true
          ..endingConditionType = EndingConditionType.never
          ..firstReminder = today
          ..frequency = 10
          ..frequencyUnit = FrequencyUnit.days)
        .build();
    final advancedReminder =
        UpdateableReminderConfiguration(reminderConfiguration)
            .advanceCurrentReminder();
    expect(advancedReminder.dueInFrom(today), equals(10));
  });

  test('can advance week-based reminder', () {
    final today = DateTime.now();
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = true
          ..endingConditionType = EndingConditionType.never
          ..firstReminder = today
          ..frequency = 4
          ..frequencyUnit = FrequencyUnit.weeks)
        .build();
    final advancedReminder =
        UpdateableReminderConfiguration(reminderConfiguration)
            .advanceCurrentReminder();
    expect(advancedReminder.dueInFrom(today), equals(28));
  });

  test('can advance month-based reminder', () {
    final today = DateTime(2021, 3, 10);
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = true
          ..endingConditionType = EndingConditionType.never
          ..firstReminder = today
          ..frequency = 1
          ..frequencyUnit = FrequencyUnit.months)
        .build();
    final advancedReminder =
        UpdateableReminderConfiguration(reminderConfiguration)
            .advanceCurrentReminder();
    expect(advancedReminder.nextReminder, equals(DateTime(2021, 4, 10)));
  });

  test('can advance year-based reminder', () {
    final today = DateTime(2021, 3, 10);
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = true
          ..endingConditionType = EndingConditionType.never
          ..firstReminder = today
          ..frequency = 2
          ..frequencyUnit = FrequencyUnit.years)
        .build();
    final advancedReminder =
        UpdateableReminderConfiguration(reminderConfiguration)
            .advanceCurrentReminder();
    expect(advancedReminder.nextReminder, equals(DateTime(2023, 3, 10)));
  });

  test(
      'returns null if advancing a reminder reaches date based ending condition',
      () {
    final today = DateTime.now();
    final reminderConfiguration =
        UpdateableReminderConfiguration((ReminderConfigurationBuilder()
              ..subjectID = subjectId
              ..repeat = true
              ..endingConditionType = EndingConditionType.after_date
              ..endingAtDate = today.add(Duration(days: 2))
              ..firstReminder = today
              ..frequency = 1
              ..frequencyUnit = FrequencyUnit.days)
            .build());

    reminderConfiguration.advanceCurrentReminder();
    reminderConfiguration.advanceCurrentReminder();
    expect(reminderConfiguration.value.nextReminder,
        equals(today.add(Duration(days: 2))));
    reminderConfiguration.advanceCurrentReminder();
    expect(reminderConfiguration.value, isNull);
  });

  test(
      'returns null if advancing a reminder reaches number of repetitions' +
          ' based ending condition', () {
    final today = DateTime.now();
    final reminderConfiguration =
        UpdateableReminderConfiguration((ReminderConfigurationBuilder()
              ..subjectID = subjectId
              ..repeat = true
              ..endingConditionType = EndingConditionType.after_repetitions
              ..endingAfterRepetitions = 2
              ..firstReminder = today
              ..frequency = 1
              ..frequencyUnit = FrequencyUnit.days)
            .build());

    reminderConfiguration.advanceCurrentReminder();
    reminderConfiguration.advanceCurrentReminder();
    expect(reminderConfiguration.value.nextReminder,
        equals(today.add(Duration(days: 2))));
    reminderConfiguration.advanceCurrentReminder();
    expect(reminderConfiguration.value, isNull);
  });

  test('returns null if a not-repeated reminder is discarded', () {
    final today = DateTime.now();
    final reminderConfiguration =
        UpdateableReminderConfiguration((ReminderConfigurationBuilder()
              ..subjectID = subjectId
              ..repeat = false
              ..firstReminder = today)
            .build());

    reminderConfiguration.advanceCurrentReminder();
    expect(reminderConfiguration.value, isNull);
  });
}
