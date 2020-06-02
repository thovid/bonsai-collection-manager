/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import '../../shared/ui/base_view.dart';
import '../../shared/state/app_context.dart';
import '../model/bonsai_collection.dart';
import '../i18n/bonsai_collection_view.i18n.dart';
import './edit_bonsai_view.dart';
import './view_bonsai_view.dart';
import './bonsai_tree_list_item.dart';

class OldBonsaiCollectionView extends StatelessWidget
    with Screen<BonsaiCollection> {
  @override
  BonsaiCollection initialModel(BuildContext context) =>
      AppContext.of(context).collection;

  @override
  String title(BuildContext context, BonsaiCollection model) =>
      "My collection".i18n;

  @override
  Widget body(BuildContext context, BonsaiCollection model) {
    return withLoadingIndicator(
        isLoading: !AppContext.of(context).isInitialized,
        child: Center(
          child: ListView(
            children: model?.trees
                    ?.map(
                      (tree) => BonsaiTreeListItem(
                        tree: tree,
                        onTap: () => Navigator.of(context).pushNamed(
                            ViewBonsaiView.route_name,
                            arguments: tree),
                      ),
                    )
                    ?.toList() ??
                const [],
          ),
        ));
  }

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
    Navigator.of(context).pushNamed(EditBonsaiView.route_name);
  }
}
