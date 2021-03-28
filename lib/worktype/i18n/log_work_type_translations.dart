/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import '../model/work_type.dart';
import 'package:i18n_extension/i18n_extension.dart';

class LogWorkTypeTranslations {
  static final t = Translations.byLocale("en_us") +
      {
        "en_us": {
          LogWorkType.custom.toString(): 'custom'
              .modifier(Tenses.present, 'custom')
              .modifier(Tenses.past, 'custom'),
          LogWorkType.deadwood.toString(): 'deadwood worked'
              .modifier(Tenses.present, 'deadwood work')
              .modifier(Tenses.past, 'deadwood worked'),
          LogWorkType.fertilized.toString(): 'fertilized'
              .modifier(Tenses.present, 'fertilize')
              .modifier(Tenses.past, 'fertilized'),
          LogWorkType.pruned.toString(): 'pruned'
              .modifier(Tenses.present, 'prune')
              .modifier(Tenses.past, 'pruned'),
          LogWorkType.repotted.toString(): 'repotted'
              .modifier(Tenses.present, 'repot')
              .modifier(Tenses.past, 'repotted'),
          LogWorkType.sprayed.toString(): 'sprayed'
              .modifier(Tenses.present, 'spray')
              .modifier(Tenses.past, 'sprayed'),
          LogWorkType.watered.toString(): 'watered'
              .modifier(Tenses.present, 'water')
              .modifier(Tenses.past, 'watered'),
          LogWorkType.wired.toString(): 'wired'
              .modifier(Tenses.present, 'wire')
              .modifier(Tenses.past, 'wired'),
          LogWorkType.pinched.toString(): 'pinched'
              .modifier(Tenses.present, 'pinch')
              .modifier(Tenses.past, 'pinched'),
        }
      } +
      {
        "de": {
          LogWorkType.custom.toString(): 'benutzerdefiniert'
              .modifier(Tenses.present, 'benutzerdefiniert')
              .modifier(Tenses.past, 'benutzerdefiniert'),
          LogWorkType.deadwood.toString(): 'Totholz bearbeitet'
              .modifier(Tenses.present, 'Totholz bearbeiten')
              .modifier(Tenses.past, 'Totholz bearbeitet'),
          LogWorkType.fertilized.toString(): 'gedüngt'
              .modifier(Tenses.present, 'düngen')
              .modifier(Tenses.past, 'gedüngt'),
          LogWorkType.pruned.toString(): 'beschnitten'
              .modifier(Tenses.present, 'schneiden')
              .modifier(Tenses.past, 'beschnitten'),
          LogWorkType.repotted.toString(): 'umgetopft'
              .modifier(Tenses.present, 'umtopfen')
              .modifier(Tenses.past, 'umgetopft'),
          LogWorkType.sprayed.toString(): 'besprüht'
              .modifier(Tenses.present, 'sprühen')
              .modifier(Tenses.past, 'besprüht'),
          LogWorkType.watered.toString(): 'gegossen'
              .modifier(Tenses.present, 'gießen')
              .modifier(Tenses.past, 'gegossen'),
          LogWorkType.wired.toString(): 'gedrahtet'
              .modifier(Tenses.present, 'drahten')
              .modifier(Tenses.past, 'gedrahtet'),
          LogWorkType.pinched.toString(): 'pinziert'
              .modifier(Tenses.present, 'pinzieren')
              .modifier(Tenses.past, 'pinziert'),
        }
      };
}
