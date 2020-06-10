/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';

import './spaces.dart';

class SpeedDial extends StatefulWidget {
  final List<SpeedDialItem> children;

  SpeedDial({this.children});

  @override
  State<StatefulWidget> createState() => SpeedDialState();
}

class SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  bool _isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  // this is needed to know how much to "translate"
  double _fabHeight = 56.0;
  // when the menu is closed, we remove elevation to prevent
  // stacking all elevations
  bool _shouldHaveElevation = false;

  @override
  initState() {
    // a bit faster animation, which looks better: 300
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.lightGreen,
      end: Colors.grey,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));

    // this does the translation of menu items
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  void animate() {
    if (!_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isOpened = !_isOpened;
    // here we update whether or not they FABs should have elevation
    _shouldHaveElevation = !_shouldHaveElevation;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildButton(SpeedDialItem item, int index, int size) => Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translateButton.value * (size - index),
          0.0,
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (_shouldHaveElevation)
                Card(
                    elevation: _shouldHaveElevation ? 6.0 : 0,
                    borderOnForeground: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.label),
                    )),
              if (_shouldHaveElevation) smallHorizontalSpace,
              FloatingActionButton(
                onPressed: () {
                  animate();
                  item.onPressed();
                },
                tooltip: item.label,
                heroTag: null,
                child: item.icon,
                elevation: _shouldHaveElevation ? 6.0 : 0,
              ),
            ],
          ),
        ),
      );

  Widget menuButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: _buttonColor.value,
            onPressed: animate,
            tooltip: 'Toggle menu',
            heroTag: null,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animateIcon,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(
        widget.children.length,
        (index) =>
            _buildButton(widget.children[index], index, widget.children.length),
      )..add(menuButton()),
    );
  }
}

class SpeedDialItem {
  final String label;
  final Icon icon;
  final VoidCallback onPressed;

  SpeedDialItem({this.label, this.icon, this.onPressed});
}
