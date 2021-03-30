/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/material.dart';

void showInformation({BuildContext context, String information}) {
  final snackBar = SnackBar(
    content: Text(information, textAlign: TextAlign.center,),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
