/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:async';
import 'package:bonsaicollectionmanager/shared/icons/tree_type_icons.dart';
import 'package:bonsaicollectionmanager/shared/ui/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../model/species.dart';
import '../model/bonsai_collection.dart';

/// Creates a widget to pick a tree species.
Widget speciesPicker(BuildContext context,
    {Species initialValue,
    bool readOnly = true,
    String hint,
    String label,
    FindSpecies findSpecies,
    Function(Species value) onChanged}) {
  var finder = context.watch<BonsaiCollection>().findSpeciesMatching;
  return SpeciesPicker(
    readOnly: readOnly,
    initialValue: initialValue,
    decoration: InputDecoration(
      filled: !readOnly,
      labelText: label,
    ),
    onSaved: onChanged,
    findSpecies: finder,
  );
}

typedef FutureOr<Iterable<Species>> FindSpecies(String pattern);

/// Widget to pick a tree species
class SpeciesPicker extends StatefulWidget {
  final bool readOnly;
  final Species initialValue;
  final InputDecoration decoration;
  final Function(Species) onSaved;
  final FindSpecies findSpecies;

  SpeciesPicker(
      {this.readOnly = false,
      this.initialValue,
      this.decoration,
      @required this.onSaved,
      @required this.findSpecies})
      : assert(onSaved != null && findSpecies != null);

  @override
  SpeciesPickerState createState() => SpeciesPickerState();
}

class SpeciesPickerState extends State<SpeciesPicker> {
  Species _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = _findSelectedValue();
  }

  @override
  void didUpdateWidget(SpeciesPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedValue = _findSelectedValue();
  }


  Species _findSelectedValue() =>
      widget.initialValue == Species.unknown ? null : widget.initialValue;

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
    // TODO should I (and if so, how) dispose this?
   var controller = TextEditingController(text: _selectedValue?.latinName ?? '');
    return TypeAheadFormField<Species>(
      textFieldConfiguration: TextFieldConfiguration(
          enabled: !widget.readOnly,
          controller: controller,
          decoration: widget.decoration),
      suggestionsCallback: (pattern) {
        return widget.findSpecies(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.latinName),
          trailing: avatarFor(context, suggestion.type, false),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        controller.text = suggestion?.latinName;
        setState(() {
          _selectedValue = suggestion;
        });
      },
      onSaved: (_) => widget.onSaved(_selectedValue),
    );
  }

  List<Widget> _buildTreeTypeBar(BuildContext context) {
    return [
      avatarFor(
          context, TreeType.conifer, _selectedValue?.type == TreeType.conifer),
      avatarFor(context, TreeType.deciduous,
          _selectedValue?.type == TreeType.deciduous),
      avatarFor(context, TreeType.broadleaf_evergreen,
          _selectedValue?.type == TreeType.broadleaf_evergreen),
      avatarFor(context, TreeType.tropical,
          _selectedValue?.type == TreeType.tropical),
    ];
  }
}

CircleAvatar avatarFor(BuildContext context, TreeType treeType, bool active) {
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

  final Color color =
      active ? Theme.of(context).accentColor : Theme.of(context).disabledColor;
  return CircleAvatar(
    child: Icon(iconData),
    backgroundColor: color,
  );
}
