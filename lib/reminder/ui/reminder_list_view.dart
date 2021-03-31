/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../shared/ui/toast.dart';
import '../../worktype/ui/icon_for_work_type.dart';
import '../i18n/reminder_tile_translation.dart';
import '../model/reminder.dart';
import 'view_reminder_configuration_page.dart';

class ReminderView extends StatelessWidget {
  final ReminderList reminderList;
  final SubjectNameResolver treeNameResolver;
  final LookupLogbook lookupLogbook;

  const ReminderView(
      {Key key,
      @required this.reminderList,
      @required this.treeNameResolver,
      @required this.lookupLogbook})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Reminder> entries = reminderList.reminders;

    return Center(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) =>
            _buildReminderTile(context, reminderList, entries[index]),
      ),
    );
  }

  Widget _buildReminderTile(
      BuildContext context, ReminderList reminderList, Reminder reminder) {
    final now = DateTime.now();
    final int dueInDays = reminder.dueInFrom(now);
    return ExpansionTile(
      leading: CircleAvatar(child: workTypeIconFor(reminder.workType)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              reminder.resolveSubjectName(treeNameResolver),
              style: Theme.of(context).textTheme.headline6,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
              dueInDays >= 0
                  ? "Due in %d days".plural(dueInDays)
                  : "Was due %d days ago".plural(-dueInDays),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontStyle: FontStyle.italic)),
        ],
      ),
      subtitle: Text(reminder.workTypeName),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  await reminderList.discardReminder(reminder);
                  showInformation(
                      context: context, information: "Reminder discarded".i18n);
                }),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      ViewReminderConfigurationPage.route_name,
                      arguments: Tuple2(reminderList, reminder));
                }),
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  await reminderList.confirmReminder(reminder, lookupLogbook,
                      workTypeTranslator: (type, tense) =>
                          type.toString().tense(tense));
                  showInformation(
                      context: context,
                      information: "Logbook entry created".i18n);
                }),
          ],
        )
      ],
    );
  }
}
