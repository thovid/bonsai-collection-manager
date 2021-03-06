/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import '../model/work_type.dart';
import 'icon_for_work_type.dart';
import '../../shared/ui/spaces.dart';
import '../i18n/log_work_type.i18n.dart';

class WorkTypePanel extends StatelessWidget {
  final LogWorkType workType;
  final String workTypeName;
  final Tenses tense;

  WorkTypePanel({this.workType, this.workTypeName, this.tense = Tenses.past});

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
                  Expanded(
                    child: Text(_buildWorkTypeName(),
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ],
              ),
            ),
          //),
        ),
      );

  String _buildWorkTypeName() {
    if (workTypeName == null || workTypeName.isEmpty) {
      return workType.toString().tense(tense);
    }
    return workTypeName;
  }
}
