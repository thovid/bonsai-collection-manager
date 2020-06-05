/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/app_drawer.dart';
import '../model/bonsai_tree_collection.dart';
import '../model/bonsai_tree_with_images.dart';
import '../i18n/bonsai_collection_view.i18n.dart';
import './view_bonsai_page.dart';
import './edit_bonsai_page.dart';

class ViewBonsaiCollectionPage extends StatelessWidget {
  static const route_name = '/';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("My collection".i18n),
        ),
        drawer: buildAppDrawer(context: context, currentPage: route_name),
        body: Consumer<BonsaiTreeCollection>(
            builder: (context, collection, _) => _withLoadingIndicator(
                  isLoading: collection == null,
                  builder: () => GridView.builder(
                    padding: EdgeInsets.all(5.0),
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
    if (tree.imagesFetched) {
      return Card(child: _buildTreeTile(tree));
    }

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
                child: tree.images.mainImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(Icons.add_photo_alternate),
                            Text('No image yet'.i18n)
                          ])
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image(
                          image: tree.images.mainImage.toThumbnail(),
                          fit: BoxFit.cover,
                        ),
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
          onTap: () {
            Navigator.of(context)
                .pushNamed(ViewBonsaiPage.route_name, arguments: tree);
          },
        ),
      ),
    );
  }

  _addTree(BuildContext context) async {
    Navigator.of(context).pushNamed(EditBonsaiPage.route_name);
  }

  Widget _withLoadingIndicator({bool isLoading, Widget Function() builder}) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    return builder();
  }
}