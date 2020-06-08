/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/ui/edit_bonsai_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import '../../utils/test_data.dart';
import '../../utils/test_mocks.dart';
import '../../utils/test_utils.dart' as testUtils;

main() {
  testWidgets('screen shows tree data', (WidgetTester tester) async {
    var collection = await testUtils.loadCollectionWith([aBonsaiTree]);
    await tester.pumpWidget( await testUtils.testAppWith(
        EditBonsaiPage(tree: aBonsaiTreeWithImages),
        bonsaiCollection: collection));

    expect(find.text(aBonsaiTree.displayName), findsOneWidget);
    expect(find.text(aBonsaiTree.species.latinName), findsOneWidget);
    expect(find.text(aBonsaiTree.treeName), findsOneWidget);
    expect(find.text(DateFormat.yMMMd().format(aBonsaiTree.acquiredAt)),
        findsOneWidget);
    expect(find.text(aBonsaiTree.acquiredFrom), findsOneWidget);
  });

  testWidgets('screen pops to previous on saving', (WidgetTester tester) async {
    final mockNavigationObserver = MockNavigatorObserver();
    var collection = await testUtils.loadCollectionWith([aBonsaiTree]);
    await tester
        .pumpWidget(await testUtils.testAppWith(
            EditBonsaiPage(tree: aBonsaiTreeWithImages),
            navigationObserver: mockNavigationObserver,
            bonsaiCollection: collection))
        .then((_) =>
            tester.enterText(find.bySemanticsLabel('Name'), 'Other Name'))
        .then((_) => tester.tap(find.byType(FlatButton)))
        .then((_) => tester.pump());

    verify(mockNavigationObserver.didPop(any, any));
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    await tester.pumpWidget(await testUtils.testAppWith(EditBonsaiPage(),
        bonsaiCollection: await testUtils.loadCollectionWith([aBonsaiTree])));
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}
