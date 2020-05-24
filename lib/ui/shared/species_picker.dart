import 'dart:async';

import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:bonsaicollectionmanager/ui/icons/tree_type_icons.dart';
import 'package:bonsaicollectionmanager/ui/shared/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

mixin SpeciesFinder {
  FutureOr<Iterable<Species>> findSpecies(String patter);
}

class SpeciesPicker extends StatefulWidget {
  final bool readOnly;
  final Species initialValue;
  final InputDecoration decoration;
  final Function(Species) onSaved;
  final SpeciesFinder finder;

  SpeciesPicker(this.finder,
      {this.readOnly = false,
      this.initialValue,
      this.decoration,
      this.onSaved}) {
    print("created species picker with initialValue=${initialValue.latinName}");
  }

  @override
  SpeciesPickerState createState() => SpeciesPickerState();
}

class SpeciesPickerState extends State<SpeciesPicker> {
  TextEditingController _typeAheadController = TextEditingController();
  Species _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue =
        widget.initialValue == Species.unknown ? null : widget.initialValue;
    _typeAheadController.text = _selectedValue?.latinName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildTreeTypeBar(context),
        ),
        smallSpace,
        _buildTypeAheadField()
      ],
    );
  }

  Widget _buildTypeAheadField() {
    return TypeAheadFormField<Species>(
      textFieldConfiguration: TextFieldConfiguration(
          enabled: !widget.readOnly,
          controller: _typeAheadController,
          decoration: widget.decoration),
      suggestionsCallback: (pattern) {
        return widget.finder.findSpecies(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.latinName),
          trailing: _avatarFor(suggestion.type, false),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        _typeAheadController.text = suggestion?.latinName;
        setState(() {
          _selectedValue = suggestion;
        });
      },
      onSaved: (_) => widget.onSaved(_selectedValue),
    );
  }

  List<Widget> _buildTreeTypeBar(BuildContext context) {
    return [
      _selectedValue?.type == TreeType.conifer
          ? _avatarFor(TreeType.conifer, true)
          : _avatarFor(TreeType.conifer, false),
      _selectedValue?.type == TreeType.deciduous
          ? _avatarFor(TreeType.deciduous, true)
          : _avatarFor(TreeType.deciduous, false),
      _selectedValue?.type == TreeType.broadleaf_evergreen
          ? _avatarFor(TreeType.broadleaf_evergreen, true)
          : _avatarFor(TreeType.broadleaf_evergreen, false),
      _selectedValue?.type == TreeType.tropical
          ? _avatarFor(TreeType.tropical, true)
          : _avatarFor(TreeType.tropical, false),
    ];
  }

  CircleAvatar _avatarFor(TreeType treeType, bool active) {
    IconData iconData = TreeTypeIcons.pine;
    switch (treeType) {
      case TreeType.conifer:
        iconData = TreeTypeIcons.pine;
        break;
      case TreeType.deciduous:
        iconData = TreeTypeIcons.tree_1;
        break;
      case TreeType.broadleaf_evergreen:
        iconData = TreeTypeIcons.tree_17;
        break;
      case TreeType.tropical:
        iconData = TreeTypeIcons.palm_tree;
        break;
    }

    final Color color = active
        ? Theme.of(context).accentColor
        : Theme.of(context).disabledColor;
    return CircleAvatar(
      child: Icon(iconData),
      backgroundColor: color,
    );
  }
}
