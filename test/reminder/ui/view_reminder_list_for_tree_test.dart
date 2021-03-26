/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/reminder/ui/reminder_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils/test_data.dart';
import '../../utils/test_mocks.dart';
import '../../utils/test_utils.dart' as testUtils;

main() {
  testWidgets('can list all reminder for a tree', (WidgetTester tester) async {
    // TODO create 3 reminder configurations that produce 3 reminder tiles
    ReminderList reminderList = await testUtils
        .loadReminderListWith([Reminder(), Reminder(), Reminder()]);
    await _openView(tester, reminderList);
    expect(find.byType(ListTile), findsNWidgets(3));
  });
}

Future _openView(WidgetTester tester, ReminderList reminderList,
    {NavigatorObserver navigatorObserver}) async {
  return tester.pumpWidget(
    await testUtils.testAppWith(
      Scaffold(
          body: ReminderView(
        reminderList: reminderList,
      )),
      navigationObserver: navigatorObserver,
    ),
  );
}
