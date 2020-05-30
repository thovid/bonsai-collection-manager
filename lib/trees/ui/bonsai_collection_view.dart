/*
 * Copyright (c) 2020 by Thomas Vidic
 */


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/base_view.dart';
import '../../shared/state/app_context.dart';
import '../model/bonsai_collection.dart';
import '../i18n/bonsai_collection_view.i18n.dart';
import '../model/bonsai_tree.dart';
import './edit_bonsai_view.dart';
import './view_bonsai_view.dart';
import './bonsai_tree_list_item.dart';

class BonsaiCollectionView extends StatelessWidget
    with Screen<BonsaiCollection> {
  @override
  BonsaiCollection initialModel(BuildContext context) =>
      AppContext.of(context).collection;

  @override
  String title(BuildContext context, BonsaiCollection model) =>
      "My collection".i18n;

  @override
  Widget body(BuildContext context, BonsaiCollection model) =>
      withLoadingIndicator(
          isLoading: !AppContext.of(context).isInitialized,
          child: Center(
              child: ListView(
                  children: model?.trees
                          ?.map((tree) => BonsaiTreeListItem(
                              tree: tree,
                              onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) {
                                    return ChangeNotifierProvider<
                                            BonsaiCollection>.value(
                                        value: model,
                                        child: ViewBonsaiView(tree));
                                  }))))
                          ?.toList() ??
                      const [])));

  Widget withLoadingIndicator({bool isLoading, Widget child}) {
    return Stack(
      children: <Widget>[
        isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        child
      ],
    );
  }

  @override
  FloatingActionButton floatingActionButton(
          BuildContext context, BonsaiCollection model) =>
      FloatingActionButton(
        onPressed: () => _addTree(context, model),
        tooltip: "Add tree".i18n,
        child: Icon(Icons.add),
      );

  _addTree(BuildContext context, BonsaiCollection collection) async {
    BonsaiTree newTree = await Navigator.of(context).push(
        MaterialPageRoute<BonsaiTree>(
            fullscreenDialog: true,
            builder: (BuildContext context) => EditBonsaiView()));
    if (newTree != null) {
      collection.add(newTree);
    }
  }
}
