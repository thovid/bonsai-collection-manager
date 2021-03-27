/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/i18n/ending_conditition_type_translations.dart';
import 'package:bonsaicollectionmanager/reminder/i18n/frequency_unit_translations.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../worktype/i18n/log_work_type_translations.dart';

extension Localization on String {
  static var _t = (Translations("en_us") +
          {
            "en_us": "Cancel",
            "de": "Abbrechen",
          } +
          {
            "en_us": "Edit reminder",
            "de": "Erinnerung bearbeiten",
          } +
          {
            "en_us": "Create reminder",
            "de": "Erinnerung anlegen",
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
            "en_us": "On",
            "de": "Am",
          } +
          {
            "en_us": "Repeat",
            "de": "Wiederholen",
          } +
          {
            "en_us": "Every",
            "de": "Alle",
          } +
          {
            "en_us": "Ends",
            "de": "Endet",
          } +
          {
            "en_us": "Repetitions".one("Repetition"),
            "de": "Wiederholungen".one("Wiederholung"),
          }) *
      LogWorkTypeTranslations.t *
      FrequencyUnitTranslations.t *
      EndingConditionTypeTranslations.t;

  String get i18n => localize(this, _t);
  String plural(int value) => localizePlural(value, this, _t);
}
