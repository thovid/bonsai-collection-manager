/*
 * Copyright (c) 2020 by Thomas Vidic
 */

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
      });

  String get i18n => localize(this, _t);
}
