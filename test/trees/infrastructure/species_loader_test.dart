/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/infrastructure/tree_species_loader.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('can load species file', () async {
    var loaded = await loadSpecies();
    expect(loaded.species.length, greaterThan(0));
  });
}
