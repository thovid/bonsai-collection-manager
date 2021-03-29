/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/reminder/ui/edit_reminder_configuration_page.dart';
import 'package:bonsaicollectionmanager/reminder/ui/view_reminder_configuration_page.dart';
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../trees/model/bonsai_tree_with_images.dart';
import '../../trees/model/bonsai_tree_collection.dart';
import '../../trees/ui/view_bonsai_collection_page.dart';
import '../../trees/ui/edit_bonsai_page.dart';
import '../../trees/ui/view_bonsai_tabbed_page.dart';

import '../../credits/ui/credits_page.dart';

import '../../logbook/model/logbook.dart';
import '../../logbook/ui/view_logbook_entry_page.dart';
import '../../logbook/ui/edit_logbook_entry_page.dart';

import '../state/app_context.dart';
import '../ui/loading_screen.dart';
import '../ui/route_not_found.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ViewBonsaiCollectionPage.route_name:
      return MaterialPageRoute(builder: (context) {
        final collection = AppContext.of(context).bonsaiCollection;
        return ChangeNotifierProvider<BonsaiTreeCollection>.value(
          value: collection,
          child: I18n(child: ViewBonsaiCollectionPage()),
        );
      });

    case EditBonsaiPage.route_name:
      return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) {
            final tree = settings.arguments as BonsaiTreeWithImages;
            final collection = AppContext.of(context).bonsaiCollection;
            return ChangeNotifierProvider<BonsaiTreeCollection>.value(
              value: collection,
              child: I18n(child: EditBonsaiPage(tree: tree)),
            );
          });

    case ViewBonsaiTabbedPage.route_name:
      return MaterialPageRoute(builder: (context) {
        final tree = settings.arguments as BonsaiTreeWithImages;

        final collection = AppContext.of(context).bonsaiCollection;
        final logbookRepository = AppContext.of(context).logbookRepository;
        final imageRepository = AppContext.of(context).imageRepository;

        final future = Future.wait([
          tree.fetchImages(),
          Logbook.load(
              logbookRepository: logbookRepository,
              imageRepository: imageRepository,
              subjectId: tree.id),
        ]);
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return LoadingScreen();
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<BonsaiTreeCollection>.value(
                  value: collection,
                ),
                ChangeNotifierProvider<BonsaiTreeWithImages>.value(
                  value: snapshot.data[0],
                ),
                ChangeNotifierProvider<Logbook>.value(
                  value: snapshot.data[1],
                ),
              ],
              child: I18n(child: ViewBonsaiTabbedPage()),
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
            if (snapshot.connectionState != ConnectionState.done) {
              return LoadingScreen();
            }

            return MultiProvider(
              providers: [
                ChangeNotifierProvider<Logbook>.value(value: logbook),
                ChangeNotifierProvider<LogbookEntryWithImages>.value(
                    value: snapshot.data),
              ],
              child: I18n(child: ViewLogbookEntryPage()),
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
          child: I18n(child: EditLogbookEntryPage(entry: entryWithImages)),
        );
      });

    case EditLogbookEntryPage.route_name_create:
      return MaterialPageRoute(builder: (context) {
        final args = settings.arguments as Tuple2<Logbook, LogWorkType>;
        final logbook = args.item1;
        final initialWorkType = args.item2;
        return ChangeNotifierProvider<Logbook>.value(
          value: logbook,
          child: I18n(
              child: EditLogbookEntryPage(initialWorkType: initialWorkType)),
        );
      });

    case ViewReminderConfigurationPage.route_name:
      return MaterialPageRoute(builder: (context) {
        final args =
            settings.arguments as Tuple2<ReminderList, ReminderConfiguration>;
        final reminderList = args.item1;
        final reminderConfiguration = args.item2;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ReminderList>.value(value: reminderList),
            Provider<ReminderConfiguration>.value(value: reminderConfiguration),
          ],
          child: I18n(child: ViewReminderConfigurationPage()),
        );
      });

    case EditReminderConfigurationPage.route_name:
      return MaterialPageRoute(builder: (context) {
        final args =
            settings.arguments as Tuple2<ReminderList, ReminderConfiguration>;
        final reminderList = args.item1;
        final reminderConfiguration = args.item2;
        return ChangeNotifierProvider<ReminderList>.value(
          value: reminderList,
          child: I18n(
              child: EditReminderConfigurationPage(
            reminderConfiguration: reminderConfiguration,
          )),
        );
      });

    case EditReminderConfigurationPage.route_name_create:
      return MaterialPageRoute(builder: (context) {
        final reminderList = settings.arguments as ReminderList;

        return ChangeNotifierProvider<ReminderList>.value(
          value: reminderList,
          child: I18n(child: EditReminderConfigurationPage()),
        );
      });

    case CreditsPage.route_name:
      return MaterialPageRoute(
          builder: (context) => I18n(child: CreditsPage()));

    default:
      return MaterialPageRoute(
          builder: (context) => I18n(child: RouteNotFound()));
  }
}
