/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:bonsaicollectionmanager/trees/ui/bonsai_collection_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

void main() {
  testWidgets('Shows tree from collection', (WidgetTester tester) async {
    BonsaiCollection collection = await TestBonsaiRepository([
      (BonsaiTreeDataBuilder()
            ..treeName = "My Tree"
            ..species = Species(TreeType.conifer, latinName: "Testus Treeus"))
          .build()
    ]).loadCollection();

    await tester.pumpWidget(testAppWith(OldBonsaiCollectionView(), collection));
    expect(find.text('Testus Treeus 1 \'My Tree\''), findsOneWidget);
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    await tester.pumpWidget(testAppWith(OldBonsaiCollectionView(),
        await TestBonsaiRepository([]).loadCollection()));
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}
