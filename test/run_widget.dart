/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/images.dart';
import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/logbook/ui/view_logbook_entry_page.dart';
import 'package:bonsaicollectionmanager/logbook/ui/view_logbook_page.dart';
import 'package:bonsaicollectionmanager/shared/i18n/i18n.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/images/ui/image_gallery.dart';
import 'package:bonsaicollectionmanager/trees/ui/edit_bonsai_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:provider/provider.dart';

import 'utils/test_data.dart';
import 'utils/test_mocks.dart';
import 'utils/test_utils.dart' as testUtils;

/// Helper to run a widget in a scaffold for visual checking purposes

Images empty =
    Images(parent: ModelID.newId(), repository: DummyImageRepository());
void main() {
  //runImageGallery();
  //runEditBonsaiView();
  //runViewBonsaiView();
  //runViewLogbookEntryPage();
  runViewLogbookPage();
}

Future runViewLogbookPage() async {
  LogbookEntry entry = aLogbookEntry;
  Logbook logbook = await testUtils.loadLogbookWith([entry, entry, entry]);
  runApp(
    WidgetRunner(
      ChangeNotifierProvider.value(
        value: logbook,
        builder: (context, child) => ViewLogbookPage(),
      ),
    ),
  );
}

Future runViewLogbookEntryPage() async {
  LogbookEntry entry = aLogbookEntry;
  Logbook logbook = await testUtils.loadLogbookWith([entry]);
  LogbookEntryWithImages entryWithImages =
      LogbookEntryWithImages(entry: entry, images: empty);
  runApp(
    WidgetRunner(
      ChangeNotifierProvider.value(
        value: logbook,
        child: ChangeNotifierProvider.value(
          value: entryWithImages,
          builder: (context, child) => ViewLogbookEntryPage(),
        ),
      ),
    ),
  );
}

void runEditBonsaiView() {
  runApp(WidgetRunner(EditBonsaiPage()));
}

void runImageGallery() {
  runApp(WidgetRunner(ChangeNotifierProvider<Images>.value(
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
          ),
        ),
      ),
    );
  }
}
