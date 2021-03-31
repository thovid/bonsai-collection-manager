/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = (Translations("en_us") +
      {
        "en_us": "My collection",
        "de": "Meine Sammlung",
      } +
      {
        "en_us": "Reminder",
        "de": "Erinnerungen",
      } +
      {
        "en_us": aboutText,
        "de":
            """Bonsai Collection Manager ist eine App zur Verwaltung deiner Bonsaisammlung. Die App wird von mir als privates Hobbyprojekt entwickelt, es kann daher keine Garantie oder Gewährleistung übernommen werden.
 
 Kontakt: theuklid@gmail.com""",
      });

  String get i18n => localize(this, _t);
}

const String aboutText =
    """Bonsai Collection Manager is an app to manage your bonsai collection. This app is developed as a private hobby project, thus I will not take any warranties. 
        
 Contact: theuklid@gmail.com""";
