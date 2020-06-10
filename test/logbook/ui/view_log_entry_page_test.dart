/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/logbook/ui/edit_logbook_entry_page.dart';
import 'package:bonsaicollectionmanager/logbook/ui/view_logbook_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../utils/test_data.dart';
import '../../utils/test_mocks.dart';
import '../../utils/test_utils.dart' as testUtils;

main() {
  testWidgets('view shows data of a single log entry',
      (WidgetTester tester) async {
    var anEntry = aLogbookEntry;
    var logbook = await testUtils.loadLogbookWith([anEntry]);
    await _openView(tester, logbook, anEntry);

    expect(find.text(// title
        'Logbook entry'), findsOneWidget);
    expect(find.text(anEntry.workTypeName), findsOneWidget);
    expect(find.text(DateFormat.yMMMd().format(anEntry.date)), findsOneWidget);
    expect(find.text(anEntry.notes), findsOneWidget);
  });

  testWidgets('can delete entry', (WidgetTester tester) async {
    var anEntry = aLogbookEntry;
    var logbook = await testUtils.loadLogbookWith([anEntry]);
    await _openView(tester, logbook, anEntry);

    await tester.tap(find.byIcon(Icons.delete)).then((_) => tester.pump());
    expect(find.text('Really delete?'), findsOneWidget);
    await tester.tap(find.text('Delete')).then((_) => tester.pumpAndSettle());
    expect(logbook.length, equals(0));
  });

  testWidgets('can edit entry', (WidgetTester tester) async {
    final mockNavigationObserver = MockNavigatorObserver();
    var anEntry = aLogbookEntry;
    var logbook = await testUtils.loadLogbookWith([anEntry]);
    await _openView(tester, logbook, anEntry,
        navigatorObserver: mockNavigationObserver);

    await tester
        .tap(find.byIcon(Icons.edit))
        .then((_) => tester.pumpAndSettle());

    await tester.enterText(
        find.bySemanticsLabel('Notes'), 'this is an updated note');
    await tester.tap(find.text('Save')).then((_) => tester.pumpAndSettle());

    expect(find.text('this is an updated note'), findsOneWidget);
    verify(mockNavigationObserver.didPop(any, any));
  });

  testWidgets('can create new entry', (WidgetTester tester) async {
    final mockNavigationObserver = MockNavigatorObserver();
    var logbook = await testUtils.loadLogbookWith([]);
    await _openView(tester, logbook, null,
        navigatorObserver: mockNavigationObserver);
    await tester.enterText(
        find.bySemanticsLabel('Notes'), 'this is a new note');
    await tester.tap(find.text('Save')).then((_) => tester.pumpAndSettle());
    verify(mockNavigationObserver.didReplace(
        newRoute: anyNamed('newRoute'), oldRoute: anyNamed('oldRoute')));
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    var anEntry = aLogbookEntry;
    var logbook = await testUtils.loadLogbookWith([anEntry]);
    await _openView(tester, logbook, anEntry);

    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}

Future<void> _openView(WidgetTester tester, Logbook logbook, LogbookEntry entry,
    {NavigatorObserver navigatorObserver}) async {
  if (entry != null) {
    final LogbookEntryWithImages entryWithImages = LogbookEntryWithImages(
        entry: entry,
        images: Images(repository: DummyImageRepository(), parent: entry.id));
    return tester.pumpWidget(
      await testUtils.testAppWith(
        ChangeNotifierProvider<Logbook>.value(
          value: logbook,
          child: ChangeNotifierProvider<LogbookEntryWithImages>.value(
            value: entryWithImages,
            builder: (context, child) => ViewLogbookEntryPage(),
          ),
        ),
        navigationObserver: navigatorObserver,
      ),
    );
  } else {
    return tester.pumpWidget(
      await testUtils.testAppWith(
        ChangeNotifierProvider<Logbook>.value(
          value: logbook,
          builder: (context, child) => EditLogbookEntryPage(),
        ),
        navigationObserver: navigatorObserver,
      ),
    );
  }
}
