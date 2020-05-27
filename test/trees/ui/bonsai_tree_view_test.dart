/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/trees/model/species.dart';
import 'package:bonsaicollectionmanager/trees/ui/bonsai_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';

import '../../utils/test_data.dart';
import '../../utils/test_utils.dart';

main() {
  final BonsaiTree aTree = (BonsaiTreeBuilder()
        ..species = Species(TreeType.conifer, latinName: 'Pinus Mugo')
        ..treeName = 'My Tree'
        ..speciesOrdinal = 1
        ..developmentLevel = DevelopmentLevel.refinement
        ..potType = PotType.bonsai_pot
        ..acquiredAt = DateTime(2020, 5, 20)
        ..acquiredFrom = 'Bonsai Shop')
      .build();

  testWidgets('screen shows tree data', (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([aTree]).loadCollection();
    await tester.pumpWidget(testAppWith(BonsaiTreeView(aTree.id), collection));

    expect(find.text(aTree.displayName), findsOneWidget);
    expect(find.text(aTree.species.latinName), findsOneWidget);
    expect(find.text(aTree.treeName), findsOneWidget);
    // expect the development level
    // expect the pot type
    expect(
        find.text(DateFormat.yMMMd().format(aTree.acquiredAt)), findsOneWidget);
    expect(find.text(aTree.acquiredFrom), findsOneWidget);
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.edit), findsOneWidget);
  });

  testWidgets('screen can enter and cancel edit mode',
      (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([aTree]).loadCollection();
    await tester.pumpWidget(testAppWith(BonsaiTreeView(aTree.id), collection));
    expect(find.text(aTree.treeName), findsOneWidget);

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
    expect(collection.trees[0].treeName, aTree.treeName);
    expect(find.text(aTree.treeName), findsOneWidget);
  });

  testWidgets('screen can edit and save tree', (WidgetTester tester) async {
    var collection = await TestBonsaiRepository([aTree]).loadCollection();
    await tester
        .pumpWidget(testAppWith(BonsaiTreeView(aTree.id), collection))
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
