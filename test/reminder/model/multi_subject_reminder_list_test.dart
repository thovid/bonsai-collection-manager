/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:date_calendar/date_calendar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils/test_mocks.dart';

main() {
  ModelID firstSubject = ModelID.newId();
  ModelID secondSubject = ModelID.newId();

  test("contains reminder for multiple subjects", () async {
    final repo = repositoryProviding(
        [aReminder(subject: firstSubject), aReminder(subject: secondSubject)]);

    ReminderList list = await MultiSubjectReminderList.load(repo);
    expect(list.reminders.length, equals(2));
  });
}

ReminderConfiguration aReminder({ModelID subject, int reminderInDays}) =>
    (ReminderConfigurationBuilder()
          ..subjectID = subject
          ..nextReminder = GregorianCalendar.now().addDays(reminderInDays))
        .build();

ReminderRepository repositoryProviding(
  List<ReminderConfiguration> reminders,
) {
  final repository = MockReminderRepository();
  when(repository.loadReminders())
      .thenAnswer((_) => Future.value(reminders));
  return repository;
}
