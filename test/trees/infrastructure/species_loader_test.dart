/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:ui';

import 'package:bonsaicollectionmanager/trees/infrastructure/tree_species_loader.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('can load species file with language en', () async {
    var loaded = await loadSpecies(Locale('en'));
    expect(loaded.species.length, greaterThan(0));
  });

  test('can load species file with language de', () async {
    var loaded = await loadSpecies(Locale('de'));
    expect(loaded.species.length, greaterThan(0));
  });
}
