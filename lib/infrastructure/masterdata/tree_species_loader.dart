import 'dart:async' show Future;
import 'dart:convert';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Load species list from json file
Future<SpeciesRepository> loadSpecies() async {
  return InMemorySpeciesRepository(
      await _loadSpeciesFile().then((json) => _parseSpeciesList(json)));
}

class InMemorySpeciesRepository extends SpeciesRepository {
  final List<Species> species;
  InMemorySpeciesRepository(this.species);
}

List<Species> _parseSpeciesList(String jsonString) {
  Map<String, dynamic> data = jsonDecode(jsonString);
  List species = data['species'];
  return species.map((e) => _parseSpecies(e)).toList();
}

Species _parseSpecies(Map<String, dynamic> data) {
  String genus = data['genus'];
  String species = data['species'];
  String type = data['type'];
  String commonName = data['common_name.en'];

  return Species(_parseTreeType(type),
      latinName: species?.isEmpty ?? true ? genus : species,
      informalName: commonName);
}

TreeType _parseTreeType(String type) {
  switch (type) {
    case 'conifer':
      return TreeType.conifer;
    case 'deciduous':
      return TreeType.deciduous;
    case 'broadleaf_evergreen':
      return TreeType.broadleaf_evergreen;
    case 'tropical':
      return TreeType.tropical;
  }

  return TreeType.conifer;
}

Future<String> _loadSpeciesFile() async {
  return await rootBundle.loadString('data/bonsai_species.json');
}
