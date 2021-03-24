/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/shared/infrastructure/enum_utils.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class SpeciesTable {
  static const String table_name = 'species';

  static const String species_id = 'id';
  static const String latin_name = 'latin_name';
  static const String informal_name = 'informal_name';
  static const String tree_type = 'tree_type';

  static const List<String> columns = const [
    species_id,
    latin_name,
    informal_name,
    tree_type,
  ];

  static createTable(DatabaseExecutor db) async {
    await db.execute("CREATE TABLE $table_name (" +
        "$species_id STRING PRIMARY KEY," +
        "$latin_name TEXT UNIQUE," +
        "$informal_name TEXT," +
        "$tree_type TEXT" +
        ")");
  }

  static Future write(Species species, DatabaseExecutor db) async =>
      db.insert(table_name, _toMap(Uuid().v4(), species),
          conflictAlgorithm: ConflictAlgorithm.fail);

  static Future<Species> read(String latinName, DatabaseExecutor db) async {
    List<Map<String, dynamic>> data = await db.query(
      table_name,
      columns: columns,
      where: '$latin_name = ?',
      whereArgs: [latinName],
    );
    if (data.length == 0) {
      return null;
    }

    return await _fromMap(data[0]);
  }

  static Future<List<Species>> readAll(DatabaseExecutor db) async {
    List<Map<String, dynamic>> data = await db.query(
      table_name,
      columns: columns,
      orderBy: '$latin_name DESC',
    );
    List<Species> result = []..length = data.length;
    for (var i = 0; i < data.length; i++) {
      Species t = await _fromMap(data[i]);
      result[i] = t;
    }
    return result;
  }

  static Map<String, dynamic> _toMap(String id, Species species) => {
        species_id: id,
        latin_name: species.latinName,
        informal_name: species.informalName,
        tree_type: species.type.toString(),
      };

  static Future<Species> _fromMap(Map<String, dynamic> values) async => Species(
        enumValueFromString(values[tree_type], TreeType.values),
        latinName: values[latin_name],
        informalName: values[informal_name],
      );
}
