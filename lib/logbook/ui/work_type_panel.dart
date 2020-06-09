/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import '../../shared/icons/log_work_type_icons.dart';
import '../../shared/ui/spaces.dart';
import '../i18n/log_work_type.i18n.dart';
import '../model/logbook.dart';

class WorkTypePanel extends StatelessWidget {
  final LogWorkType workType;
  final String workTypeName;

  WorkTypePanel({this.workType, this.workTypeName});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                workTypeIconFor(workType),
                mediumHorizontalSpace,
                Text(_buildWorkTypeName(),
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
          ),
        ),
      );

  String _buildWorkTypeName() {
    if (workTypeName == null || workTypeName.isEmpty) {
      return workType.toString().i18n;
    }
    return workTypeName;
  }

}

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
