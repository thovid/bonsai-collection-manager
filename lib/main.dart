/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './shared/infrastructure/navigation.dart';
import './trees/ui/view_bonsai_collection_page.dart';
import './shared/state/app_context.dart';
import './shared/i18n/i18n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print(imageCache.maximumSizeBytes);
 // imageCache.maximumSizeBytes = 500 << 20;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return WithAppContext(
      child: MaterialApp(
        title: 'Bonsai Collection Manager',
        debugShowCheckedModeBanner: false,
      //checkerboardOffscreenLayers: true,
      //checkerboardRasterCacheImages: true,
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
        initialRoute: ViewBonsaiCollectionPage.route_name,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
