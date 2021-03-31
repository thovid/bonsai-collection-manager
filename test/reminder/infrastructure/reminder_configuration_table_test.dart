/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/infrastructure/reminder_configuration_table.dart';
import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:date_calendar/date_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

import '../../utils/test_utils.dart';

main() {
  final ModelID subject = ModelID.newId();

  test('can create table', () async {
    var db = await openTestDatabase(createTables: false);
    await ReminderConfigurationTable.createTable(db);
    var allTables = await db.query('sqlite_master');
    var table = allTables.firstWhere((element) =>
        element['type'] == 'table' &&
        element['name'] == ReminderConfigurationTable.table_name);
    expect(table, isNotNull);
  });

  test('can CRUD an entry', () async {
    DatabaseExecutor db = await openTestDatabase();
    var anEntry = _anEntry(subject, repeat: true);
    await ReminderConfigurationTable.write(anEntry, db);
    ReminderConfiguration fromDB =
        await ReminderConfigurationTable.read(anEntry.id, db);
    expect(fromDB.subjectID, equals(anEntry.subjectID));
    expect(fromDB.workType, equals(anEntry.workType));
    expect(fromDB.workTypeName, equals(anEntry.workTypeName));
    expect(fromDB.firstReminder, equals(anEntry.firstReminder));
    expect(fromDB.repeat, equals(anEntry.repeat));
    expect(fromDB.frequency, equals(anEntry.frequency));
    expect(fromDB.frequencyUnit, equals(anEntry.frequencyUnit));

    var toUpdate = (ReminderConfigurationBuilder(fromConfiguration: fromDB)
          ..frequencyUnit = FrequencyUnit.months)
        .build();
    await ReminderConfigurationTable.write(toUpdate, db);
    fromDB = await ReminderConfigurationTable.read(toUpdate.id, db);
    expect(fromDB.frequencyUnit, equals(toUpdate.frequencyUnit));

    await ReminderConfigurationTable.delete(fromDB.id, db);
    fromDB = await ReminderConfigurationTable.read(fromDB.id, db);
    expect(fromDB, isNull);
  });

  test('can get and delete all for a subject', () async {
    DatabaseExecutor db = await openTestDatabase();
    final otherSubject = ModelID.newId();
    final entries = [
      _anEntry(subject),
      _anEntry(subject),
      _anEntry(otherSubject),
    ];
    entries.forEach((element) async {
      await ReminderConfigurationTable.write(element, db);
    });

    final forSubject = await ReminderConfigurationTable.readAll(subject, db);
    expect(forSubject.length, equals(2));
    await ReminderConfigurationTable.deleteAll(subject, db);
    final deleted = await ReminderConfigurationTable.readAll(subject, db);
    expect(deleted.length, equals(0));
    final notDeleted =
        await ReminderConfigurationTable.readAll(otherSubject, db);
    expect(notDeleted.length, equals(1));
  });

  test('can get all reminders', () async {
    DatabaseExecutor db = await openTestDatabase();
    final otherSubject = ModelID.newId();
    final entries = [
      _anEntry(subject),
      _anEntry(subject),
      _anEntry(otherSubject),
    ];
    entries.forEach((element) async {
      await ReminderConfigurationTable.write(element, db);
    });

    final all = await ReminderConfigurationTable.readAllUntil(db);
    expect(all.length, equals(3));
  });

  test('can get all reminders until specific date', () async {
    DatabaseExecutor db = await openTestDatabase();
    final otherSubject = ModelID.newId();
    final entries = [
      _anEntry(subject, nextReminder: GregorianCalendar.now()),
      _anEntry(subject, nextReminder: GregorianCalendar.now().addYears(1)),
      _anEntry(otherSubject, nextReminder: GregorianCalendar.now().addDays(2)),
    ];
    entries.forEach((element) async {
      await ReminderConfigurationTable.write(element, db);
    });

    final all = await ReminderConfigurationTable.readAllUntil(db,
        until: GregorianCalendar.now().addDays(3));
    expect(all.length, equals(2));
  });
}

ReminderConfiguration _anEntry(ModelID subject,
    {bool repeat = false, Calendar nextReminder}) {
  return (ReminderConfigurationBuilder()
        ..subjectID = subject
        ..nextReminder = nextReminder
        ..repeat = repeat)
      .build();
}
