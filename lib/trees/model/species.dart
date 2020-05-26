/*
 * Copyright (c) 2020 by Thomas Vidic
 */

/// General type a tree can be.
enum TreeType { conifer, deciduous, broadleaf_evergreen, tropical }

abstract class SpeciesRepository {
  List<Species> get species;

  Future<List<Species>> findMatching(String pattern) async {
    var lowerCasePattern = pattern.toLowerCase();
    return Future(() {
      var result = <Species>[];
      species.forEach((element) {
        if (element._searchString.contains(lowerCasePattern)) {
          result.add(element);
        }
      });
      return result;
    });
  }
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
      : _searchString =
            latinName?.toLowerCase() ?? '' + informalName?.toLowerCase() ?? '';
}

/// List of known species
class KnownSpecies {
  static final List<Species> knownSpecies = [
    Species(TreeType.conifer,
        latinName: "unknown conifer", informalName: "unknown conifer"),
    Species(TreeType.deciduous,
        latinName: "unknown deciduous", informalName: "unknown deciduous"),
    Species(TreeType.broadleaf_evergreen,
        latinName: "unknown broadleaf evergreen",
        informalName: "unknown broadleaf evergreen"),
    Species(TreeType.tropical,
        latinName: "unknown tropical", informalName: "unknown tropical"),
    Species(TreeType.conifer,
        latinName: "Pinus Silvestris", informalName: "Scots Pine"),
    Species(TreeType.conifer,
        latinName: "Pinus mugo", informalName: "Mugo Pine"),
    Species(TreeType.conifer,
        latinName: "juniperus chinensis", informalName: "Chinese Juniper"),
  ];

  static Future<List<Species>> findByPattern(String pattern) async {
    var lowerCasePattern = pattern.toLowerCase();
    return Future(() {
      var result = <Species>[];
      knownSpecies.forEach((element) {
        if (element.latinName.toLowerCase().contains(lowerCasePattern) ||
            element.informalName.toLowerCase().contains(lowerCasePattern)) {
          result.add(element);
        }
      });
      return result;
    });
  }
}
