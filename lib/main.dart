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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SpeciesRepository species = await loadSpecies();
  final BonsaiCollection collection = _testCollection(species);

  runApp(MyApp(collection));
}

class MyApp extends StatelessWidget {
  final BonsaiCollection collection;

  MyApp(this.collection);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bonsai Collection Manager',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('de', ''), const Locale('en', '')],
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: I18n(child: BonsaiCollectionView(collection)),
    );
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
      BonsaiCollection.withTrees(trees, species: species);
  return collection;
}
