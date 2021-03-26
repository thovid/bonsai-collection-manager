/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import '../model/reminder.dart';

class EditReminderConfigurationPage extends StatefulWidget {
  final ReminderList reminderList;
  EditReminderConfigurationPage(this.reminderList);
  @override
  _EditReminderConfigurationPageState createState() {
    return _EditReminderConfigurationPageState();
  }
}

class _EditReminderConfigurationPageState
    extends State<EditReminderConfigurationPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _workTypeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
