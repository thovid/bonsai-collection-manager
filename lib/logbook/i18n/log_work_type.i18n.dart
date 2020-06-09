/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static var _t = Translations.byLocale("en_us") +
      {
        "en_us": {
          LogWorkType.custom.toString(): 'custom',
          LogWorkType.deadwood.toString(): 'deadwood worked',
          LogWorkType.fertilized.toString(): 'fertilized',
          LogWorkType.pruned.toString(): 'pruned',
          LogWorkType.repotted.toString(): 'repotted',
          LogWorkType.sprayed.toString(): 'sprayed',
          LogWorkType.watered.toString(): 'watered',
          LogWorkType.wired.toString(): 'wired',
          LogWorkType.pinched.toString(): 'pinched',
        }
      } +
      {
        "de": {
          LogWorkType.custom.toString(): 'benutzerdefiniert',
          LogWorkType.deadwood.toString(): 'Totholz bearbeitet',
          LogWorkType.fertilized.toString(): 'gedüngt',
          LogWorkType.pruned.toString(): 'beschnitten',
          LogWorkType.repotted.toString(): 'umgetopft',
          LogWorkType.sprayed.toString(): 'besprüht',
          LogWorkType.watered.toString(): 'gegossen',
          LogWorkType.wired.toString(): 'gedrahtet',
          LogWorkType.pinched.toString(): 'pinziert',
        }
      };

  String get i18n => localize(this, _t);
}
