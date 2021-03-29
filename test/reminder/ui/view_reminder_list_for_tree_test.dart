/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/reminder/ui/reminder_list_view.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../utils/test_utils.dart' as testUtils;

main() {
  testWidgets('can list all reminder for a tree', (WidgetTester tester) async {
    ReminderList reminderList = await testUtils
        .loadReminderListWith([aReminder(), aReminder(), aReminder()]);
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
        treeNameResolver: (_) => "My Tree",
      )),
      navigationObserver: navigatorObserver,
    ),
  );
}

ReminderConfiguration aReminder() => (ReminderConfigurationBuilder()
      ..subjectID = ModelID.newId()
      ..workTypeName = "Some work")
    .build();
