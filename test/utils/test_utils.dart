/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/infrastructure/logbook_entry_table.dart';
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/reminder/infrastructure/reminder_configuration_table.dart';
import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/infrastructure/navigation.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/shared/ui/route_not_found.dart';
import 'package:bonsaicollectionmanager/trees/infrastructure/bonsai_tree_table.dart';
import 'package:bonsaicollectionmanager/images/infrastructure/collection_item_image_table.dart';
import 'package:bonsaicollectionmanager/trees/infrastructure/species_table.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_collection.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_data.dart';
import 'test_mocks.dart';

Future<Widget> testAppWith(Widget widget,
    {BonsaiTreeCollection bonsaiCollection,
    NavigatorObserver navigationObserver}) async {
  bonsaiCollection ??= await emptyCollection();
  return WithAppContext(
      child: MaterialApp(
        home: ChangeNotifierProvider<BonsaiTreeCollection>.value(
          value: bonsaiCollection,
          builder: (context, child) => widget,
        ),
        navigatorObservers: [
          if (navigationObserver != null) navigationObserver
        ],
        onGenerateRoute: generateRoute,
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => RouteNotFound(),
        ),
      ),
      testContext: AppContext(
        isInitialized: true,
        bonsaiCollection: bonsaiCollection,
        speciesRepository: testSpecies,
        imageRepository: DummyImageRepository(),
        logbookRepository: MockLogbookRepository(),
      ));
}

Future<Database> openTestDatabase(
    {bool createTables = true, bool dropAll = true}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  if (dropAll) {
    await databaseFactoryFfi.deleteDatabase(inMemoryDatabasePath);
  }

  var database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  if (createTables) {
    await BonsaiTreeTable.createTable(database);
    await CollectionItemImageTable.createTable(database);
    await LogbookEntryTable.createTable(database);
    await SpeciesTable.createTable(database);
    await ReminderConfigurationTable.createTable(database);
  }
  return database;
}

Future<BonsaiTreeCollection> loadCollectionWith(
        List<BonsaiTreeData> trees) async =>
    await BonsaiTreeCollection.load(
        treeRepository: TestBonsaiRepository(trees),
        imageRepository: DummyImageRepository());

Future<Logbook> loadLogbookWith(List<LogbookEntry> entries,
    {ModelID subject}) async {
  subject ??= ModelID.newId();

  var repo = MockLogbookRepository();
  when(repo.loadLogbook(subject)).thenAnswer((_) => Future.value(entries));

  return await Logbook.load(
      logbookRepository: repo,
      imageRepository: DummyImageRepository(),
      subjectId: subject);
}

Future<SingleSubjectReminderList> loadReminderListWith(List<ReminderConfiguration> entries,
    {ModelID subject}) async {
  subject ??= ModelID.newId();

  var repo = MockReminderRepository();
  when(repo.loadReminderFor(subject)).thenAnswer((_) => Future.value(entries));
  return SingleSubjectReminderList.load(repo, subjectId: subject);
}
