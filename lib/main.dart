import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/ui/tree/bonsai_collection_view.dart';
import 'package:flutter/material.dart';

import 'domain/tree/bonsai_tree.dart';
import 'domain/tree/species.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bonsai Collection Manager',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BonsaiCollectionView(testCollection()),
    );
  }

  BonsaiCollection testCollection() {
    final Species mugo = Species(TreeType.conifer, latinName: "Pinus Mugo");
    final List<BonsaiTree> trees = List<BonsaiTree>.generate(
        30,
        (i) => (BonsaiTreeBuilder()
              ..species = mugo
              ..speciesCounter = i)
            .build());

    final BonsaiCollection collection = BonsaiCollection.withTrees(trees);
    return collection;
  }
}
