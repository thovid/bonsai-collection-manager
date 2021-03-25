/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../shared/state/app_context.dart';
import '../../shared/icons/tree_type_icons.dart';
import '../../shared/ui/spaces.dart';
import '../i18n/species_picker.i18n.dart';
import '../model/species.dart';

/// Creates a widget to pick a tree species.
Widget speciesPicker(BuildContext context,
    {Species initialValue,
    bool readOnly = true,
    String hint,
    String label,
    Function(Species value) onSaved}) {
  var repository = AppContext.of(context).speciesRepository;
  var finder = repository.findMatching;
  var saver = repository.save;
  return SpeciesPicker(
    readOnly: readOnly,
    initialValue: initialValue,
    decoration: InputDecoration(
      filled: !readOnly,
      labelText: label,
    ),
    onSaved: onSaved,
    findSpecies: finder,
    saveSpecies: saver,
  );
}

typedef FutureOr<Iterable<Species>> FindSpecies(String pattern);
typedef Future<bool> SaveSpecies(Species species);

/// Widget to pick a tree species
class SpeciesPicker extends StatefulWidget {
  final bool readOnly;
  final Species initialValue;
  final InputDecoration decoration;
  final Function(Species) onSaved;
  final FindSpecies findSpecies;
  final SaveSpecies saveSpecies;

  SpeciesPicker({
    this.readOnly = false,
    this.initialValue,
    this.decoration,
    @required this.onSaved,
    @required this.findSpecies,
    @required this.saveSpecies,
  }) : assert(onSaved != null && findSpecies != null);

  @override
  SpeciesPickerState createState() => SpeciesPickerState();
}

class SpeciesPickerState extends State<SpeciesPicker> {
  // List to store created controllers so that they can be disposed when the
  // widget is disposed - there sure is a better way to do this
  final List<TextEditingController> _controllerList = [];
  Species _selectedValue;

  @override
  void initState() {
    super.initState();
    _updateSelectedValue();
  }

  @override
  void didUpdateWidget(SpeciesPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectedValue();
  }

  @override
  void dispose() {
    _controllerList.forEach((element) => element.dispose());
    super.dispose();
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
        smallVerticalSpace,
        _buildTypeAheadField()
      ],
    );
  }

  Widget _buildTypeAheadField() {
    // we create a new controller to avoid triggering a rebuild due to modifying
    // an existing controller
    var _controller =
        TextEditingController(text: _selectedValue?.latinName ?? '');
    // each controller is stored so that we can dispose 'em all once the widget
    // is disposed - This most likely is an issue with me not understanding the
    // framework correctly...
    _controllerList.add(_controller);

    return TypeAheadFormField<Species>(
      textFieldConfiguration: TextFieldConfiguration(
          enabled: !widget.readOnly,
          controller: _controller,
          decoration: widget.decoration),
      suggestionsCallback: (pattern) {
        return widget.findSpecies(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.latinName),
          trailing: avatarFor(context, suggestion.type, false),
          subtitle: Text(suggestion.informalName ?? ''),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        _controller.text = suggestion?.latinName;
        setState(() {
          _selectedValue = suggestion;
        });
      },
      noItemsFoundBuilder: (context) => TextButton(
          child: Text("Not found. Create?".i18n),
          onPressed: () => _showAddTreeSpeciesDialog(
                context,
                _controller,
                widget.findSpecies,
                widget.saveSpecies,
              )),
      onSaved: (_) => widget.onSaved(_selectedValue),
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select a tree species".i18n;
        }
        return null;
      },
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

  void _updateSelectedValue() {
    _selectedValue =
        widget.initialValue == Species.unknown ? null : widget.initialValue;
  }
}

CircleAvatar avatarFor(BuildContext context, TreeType treeType, bool active,
    {VoidCallback onPressed}) {
  final IconData iconData = iconFor(treeType);
  final Color color =
      active ? Theme.of(context).accentColor : Theme.of(context).disabledColor;
  return CircleAvatar(
    child: IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
    ),
    backgroundColor: color,
  );
}

IconData iconFor(TreeType treeType) {
  switch (treeType) {
    case TreeType.conifer:
      return TreeTypeIcons.pine;
    case TreeType.deciduous:
      return TreeTypeIcons.tree_1;
    case TreeType.broadleaf_evergreen:
      return TreeTypeIcons.tree_17;
    case TreeType.tropical:
      return TreeTypeIcons.palm_tree;

    default:
      return TreeTypeIcons.pine;
  }
}

class AddSpeciesDialog extends Dialog {}

Future<void> _showAddTreeSpeciesDialog(
    BuildContext context,
    TextEditingController initiatingTextController,
    FindSpecies findSpecies,
    SaveSpecies saveSpecies) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Text("Add Species".i18n),
                  content: AddSpeciesForm(
                    initiatingTextController,
                    findSpecies,
                    saveSpecies,
                  ),
                ));
      });
}

class AddSpeciesForm extends StatefulWidget {
  final FindSpecies findSpecies;
  final SaveSpecies saveSpecies;
  final TextEditingController initiatingTextController;
  AddSpeciesForm(
      this.initiatingTextController, this.findSpecies, this.saveSpecies);

  @override
  AddSpeciesFormState createState() => AddSpeciesFormState();
}

class AddSpeciesFormState extends State<AddSpeciesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String latinName;
  String informalName;
  TreeType selectedTreeType = TreeType.conifer;

  bool _latinNameExisting = false;

  void save() {}

  @override
  Widget build(BuildContext context) {
    _formKey.currentState?.validate();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.initiatingTextController.text,
              validator: (value) {
                if (value.isEmpty) return "Latin name".i18n;
                if (_latinNameExisting) return "Species already existing".i18n;

                return null;
              },
              onSaved: (value) {
                latinName = value;
              },
              decoration:
                  InputDecoration(hintText: "Please enter the latin name".i18n),
            ),
            TextFormField(
              validator: (value) {
                return value.isNotEmpty ? null : "Informal name".i18n;
              },
              onSaved: (value) {
                informalName = value;
              },
              decoration: InputDecoration(
                  hintText: "Please enter the informal name".i18n),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  avatarFor(context, TreeType.conifer,
                      TreeType.conifer == selectedTreeType, onPressed: () {
                    setState(() {
                      selectedTreeType = TreeType.conifer;
                    });
                  }),
                  avatarFor(context, TreeType.deciduous,
                      TreeType.deciduous == selectedTreeType, onPressed: () {
                    setState(() {
                      selectedTreeType = TreeType.deciduous;
                    });
                  }),
                  avatarFor(context, TreeType.broadleaf_evergreen,
                      TreeType.broadleaf_evergreen == selectedTreeType,
                      onPressed: () {
                    setState(() {
                      selectedTreeType = TreeType.broadleaf_evergreen;
                    });
                  }),
                  avatarFor(context, TreeType.tropical,
                      TreeType.tropical == selectedTreeType, onPressed: () {
                    setState(() {
                      selectedTreeType = TreeType.tropical;
                    });
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _formKey.currentState.save();

                  _checkLatinName(latinName).then((ok) {
                    setState(() {
                      _latinNameExisting = !ok;
                    });

                    if (_formKey.currentState.validate()) {
                      // save
                      Species species = Species(selectedTreeType,
                          latinName: latinName, informalName: informalName);
                      widget.saveSpecies(species).then((saved) {
                        if (saved) {
                          // close dialog
                          widget.initiatingTextController.text = latinName;
                          Navigator.pop(context);
                        }
                      });
                    }
                  });
                },
                child: Text("Save".i18n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkLatinName(String latinName) async {
    Iterable<Species> species = await widget.findSpecies(latinName);
    return species == null || species.isEmpty;
  }
}
