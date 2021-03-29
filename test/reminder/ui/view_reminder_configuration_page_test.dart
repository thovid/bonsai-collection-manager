/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';
import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/reminder/ui/edit_reminder_configuration_page.dart';
import 'package:bonsaicollectionmanager/reminder/ui/view_reminder_configuration_page.dart';

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
    WidgetTester tester, ReminderList reminderList, DummyReminder entry,
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

class DummyReminder with Reminder {
  LogWorkType get workType => LogWorkType.custom;

  String get workTypeName => "Do bonsai work";

  int dueInFrom(DateTime now) => 2;

  @override
  String resolveSubjectName(SubjectNameResolver resolver) => "Tree Name";

  @override
  UpdateableReminderConfiguration getConfiguration() {
    throw UnimplementedError();
  }
}
