/*
 * Copyright (c) 2020 by Thomas Vidic
 */

/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../logbook/ui/logbook_view.dart';
import '../../logbook/model/logbook.dart';
import '../../logbook/ui/edit_logbook_entry_page.dart';
import '../../shared/icons/log_work_type_icons.dart';
import '../../shared/ui/speed_dial.dart';
import '../model/bonsai_tree_collection.dart';
import '../model/bonsai_tree_with_images.dart';
import '../i18n/bonsai_tree_view.i18n.dart';
import './edit_bonsai_page.dart';
import './bonsa_with_images_view.dart';

class ViewBonsaiTabbedPage extends StatelessWidget {
  static const route_name = '/view-tree-tabbed';

  @override
  Widget build(BuildContext context) => SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Consumer3<BonsaiTreeWithImages, Logbook, BonsaiTreeCollection>(
            builder: (BuildContext context,
                    BonsaiTreeWithImages tree,
                    Logbook logbook,
                    BonsaiTreeCollection collection,
                    Widget child) =>
                Scaffold(
              appBar: AppBar(
                title: _buildTitle(tree),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _delete(context, tree, logbook, collection),
                  )
                ],
                bottom: TabBar(
                  tabs: [
                    Tab(
                        icon: ImageIcon(AssetImage('icons/bonsai.png')),
                        text: 'Tree'.i18n),
                    Tab(icon: Icon(Icons.list), text: 'Logbook'.i18n),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  BonsaiWithImagesView(tree: tree),
                  LogbookView(
                    logbook: logbook,
                  )
                ],
              ),
              floatingActionButton: SpeedDial(
                children: [
                  SpeedDialItem(
                    label: 'More'.i18n,
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      _addLogbookEntry(context, LogWorkType.custom, logbook);
                    },
                  ),
                  SpeedDialItem(
                    label: LogWorkType.fertilized.toString().i18n,
                    icon: Icon(LogWorkTypeIcons.seed_bag),
                    onPressed: () {
                      _addLogbookEntry(
                          context, LogWorkType.fertilized, logbook);
                    },
                  ),
                  SpeedDialItem(
                    label: LogWorkType.watered.toString().i18n,
                    icon: Icon(LogWorkTypeIcons.watering),
                    onPressed: () {
                      _addLogbookEntry(context, LogWorkType.watered, logbook);
                    },
                  ),
                  SpeedDialItem(
                    label: 'Edit'.i18n,
                    icon: Icon(Icons.edit),
                    onPressed: () => _startEdit(context, tree),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Text _buildTitle(BonsaiTreeWithImages tree) =>
      Text(tree.treeData.displayName);

  Future<void> _startEdit(
          BuildContext context, BonsaiTreeWithImages tree) async =>
      Navigator.of(context)
          .pushNamed(EditBonsaiPage.route_name, arguments: tree);

  Future _delete(BuildContext context, BonsaiTreeWithImages tree,
      Logbook logbook, BonsaiTreeCollection collection) async {
    final bool shouldDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Really delete tree?".i18n),
              content: Text("Deletion can not be made undone!".i18n),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel".i18n),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Delete".i18n),
                ),
              ],
            ));

    if (shouldDelete) {
      await collection.delete(tree);
      await logbook.deleteAll();
      Navigator.of(context).pop();
    }
  }

  void _addLogbookEntry(
      BuildContext context, LogWorkType initialWorkType, Logbook logbook) {
    Navigator.of(context).pushNamed(EditLogbookEntryPage.route_name_create,
        arguments: Tuple2(logbook, initialWorkType));
  }
}
