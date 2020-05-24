/// General type a tree can be.
enum TreeType {conifer, deciduous, broadleaf_evergreen, tropical }

// The species of the tree.
class Species {
  static const Species unknown =
      const Species(TreeType.conifer, latinName: "unknown", informalName: "unknown");

  final String latinName;
  final String informalName;
  final TreeType type;

  const Species(this.type, {this.latinName, this.informalName});
}

/// List of known species
class KnownSpecies {
  static final List<Species> knownSpecies = [
    Species(TreeType.conifer, latinName: "unknown conifer", informalName: "unknown conifer"),
    Species(TreeType.deciduous, latinName: "unknown deciduous", informalName: "unknown deciduous"),
    Species(TreeType.broadleaf_evergreen, latinName: "unknown broadleaf evergreen", informalName: "unknown broadleaf evergreen"),
    Species(TreeType.tropical, latinName: "unknown tropical", informalName: "unknown tropical"),
    Species(TreeType.conifer, latinName: "Pinus Silvestris", informalName: "Scots Pine"),
    Species(TreeType.conifer, latinName: "Pinus mugo", informalName: "Mugo Pine"),
    Species(TreeType.conifer, latinName: "juniperus chinensis", informalName: "Chinese Juniper"),
  ];
}
