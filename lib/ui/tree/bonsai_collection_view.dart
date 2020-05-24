import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/ui/base/base_view.dart';
import 'package:bonsaicollectionmanager/ui/shared/bonsai_tree_list_item.dart';
import 'package:bonsaicollectionmanager/ui/tree/bonsai_tree_view.dart';
import 'package:flutter/material.dart';

class BonsaiCollectionView extends StatelessWidget with Screen<BonsaiCollection> {
  final BonsaiCollection collection;
  BonsaiCollectionView(this.collection);

  @override
  BonsaiCollection initialModel(BuildContext context) => collection;

  @override
  String title(BuildContext context, BonsaiCollection model) => 'Collection';

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
        tooltip: 'Add Tree',
        child: Icon(Icons.add),
      );

  _addTree(BuildContext context, BonsaiCollection collection) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return BonsaiTreeView(collection, null);
    }));
  }
}
