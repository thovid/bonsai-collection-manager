/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../i18n/view_logbook_page.i18n.dart';
import '../model/logbook.dart';
import './work_type_panel.dart';
import './view_logbook_entry_page.dart';

class ViewLogbookPage extends StatelessWidget {
  static const route_name = '/logbook';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<Logbook>(
        builder: (context, logbook, _) => Scaffold(
          appBar: AppBar(
            title: Text('Logbook'.i18n),
          ),
          body: _buildBody(context, logbook),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Logbook logbook) {
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
        title: Text(entry.entry.workTypeName),
        subtitle: Text(
          DateFormat.yMMMd(I18n.locale?.toString()).format(entry.entry.date),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(ViewLogbookEntryPage.route_name,
              arguments: Tuple2(logbook, entry));
        },
      );
}
