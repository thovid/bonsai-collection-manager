/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/logbook/model/logbook.dart';
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';
import 'package:flutter/foundation.dart';

class Reminder with ChangeNotifier {
  String get treeName => "Tree Name";

  LogWorkType get workType => LogWorkType.custom;

  String get workTypeName => "Do bonsai work";

  String dueInFrom(DateTime now) => "Due in 2 Days";
}

class ReminderList with ChangeNotifier {
  List<Reminder> get entries => [];
}
