/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';

import '../../logbook/model/logbook.dart';
import '../../shared/icons/log_work_type_icons.dart';
import '../../worktype/model/work_type.dart';
import '../../worktype/ui/icon_for_work_type.dart';
import '../model/reminder.dart';

class ReminderView extends StatelessWidget {
  final ReminderList reminderList;

  const ReminderView({Key key, this.reminderList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //List<Reminder> entries = reminderList.entries;
    List<Reminder> entries = [Reminder(), Reminder(), Reminder()];
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
    return ExpansionTile(
      leading: CircleAvatar(child: workTypeIconFor(entry.workType)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(entry.treeName, style: Theme.of(context).textTheme.headline6),
          Text(entry.dueInFrom(now),
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
