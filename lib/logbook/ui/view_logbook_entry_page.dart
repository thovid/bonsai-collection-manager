/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/spaces.dart';
import '../i18n/view_logbook_entry_page.i18n.dart';
import '../model/logbook.dart';

class ViewLogbookEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Consumer<LogbookEntryWithImages>(
          builder: (context, logbookEntry, _) => Scaffold(
            body: _buildBody(context, logbookEntry),
          ),
        ),
      );

  Widget _buildBody(
          BuildContext context, LogbookEntryWithImages logbookEntry) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _workTypeRow(context, logbookEntry.entry),
          smallSpace,
          _informationBox(context, logbookEntry.entry),
        ],
      );

  Widget _workTypeRow(BuildContext context, LogbookEntry entry) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Text(entry.workTypeName)],
          ),
        ),
      );

  Widget _informationBox(BuildContext context, LogbookEntry entry) => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
          child: Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Table(
              columnWidths: {0: FractionColumnWidth(.4)},
              children: [
                _tableRow('Date'.i18n, DateFormat.yMMMd().format(entry.date)),
                _tableRow('Notes'.i18n, entry.notes),
              ],
            ),
          ),
        ),
      );

  TableRow _tableRow(String labelKey, String value) => TableRow(children: [
        TableCell(
            child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(labelKey.i18n + ':'))),
        TableCell(
            child: Container(
                padding: const EdgeInsets.only(top: 10.0), child: Text(value)))
      ]);
}
