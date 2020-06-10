/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../logbook/ui/view_logbook_page.dart';
import '../../images/model/images.dart';

import '../../images/ui/image_gallery.dart';
import '../../shared/icons/log_work_type_icons.dart';
import '../../shared/ui/speed_dial.dart';
import '../../shared/ui/spaces.dart';
import '../model/bonsai_tree_collection.dart';
import '../model/bonsai_tree_with_images.dart';
import '../i18n/bonsai_tree_view.i18n.dart';
import './edit_bonsai_page.dart';

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
            body: _buildBody(context, tree),
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

  Widget _buildBody(BuildContext context, BonsaiTreeWithImages tree) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ChangeNotifierProvider<Images>.value(
            value: tree.images,
            child: Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * .5 - 20,
              child: ImageGallery(),
            )),
          ),
          smallVerticalSpace,
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Table(
                  columnWidths: {0: FractionColumnWidth(.4)},
                  children: [
                    _tableRow('Species',
                        "${tree.treeData.species.latinName} - ${tree.treeData.species.informalName}"),
                    if (tree.treeData.treeName != null &&
                        tree.treeData.treeName.isNotEmpty)
                      _tableRow('Name', tree.treeData.treeName),
                    _tableRow('Development Level',
                        tree.treeData.developmentLevel.toString().i18n),
                    _tableRow(
                        'Pot Type', tree.treeData.potType.toString().i18n),
                    _tableRow(
                        'Acquired at',
                        DateFormat.yMMMd(I18n.locale?.toString())
                            .format(tree.treeData.acquiredAt)),
                    _tableRow('Acquired from', tree.treeData.acquiredFrom),
                  ],
                ),
              ),
            ),
          )
        ],
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
