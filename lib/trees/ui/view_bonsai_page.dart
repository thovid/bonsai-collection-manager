/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../images/model/images.dart';
import '../../images/ui/image_gallery.dart';
import '../../shared/ui/spaces.dart';
import '../model/bonsai_tree_with_images.dart';
import '../i18n/bonsai_tree_view.i18n.dart';
import './edit_bonsai_page.dart';

class ViewBonsaiPage extends StatelessWidget {
  static const route_name = '/view-tree';
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Consumer<BonsaiTreeWithImages>(
          builder:
              (BuildContext context, BonsaiTreeWithImages tree, Widget child) =>
                  Scaffold(
            appBar: AppBar(
              title: _buildTitle(tree),
            ),
            body: _buildBody(context, tree),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startEdit(context, tree),
              tooltip: "Edit".i18n,
              child: Icon(Icons.edit),
            ),
          ),
        ),
      );

  Text _buildTitle(BonsaiTreeWithImages tree) =>
      Text(tree.treeData.displayName);

  void _startEdit(BuildContext context, BonsaiTreeWithImages tree) async {
    Navigator.of(context).push(
      MaterialPageRoute<BonsaiTreeWithImages>(
        fullscreenDialog: true,
        builder: (BuildContext context) => EditBonsaiPage(
          tree: tree,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BonsaiTreeWithImages tree) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ChangeNotifierProvider<Images>.value(
            value: tree.images,
            child: Expanded(child:Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * .5 - 20,
              child: ImageGallery(),
            )),
          ),
          smallSpace,
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Card(
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10),
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
                    _tableRow('Acquired at',
                        DateFormat.yMMMd().format(tree.treeData.acquiredAt)),
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
}
