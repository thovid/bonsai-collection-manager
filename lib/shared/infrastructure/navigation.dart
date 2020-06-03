/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';

import '../../trees/model/bonsai_tree_with_images.dart';
import '../../trees/ui/view_bonsai_collection.dart';
import '../../trees/model/bonsai_tree_collection.dart';
import '../../trees/ui/view_bonsai_view.dart';
import '../../trees/ui/edit_bonsai_view.dart';
import '../state/app_context.dart';
import '../ui/loading_screen.dart';
import '../ui/route_not_found.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ViewBonsaiCollectionView.route_name:
      return MaterialPageRoute(
        builder: (context) {
          final collection = AppContext.of(context).bonsaiCollection;
          return ChangeNotifierProvider<BonsaiTreeCollection>.value(
            value: collection,
            child: I18n(
              child: ViewBonsaiCollectionView(),
            ),
          );
        },
      );

    case EditBonsaiView.route_name:
      final tree = settings.arguments as BonsaiTreeWithImages;
      return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => I18n(child: EditBonsaiView(tree: tree)));

    case ViewBonsaiView.route_name:
      return MaterialPageRoute(builder: (context) {
        final tree = settings.arguments as BonsaiTreeWithImages;
        return FutureBuilder(
          future: tree.fetchImages(),
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
