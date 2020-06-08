/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/infrastructure/logbook_entry_table.dart';
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

import '../../utils/test_utils.dart';

main() {
  final ModelID subject = ModelID.newId();

  test('can create table', () async {
    var db = await openTestDatabase(createTables: false);
    await LogbookEntryTable.createTable(db);
    var allTables = await db.query('sqlite_master');
    var table = allTables.firstWhere((element) =>
        element['type'] == 'table' &&
        element['name'] == LogbookEntryTable.table_name);
    expect(table, isNotNull);
  });

  test('can CRUD an entry', () async {
    DatabaseExecutor db = await openTestDatabase();
    var anEntry = _anEntry();

    await LogbookEntryTable.write(anEntry, subject, db);
    LogbookEntry fromDB = await LogbookEntryTable.read(anEntry.id, db);
    expect(fromDB.workType, equals(anEntry.workType));
    expect(fromDB.workTypeName, equals(anEntry.workTypeName));
    expect(fromDB.date, equals(anEntry.date));
    expect(fromDB.notes, equals(anEntry.notes));

    LogbookEntry toUpdate = (LogbookEntryBuilder(fromEntry: fromDB)
          ..workType = LogWorkType.deadwood)
        .build();
    await LogbookEntryTable.write(toUpdate, subject, db);
    fromDB = await LogbookEntryTable.read(toUpdate.id, db);
    expect(fromDB.workType, equals(LogWorkType.deadwood));

    await LogbookEntryTable.delete(toUpdate.id, db);
    LogbookEntry deleted = await LogbookEntryTable.read(toUpdate.id, db);
    expect(deleted, isNull);
  });

  test('can read all entries for a subject', () async {
    DatabaseExecutor db = await openTestDatabase();
    var firstForSubject = _anEntry();
    var secondForSubject = _anEntry();
    var forOtherSubject = _anEntry();

    await LogbookEntryTable.write(firstForSubject, subject, db);
    await LogbookEntryTable.write(secondForSubject, subject, db);
    await LogbookEntryTable.write(forOtherSubject, ModelID.newId(), db);

    List<LogbookEntry> entries = await LogbookEntryTable.readAll(subject, db);
    expect(entries.length, equals(2));
  });
}

LogbookEntry _anEntry() => LogbookEntryBuilder().build();
