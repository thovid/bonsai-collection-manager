/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:bonsaicollectionmanager/shared/ui/base_view.dart';
import 'package:bonsaicollectionmanager/trees/ui/bonsai_tree_list_item.dart';

import 'package:flutter/material.dart';

import '../model/bonsai_collection.dart';
import './bonsai_tree_view.dart';
import '../i18n/bonsai_collection_view.i18n.dart';

class BonsaiCollectionView extends StatelessWidget
    with Screen<BonsaiCollection> {
  final BonsaiCollection collection;
  BonsaiCollectionView(this.collection);

  @override
  BonsaiCollection initialModel(BuildContext context) => collection;

  @override
  String title(BuildContext context, BonsaiCollection model) =>
      "My collection".i18n;

  @override
  Widget body(BuildContext context, BonsaiCollection model) => Center(
      child: ListView(
          children: model.trees
              .map((tree) => BonsaiTreeListItem(
                  tree: tree,
                  onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                        return BonsaiTreeView(model, tree.id);
                      }))))
              .toList()));

  @override
  FloatingActionButton floatingActionButton(
          BuildContext context, BonsaiCollection model) =>
      FloatingActionButton(
        onPressed: () => _addTree(context, model),
        tooltip: "Add tree".i18n,
        child: Icon(Icons.add),
      );

  _addTree(BuildContext context, BonsaiCollection collection) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return BonsaiTreeView(collection, null);
    }));
  }
}
