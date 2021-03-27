/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/infrastructure/reminder_configuration_table.dart';
import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
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
}

ReminderConfiguration _anEntry(ModelID subject, {bool repeat = false}) {
  return (ReminderConfigurationBuilder()
        ..subjectID = subject
        ..repeat = repeat)
      .build();
}
