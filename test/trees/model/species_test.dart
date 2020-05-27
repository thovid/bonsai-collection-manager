/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:test/test.dart';

import '../../utils/test_data.dart';

main() {
  test('repository finds species matching pattern', () async {
    var result = await testSpecies.findMatching('her');
    expect(result[0].latinName, equals('other'));

    result = await testSpecies.findMatching("Tes");
    expect(result[0].latinName, equals('test'));
  });

  test('repository finds species matching informal name', () async {
    var result = await testSpecies.findMatching('reh');
    expect(result[0].latinName, equals('other'));
  });

  test('repository finds species by exact latin name', () async {
    var result = await testSpecies.findOne(latinName: 'Pinus');
    expect(result.latinName, equals('Pinus'));

    result = await testSpecies.findOne(latinName: 'pinus mugo');
    expect(result.latinName, equals('Pinus Mugo'));

    result = await testSpecies.findOne(latinName: 'does not exist');
    expect(result, isNull);
  });
}
