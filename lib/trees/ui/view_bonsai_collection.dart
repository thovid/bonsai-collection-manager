/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_with_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../images/model/images.dart';
import '../model/bonsai_tree_data.dart';
import '../model/bonsai_collection.dart';
import '../i18n/bonsai_collection_view.i18n.dart';
import './edit_bonsai_view.dart';

class ViewCollectionView extends StatelessWidget {
  static const route_name = '/collection';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("My collection".i18n),
    ),
    body: Consumer2<BonsaiCollection, ImageRepository>(
        builder: (context, collection, images, _) => _withLoadingIndicator(
          isLoading: collection == null,
          builder: () => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: collection.size,
            itemBuilder: (context, index) => _buildTreeTile(
                context, collection.trees[index], collection, images),
          ),
        )),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _addTree(context),
      tooltip: "Add tree".i18n,
      child: Icon(Icons.add),
    ),
  );

  _buildTreeTile(BuildContext context, BonsaiTreeData tree,
      BonsaiCollection collection, ImageRepository images) {
    return FutureBuilder(
      future: _loadTreeWithMainImage(context, tree, collection, images),
      builder: (context, snapshot) {
        var child = snapshot.connectionState != ConnectionState.done
            ? Center(child: CircularProgressIndicator())
            : ChangeNotifierProvider<BonsaiTreeWithImages>.value(
          value: snapshot.data,
          builder: (context, _) => Consumer<BonsaiTreeWithImages>(
            builder:
                (BuildContext context, BonsaiTreeWithImages value, Widget child) =>
                InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Image.file(
                          File(value.images.mainImage?.path),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate),
                                Text('No image yet'.i18n)
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          value.treeData.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  ),
                  onTap: () {/* TODO open tree */},
                ),
          ),
        );
        return Card(
          child: child,
        );
      },
    );
  }

  _addTree(BuildContext context) async {
    Navigator.of(context).pushNamed(EditBonsaiView.route_name);
  }

  Future<BonsaiTreeWithImages> _loadTreeWithMainImage(
      BuildContext context,
      BonsaiTreeData tree,
      BonsaiCollection collection, // TODO remove
      ImageRepository imageRepository) async {
    print("Load tree with main image for ${tree.displayName}");

    final Images images = Images(repository: imageRepository, parent: tree.id);
    await images.fetchImages();
    return BonsaiTreeWithImages(treeData: tree, images: images);
  }

  Widget _withLoadingIndicator({bool isLoading, Widget Function() builder}) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    return builder();
  }
}
