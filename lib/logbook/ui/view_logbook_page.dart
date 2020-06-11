/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../i18n/view_logbook_page.i18n.dart';
import '../model/logbook.dart';
import './edit_logbook_entry_page.dart';
import './logbook_view.dart';


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
          body: LogbookView(
            logbook: logbook,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addEntry(context, logbook),
            tooltip: "Add log entry".i18n,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Future _addEntry(BuildContext context, Logbook logbook) async =>
      Navigator.of(context).pushNamed(EditLogbookEntryPage.route_name,
          arguments: Tuple2(logbook, null));
}
