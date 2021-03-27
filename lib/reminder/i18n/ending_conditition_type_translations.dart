/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:i18n_extension/i18n_extension.dart';
import '../model/reminder.dart';

class EndingConditionTypeTranslations {
  static final t = Translations.byLocale("en_us") +
      {
        "en_us": {
          EndingConditionType.never.toString(): 'Never',
          EndingConditionType.after_date.toString(): 'On',
          EndingConditionType.after_repetitions.toString(): 'After',
        }
      } +
      {
        "de": {
          EndingConditionType.never.toString(): 'Nie',
          EndingConditionType.after_date.toString(): 'Am',
          EndingConditionType.after_repetitions.toString(): 'Nach',
        }
      };
}
