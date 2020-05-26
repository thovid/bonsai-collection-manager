/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:bonsaicollectionmanager/ui/tree/bonsai_collection_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../domain/tree/test_data.dart';
import '../test_utils.dart';

void main() {
  testWidgets('Shows tree from collection', (WidgetTester tester) async {
    BonsaiCollection collection = BonsaiCollection.withTrees([
      (BonsaiTreeBuilder()
            ..treeName = "My Tree"
            ..species = Species(TreeType.conifer, latinName: "Testus Treeus"))
          .build()
    ], species: testSpecies);

    await tester.pumpWidget(testAppWith(BonsaiCollectionView(collection)));
    expect(find.text('Testus Treeus 1 \'My Tree\''), findsOneWidget);
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    await tester.pumpWidget(testAppWith(BonsaiCollectionView(BonsaiCollection(species: testSpecies))));
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}
