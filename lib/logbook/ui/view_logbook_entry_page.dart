/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/spaces.dart';
import '../i18n/view_logbook_entry_page.i18n.dart';
import '../model/logbook.dart';
import './work_type_panel.dart';

class ViewLogbookEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Consumer<LogbookEntryWithImages>(
          builder: (context, logbookEntry, _) => Scaffold(
            appBar: AppBar(
              title: Text(_title(logbookEntry)),
            ),
            body: _buildBody(context, logbookEntry),
          ),
        ),
      );

  String _title(LogbookEntryWithImages logbookEntry) {
    return 'Logbook entry'.i18n ;//'${logbookEntry.entry.workTypeName}';
  }

  Widget _buildBody(
          BuildContext context, LogbookEntryWithImages logbookEntry) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          WorkTypePanel(
            workType: logbookEntry.entry.workType,
            workTypeName: logbookEntry.entry.workTypeName,
          ),
          smallVerticalSpace,
          _informationBox(context, logbookEntry.entry),
        ],
      );

  Widget _informationBox(BuildContext context, LogbookEntry entry) => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
          child: Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Table(
              columnWidths: {0: FractionColumnWidth(.4)},
              children: [
                _tableRow('Date', DateFormat.yMMMd().format(entry.date)),
                _tableRow('Notes', entry.notes),
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
