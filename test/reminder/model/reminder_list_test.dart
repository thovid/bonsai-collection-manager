/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils/test_mocks.dart';

main() {
  final ModelID subjectId = ModelID.newId();
  test('can load empty reminder list from repository', () async {
    final repository = repositoryProviding([], subjectId: subjectId);

    ReminderList reminderList =
        await ReminderList.load(repository, subjectId: subjectId);
    expect(reminderList.reminders.length, equals(0));
  });

  test('can load reminder for subject', () async {
    final repository = repositoryProviding([aConfiguration(subject: subjectId)],
        subjectId: subjectId);

    ReminderList reminderList =
        await ReminderList.load(repository, subjectId: subjectId);
    expect(reminderList.reminders.length, equals(1));
  });

  test('can save new reminder config in list', () async {
    final repository = repositoryProviding([], subjectId: subjectId);

    ReminderList reminderList =
        await ReminderList.load(repository, subjectId: subjectId);

    ReminderConfiguration configuration =
        (ReminderConfigurationBuilder()..subjectID = subjectId).build();
    reminderList.add(configuration);
    verify(repository.add(configuration));
  });

  test('discarding a repeated reminder reminds for the next date', () async {
    final today = DateTime.now();
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = true
          ..endingConditionType = EndingConditionType.never
          ..firstReminder = today
          ..frequency = 1
          ..frequencyUnit = FrequencyUnit.days)
        .build();

    final repository =
        repositoryProviding([reminderConfiguration], subjectId: subjectId);
    final reminderList =
        await ReminderList.load(repository, subjectId: subjectId);

    expect(reminderList.reminders[0].dueInFrom(today), equals(0));
    await reminderList.discardReminder(reminderList.reminders[0]);

    expect(reminderList.reminders[0].dueInFrom(today), equals(1));
    verify(repository.add(reminderList.reminders[0].configuration));
  });

  test(
      'discarding a reminder that ends after current reminder deletes the reminder',
      () async {
    final today = DateTime.now();
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = false
          ..firstReminder = today)
        .build();

    final repository =
        repositoryProviding([reminderConfiguration], subjectId: subjectId);
    final reminderList =
        await ReminderList.load(repository, subjectId: subjectId);
    await reminderList.discardReminder(reminderList.reminders[0]);
    expect(reminderList.reminders, isEmpty);
    verify(repository.remove(reminderConfiguration.id));
  });
}

ReminderConfiguration aConfiguration({ModelID subject}) =>
    (ReminderConfigurationBuilder()..subjectID = subject).build();

ReminderRepository repositoryProviding(List<ReminderConfiguration> reminders,
    {ModelID subjectId}) {
  final repository = MockReminderRepository();
  when(repository.loadReminderFor(subjectId))
      .thenAnswer((_) => Future.value(reminders));
  return repository;
}
