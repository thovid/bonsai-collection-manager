/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree.dart';
import 'package:i18n_extension/i18n_extension.dart';

class BonsaiEnumTranslations {
  static var t = Translations.byLocale("en_us") +
      {
        "en_us": {
          DevelopmentLevel.raw.toString(): "Raw material",
          DevelopmentLevel.development.toString(): "In development",
          DevelopmentLevel.refinement.toString(): "In refinement",
          PotType.nursery_pot.toString(): "Nursery pot",
          PotType.training_pot.toString(): "Training pot",
          PotType.bonsai_pot.toString(): "Bonsai Pot"
        }
      } +
      {
        "de": {
          DevelopmentLevel.raw.toString(): "Rohmaterial",
          DevelopmentLevel.development.toString(): "In Entwicklung",
          DevelopmentLevel.refinement.toString(): "In Verfeinerung",
          PotType.nursery_pot.toString(): "Baumschulcontainer",
          PotType.training_pot.toString(): "Trainingsschale",
          PotType.bonsai_pot.toString(): "Bonsaischale"
        }
      };
}
