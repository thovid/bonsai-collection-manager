/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:bonsaicollectionmanager/trees/ui/view_bonsai_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

void main() {
  testWidgets('Shows tree from collection', (WidgetTester tester) async {
    var treeRepository = TestBonsaiRepository([
      (BonsaiTreeDataBuilder()
            ..treeName = "My Tree"
            ..species = Species(TreeType.conifer, latinName: "Testus Treeus"))
          .build()
    ]);
    BonsaiTreeCollection treeCollection = await BonsaiTreeCollection.load(
        treeRepository: treeRepository,
        imageRepository: DummyImageRepository());

    await tester
        .pumpWidget(testAppWith(ViewBonsaiCollectionView(),
            bonsaiCollection: treeCollection))
        .then((value) => tester.pumpAndSettle());
    expect(find.text('Testus Treeus 1 \'My Tree\''), findsOneWidget);
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    await tester.pumpWidget(testAppWith(ViewBonsaiCollectionView(),
        bonsaiCollection: await BonsaiTreeCollection.load(
            treeRepository: TestBonsaiRepository([aBonsaiTree]),
            imageRepository: DummyImageRepository())));
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}
