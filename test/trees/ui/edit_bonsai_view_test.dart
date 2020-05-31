/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/ui/edit_bonsai_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

main() {
  testWidgets('screen shows tree data', (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([aBonsaiTree]).loadCollection();
    await tester.pumpWidget(
        testAppWith(EditBonsaiView(initialTree: aBonsaiTree), collection));

    expect(find.text(aBonsaiTree.displayName), findsOneWidget);
    expect(find.text(aBonsaiTree.species.latinName), findsOneWidget);
    expect(find.text(aBonsaiTree.treeName), findsOneWidget);
    expect(find.text(DateFormat.yMMMd().format(aBonsaiTree.acquiredAt)),
        findsOneWidget);
    expect(find.text(aBonsaiTree.acquiredFrom), findsOneWidget);
  });

  testWidgets('screen pops to previous on saving', (WidgetTester tester) async {
    final mockNavigationObserver = MockNavigatorObserver();
    var collection = await TestBonsaiRepository([aBonsaiTree]).loadCollection();
    await tester.pumpWidget(testAppWith(
        EditBonsaiView(initialTree: aBonsaiTree), collection,
        navigationObserver: mockNavigationObserver))
    .then((_) => tester.enterText(find.bySemanticsLabel('Name'), 'Other Name'))
    .then((_) => tester.tap(find.byType(FlatButton)))
    .then((_) => tester.pumpAndSettle());

    verify(mockNavigationObserver.didPop(any, any));
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    await tester.pumpWidget(testAppWith(
        EditBonsaiView(), await TestBonsaiRepository([]).loadCollection()));
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}