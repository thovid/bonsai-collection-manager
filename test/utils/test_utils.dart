/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/shared/ui/app_state.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_collection.dart';
import 'package:flutter/material.dart';

Widget testAppWith(Widget widget, BonsaiCollection collection) => AppState(
    child: MaterialApp(home: widget), initial: collection);
