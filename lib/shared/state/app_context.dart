/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/infrastructure/sql_logbook_repository.dart';
import 'package:flutter/material.dart';

import '../i18n/i18n.dart';
import '../../images/infrastructure/sql_image_gallery_repository.dart';
import '../../images/model/images.dart';
import '../../trees/model/species.dart';
import '../../trees/model/bonsai_tree_collection.dart';
import '../../trees/infrastructure/sql_bonsai_tree_repository.dart';
import '../../trees/infrastructure/tree_species_loader.dart';
import '../../logbook/model/logbook.dart';

class AppContext {
  final isInitialized;
  final BonsaiTreeCollection bonsaiCollection;
  final SpeciesRepository speciesRepository;
  final ImageRepository imageRepository;
  final LogbookRepository logbookRepository;
  AppContext(
      {@required this.isInitialized,
      this.bonsaiCollection,
      this.speciesRepository,
      this.imageRepository,
      this.logbookRepository});

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
    BonsaiTreeRepository treeRepository = SQLBonsaiTreeRepository(species);
    ImageRepository imageRepository = SQLImageGalleryRepository();
    LogbookRepository logbookRepository = SQLLogbookRepository();
    BonsaiTreeCollection bonsaiCollection = await BonsaiTreeCollection.load(
        treeRepository: treeRepository, imageRepository: imageRepository);

    setState(() {
      _appContext = AppContext(
          isInitialized: true,
          bonsaiCollection: bonsaiCollection,
          speciesRepository: species,
          imageRepository: imageRepository,
          logbookRepository: logbookRepository);
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
