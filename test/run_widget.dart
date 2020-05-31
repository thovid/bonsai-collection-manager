/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/image_gallery_model.dart';
import 'package:bonsaicollectionmanager/shared/i18n/i18n.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/images/ui/image_gallery.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_with_images.dart';
import 'package:bonsaicollectionmanager/trees/ui/edit_bonsai_view.dart';
import 'package:bonsaicollectionmanager/trees/ui/view_bonsai_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';

import 'utils/test_data.dart';
import 'utils/test_utils.dart';

/// Helper to run a widget in a scaffold for visual checking purposes

ImageGalleryModel empty = ImageGalleryModel(
    parent: ModelID.newId(), repository: DummyImageRepository());
void main() {
  //runImageGallery();
  //runEditBonsaiView();
  runViewBonsaiView();
}

Future runViewBonsaiView() async {
  BonsaiTree tree = aBonsaiTree;
  BonsaiTreeWithImages treeWithImages = BonsaiTreeWithImages(
    tree: tree,
    images: empty,
    collection: await TestBonsaiRepository([tree]).loadCollection(),
  );
  runApp(WidgetRunner(ChangeNotifierProvider.value(
    value: treeWithImages,
    builder: (context, child) => ViewBonsaiView(),
  )));
}

void runEditBonsaiView() {
  runApp(WidgetRunner(EditBonsaiView()));
}

void runImageGallery() {
  runApp(WidgetRunner(ChangeNotifierProvider<ImageGalleryModel>.value(
      value: empty,
      builder: (context, _) => Scaffold(
          body: Center(
              child: Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * .5 - 20,
                  child: ImageGallery()))))));
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
