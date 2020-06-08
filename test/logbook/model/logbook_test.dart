/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../utils/test_mocks.dart';

main() {
  final ModelID treeId = ModelID.newId();

  test('can load empty logbook', () async {
    final LogbookRepository repository = MockLogbookRepository();
    when(repository.loadLogbook(treeId))
        .thenAnswer((_) => Future.value(<LogbookEntry>[]));
    final Logbook logbook = await Logbook.load(
        logbookRepository: repository,
        subjectId: treeId,
        imageRepository: DummyImageRepository());
    expect(logbook.length, equals(0));
  });

  test('can load logbook with entry', () async {
    final LogbookEntry logbookEntry = (LogbookEntryBuilder()
          ..workType = LogWorkType.pruned
          ..date = DateTime.now()
          ..notes = "Some notes")
        .build();
    final LogbookRepository repository = MockLogbookRepository();
    when(repository.loadLogbook(treeId))
        .thenAnswer((_) => Future.value(<LogbookEntry>[logbookEntry]));

    final Logbook logbook = await Logbook.load(
        logbookRepository: repository,
        imageRepository: DummyImageRepository(),
        subjectId: treeId);
    expect(logbook.length, equals(1));
    expect(logbook.entries[0].entry.workType, equals(LogWorkType.pruned));
  });

  test('can add entry to logbook', () async {
    final LogbookRepository repository = MockLogbookRepository();
    when(repository.loadLogbook(treeId))
        .thenAnswer((_) => Future.value(<LogbookEntry>[]));
    final Logbook logbook = await Logbook.load(
        logbookRepository: repository,
        subjectId: treeId,
        imageRepository: DummyImageRepository());

    final LogbookEntry logbookEntry = (LogbookEntryBuilder()
          ..workType = LogWorkType.pruned
          ..date = DateTime.now()
          ..notes = "Some notes")
        .build();

    LogbookEntryWithImages entryWithImages = await logbook.add(logbookEntry);
    expect(logbook.length, equals(1));
    expect(entryWithImages.entry, equals(logbookEntry));
    verify(repository.add(logbookEntry, treeId));
  });

  test('can get and update entry', () async {
    final LogbookEntry logbookEntry = (LogbookEntryBuilder()
          ..workType = LogWorkType.pruned
          ..date = DateTime.now()
          ..notes = "Some notes")
        .build();
    final LogbookRepository repository = MockLogbookRepository();
    when(repository.loadLogbook(treeId))
        .thenAnswer((_) => Future.value(<LogbookEntry>[logbookEntry]));

    final Logbook logbook = await Logbook.load(
        logbookRepository: repository,
        imageRepository: DummyImageRepository(),
        subjectId: treeId);

    final LogbookEntryWithImages entryWithImages =
        logbook.findById(logbookEntry.id);
    expect(entryWithImages.entry, equals(logbookEntry));

    final LogbookEntry updated = (LogbookEntryBuilder(fromEntry: logbookEntry)
          ..workType = LogWorkType.custom
          ..workTypeName = 'second styling')
        .build();
    entryWithImages.entry = updated;

    final LogbookEntryWithImages updatedWithImages =
        await logbook.update(entryWithImages);
    final LogbookEntryWithImages found = logbook.findById(updatedWithImages.id);
    expect(found.entry.workType, equals(LogWorkType.custom));
    expect(found.entry.workTypeName, equals('second styling'));
    verify(repository.update(updated, treeId));
  });

  test('can delete entry', () async {
    final LogbookEntry logbookEntry = (LogbookEntryBuilder()
      ..workType = LogWorkType.pruned
      ..date = DateTime.now()
      ..notes = "Some notes")
        .build();
    final LogbookRepository repository = MockLogbookRepository();
    when(repository.loadLogbook(treeId))
        .thenAnswer((_) => Future.value(<LogbookEntry>[logbookEntry]));

    final Logbook logbook = await Logbook.load(
        logbookRepository: repository,
        imageRepository: DummyImageRepository(),
        subjectId: treeId);

    await logbook.delete(logbookEntry.id);
    expect(logbook.length, equals(0));
    verify(repository.delete(logbookEntry.id));
  });
}

class MockLogbookRepository extends Mock implements LogbookRepository {}
