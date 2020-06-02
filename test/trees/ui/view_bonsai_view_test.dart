/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/images/ui/image_gallery.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_with_images.dart';
import 'package:bonsaicollectionmanager/trees/ui/view_bonsai_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

main() {
  testWidgets('screen shows tree data', (WidgetTester tester) async {
    var collection = await BonsaiTreeCollection.load(
        treeRepository: TestBonsaiRepository([aBonsaiTree]),
        imageRepository: DummyImageRepository());
    await _openView(tester, collection);

    expect(find.text(aBonsaiTree.displayName), findsOneWidget);
    expect(
        find.text(
            '${aBonsaiTree.species.latinName} - ${aBonsaiTree.species.informalName}'),
        findsOneWidget);
    expect(find.text(aBonsaiTree.treeName), findsOneWidget);
    expect(find.text(DateFormat.yMMMd().format(aBonsaiTree.acquiredAt)),
        findsOneWidget);
    expect(find.text(aBonsaiTree.acquiredFrom), findsOneWidget);
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.edit), findsOneWidget);
    expect(find.byType(ImageGallery), findsOneWidget);
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    await _openView(
        tester,
        await BonsaiTreeCollection.load(
            treeRepository: TestBonsaiRepository([aBonsaiTree]),
            imageRepository: DummyImageRepository()));
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}

Future<void> _openView(WidgetTester tester, BonsaiTreeCollection collection) {
  final BonsaiTreeData tree = aBonsaiTree;
  final BonsaiTreeWithImages treeWithImages = BonsaiTreeWithImages(
    treeData: tree,
    images: Images(parent: tree.id, repository: DummyImageRepository()),
  );
  return tester.pumpWidget(testAppWith(
      ChangeNotifierProvider.value(
          value: treeWithImages, child: ViewBonsaiView()),
      bonsaiCollection: collection));
}
