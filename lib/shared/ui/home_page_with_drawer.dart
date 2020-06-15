/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import 'startup_screen.dart';
import 'app_drawer.dart';

abstract class HomePageWithDrawer extends StatefulWidget {
  final bool withInitAnimation;

  const HomePageWithDrawer({Key key, this.withInitAnimation}) : super(key: key);

  @override
  _HomePageWithDrawerState createState() => _HomePageWithDrawerState();

  String buildTitle(BuildContext context);

  Widget buildFloatingActionButton(BuildContext context);

  Widget buildBody(BuildContext context);

  String get routeName;
}

class _HomePageWithDrawerState extends State<HomePageWithDrawer> {
  bool _initStarted = false;
  bool _isInitialized = false;
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    if (widget.withInitAnimation && !_initStarted) {
      _initStarted = true;
      Future.delayed(
          Duration(seconds: 1, milliseconds: 1000),
          () => setState(() {
                _isInitialized = true;
              })).then((value) => Future.delayed(
          Duration(milliseconds: 500),
          () => setState(() {
                _isFinished = true;
              })));
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(widget.buildTitle(context)),
          ),
          drawer:
              buildAppDrawer(context: context, currentPage: widget.routeName),
          floatingActionButton: widget.buildFloatingActionButton(context),
          body: widget.buildBody(context),
        ),
        if (!_isFinished)
          AnimatedOpacity(
            opacity: _isInitialized ? 0.0 : 1.0,
            duration: Duration(milliseconds: 500),
            child: StartupScreen(),
          ),
      ],
    );
  }
}
