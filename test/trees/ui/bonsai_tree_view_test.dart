/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/ui/bonsai_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

main() {
  testWidgets('screen shows tree data', (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([aBonsaiTree]).loadCollection();
    await tester
        .pumpWidget(testAppWith(BonsaiTreeView(aBonsaiTree.id), collection));

    expect(find.text(aBonsaiTree.displayName), findsOneWidget);
    expect(find.text(aBonsaiTree.species.latinName), findsOneWidget);
    expect(find.text(aBonsaiTree.treeName), findsOneWidget);
    // expect the development level
    // expect the pot type
    expect(find.text(DateFormat.yMMMd().format(aBonsaiTree.acquiredAt)),
        findsOneWidget);
    expect(find.text(aBonsaiTree.acquiredFrom), findsOneWidget);
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.edit), findsOneWidget);
  });

  testWidgets('screen can enter and cancel edit mode',
      (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([aBonsaiTree]).loadCollection();
    await tester
        .pumpWidget(testAppWith(BonsaiTreeView(aBonsaiTree.id), collection));
    expect(find.text(aBonsaiTree.treeName), findsOneWidget);

    await tester
        .tap(find.widgetWithIcon(FloatingActionButton, Icons.edit))
        .then((value) => tester.pump());
    expect(find.widgetWithIcon(IconButton, Icons.done), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Name'), 'Other Name');
    expect(find.text('Other Name'), findsOneWidget);

    var cancelButton = find.byType(BackButton);
    await tester
        .ensureVisible(cancelButton)
        .then((value) => tester.tap(cancelButton))
        .then((value) => tester.pump());
    expect(collection.trees[0].treeName, aBonsaiTree.treeName);
    expect(find.text(aBonsaiTree.treeName), findsOneWidget);
  });

  testWidgets('screen can edit and save tree', (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([aBonsaiTree]).loadCollection();
    await tester
        .pumpWidget(testAppWith(BonsaiTreeView(aBonsaiTree.id), collection))
        .then((value) =>
            tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.edit)))
        .then((value) => tester.pump());

    await tester.enterText(find.bySemanticsLabel('Name'), 'Other Name');

    var saveButton = find.widgetWithIcon(IconButton, Icons.done);
    await tester
        .ensureVisible(saveButton)
        .then((value) => tester.tap(saveButton))
        .then((value) => tester.pump());

    expect(find.text('Other Name'), findsOneWidget);
    expect(collection.trees[0].treeName, 'Other Name');
  });

  testWidgets('screen can create new tree', (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([]).loadCollection();
    await tester.pumpWidget(testAppWith(BonsaiTreeView(null), collection));

    expect(find.widgetWithIcon(IconButton, Icons.done), findsOneWidget);
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    await tester.pumpWidget(testAppWith(
        BonsaiTreeView(null), await TestBonsaiRepository([]).loadCollection()));
    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}
