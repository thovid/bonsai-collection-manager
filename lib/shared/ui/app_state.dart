/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

import '../../trees/infrastructure/tree_species_loader.dart';
import '../../trees/model/bonsai_collection.dart';
import '../../trees/model/bonsai_tree.dart';
import '../../trees/model/species.dart';

class AppState extends StatefulWidget {
  final Widget child;
  final BonsaiCollection initial;

  AppState({@required this.child, this.initial}) : assert(child != null);

  static _AppStateState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAppState>()
        .data;
  }

  @override
  State<StatefulWidget> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  BonsaiCollection collection;

  @override
  void initState() {
    I18n.observeLocale =
        ({Locale oldLocale, Locale newLocale}) => _loadCollection();

    _loadCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAppState(
      data: this,
      child: widget.child,
    );
  }

  void _loadCollection() async {
    if (widget.initial != null) {
      setState(() {
        collection = widget.initial;
      });
      return;
    }

    Locale locale = I18n.locale;
    if(locale == null) {
      return;
    }
    // TODO implement
    var species = await loadSpecies(I18n.locale);
    setState(() {
      collection = _testCollection(species);
    });
  }
}

class _InheritedAppState extends InheritedWidget {
  final _AppStateState data;

  _InheritedAppState({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
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
