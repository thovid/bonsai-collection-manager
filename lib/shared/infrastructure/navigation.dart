/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../trees/model/bonsai_tree_with_images.dart';
import '../../trees/model/bonsai_tree_collection.dart';
import '../../trees/ui/view_bonsai_collection_page.dart';
import '../../trees/ui/view_bonsai_page.dart';
import '../../trees/ui/edit_bonsai_page.dart';

import '../../credits/ui/credits_page.dart';

import '../../logbook/model/logbook.dart';
import '../../logbook/ui/view_logbook_page.dart';
import '../../logbook/ui/view_logbook_entry_page.dart';
import '../../logbook/ui/edit_logbook_entry_page.dart';

import '../model/model_id.dart';
import '../state/app_context.dart';
import '../ui/loading_screen.dart';
import '../ui/route_not_found.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ViewBonsaiCollectionPage.route_name:
      return MaterialPageRoute(
        builder: (context) {
          final collection = AppContext.of(context).bonsaiCollection;
          return ChangeNotifierProvider<BonsaiTreeCollection>.value(
            value: collection,
            child: I18n(
              child: ViewBonsaiCollectionPage(),
            ),
          );
        },
      );

    case EditBonsaiPage.route_name:
      final tree = settings.arguments as BonsaiTreeWithImages;
      return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => I18n(child: EditBonsaiPage(tree: tree)));

    case ViewBonsaiPage.route_name:
      return MaterialPageRoute(builder: (context) {
        final tree = settings.arguments as BonsaiTreeWithImages;
        final collection = AppContext.of(context).bonsaiCollection;
        return FutureBuilder(
          future: tree.fetchImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return LoadingScreen();
            return ChangeNotifierProvider<BonsaiTreeCollection>.value(
              value: collection,
              child: ChangeNotifierProvider<BonsaiTreeWithImages>.value(
                value: snapshot.data,
                builder: (context, _) => I18n(child: ViewBonsaiPage()),
              ),
            );
          },
        );
      });

    case ViewLogbookEntryPage.route_name:
      return MaterialPageRoute(builder: (context) {
        final args =
            settings.arguments as Tuple2<Logbook, LogbookEntryWithImages>;
        final logbook = args.item1;
        final entry = args.item2;
        return FutureBuilder(
          future: entry.fetchImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return LoadingScreen();

            // return MultiProvider(providers: [], child: ,);

            return ChangeNotifierProvider<Logbook>.value(
              value: logbook,
              builder: (context, _) =>
                  ChangeNotifierProvider<LogbookEntryWithImages>.value(
                value: snapshot.data,
                builder: (context, _) => I18n(child: ViewLogbookEntryPage()),
              ),
            );
          },
        );
      });

    case EditLogbookEntryPage.route_name:
      return MaterialPageRoute(builder: (context) {
        final args =
            settings.arguments as Tuple2<Logbook, LogbookEntryWithImages>;
        final logbook = args.item1;
        final entryWithImages = args.item2;
        return ChangeNotifierProvider<Logbook>.value(
          value: logbook,
          builder: (context, _) =>
              I18n(child: EditLogbookEntryPage(entry: entryWithImages)),
        );
      });

    case ViewLogbookPage.route_name:
      return MaterialPageRoute(
        builder: (context) {
          final subjectId = settings.arguments as ModelID;
          final imageRepository = AppContext.of(context).imageRepository;
          final logbookRepository = AppContext.of(context).logbookRepository;
          return FutureBuilder(
            future: Logbook.load(
                logbookRepository: logbookRepository,
                imageRepository: imageRepository,
                subjectId: subjectId),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return LoadingScreen();
              return ChangeNotifierProvider<Logbook>.value(
                value: snapshot.data,
                builder: (context, child) => I18n(child: ViewLogbookPage()),
              );
            },
          );
        },
      );

    case CreditsPage.route_name:
      return MaterialPageRoute(
          builder: (context) => I18n(child: CreditsPage()));

    default:
      return MaterialPageRoute(
          builder: (context) => I18n(child: RouteNotFound()));
  }
}
