/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations("en_us") +
      {
        "en_us": "Due in %d days".zero("Due today").one("Due tomorrow"),
        "de": "Fällig in %d Tagen".zero("Heute fällig").one("Morgen fällig")
      } +
      {
        "en_us": "Was due %d days ago".one("Was due yesterday"),
        "de": "War vor %d Tagen fällig".one("War gestern fällig")
      } +
      {"en_us": "Reminder discarded", "de": "Erinnerung verworfen"} +
      {"en_us": "Logbook entry created", "de": "Logbucheintrag angelegt"};

  String plural(int value) => localizePlural(value, this, _t);
  String get i18n => localize(this, _t);
}
