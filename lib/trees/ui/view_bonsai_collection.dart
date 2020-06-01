/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/bonsai_tree_collection.dart';
import '../model/bonsai_tree_with_images.dart';
import '../i18n/bonsai_collection_view.i18n.dart';
import './edit_bonsai_view.dart';

class ViewCollectionView extends StatelessWidget {
  static const route_name = '/collection';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("My collection".i18n),
        ),
        body: Consumer<BonsaiTreeCollection>(
            builder: (context, collection, _) => _withLoadingIndicator(
                  isLoading: collection == null,
                  builder: () => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: collection.size,
                    itemBuilder: (context, index) =>
                        _buildLoadingTreeTile(collection.trees[index]),
                  ),
                )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTree(context),
          tooltip: "Add tree".i18n,
          child: Icon(Icons.add),
        ),
      );

  _buildLoadingTreeTile(BonsaiTreeWithImages tree) {
    return FutureBuilder(
      future: tree.fetchImages(),
      builder: (context, snapshot) {
        return Card(
          child: _withLoadingIndicator(
              isLoading: snapshot.connectionState != ConnectionState.done,
              builder: () => _buildTreeTile(snapshot.data)),
        );
      },
    );
  }

  ChangeNotifierProvider<BonsaiTreeWithImages> _buildTreeTile(
      BonsaiTreeWithImages initialTree) {
    return ChangeNotifierProvider<BonsaiTreeWithImages>.value(
      value: initialTree,
      builder: (context, _) => Consumer<BonsaiTreeWithImages>(
        builder:
            (BuildContext context, BonsaiTreeWithImages tree, Widget child) =>
                InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Image.file(
                  File(tree.images.mainImage?.path ?? ''),
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
                  tree.treeData.displayName,
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
  }

  _addTree(BuildContext context) async {
    Navigator.of(context).pushNamed(EditBonsaiView.route_name);
  }

  Widget _withLoadingIndicator({bool isLoading, Widget Function() builder}) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    return builder();
  }
}
