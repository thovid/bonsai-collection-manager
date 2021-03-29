/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/spaces.dart';
import '../../worktype/ui/work_type_panel.dart';
import '../../worktype/model/work_type.dart';

import '../i18n/view_reminder_configuration_page.i18n.dart';
import '../model/reminder.dart';

import 'edit_reminder_configuration_page.dart';

class ViewReminderConfigurationPage extends StatelessWidget {
  static const String route_name = '/reminder/view-configuration';

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Consumer2<ReminderList, UpdateableReminderConfiguration>(
          builder: (context, reminderList, reminderConfiguration, _) =>
              Scaffold(
            appBar: AppBar(
              title: Text(_title(reminderConfiguration.value)),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _startEdit(context, reminderList, reminderConfiguration),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _delete(context, reminderList, reminderConfiguration),
                )
              ],
            ),
            body: _buildBody(context, reminderConfiguration.value),
          ),
        ),
      );

  String _title(ReminderConfiguration reminderConfiguration) {
    return 'Reminder'.i18n;
  }

  Future<void> _startEdit(BuildContext context, ReminderList reminderList,
          UpdateableReminderConfiguration reminderConfiguration) async =>
      Navigator.of(context).push(
        MaterialPageRoute<UpdateableReminderConfiguration>(
          fullscreenDialog: true,
          builder: (context) => ChangeNotifierProvider.value(
            value: reminderList,
            builder: (_, __) => EditReminderConfigurationPage(
              reminderConfiguration: reminderConfiguration,
              subjectID: reminderConfiguration.value.subjectID,
            ),
          ),
        ),
      );

  _delete(BuildContext context, ReminderList reminderList,
      UpdateableReminderConfiguration reminderConfiguration) {}

  _buildBody(BuildContext context, ReminderConfiguration value) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          WorkTypePanel(
            workType: value.workType,
            workTypeName: value.workTypeName,
            tense: Tenses.present,
          ),
          smallVerticalSpace,
          _informationBox(context, value),
        ],
      );

  Widget _informationBox(
          BuildContext context, ReminderConfiguration reminderConfiguration) =>
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
          child: Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Table(
              columnWidths: {0: FractionColumnWidth(.4)},
              children: [
                _tableRow('For', reminderConfiguration.treeName),
                _tableRow(
                    'Starts',
                    DateFormat.yMMMd()
                        .format(reminderConfiguration.firstReminder)),
                _tableRow(
                    'Repeats', _buildRepeatStatement(reminderConfiguration)),
                _tableRow('Ends', _buildEndingStatement(reminderConfiguration)),
              ],
            ),
          ),
        ),
      );

  TableRow _tableRow(String labelKey, String value) => TableRow(
        children: [
          TableCell(
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(labelKey.i18n + ':'),
            ),
          ),
          TableCell(
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(value ?? ''),
            ),
          ),
        ],
      );

  String _buildRepeatStatement(ReminderConfiguration reminderConfiguration) {
    if (!reminderConfiguration.repeat) {
      return "Once".i18n;
    }
    return "Every %d %s".i18n.fill([
      reminderConfiguration.frequency,
      reminderConfiguration.frequencyUnit.toString().i18n
    ]);
  }

  String _buildEndingStatement(ReminderConfiguration reminderConfiguration) {
    if (!reminderConfiguration.repeat) {
      return "";
    }
    switch (reminderConfiguration.endingConditionType) {
      case EndingConditionType.never:
        return "Never".i18n;
      case EndingConditionType.after_repetitions:
        return "After %d repetitions"
            .plural(reminderConfiguration.endingAfterRepetitions);
      case EndingConditionType.after_date:
        return "At %s".i18n.fill(
            [DateFormat.yMMMd().format(reminderConfiguration.endingAtDate)]);
    }
    return "";
  }
}
