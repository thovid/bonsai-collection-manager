/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:sqflite/sqflite.dart';

import '../model/bonsai_tree.dart';
import '../../shared/model/model_id.dart';
import '../model/species.dart';

class BonsaiTreeTable {
  static const String table_name = 'bonsai';

  static const String tree_id = 'id';
  static const String treeName = 'name';
  static const String species = 'species';
  static const String speciesOrdinal = 'species_ordinal';
  static const String developmentLevel = 'development_level';
  static const String potType = 'pot_type';
  static const String acquiredAt = 'acquired_at';
  static const String acquiredFrom = 'acquired_from';

  static const List<String> columns = const [
    tree_id,
    treeName,
    species,
    speciesOrdinal,
    developmentLevel,
    potType,
    acquiredAt,
    acquiredFrom,
  ];

  static createTable(Database db) async {
    await db.execute("CREATE TABLE $table_name (" +
        "$tree_id STRING PRIMARY KEY," +
        "$treeName TEXT," +
        "$species TEXT," +
        "$speciesOrdinal INTEGER," +
        "$potType TEXT," +
        "$developmentLevel TEXT," +
        "$acquiredAt TEXT," +
        "$acquiredFrom TEXT" +
        ")");
  }

  static Future write(BonsaiTree tree, Database db) async {
    Map<String, dynamic> data = {
      tree_id: tree.id.value,
      treeName: tree.treeName,
      species: tree.species.latinName,
      speciesOrdinal: tree.speciesOrdinal,
      potType: tree.potType.toString(),
      developmentLevel: tree.developmentLevel.toString(),
      acquiredFrom: tree.acquiredFrom,
      acquiredAt: tree.acquiredAt.toIso8601String(),
    };

    return db.insert(table_name, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<BonsaiTree> read(ModelID<BonsaiTree> id,
      SpeciesRepository speciesRepository, Database db) async {
    List<Map<String, dynamic>> data = await db.query(table_name,
        columns: columns, where: '$tree_id = ?', whereArgs: [id.value]);
    if (data.length == 0) {
      return null;
    }

    return await _fromMap(data[0], speciesRepository);
  }

  static Future<List<BonsaiTree>> readAll(
      SpeciesRepository speciesRepository, Database db) async {
    List<Map<String, dynamic>> data =
        await db.query(table_name, columns: columns);
    List<BonsaiTree> result = List(data.length);
    for (var i = 0; i < data.length; i++) {
      BonsaiTree t = await _fromMap(data[i], speciesRepository);
      result[i] = t;
    }
    return result;
  }

  static Future<BonsaiTree> _fromMap(
      Map<String, dynamic> values, SpeciesRepository speciesRepository) async {
    return (BonsaiTreeBuilder(id: values[tree_id])
          ..treeName = values[treeName]
          ..species =
              await speciesRepository.findOne(latinName: values[species])
          ..speciesOrdinal = values[speciesOrdinal]
          ..potType = _enumValueFromString(values[potType], PotType.values)
          ..developmentLevel = _enumValueFromString(
              values[developmentLevel], DevelopmentLevel.values)
          ..acquiredAt = DateTime.parse(values[acquiredAt])
          ..acquiredFrom = values[acquiredFrom])
        .build();
  }

  static T _enumValueFromString<T>(String value, List<T> values) {
    return values.firstWhere((element) => element.toString() == value);
  }
}
