/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:test/test.dart';

import 'test_data.dart';

main() {
  test('repository finds species matching pattern', () async {
    var result = await testSpecies.findMatching('her');
    expect(result[0].latinName, 'other');

    result = await testSpecies.findMatching("Tes");
    expect(result[0].latinName, 'test');
  });
}
