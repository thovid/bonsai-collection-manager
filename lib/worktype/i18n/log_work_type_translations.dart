/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import '../model/work_type.dart';
import 'package:i18n_extension/i18n_extension.dart';

class LogWorkTypeTranslations {
  static final t = Translations.byLocale("en_us") +
      {
        "en_us": {
          LogWorkType.custom.toString(): 'custom',
          LogWorkType.deadwood.toString():
              'deadwood worked'.modifier(Tenses.present, 'deadwood work'),
          LogWorkType.fertilized.toString():
              'fertilized'.modifier(Tenses.present, 'fertilize'),
          LogWorkType.pruned.toString():
              'pruned'.modifier(Tenses.present, 'prune'),
          LogWorkType.repotted.toString():
              'repotted'.modifier(Tenses.present, 'repot'),
          LogWorkType.sprayed.toString():
              'sprayed'.modifier(Tenses.present, 'spray'),
          LogWorkType.watered.toString():
              'watered'.modifier(Tenses.present, 'water'),
          LogWorkType.wired.toString():
              'wired'.modifier(Tenses.present, 'wire'),
          LogWorkType.pinched.toString():
              'pinched'.modifier(Tenses.present, 'pinch'),
        }
      } +
      {
        "de": {
          LogWorkType.custom.toString(): 'benutzerdefiniert',
          LogWorkType.deadwood.toString(): 'Totholz bearbeitet'
              .modifier(Tenses.present, 'Totholz bearbeiten'),
          LogWorkType.fertilized.toString():
              'gedüngt'.modifier(Tenses.present, 'düngen'),
          LogWorkType.pruned.toString():
              'beschnitten'.modifier(Tenses.present, 'schneiden'),
          LogWorkType.repotted.toString():
              'umgetopft'.modifier(Tenses.present, 'umtopfen'),
          LogWorkType.sprayed.toString():
              'besprüht'.modifier(Tenses.present, 'sprühen'),
          LogWorkType.watered.toString():
              'gegossen'.modifier(Tenses.present, 'gießen'),
          LogWorkType.wired.toString():
              'gedrahtet'.modifier(Tenses.present, 'drahten'),
          LogWorkType.pinched.toString():
              'pinziert'.modifier(Tenses.present, 'pinzieren'),
        }
      };
}
