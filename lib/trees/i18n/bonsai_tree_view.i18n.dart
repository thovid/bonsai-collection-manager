/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import '../../worktype/model/work_type.dart';
import 'package:i18n_extension/i18n_extension.dart';
import '../../worktype/i18n/log_work_type_translations.dart';
import 'bonsai_enums.i18n.dart';

extension Localization on String {
  static var _t = BonsaiEnumTranslations.t *
      LogWorkTypeTranslations.t *
      (Translations("en_us") +
          {"en_us": "Add new tree", "de": "Neuen Baum hinzufügen"} +
          {"en_us": "Edit", "de": "Bearbeiten"} +
          {"en_us": "The species of the tree", "de": "Die Spezies des Baumes"} +
          {"en_us": "Species", "de": "Spezies"} +
          {
            "en_us": "Name your tree (optional)",
            "de": "Gib deinem Baum einen Namen (optional)"
          } +
          {"en_us": "Pot Type", "de": "Schale"} +
          {"en_us": "Development Level", "de": "Entwicklungsstand"} +
          {"en_us": "Name", "de": "Name"} +
          {"en_us": "Acquired at", "de": "Erworben am"} +
          {
            "en_us": "Where did you acquire the tree from?",
            "de": "Wo hast du den Baum erworben?"
          } +
          {"en_us": "Acquired from", "de": "Erworben von"} +
          {"en_us": "Cancel", "de": "Abbrechen"} +
          {"en_us": "Save", "de": "Speichern"} +
          {"en_us": "Really delete tree?", "de": "Wirklich löschen?"} +
          {
            "en_us": "Deletion can not be made undone!",
            "de": "Löschen kann nicht rückgängig gemacht werden!"
          } +
          {"en_us": "Delete", "de": "Löschen"} +
          {"en_us": "More", "de": "Mehr"} +
          {"en_us": "Tree", "de": "Baum"} +
          {"en_us": "Logbook", "de": "Logbuch"} +
          {"en_us": "Reminder", "de": "Erinnerungen"} +
          {"en_us": "Add reminder", "de": "Erinnerung hinzufügen"} +
          {"en_us": "Tree deleted", "de": "Baum gelöscht"} +
          {"en_us": "Tree created", "de": "Baum angelegt"} +
          {"en_us": "Tree saved", "de": "Baum gespeichert"});

  String get i18n => localize(this, _t);
  String tense(Tenses tense) =>
      localizeVersion(tense, this, LogWorkTypeTranslations.t);
}
