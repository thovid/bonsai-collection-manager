/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';

import './shared/infrastructure/navigation.dart';

import './trees/ui/bonsai_collection_view.dart';
import './shared/state/app_context.dart';
import './shared/i18n/i18n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return WithAppContext(
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
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

