/*
 * Copyright (c) 2020 by Thomas Vidic
 */

/// General type a tree can be.
enum TreeType { conifer, deciduous, broadleaf_evergreen, tropical }

mixin SpeciesRepository {
  Future<List<Species>> get species;

  Future<List<Species>> findMatching(String pattern) async {
    var lowerCasePattern = pattern.toLowerCase();
    var allSpecies = await species;
    var result = <Species>[];
    allSpecies.forEach((element) {
      if (element._searchString.contains(lowerCasePattern)) {
        result.add(element);
      }
    });
    return result;
  }

  Future<Species> findOne({String latinName}) async {
    var lowerCasePattern = latinName.toLowerCase();
    var allSpecies = await species;
    return allSpecies.firstWhere(
        (element) => element.latinName.toLowerCase() == lowerCasePattern,
        orElse: () => null);
  }

  Future<bool> save(Species species);
}

// The species of the tree.
class Species {
  static Species unknown =
      Species(TreeType.conifer, latinName: "unknown", informalName: "unknown");

  final String latinName;
  final String informalName;
  final TreeType type;
  final String _searchString;

  Species(this.type, {this.latinName, this.informalName})
      : _searchString = (latinName?.toLowerCase() ?? '') +
            (informalName?.toLowerCase() ?? '');

  @override
  bool operator ==(other) {
    return latinName == other.latinName;
  }

  @override
  int get hashCode => latinName.hashCode;
}
