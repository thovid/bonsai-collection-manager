/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/worktype/i18n/log_work_type_translations.dart';
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = (Translations("en_us") +
          {
            'en_us': 'Logbook entry',
            'de': 'Logbuch Eintrag',
          } +
          {
            'en_us': 'Date',
            'de': 'Datum',
          } +
          {
            'en_us': 'Notes',
            'de': 'Notizen',
          } +
          {
            "en_us": "Cancel",
            "de": "Abbrechen",
          } +
          {
            "en_us": "Really delete?",
            "de": "Wirklich löschen?",
          } +
          {
            "en_us": "Deletion can not be made undone!",
            "de": "Löschen kann nicht rückgängig gemacht werden!",
          } +
          {
            "en_us": "Delete",
            "de": "Löschen",
          } +
          {
            "en_us": "Save",
            "de": "Speichern",
          } +
          {
            "en_us": "Add some notes",
            "de": "Füge eine Notiz hinzu",
          } +
          {
            "en_us": "Edit entry",
            "de": "Eintrag bearbeiten",
          } +
          {
            "en_us": "Create entry",
            "de": "Eintrag erstellen",
          }) *
      LogWorkTypeTranslations.t;

  String get i18n => localize(this, _t);
}
