/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:i18n_extension/i18n_extension.dart';
import 'bonsai_enums.i18n.dart';

extension Localization on String {
  static var _t = BonsaiEnumTranslations.t *
      (Translations("en_us") +
          {"en_us": "Add new tree", "de": "Neuen Baum hinzufügen"} +
          {"en_us": "Edit", "de": "Bearbeiten"} +
          {"en_us": "The species of the tree", "de": "Die Spezies des Baumes"} +
          {"en_us": "Species", "de": "Spezies"} +
          {
            "en_us": "Name your tree (optional)",
            "de": "Gib deinem Baum einen Namen (optional)"
          } +
          {"en_us": "Name", "de": "Name"} +
          {"en_us": "Acquired at", "de": "Erworben am"} +
          {
            "en_us": "Where did you acquire the tree from?",
            "de": "Wo hast du den Baum erworben?"
          } +
          {"en_us": "Acquired from", "de": "Erworben von"} +
          {"en_us": "Cancel", "de": "Abbrechen"} +
          {"en_us": "Save", "de": "Speichern"});

  String get i18n => localize(this, _t);
}
