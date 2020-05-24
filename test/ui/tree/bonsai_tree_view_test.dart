import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:bonsaicollectionmanager/ui/tree/bonsai_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../test_utils.dart';

main() {
  final BonsaiTree aTree = (BonsaiTreeBuilder()
        ..species = Species(TreeType.conifer, latinName: 'Pinus Mugo')
        ..treeName = 'My Tree'
        ..speciesCounter = 1
        ..developmentLevel = DevelopmentLevel.refinement
        ..potType = PotType.bonsai_pot
        ..acquiredAt = DateTime(2020, 5, 20)
        ..acquiredFrom = 'Bonsai Shop')
      .build();

  testWidgets('screen shows tree data', (WidgetTester tester) async {
    await tester.pumpWidget(testAppWith(
        BonsaiTreeView(BonsaiCollection.withTrees([aTree]), aTree.id)));

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
    await tester.pumpWidget(testAppWith(
        BonsaiTreeView(BonsaiCollection.withTrees([aTree]), aTree.id)));
    expect(find.text(aTree.treeName), findsOneWidget);

    await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.edit));
    await tester.pump();
    expect(find.widgetWithText(RaisedButton, 'Cancel'), findsOneWidget);
    expect(find.widgetWithText(RaisedButton, 'Save'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Name'), 'Other Name');
    expect(find.text('Other Name'), findsOneWidget);

    await tester.tap(find.widgetWithText(RaisedButton, 'Cancel'));
    await tester.pump();
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.edit), findsOneWidget);
    expect(find.text(aTree.treeName), findsOneWidget);
  });

  testWidgets('screen can edit and save tree', (WidgetTester tester) async {
    await tester.pumpWidget(testAppWith(
        BonsaiTreeView(BonsaiCollection.withTrees([aTree]), aTree.id)));
    await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.edit));
    await tester.pump();
    await tester.enterText(find.bySemanticsLabel('Name'), 'Other Name');
    await tester.tap(find.widgetWithText(RaisedButton, 'Save'));
    await tester.pump();
    expect(find.text('Other Name'), findsOneWidget);
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.edit), findsOneWidget);
  });

  testWidgets('screen can create new tree', (WidgetTester tester) async {
    var collection = BonsaiCollection();
    await tester
        .pumpWidget(testAppWith(BonsaiTreeView(collection, null)));

    expect(find.widgetWithText(RaisedButton, 'Cancel'), findsOneWidget);
    expect(find.widgetWithText(RaisedButton, 'Save'), findsOneWidget);
  });
}
