/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/infrastructure/sql_image_gallery_repository.dart';
import 'package:flutter/material.dart';

import '../i18n/i18n.dart';
import '../../images/model/image_gallery_model.dart';
import '../../trees/infrastructure/sql_bonsai_tree_repository.dart';
import '../../trees/infrastructure/tree_species_loader.dart';
import '../../trees/model/bonsai_collection.dart';
import '../../trees/model/species.dart';

class AppContext {
  final isInitialized;
  final BonsaiCollection collection;
  final SpeciesRepository speciesRepository;
  final ImageRepository imageRepository;
  AppContext(
      {@required this.isInitialized,
      this.collection,
      this.speciesRepository,
      this.imageRepository});

  static AppContext of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedAppContext>()
      .appContext;
}

typedef Widget AppBuilder(BuildContext context);

class WithAppContext extends StatefulWidget {
  final Widget child;
  final AppContext testContext;

  WithAppContext({@required this.child, this.testContext});

  @override
  _WithAppContextState createState() => _WithAppContextState();
}

class _WithAppContextState extends State<WithAppContext> {
  AppContext _appContext;

  @override
  void initState() {
    super.initState();
    if (widget.testContext != null) {
      _appContext = widget.testContext;
      return;
    }

    _appContext = AppContext(isInitialized: false);
    _loadAppContext();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAppContext(
      appContext: _appContext,
      child: widget.child,
    );
  }

  Future<void> _loadAppContext() async {
    Locale locale = await fetchLocale();
    SpeciesRepository species = await fetchSpecies(locale);
    BonsaiCollection collection =
        await SQLBonsaiTreeRepository(species).loadCollection();
    ImageRepository imageRepository = SQLImageGalleryRepository();

    setState(() {
      _appContext = AppContext(
          isInitialized: true,
          collection: collection,
          speciesRepository: species,
          imageRepository: imageRepository);
    });
  }
}

class _InheritedAppContext extends InheritedWidget {
  final AppContext appContext;

  _InheritedAppContext({
    Key key,
    @required this.appContext,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedAppContext oldWidget) {
    return appContext != oldWidget.appContext;
  }
}
