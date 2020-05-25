import 'package:bonsaicollectionmanager/infrastructure/masterdata/tree_species_loader.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('can load species file', () async {
    var loaded = await loadSpecies();
    expect(loaded.species.length, greaterThan(0));
  });
}
