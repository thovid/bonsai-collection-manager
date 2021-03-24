/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = (Translations("en_us") +
      {
        "en_us": "Please select a tree species",
        "de": "Bitte wähle eine Spezies aus",
      } +
      {
        "en_us": "Please enter the informal name",
        "de": "Bitte gib einen gemeinen Namen ein",
      } +
      {
        "en_us": "Informal name",
        "de": "Gemeiner Name",
      } +
      {
        "en_us": "Please enter the latin name",
        "de": "Bitte gib den lateinischen Namen ein",
      } +
      {
        "en_us": "Latin name",
        "de": "Lateinischer Name",
      } +
      {
        "en_us": "Species already existing",
        "de": "Es existiert bereits eine Spezies mit diesem Namen",
      } +
      {
        "en_us": "Add Species",
        "de": "Spezies hinzufügen",
      } +
      {
        "en_us": "Not found. Create?",
        "de": "Spezies nicht gefunden. Hinzufügen?",
      } +
      {
        "en_us": "Save",
        "de": "Speichern",
      });

  String get i18n => localize(this, _t);
}
