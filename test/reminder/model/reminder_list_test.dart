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
    final repository = MockReminderRepository();
    when(repository.loadReminderFor(subjectId))
        .thenAnswer((_) => Future.value(<ReminderConfiguration>[]));

    ReminderList reminderList =
        await ReminderList.load(repository, subjectId: subjectId);
    expect(reminderList.entries.length, equals(0));
  });

  test('can load reminder for subject', () async {
    final repository = MockReminderRepository();
    when(repository.loadReminderFor(subjectId)).thenAnswer((_) => Future.value(
        <ReminderConfiguration>[aConfiguration(subject: subjectId)]));

    ReminderList reminderList =
        await ReminderList.load(repository, subjectId: subjectId);
    expect(reminderList.entries.length, equals(1));
  });

  test('can save new reminder config in list', () async {
    final repository = MockReminderRepository();
    when(repository.loadReminderFor(subjectId))
        .thenAnswer((_) => Future.value(<ReminderConfiguration>[]));

    ReminderList reminderList =
        await ReminderList.load(repository, subjectId: subjectId);

    ReminderConfiguration configuration =
        (ReminderConfigurationBuilder()..subjectID = subjectId).build();
    reminderList.add(configuration);
    verify(repository.add(configuration));
  });
}

ReminderConfiguration aConfiguration({ModelID subject}) =>
    (ReminderConfigurationBuilder()..subjectID = subject).build();
