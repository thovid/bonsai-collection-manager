/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/reminder/ui/edit_reminder_configuration_page.dart';
import 'package:bonsaicollectionmanager/reminder/ui/view_reminder_configuration_page.dart';

import '../../utils/test_data.dart';
import '../../utils/test_mocks.dart';
import '../../utils/test_utils.dart' as testUtils;

main() {
  testWidgets('view shows data of a reminder configuration',
      (WidgetTester tester) async {});

  testWidgets('can create new reminder configuration',
      (WidgetTester tester) async {
    final mockNavigationObserver = MockNavigatorObserver();
    var reminderList = await testUtils.loadReminderListWith([]);
    await _openView(tester, reminderList, null,
        navigatorObserver: mockNavigationObserver);
    //await tester.enterText(find.bySemanticsLabel('Frequency'), '10');
    await tester.tap(find.text('Save')).then((_) => tester.pumpAndSettle());
    verify(mockNavigationObserver.didReplace(
        newRoute: anyNamed('newRoute'), oldRoute: anyNamed('oldRoute')));
  });
}

Future<void> _openView(
    WidgetTester tester, ReminderList reminderList, Reminder entry,
    {NavigatorObserver navigatorObserver}) async {
  if (entry != null) {
    return tester.pumpWidget(
      await testUtils.testAppWith(
        ChangeNotifierProvider<ReminderList>.value(
          value: reminderList,
          builder: (context, child) => ViewReminderConfigurationPage(),
        ),
        navigationObserver: navigatorObserver,
      ),
    );
  } else {
    return tester.pumpWidget(
      await testUtils.testAppWith(
        ChangeNotifierProvider<ReminderList>.value(
          value: reminderList,
          builder: (context, child) => EditReminderConfigurationPage(),
        ),
        navigationObserver: navigatorObserver,
      ),
    );
  }
}
