/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/base_view.dart';
import '../../shared/state/app_context.dart';
import '../../images/model/image_gallery_model.dart';
import '../model/bonsai_tree_with_images.dart';
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
  Widget body(BuildContext context, BonsaiCollection model) {
    final ImageRepository imageRepository =
        AppContext.of(context).imageRepository;
    return withLoadingIndicator(
        isLoading: !AppContext.of(context).isInitialized,
        child: Center(
          child: ListView(
            children: model?.trees
                    ?.map(
                      (tree) => BonsaiTreeListItem(
                        tree: tree,
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                          return FutureBuilder(
                            future:
                                _loadWithImages(model, imageRepository, tree),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ChangeNotifierProvider<
                                        BonsaiTreeWithImages>.value(
                                    value: snapshot.data,
                                    child: ViewBonsaiView());
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          );
                        })),
                      ),
                    )
                    ?.toList() ??
                const [],
          ),
        ));
  }
/*
  ChangeNotifierProvider<
      BonsaiTreeWithImages>.value(
  value:
  _loadWithImages(model, imageRepository, tree),
  child: ViewBonsaiView());
*/

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

  Future<BonsaiTreeWithImages> _loadWithImages(BonsaiCollection model,
      ImageRepository imageRepository, BonsaiTree tree) async {
    var images =
        await ImageGalleryModel.fromRepository(imageRepository, tree.id);
    return BonsaiTreeWithImages(tree: tree, images: images, collection: model);
  }
}
