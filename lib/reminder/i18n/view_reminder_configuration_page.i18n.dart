/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'ending_conditition_type_translations.dart';
import 'frequency_unit_translations.dart';
import '../../worktype/model/work_type.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../worktype/i18n/log_work_type_translations.dart';

extension Localization on String {
  static var _t = (Translations("en_us") +
          {
            "en_us": "Reminder",
            "de": "Erinnerung",
          } +
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
          } +
          {
            "en_us": "For",
            "de": "Für",
          } +
          {
            "en_us": "Starts",
            "de": "Beginnt",
          } +
          {
            "en_us": "Repeats",
            "de": "Wiederholt",
          } +
          {
            "en_us": "Ends",
            "de": "Endet",
          } +
          {
            "en_us": "Once",
            "de": "Einmal",
          } +
          {
            "en_us": "Every %d %s",
            "de": "Alle %d %s",
          } +
          {
            "en_us": "Never",
            "de": "Nie",
          } +
          {
            "en_us": "After %d repetitions".one("After one repetition"),
            "de": "Nach %d Wiederholungen".one("Nach einer Wiederholung"),
          } +
          {
            "en_us": "At %s",
            "de": "Am %s",
          }) *
      LogWorkTypeTranslations.t *
      FrequencyUnitTranslations.t *
      EndingConditionTypeTranslations.t;

  String get i18n => localize(this, _t);
  String plural(int value) => localizePlural(value, this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String tense(Tenses tense) =>
      localizeVersion(tense, this, LogWorkTypeTranslations.t);
}
