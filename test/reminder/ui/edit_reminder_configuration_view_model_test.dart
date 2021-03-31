/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/reminder/ui/edit_reminder_configuration_view_model.dart';
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';
import 'package:date_calendar/date_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

import '../../utils/test_utils.dart';

main() {
  group('model without existing configuration', () {
    EditReminderConfigurationViewModel model;
    SetStateMock setStateMock;

    setUp(() {
      setStateMock = SetStateMock();
      model = EditReminderConfigurationViewModel(setStateMock.setState);
    });

    test('has title', () {
      expect(model.pageTitle, equals('Create reminder'));
    });

    test('has first reminder set to tomorrow', () {
      expect(model.firstReminder, equals(GregorianCalendar.now().addDays(1)));
    });

    test('earliest first reminder is tomorrow', () {
      expect(model.earliestFirstReminder,
          equals(GregorianCalendar.now().addDays(1)));
    });

    test('can update first reminder', () {
      final value = GregorianCalendar.now().addWeeks(4);
      model.firstReminderChanged(value.toDateTimeLocal());
      expect(model.firstReminder, equals(value));
      expect(setStateMock.called, isTrue);
    });

    test('can set and get repeat value', () {
      expect(model.repeat, isFalse);
      model.repeatChanged(true);
      expect(model.repeat, isTrue);
      expect(setStateMock.called, isTrue);
    });

    test('frequency is editable if reminder is repeated', () {
      expect(model.frequencyEditable, isFalse);
      model.repeatChanged(true);
      expect(model.frequencyEditable, isTrue);
    });

    test('can set and get frequency', () {
      model.repeatChanged(true);
      expect(model.frequency, equals("1"));
      model.frequencyChanged("4");
      expect(model.frequency, equals("4"));
      expect(setStateMock.called, isTrue);
    });

    test('frequency is not changed if value is not a number', () {
      model.repeatChanged(true);
      model.frequencyChanged("1");
      setStateMock.reset();
      model.frequencyChanged("abc");
      expect(model.frequency, equals("1"));
      expect(setStateMock.called, isFalse);
    });

    test('can set and get frequency unit', () {
      model.repeatChanged(true);
      model.frequencyUnitChanged(FrequencyUnit.months);
      expect(model.frequencyUnit, equals(FrequencyUnit.months));
      expect(setStateMock.called, isTrue);
    });

    test('ending condition editable if reminder is repeated', () {
      expect(model.endingConditionEditable, isFalse);
      model.repeatChanged(true);
      expect(model.endingConditionEditable, isTrue);
    });

    test('can set and get ending condition type', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_repetitions);
      expect(model.endingConditionType,
          equals(EndingConditionType.after_repetitions));
      expect(setStateMock.called, isTrue);
    });

    test('ending at date is editable if ending condition is end at date', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.never);
      expect(model.endingAtDateEditable, isFalse);
      model.endingConditionTypeChanged(EndingConditionType.after_date);
      expect(model.endingAtDateEditable, isTrue);
    });

    test('earliest ending date is the same as date of first reminder', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_date);
      final reminderDate = GregorianCalendar.now().addDays(23);
      model.firstReminderChanged(reminderDate.toDateTimeLocal());
      expect(model.earliestEndingAtDate, equals(reminderDate));
    });

    test('can set and get ending date', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_date);
      final endDate = GregorianCalendar.now().addDays(2);
      model.endingAtDateChanged(endDate.toDateTimeLocal());
      expect(model.endingAtDate, equals(endDate));
      expect(setStateMock.called, isTrue);
    });

    test(
        'changing the first reminder date so that it is still ' +
            'before the ending date does not change the ending date', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_date);
      model.firstReminderChanged(
          GregorianCalendar.now().addDays(1).toDateTimeLocal());
      final endingDate = GregorianCalendar.now().addDays(30);
      model.endingAtDateChanged(endingDate.toDateTimeLocal());
      model.firstReminderChanged(
          GregorianCalendar.now().addDays(10).toDateTimeLocal());
      expect(model.endingAtDate, equals(endingDate));
    });

    test(
        'changing the first reminder date to be later ' +
            'than the current ending date changes the current ending date', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_date);
      model.firstReminderChanged(
          GregorianCalendar.now().addDays(1).toDateTimeLocal());
      final firstEndDate = GregorianCalendar.now().addDays(2).toDateTimeLocal();
      model.endingAtDateChanged(firstEndDate);
      final newReminderDate = GregorianCalendar.now().addDays(4);
      model.firstReminderChanged(newReminderDate.toDateTimeLocal());

      expect(model.earliestEndingAtDate, equals(newReminderDate));
      expect(model.endingAtDate, equals(newReminderDate));
    });

    test(
        'number of repetitions is only editable if ' +
            'ending condition is end after number of repetitions', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_date);
      expect(model.endingAfterRepetitionsEditable, isFalse);
      model.endingConditionTypeChanged(EndingConditionType.after_repetitions);
      expect(model.endingAfterRepetitionsEditable, isTrue);
    });

    test('can set and get number of repetitions', () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_repetitions);
      setStateMock.reset();
      model.endingAfterRepetitionsChanged("5");
      expect(model.endingAfterRepetitions, equals("5"));
      expect(setStateMock.called, isTrue);
    });

    test('ending after repetitions is not changed if value is not a number',
        () {
      model.repeatChanged(true);
      model.endingConditionTypeChanged(EndingConditionType.after_repetitions);
      model.endingAfterRepetitionsChanged("5");
      setStateMock.reset();
      model.endingAfterRepetitionsChanged("1a");
      expect(model.endingAfterRepetitions, equals("5"));
      expect(setStateMock.called, isFalse);
    });
  });

  group('model created from existing configuration', () {
    final ReminderConfiguration initialConfiguration =
        (ReminderConfigurationBuilder()
              ..repeat = true
              ..endingConditionType = EndingConditionType.never
              ..frequency = 1
              ..frequencyUnit = FrequencyUnit.days
              ..firstReminder = GregorianCalendar.now().addDays(-5)
              ..numberOfPreviousReminders = 5
              ..nextReminder = GregorianCalendar.now())
            .build();
    EditReminderConfigurationViewModel model;
    SetStateMock setStateMock;

    setUp(() {
      setStateMock = SetStateMock();
      model = EditReminderConfigurationViewModel(setStateMock.setState,
          reminderConfiguration: initialConfiguration);
    });

    test('keeps next reminder date if date is not changed', () async {
      model.updateWorkType(LogWorkType.pruned, "Pruned");
      final updatedConfiguration =
          await model.saveIn(await loadReminderListWith([]));

      expect(updatedConfiguration.nextReminder,
          equals(initialConfiguration.nextReminder));
      expect(updatedConfiguration.numberOfPreviousReminders,
          equals(initialConfiguration.numberOfPreviousReminders));
    });

    test(
        'updates next reminder if first reminder date is changed to be ' +
            'after next reminder', () async {
      final newInitialReminder = initialConfiguration.nextReminder.addDays(1);
      model.firstReminderChanged(newInitialReminder.toDateTimeLocal());
      final updatedConfiguration =
          await model.saveIn(await loadReminderListWith([]));

      expect(updatedConfiguration.nextReminder, equals(newInitialReminder));
    });
  });
}

class SetStateMock {
  bool called = false;
  void setState(VoidCallback fn) {
    called = true;
    fn();
  }

  void reset() => called = false;
}
