/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:i18n_extension/i18n_extension.dart';
import 'bonsai_enums.i18n.dart';

extension Localization on String {
  static var _t = BonsaiEnumTranslations.t *
      (Translations("en_us") +
          {
            "en_us": "My collection",
            "de": "Meine Sammlung",
          } +
          {"en_us": "Add tree", "de": "Baum hinzufügen"});

  String get i18n => localize(this, _t);
}
