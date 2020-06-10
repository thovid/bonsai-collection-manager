/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:i18n_extension/i18n_extension.dart';
import './log_work_type_translations.dart';

extension Localization on String {
  static var _t = (Translations("en_us") +
          {
            'en_us': 'Logbook',
            'de': 'Logbuch',
          } +
          {
            'en_us': 'Add log entry',
            'de': 'Logbucheintrag hinzufügen',
          }) *
      LogWorkTypeTranslations.t;

  String get i18n => localize(this, _t);
}
