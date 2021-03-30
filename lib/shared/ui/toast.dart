/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';

void showInformation({BuildContext context, String information}) {
  final snackBar = SnackBar(
    content: Text(information),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
