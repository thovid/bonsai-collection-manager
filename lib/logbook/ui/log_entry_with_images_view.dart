/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/ui/spaces.dart';
import '../model/logbook.dart';
import '../i18n/view_logbook_entry_page.i18n.dart';
import '../../worktype/ui/work_type_panel.dart';

class LogEntryWithImagesView extends StatelessWidget {
  final LogbookEntryWithImages logbookEntry;

  const LogEntryWithImagesView({Key key, this.logbookEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
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
}
