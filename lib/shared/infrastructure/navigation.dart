/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../images/model/image_gallery_model.dart';
import '../../trees/model/bonsai_tree.dart';
import '../../trees/model/bonsai_tree_with_images.dart';
import '../../trees/ui/view_bonsai_view.dart';
import '../../trees/ui/edit_bonsai_view.dart';
import '../state/app_context.dart';
import '../ui/loading_screen.dart';
import '../ui/route_not_found.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case EditBonsaiView.route_name:
      final tree = settings.arguments as BonsaiTree;
      return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => EditBonsaiView(initialTree: tree));

    case ViewBonsaiView.route_name:
      return MaterialPageRoute(builder: (context) {
        final tree = settings.arguments as BonsaiTree;
        return FutureBuilder(
          future: _fetchTreeWithImages(context, tree),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return LoadingScreen();
            return ChangeNotifierProvider<BonsaiTreeWithImages>.value(
              value: snapshot.data,
              builder: (context, _) => ViewBonsaiView(),
            );
          },
        );
      });

    default:
      return MaterialPageRoute(builder: (context) => RouteNotFound());
  }
}

Future<BonsaiTreeWithImages> _fetchTreeWithImages(
    BuildContext context, BonsaiTree tree) async {
  final collection = AppContext.of(context).collection;
  final imageRepo = AppContext.of(context).imageRepository;
  var images = await ImageGalleryModel.fromRepository(imageRepo, tree.id);

  return BonsaiTreeWithImages(
      tree: tree, images: images, collection: collection);
}
