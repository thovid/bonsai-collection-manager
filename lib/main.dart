/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';

import './trees/model/bonsai_collection.dart';
import './trees/model/bonsai_tree.dart';
import './trees/model/species.dart';

import './trees/infrastructure/tree_species_loader.dart';

import './trees/ui/bonsai_collection_view.dart';
import './shared/i18n/i18n.dart';
import 'shared/ui/app_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return AppState(
        child: MaterialApp(
            title: 'Bonsai Collection Manager',
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: supportedLanguageCodes,
            theme: ThemeData(
              primarySwatch: Colors.lightGreen,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: I18n(
              child: BonsaiCollectionView(),
            )));
  }
}

BonsaiCollection _testCollection(SpeciesRepository species) {
  final Species aSpecies = species.species[0];
  final List<BonsaiTree> trees = List<BonsaiTree>.generate(
      30,
      (i) => (BonsaiTreeBuilder()
            ..species = aSpecies
            ..speciesOrdinal = i)
          .build());

  final BonsaiCollection collection =
      BonsaiCollection.withTrees(trees);
  return collection;
}
