/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

import '../../worktype/ui/icon_for_work_type.dart';
import '../model/logbook.dart';
import './view_logbook_entry_page.dart';

class LogbookView extends StatelessWidget {
  final Logbook logbook;

  const LogbookView({Key key, this.logbook}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LogbookEntryWithImages> entries = logbook.entries;
    return Center(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) =>
            _buildLogbookEntryTile(context, logbook, entries[index]),
      ),
    );
  }

  Widget _buildLogbookEntryTile(BuildContext context, Logbook logbook,
          LogbookEntryWithImages entry) =>
      ListTile(
        leading: CircleAvatar(child: workTypeIconFor(entry.entry.workType)),
        title: Text(entry.entry.workTypeName ?? ''),
        subtitle: Text(
          DateFormat.yMMMd(I18n.locale?.toString())
              .format(entry.entry.date.toDateTimeLocal()),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(ViewLogbookEntryPage.route_name,
              arguments: Tuple2(logbook, entry));
        },
      );
}
