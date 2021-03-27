/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import '../../shared/ui/spaces.dart';
import '../i18n/log_work_type.i18n.dart';
import '../model/work_type.dart';
import 'package:flutter/material.dart';

import 'icon_for_work_type.dart';

class WorkTypeSelector extends StatefulWidget {
  final HasWorkType hasWorkType;
  WorkTypeSelector({this.hasWorkType});

  @override
  _WorkTypeSelectorState createState() {
    return _WorkTypeSelectorState();
  }
}

class _WorkTypeSelectorState extends State<WorkTypeSelector> {
  TextEditingController _workTypeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initFromWidget();
  }

  @override
  void didUpdateWidget(WorkTypeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initFromWidget();
  }

  @override
  void dispose() {
    _workTypeNameController.dispose();
    super.dispose();
  }

  void _initFromWidget() {
    _workTypeNameController.text = widget.hasWorkType.workTypeName;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: DropdownButtonFormField<LogWorkType>(
            isExpanded: true,
            selectedItemBuilder: (_) => LogWorkType.values
                .map((e) => Center(child: workTypeIconFor(e)))
                .toList(),
            value: widget.hasWorkType.workType,
            items: _buildWorkTypeItems(),
            onChanged: (value) {
              widget.hasWorkType.workType = value;
              _workTypeNameController.text = value.toString().i18n;
              setState(() {});
            },
          ),
        ),
        smallHorizontalSpace,
        Flexible(
          flex: 3,
          child: TextFormField(
            controller: _workTypeNameController,
            onSaved: (newValue) => widget.hasWorkType.workTypeName = newValue,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<LogWorkType>> _buildWorkTypeItems() =>
      LogWorkType.values
          .map((e) => DropdownMenuItem(
                child: Center(child: workTypeIconFor(e)),
                value: e,
              ))
          .toList();
}
