/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:sqflite_common/sqlite_api.dart';

class LogbookEntryTable {
  static const table_name = 'logbook_entry';

  static const entry_id = 'id';
  static const subject_id = 'subject_id';
  static const work_type = 'work_type';
  static const work_type_name = 'work_type_name';
  static const date = 'date';
  static const notes = 'notes';

  static createTable(Database db) async {
    await db.execute("CREATE TABLE $table_name (" +
        '$entry_id STRING PRIMARY KEY,' +
        '$subject_id STRING,' +
        '$work_type TEXT,' +
        '$work_type_name TEXT,' +
        '$date TEXT,' +
        '$notes TEXT' +
        ')');
  }
}
