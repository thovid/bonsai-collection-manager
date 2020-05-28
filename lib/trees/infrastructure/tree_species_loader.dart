/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'dart:async' show Future;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;

import '../model/species.dart';
import '../../shared/i18n/i18n.dart';

/// Load species list from json file
Future<SpeciesRepository> fetchSpecies(Locale locale) async {
  return _InMemorySpeciesRepository(
      await _loadSpeciesFile().then((json) => _parseSpeciesList(json, locale)));
}

class _InMemorySpeciesRepository extends SpeciesRepository {
  final List<Species> species;
  _InMemorySpeciesRepository(this.species);
}

List<Species> _parseSpeciesList(String jsonString, Locale locale) {
  Map<String, dynamic> data = jsonDecode(jsonString);
  List species = data['species'];
  return species.map((e) => _parseSpecies(e, locale)).toList();
}

Species _parseSpecies(Map<String, dynamic> data, Locale locale) {
  String genus = data['genus'];
  String species = data['species'];
  String type = data['type'];
  String commonNameKey = extractSupportedLanguageCode(locale);
  String commonName = data['common_name.' + commonNameKey];

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
