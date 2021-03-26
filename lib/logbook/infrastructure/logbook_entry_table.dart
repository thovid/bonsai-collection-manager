/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../model/logbook.dart';
import '../../shared/infrastructure/enum_utils.dart';
import '../../shared/model/model_id.dart';

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

  static const List<String> columns = const [
    entry_id,
    subject_id,
    work_type,
    work_type_name,
    date,
    notes
  ];

  static Future write(LogbookEntry logbookEntry, ModelID subject,
          DatabaseExecutor database) async =>
      database.insert(
        table_name,
        _toMap(logbookEntry, subject),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  static Future<LogbookEntry> read(
      ModelID<LogbookEntry> id, DatabaseExecutor database) async {
    List<Map<String, dynamic>> data = await database.query(table_name,
        columns: columns, where: '$entry_id = ?', whereArgs: [id.value]);
    if (data.length == 0) {
      return null;
    }

    return _fromMap(data[0]);
  }

  static Future delete(
          ModelID<LogbookEntry> id, DatabaseExecutor database) async =>
      database.delete(
        table_name,
        where: '$entry_id = ?',
        whereArgs: [id.value],
      );

  static Future<List<LogbookEntry>> readAll(
      ModelID subject, DatabaseExecutor database) async {
    var data = await database.query(
      table_name,
      columns: columns,
      where: '$subject_id = ?',
      whereArgs: [subject.value],
      orderBy: '$date DESC',
    );
    List<LogbookEntry> result = []..length = data.length;
    for (int i = 0; i < data.length; i++) {
      result[i] = _fromMap(data[i]);
    }
    return result;
  }

  static Future deleteAll(ModelID subjectId, DatabaseExecutor database) async =>
      database.delete(table_name,
          where: '$subject_id = ?', whereArgs: [subjectId.value]);

  static Map<String, dynamic> _toMap(LogbookEntry entry, ModelID subject) => {
        entry_id: entry.id.value,
        subject_id: subject.value,
        work_type: entry.workType.toString(),
        work_type_name: entry.workTypeName,
        date: entry.date.toIso8601String(),
        notes: entry.notes
      };

  static LogbookEntry _fromMap(Map<String, dynamic> data) =>
      (LogbookEntryBuilder(id: data[entry_id])
            ..workType =
                enumValueFromString(data[work_type], LogWorkType.values)
            ..workTypeName = data[work_type_name]
            ..date = DateTime.parse(data[date])
            ..notes = data[notes])
          .build();
}
