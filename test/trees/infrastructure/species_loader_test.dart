/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:ui';

import 'package:bonsaicollectionmanager/trees/infrastructure/tree_species_loader.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('can load species file with language en', () async {
    var species = await fetchInitialSpecies(Locale('en'));
    expect(species.length, greaterThan(0));
  });

  test('can load species file with language de', () async {
    var species = await fetchInitialSpecies(Locale('de'));
    expect(species.length, greaterThan(0));
  });
}
