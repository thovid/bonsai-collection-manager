/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logbook/model/logbook.dart';
import '../../logbook/ui/view_logbook_page.dart';
import '../../shared/icons/log_work_type_icons.dart';
import '../../shared/ui/speed_dial.dart';
import '../model/bonsai_tree_collection.dart';
import '../model/bonsai_tree_with_images.dart';
import '../i18n/bonsai_tree_view.i18n.dart';
import './edit_bonsai_page.dart';
import './bonsa_with_images_view.dart';

class ViewBonsaiPage extends StatelessWidget {
  static const route_name = '/view-tree';

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Consumer2<BonsaiTreeWithImages, BonsaiTreeCollection>(
          builder: (BuildContext context, BonsaiTreeWithImages tree,
                  BonsaiTreeCollection collection, Widget child) =>
              Scaffold(
            appBar: AppBar(
              title: _buildTitle(tree),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.apps),
                  onPressed: () => Navigator.of(context).pushNamed(
                      ViewLogbookPage.route_name,
                      arguments: tree.id),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _delete(context, tree, collection),
                )
              ],
            ),
            body: BonsaiWithImagesView(tree: tree),
            floatingActionButton: SpeedDial(
              children: [
                SpeedDialItem(
                  label: 'More'.i18n,
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
                SpeedDialItem(
                  label: LogWorkType.fertilized.toString().i18n,
                  icon: Icon(LogWorkTypeIcons.seed_bag),
                  onPressed: () {},
                ),
                SpeedDialItem(
                  label: LogWorkType.watered.toString().i18n,
                  icon: Icon(LogWorkTypeIcons.watering),
                  onPressed: () {},
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
      );

  Text _buildTitle(BonsaiTreeWithImages tree) =>
      Text(tree.treeData.displayName);

  Future<void> _startEdit(
          BuildContext context, BonsaiTreeWithImages tree) async =>
      Navigator.of(context).push(
        MaterialPageRoute<BonsaiTreeWithImages>(
          fullscreenDialog: true,
          builder: (BuildContext context) => EditBonsaiPage(
            tree: tree,
          ),
        ),
      );

  Future _delete(BuildContext context, BonsaiTreeWithImages tree,
      BonsaiTreeCollection collection) async {
    final bool shouldDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Really delete tree?".i18n),
              content: Text("Deletion can not be made undone!".i18n),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel".i18n),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Delete".i18n),
                ),
              ],
            ));

    if (shouldDelete) {
      await collection.delete(tree);
      Navigator.of(context).pop();
    }
  }
}
