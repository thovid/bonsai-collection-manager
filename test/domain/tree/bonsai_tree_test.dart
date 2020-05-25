/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:test/test.dart';

void main() {
  final Species pinusSilvestris = Species(TreeType.conifer,
      latinName: 'Pinus Silvestris', informalName: "Scots Pine");

  test('can create and update a bonsai tree', () {
    BonsaiTree tree = (BonsaiTreeBuilder()..treeName = "The Tester").build();
    expect(tree.treeName, "The Tester");
    BonsaiTree updated =
        (BonsaiTreeBuilder(fromTree: tree)..treeName = "The New Tester").build();
    expect(updated.treeName, "The New Tester");
  });

  test('a tree has a nice display name', () {
    BonsaiTree tree = (BonsaiTreeBuilder()
          ..species = pinusSilvestris
          ..treeName = "The Tester")
        .build();
    expect(tree.displayName, "Pinus Silvestris 1 \'The Tester\'");
    BonsaiTree treeWithoutName = (BonsaiTreeBuilder()
          ..species = pinusSilvestris
          ..speciesOrdinal = 2)
        .build();
    expect(treeWithoutName.displayName, "Pinus Silvestris 2");
  });
}
