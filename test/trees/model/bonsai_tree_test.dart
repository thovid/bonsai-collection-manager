/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:test/test.dart';

void main() {
  final Species pinusSilvestris = Species(TreeType.conifer,
      latinName: 'Pinus Silvestris', informalName: "Scots Pine");

  test('can create and update a bonsai tree', () {
    BonsaiTreeData tree = (BonsaiTreeDataBuilder()..treeName = "The Tester").build();
    expect(tree.treeName, "The Tester");
    BonsaiTreeData updated =
        (BonsaiTreeDataBuilder(fromTree: tree)..treeName = "The New Tester").build();
    expect(updated.treeName, "The New Tester");
  });

  test('a tree has a nice display name', () {
    BonsaiTreeData tree = (BonsaiTreeDataBuilder()
          ..species = pinusSilvestris
          ..treeName = "The Tester")
        .build();
    expect(tree.displayName, "Pinus Silvestris 1 \'The Tester\'");
    BonsaiTreeData treeWithoutName = (BonsaiTreeDataBuilder()
          ..species = pinusSilvestris
          ..speciesOrdinal = 2)
        .build();
    expect(treeWithoutName.displayName, "Pinus Silvestris 2");
  });
}
