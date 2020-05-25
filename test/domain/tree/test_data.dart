import 'package:bonsaicollectionmanager/domain/tree/species.dart';

final SpeciesRepository testSpecies = TestSpeciesRepository([
  Species(TreeType.tropical, latinName: 'test'),
  Species(TreeType.tropical, latinName: 'other')
]);

class TestSpeciesRepository extends SpeciesRepository {
  final List<Species> species;
  TestSpeciesRepository(this.species);
}
