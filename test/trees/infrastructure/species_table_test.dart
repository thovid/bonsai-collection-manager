/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/infrastructure/species_table.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';

import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_utils.dart';

main() {
  test('can create table', () async {
    var db = await openTestDatabase(createTables: false);
    await SpeciesTable.createTable(db);
    var allTables = await db.query('sqlite_master');
    var table = allTables.firstWhere((element) =>
        element['type'] == 'table' &&
        element['name'] == SpeciesTable.table_name);
    expect(table, isNotNull);
  });

  test('can write and read species', () async {
    var db = await openTestDatabase();
    var aSpecies = Species(TreeType.conifer,
        latinName: 'Treeus Testus', informalName: 'Test Tree');

    await SpeciesTable.write(aSpecies, db);

    var speciesFromDB = await SpeciesTable.read(aSpecies.latinName, db);

    expect(speciesFromDB.latinName, equals('Treeus Testus'));
    expect(speciesFromDB.informalName, equals('Test Tree'));
    expect(speciesFromDB.type, TreeType.conifer);
  });

  test("can't write with same latin name", () async {
    var latinName = 'Treeus Testus';
    var db = await openTestDatabase();
    var aSpecies = Species(TreeType.conifer,
        latinName: latinName, informalName: 'Test Tree');
    await SpeciesTable.write(aSpecies, db);

    expect(() async => await SpeciesTable.write(aSpecies, db), throwsException);
  });

  test("can read all species", () async {
    var db = await openTestDatabase();
    await SpeciesTable.write(
        Species(TreeType.deciduous, latinName: "first"), db);
    await SpeciesTable.write(
        Species(TreeType.tropical, latinName: "second"), db);

    List<Species> result = await SpeciesTable.readAll(db);
    expect(result.length, equals(2));
  });
}
