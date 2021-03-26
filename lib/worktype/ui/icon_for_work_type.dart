/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import '../../shared/icons/log_work_type_icons.dart';
import '../model/work_type.dart';

import 'package:flutter/material.dart';

Widget workTypeIconFor(LogWorkType workType) {
  switch (workType) {
    case LogWorkType.wired:
      return Icon(LogWorkTypeIcons.wire);
    case LogWorkType.watered:
      return Icon(LogWorkTypeIcons.watering);
    case LogWorkType.sprayed:
      return Icon(LogWorkTypeIcons.pest_control);
    case LogWorkType.repotted:
      return Icon(LogWorkTypeIcons.pot);
    case LogWorkType.pruned:
      return Icon(LogWorkTypeIcons.manicure);
    case LogWorkType.fertilized:
      return Icon(LogWorkTypeIcons.seed_bag);
    case LogWorkType.deadwood:
      return Icon(LogWorkTypeIcons.wood);
    case LogWorkType.pinched:
      return Icon(LogWorkTypeIcons.pinch);
    case LogWorkType.custom:
    default:
      return Icon(LogWorkTypeIcons.settings);
  }
}
