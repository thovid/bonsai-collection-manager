/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:date_calendar/date_calendar.dart';
import 'package:sqflite/sqflite.dart';

import '../model/reminder.dart';
import '../../shared/model/model_id.dart';
import '../../shared/infrastructure/enum_utils.dart';
import '../../worktype/model/work_type.dart';

class ReminderConfigurationTable {
  static const table_name = 'reminder_configuration';

  static const entry_id = 'id';
  static const subject_id = 'subject_id';
  static const work_type = 'work_type';
  static const work_type_name = 'work_type_name';
  static const first_reminder_at = 'first_reminder_at';
  static const next_reminder_at = 'next_reminder_at';
  static const num_prev_reminders = 'num_prev_reminders';
  static const repeat = 'repeat';
  static const frequency = 'frequency';
  static const frequency_unit = 'frequency_unit';
  static const ending_condition_type = 'ending_condition_type';
  static const ending_at_date = 'ending_at_date';
  static const ending_after_repetitions = 'ending_after_repetitions';

  static createTable(Database db) async {
    await db.execute("CREATE TABLE $table_name (" +
        '$entry_id STRING PRIMARY KEY,' +
        '$subject_id STRING,' +
        '$work_type TEXT,' +
        '$work_type_name TEXT,' +
        '$first_reminder_at TEXT,' +
        '$next_reminder_at TEXT,' +
        '$num_prev_reminders INTEGER,' +
        '$repeat INTEGER,' +
        '$frequency INTEGER,' +
        '$frequency_unit TEXT,' +
        '$ending_condition_type TEXT,' +
        '$ending_at_date TEXT,'
            '$ending_after_repetitions INTEGER'
            ')');
  }

  static const List<String> columns = const [
    entry_id,
    subject_id,
    work_type,
    work_type_name,
    first_reminder_at,
    next_reminder_at,
    num_prev_reminders,
    repeat,
    frequency,
    frequency_unit,
    ending_condition_type,
    ending_at_date,
    ending_after_repetitions,
  ];

  static Future write(ReminderConfiguration configuration,
          DatabaseExecutor database) async =>
      database.insert(
        table_name,
        _toMap(configuration),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  static Future<ReminderConfiguration> read(
      ModelID<ReminderConfiguration> id, DatabaseExecutor database) async {
    List<Map<String, dynamic>> data = await database.query(table_name,
        columns: columns, where: '$entry_id = ?', whereArgs: [id.value]);
    if (data.length == 0) {
      return null;
    }

    return _fromMap(data[0]);
  }

  static Future delete(
          ModelID<ReminderConfiguration> id, DatabaseExecutor database) async =>
      database.delete(
        table_name,
        where: '$entry_id = ?',
        whereArgs: [id.value],
      );

  static Future deleteAll(ModelID subjectId, DatabaseExecutor database) async =>
      database.delete(
        table_name,
        where: '$subject_id = ?',
        whereArgs: [subjectId.value],
      );

  static Future<List<ReminderConfiguration>> readAll(
      ModelID subjectId, DatabaseExecutor database) async {
    List<Map<String, dynamic>> data = await database.query(
      table_name,
      columns: columns,
      where: '$subject_id = ?',
      whereArgs: [subjectId.value],
      orderBy: '$next_reminder_at ASC',
    );

    List<ReminderConfiguration> result = []..length = data.length;
    for (int i = 0; i < data.length; i++) {
      result[i] = _fromMap(data[i]);
    }
    return result;
  }

  static Future<List<ReminderConfiguration>> readAllUntil(
      DatabaseExecutor database,
      {Calendar until}) async {
    until ??= GregorianCalendar(9999);
    List<Map<String, dynamic>> data = await database.query(
      table_name,
      columns: columns,
      orderBy: '$next_reminder_at ASC',
      where: '$next_reminder_at < ?',
      whereArgs: [until.toDateTimeString()],
    );

    List<ReminderConfiguration> result = []..length = data.length;
    for (int i = 0; i < data.length; i++) {
      result[i] = _fromMap(data[i]);
    }
    return result;
  }

  static Map<String, dynamic> _toMap(ReminderConfiguration entry) => {
        entry_id: entry.id.value,
        subject_id: entry.subjectID.value,
        work_type: entry.workType.toString(),
        work_type_name: entry.workTypeName,
        first_reminder_at: entry.firstReminder.toDateTimeString(),
        next_reminder_at: entry.nextReminder.toDateTimeString(),
        num_prev_reminders: entry.numberOfPreviousReminders,
        repeat: entry.repeat ? 1 : 0,
        frequency: entry.frequency,
        frequency_unit: entry.frequencyUnit.toString(),
        ending_condition_type: entry.endingConditionType.toString(),
        ending_at_date: entry.endingAtDate.toDateTimeString(),
        ending_after_repetitions: entry.endingAfterRepetitions,
      };

  static ReminderConfiguration _fromMap(Map<String, dynamic> data) =>
      (ReminderConfigurationBuilder(id: data[entry_id])
            ..subjectID = ModelID.fromID(data[subject_id])
            ..workType =
                enumValueFromString(data[work_type], LogWorkType.values)
            ..workTypeName = data[work_type_name]
            ..firstReminder = GregorianCalendar.parse(data[first_reminder_at])
            ..nextReminder = GregorianCalendar.parse(data[next_reminder_at])
            ..numberOfPreviousReminders = data[num_prev_reminders]
            ..repeat = data[repeat] > 0
            ..frequency = data[frequency]
            ..frequencyUnit =
                enumValueFromString(data[frequency_unit], FrequencyUnit.values)
            ..endingConditionType = enumValueFromString(
                data[ending_condition_type], EndingConditionType.values)
            ..endingAtDate = GregorianCalendar.parse(data[ending_at_date])
            ..endingAfterRepetitions = data[ending_after_repetitions])
          .build();
}
