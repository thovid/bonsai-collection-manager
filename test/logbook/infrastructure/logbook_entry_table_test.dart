/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/infrastructure/logbook_entry_table.dart';
import 'package:test/test.dart';

import '../../utils/test_utils.dart';

main() {
  test('can create table', () async {
    var db = await openTestDatabase(createTables: false);
    await LogbookEntryTable.createTable(db);
    var allTables = await db.query('sqlite_master');
    var table = allTables.firstWhere((element) =>
        element['type'] == 'table' &&
        element['name'] == LogbookEntryTable.table_name);
    print(table);
    expect(table, isNotNull);
  });

  test('can CRUD an entry', () async {
    fail('not yet implemented');
  });
}
