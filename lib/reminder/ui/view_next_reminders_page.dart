/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/home_page_with_drawer.dart';
import '../../shared/model/model_id.dart';
import '../../trees/model/bonsai_tree_collection.dart';
import '../../trees/model/bonsai_tree_data.dart';

import '../model/reminder.dart';
import '../i18n/reminder_tile_translation.dart';
import 'reminder_list_view.dart';

class ViewNextRemindersPage extends HomePageWithDrawer {
  static const route_name = "/reminders";

  @override
  Widget buildBody(BuildContext context) =>
      Consumer3<MultiSubjectReminderList, BonsaiTreeCollection, LookupLogbook>(
        builder: (context, reminderList, collection, lookupLogbook, _) {
          final treeNameResolver = (ModelID id) async => collection
              .findById(ModelID<BonsaiTreeData>.fromID(id.value))
              .displayName;

          return ReminderView(
            reminderList: reminderList,
            treeNameResolver: treeNameResolver,
            lookupLogbook: lookupLogbook,
            showEdit: false,
          );
        },
      );

  @override
  Widget buildFloatingActionButton(BuildContext context) => null;

  @override
  String buildTitle(BuildContext context) => "Reminder".i18n;

  @override
  String get routeName => route_name;
}
