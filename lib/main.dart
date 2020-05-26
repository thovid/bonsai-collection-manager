/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/infrastructure/localization/bcm_localizations.dart';
import 'package:bonsaicollectionmanager/ui/tree/bonsai_collection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'domain/tree/bonsai_tree.dart';
import 'domain/tree/species.dart';
import 'infrastructure/masterdata/tree_species_loader.dart';

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
        BCMLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('de', ''), const Locale('en', '')],
      onGenerateTitle: (context) => I10L.of(context).app_title,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BonsaiCollectionView(collection),
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
