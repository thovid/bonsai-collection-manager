/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/logbook/ui/view_logbook_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../utils/test_data.dart';
import '../../utils/test_mocks.dart';
import '../../utils/test_utils.dart' as testUtils;

main() {
  testWidgets('can list all log entries', (WidgetTester tester) async {
    final LogbookEntry firstEntry = (LogbookEntryBuilder()
          ..workType = LogWorkType.deadwood
          ..workTypeName = 'deadwood worked'
          ..date = DateTime(2020, 1, 1))
        .build();
    final LogbookEntry secondEntry = (LogbookEntryBuilder()
          ..workType = LogWorkType.fertilized
          ..workTypeName = 'fertilized'
          ..date = DateTime(2020, 2, 1))
        .build();
    var logbook = await testUtils.loadLogbookWith([firstEntry, secondEntry]);
    await _openView(tester, logbook);
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(
        find.descendant(
          of: find.byType(ListTile).at(0),
          matching: find.text('deadwood worked'),
        ),
        findsOneWidget);
    expect(
        find.descendant(
          of: find.byType(ListTile).at(1),
          matching: find.text('fertilized'),
        ),
        findsOneWidget);
  });

  testWidgets('can view single entry', (WidgetTester tester) async {
    var logbook = await testUtils.loadLogbookWith([aLogbookEntry]);
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    await _openView(tester, logbook, navigatorObserver: mockObserver);

    await tester
        .tap(find.byType(ListTile).first)
        .then((_) => tester.pumpAndSettle());
    // TODO test correct route
    verify(mockObserver.didPush(any, any));
  });
}

Future _openView(WidgetTester tester, Logbook logbook,
    {NavigatorObserver navigatorObserver}) async {
  return tester.pumpWidget(
    await testUtils.testAppWith(
      ChangeNotifierProvider<Logbook>.value(
        value: logbook,
        builder: (context, child) => ViewLogbookPage(),
      ),
      navigationObserver: navigatorObserver,
    ),
  );
}
