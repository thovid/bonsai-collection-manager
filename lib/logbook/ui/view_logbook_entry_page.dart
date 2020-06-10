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
import './edit_logbook_entry_page.dart';

class ViewLogbookEntryPage extends StatelessWidget {
  static const String route_name = '/logbook/view-entry';

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Consumer2<LogbookEntryWithImages, Logbook>(
          builder: (context, logbookEntry, logbook, _) => Scaffold(
            appBar: AppBar(
              title: Text(_title(logbookEntry)),
              actions: <Widget>[
                FlatButton(
                  child: Icon(Icons.edit),
                  onPressed: () => _startEdit(context, logbook, logbookEntry),
                ),
                FlatButton(
                  child: Icon(Icons.delete),
                  onPressed: () => _delete(context, logbookEntry, logbook),
                )
              ],
            ),
            body: _buildBody(context, logbookEntry),
          ),
        ),
      );

  String _title(LogbookEntryWithImages logbookEntry) {
    return 'Logbook entry'.i18n;
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

  TableRow _tableRow(String labelKey, String value) => TableRow(
        children: [
          TableCell(
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(labelKey.i18n + ':'),
            ),
          ),
          TableCell(
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(value ?? ''),
            ),
          ),
        ],
      );

  Future _delete(BuildContext context, LogbookEntryWithImages entry,
      Logbook logbook) async {
    final bool shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Really delete?'.i18n),
        content: Text('Deletion can not be made undone!'.i18n),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'.i18n),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'.i18n),
          ),
        ],
      ),
    );

    if (shouldDelete) {
      await logbook.delete(entry.id);
      Navigator.of(context).pop();
    }
  }

  Future<void> _startEdit(BuildContext context, Logbook logbook,
          LogbookEntryWithImages logbookEntry) async =>
      Navigator.of(context).push(
        MaterialPageRoute<LogbookEntryWithImages>(
          fullscreenDialog: true,
          builder: (context) => ChangeNotifierProvider.value(
            value: logbook,
            builder: (_, __) => EditLogbookEntryPage(entry: logbookEntry),
          ),
        ),
      );
}
