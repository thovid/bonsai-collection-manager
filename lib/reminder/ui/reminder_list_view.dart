/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import '../../worktype/ui/icon_for_work_type.dart';

import '../i18n/reminder_tile_translation.dart';
import '../model/reminder.dart';

class ReminderView extends StatelessWidget {
  final ReminderList reminderList;

  const ReminderView({Key key, this.reminderList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //List<Reminder> entries = reminderList.entries;
    List<Reminder> entries = [
      DummyReminder(),
      DummyReminder(),
      DummyReminder()
    ];
    return Center(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) =>
            _buildReminderTile(context, reminderList, entries[index]),
      ),
    );
  }

  Widget _buildReminderTile(
      BuildContext context, ReminderList reminderList, Reminder entry) {
    final now = DateTime.now();
    final int dueInDays = entry.dueInFrom(now);
    return ExpansionTile(
      leading: CircleAvatar(child: workTypeIconFor(entry.workType)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(entry.treeName, style: Theme.of(context).textTheme.headline6),
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
      subtitle: Text(entry.workTypeName),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.delete), onPressed: () {}),
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            IconButton(icon: Icon(Icons.snooze), onPressed: () {}),
            IconButton(icon: Icon(Icons.check), onPressed: () {}),
          ],
        )
      ],
    );
  }
}
