/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/logbook/ui/edit_logbook_entry_page.dart';
import 'package:bonsaicollectionmanager/logbook/ui/log_entry_with_images_view.dart';
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
    var anEntry = (LogbookEntryBuilder()
          ..workTypeName = 'custom'
          ..notes = 'notes')
        .build();

    await _openView(tester, anEntry);

    expect(find.text(anEntry.workTypeName), findsOneWidget);
    expect(find.text(DateFormat.yMMMd().format(anEntry.date)), findsOneWidget);
    expect(find.text(anEntry.notes), findsOneWidget);
  });

  testWidgets('can edit entry', (WidgetTester tester) async {
    final mockNavigationObserver = MockNavigatorObserver();
    var anEntry = aLogbookEntry;
    var logbook = await testUtils.loadLogbookWith([anEntry]);
    await _openEdit(tester, logbook, anEntry,
        navigatorObserver: mockNavigationObserver);

    await tester.enterText(
        find.bySemanticsLabel('Notes'), 'this is an updated note');
    await tester.tap(find.text('Save')).then((_) => tester.pumpAndSettle());

    verify(mockNavigationObserver.didPop(any, any));
  });

  testWidgets('can create new entry', (WidgetTester tester) async {
    final mockNavigationObserver = MockNavigatorObserver();
    var logbook = await testUtils.loadLogbookWith([]);
    await _openCreate(tester, logbook,
        navigatorObserver: mockNavigationObserver);
    await tester.enterText(
        find.bySemanticsLabel('Notes'), 'this is a new note');
    await tester.tap(find.text('Save')).then((_) => tester.pumpAndSettle());
    verify(mockNavigationObserver.didReplace(
        newRoute: anyNamed('newRoute'), oldRoute: anyNamed('oldRoute')));
  });

  testWidgets('All translations defined', (WidgetTester tester) async {
    var anEntry = aLogbookEntry;
    await _openView(tester, anEntry);

    expect(Translations.missingKeys, isEmpty);
    expect(Translations.missingTranslations, isEmpty);
  });
}

Future<void> _openCreate(WidgetTester tester, Logbook logbook,
    {NavigatorObserver navigatorObserver}) async {
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

Future<void> _openEdit(WidgetTester tester, Logbook logbook, LogbookEntry entry,
    {NavigatorObserver navigatorObserver}) async {
  final LogbookEntryWithImages entryWithImages = LogbookEntryWithImages(
      entry: entry,
      images: Images(repository: DummyImageRepository(), parent: entry.id));
  return tester.pumpWidget(
    await testUtils.testAppWith(
      ChangeNotifierProvider<Logbook>.value(
        value: logbook,
        builder: (context, child) => EditLogbookEntryPage(
          entry: entryWithImages,
        ),
      ),
      navigationObserver: navigatorObserver,
    ),
  );
}

Future<void> _openView(WidgetTester tester, LogbookEntry entry,
    {NavigatorObserver navigatorObserver}) async {
  final LogbookEntryWithImages entryWithImages = LogbookEntryWithImages(
      entry: entry,
      images: Images(repository: DummyImageRepository(), parent: entry.id));
  return tester.pumpWidget(
    await testUtils.testAppWith(
      LogEntryWithImagesView(
        logbookEntry: entryWithImages,
      ),
      navigationObserver: navigatorObserver,
    ),
  );
}
