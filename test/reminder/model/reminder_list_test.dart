/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';
import 'package:date_calendar/date_calendar.dart';
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
    final today = GregorianCalendar.now();
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
    final today = GregorianCalendar.now();
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

  test('can delete reminder', () async {
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = false
          ..firstReminder = GregorianCalendar.now())
        .build();

    final repository =
        repositoryProviding([reminderConfiguration], subjectId: subjectId);
    final reminderList =
        await ReminderList.load(repository, subjectId: subjectId);
    reminderList.remove(reminderList.reminders[0]);
    expect(reminderList.reminders, isEmpty);
    verify(repository.remove(reminderConfiguration.id));
  });

  test('confirming reminder creates logbook entry', () async {
    final LookupLogbookMock lookupLogbookMock = LookupLogbookMock();
    final today = GregorianCalendar.now();
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = true
          ..endingConditionType = EndingConditionType.never
          ..firstReminder = today
          ..frequency = 1
          ..workTypeName = "some work"
          ..frequencyUnit = FrequencyUnit.days)
        .build();

    final repository =
        repositoryProviding([reminderConfiguration], subjectId: subjectId);
    final reminderList =
        await ReminderList.load(repository, subjectId: subjectId);

    final logbookEntry = await reminderList.confirmReminder(
        reminderList.reminders[0], lookupLogbookMock.lookUp);
    expect(logbookEntry.workType, equals(reminderConfiguration.workType));
    expect(
        logbookEntry.workTypeName, equals(reminderConfiguration.workTypeName));
    verify(lookupLogbookMock.logbook.add(logbookEntry));
  });

  test(
      'created logbook entry with standard work type name has work ' +
          'type name in past tense', () async {
    final LookupLogbookMock lookupLogbookMock = LookupLogbookMock();
    final today = GregorianCalendar.now();
    final reminderConfiguration = (ReminderConfigurationBuilder()
          ..subjectID = subjectId
          ..repeat = true
          ..endingConditionType = EndingConditionType.never
          ..firstReminder = today
          ..frequency = 1
          ..workType = LogWorkType.pruned
          ..workTypeName = "Prune"
          ..frequencyUnit = FrequencyUnit.days)
        .build();

    final repository =
        repositoryProviding([reminderConfiguration], subjectId: subjectId);
    final reminderList =
        await ReminderList.load(repository, subjectId: subjectId);

    final logbookEntry = await reminderList.confirmReminder(
        reminderList.reminders[0], lookupLogbookMock.lookUp,
        workTypeTranslator: mockWorkTypeTranslator("Pruned", "Prune"));
    expect(logbookEntry.workType, equals(reminderConfiguration.workType));
    expect(logbookEntry.workTypeName, equals("Pruned"));
    verify(lookupLogbookMock.logbook.add(logbookEntry));
  });

  test('confirming reminder advances reminder', () async {
    final today = GregorianCalendar.now();
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

    await reminderList.confirmReminder(
      reminderList.reminders[0],
      LookupLogbookMock().lookUp,
    );

    expect(reminderList.reminders[0].dueInFrom(today), equals(1));
    verify(repository.add(reminderList.reminders[0].configuration));
  });

  test('can remove all reminders', () async {
    final repository = repositoryProviding([aConfiguration(), aConfiguration()],
        subjectId: subjectId);
    final reminderList =
        await ReminderList.load(repository, subjectId: subjectId);
    expect(reminderList.reminders.length, equals(2));
    reminderList.removeAll();
    expect(reminderList.reminders.length, equals(0));
    verify(repository.removeAll(subjectId));
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

class LookupLogbookMock {
  Logbook logbook = LogbookMock();

  Logbook lookUp(ModelID subject) => logbook;
}

class LogbookMock extends Mock implements Logbook {}

WorkTypeTranslator mockWorkTypeTranslator(String past, String present) {
  return (type, tense) {
    if (tense == Tenses.past)
      return past;
    else
      return present;
  };
}
