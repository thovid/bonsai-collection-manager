import 'dart:async';

import 'package:bonsaicollectionmanager/domain/tree/species.dart';
import 'package:bonsaicollectionmanager/ui/icons/tree_type_icons.dart';
import 'package:bonsaicollectionmanager/ui/shared/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

typedef FutureOr<Iterable<Species>> FindSpecies(String pattern);

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
    final TextEditingController controller =
        TextEditingController(text: _selectedValue?.latinName ?? '');
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
          trailing: _avatarFor(suggestion.type, false),
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
