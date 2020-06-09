/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/logbook/ui/view_logbook_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
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
}

Future<void> _openView(
    WidgetTester tester, Logbook logbook, LogbookEntry entry) async {
  final LogbookEntryWithImages entryWithImages = LogbookEntryWithImages(
      entry: entry,
      images: Images(repository: DummyImageRepository(), parent: entry.id));
  return tester.pumpWidget(await testUtils.testAppWith(
    ChangeNotifierProvider<Logbook>.value(
      value: logbook,
      child: ChangeNotifierProvider<LogbookEntryWithImages>.value(
        value: entryWithImages,
        builder: (context, child) => ViewLogbookEntryPage(),
      ),
    ),
  ));
}
