/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/shared/i18n/i18n.dart';
import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/shared/ui/image_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';

/// Helper to run a widget in a scaffold for visual checking purposes

ImageGalleryModel model = ImageGalleryModel(
    primary: ImageDescriptor(
        'https://www.bonsaipflege.ch/images/bilder/Bonsai%20-%20Nadel/E-H/Picea_.jpg'),
    images: [
      ImageDescriptor(
          'https://www.gartenjournal.net/wp-content/uploads/fichte-bonsai.jpg'),
      ImageDescriptor(
          'https://www.bonsaipflege.ch/images/bilder/Bonsai%20-%20Nadel/E-H/Picea_.jpg'),
      ImageDescriptor(
          'https://www.gartenjournal.net/wp-content/uploads/fichte-bonsai.jpg'),
      ImageDescriptor(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
      ImageDescriptor(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
      ImageDescriptor(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
    ]);

void main() {
  runApp(WidgetRunner(ChangeNotifierProvider<ImageGalleryModel>.value(
      value: model, builder: (context, _) => ImageGallery())));
}

class WidgetRunner extends StatelessWidget {
  final Widget child;
  WidgetRunner(this.child);

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
              child: Scaffold(
            body: Center(
              child: child,
            ),
          ))),
    );
  }
}
