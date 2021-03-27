/*
 * Copyright (c) 2021 by Thomas Vidic
 */


import 'package:i18n_extension/i18n_extension.dart';
import '../model/reminder.dart';


class FrequencyUnitTranslations {
  static final t = Translations.byLocale("en_us") +
      {
        "en_us": {
          FrequencyUnit.days.toString(): 'Days',
          FrequencyUnit.weeks.toString(): 'Weeks',
          FrequencyUnit.months.toString(): 'Months',
          FrequencyUnit.years.toString(): 'Years',
        }
      } +
      {
        "de": {
          FrequencyUnit.days.toString(): 'Tage',
          FrequencyUnit.weeks.toString(): 'Wochen',
          FrequencyUnit.months.toString(): 'Monate',
          FrequencyUnit.years.toString(): 'Jahre',
        }
      };
}

