/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen
      ),
      child: Center(
        child: ImageIcon(AssetImage('icons/bonsai.png'), size: 96,),
      ),
    );
  }
}
