/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../shared/ui/app_state.dart';
import '../../shared/ui/base_view.dart';
import '../../shared/ui/spaces.dart';
import '../../shared/ui/widget_factory.dart';

import '../model/bonsai_collection.dart';
import '../model/bonsai_tree.dart';
import '../i18n/bonsai_tree_view.i18n.dart';

import './species_picker.dart';

class BonsaiTreeView extends StatefulWidget {
  final BonsaiTreeID id;
  BonsaiTreeView(this.id);

  @override
  BonsaiTreeViewState createState() => BonsaiTreeViewState(id);
}

class BonsaiTreeViewState extends State<BonsaiTreeView>
    with Screen<BonsaiCollection> {
  bool _isEdit;
  BonsaiTreeID id;

  BonsaiTreeViewState(this.id);

  @override
  void initState() {
    super.initState();
    _isEdit = _isCreateNew();
  }

  @override
  BonsaiCollection initialModel(BuildContext context) =>
      AppState.of(context).collection;

  @override
  String title(BuildContext context, BonsaiCollection model) =>
      model.findById(id)?.displayName ?? 'Add new tree'.i18n;

  @override
  Widget body(BuildContext context, BonsaiCollection model) {
    return BonsaiTreeForm(
        _tree(model), !_isEdit, (tree) => _finishEdit(model, tree));
  }

  @override
  Widget floatingActionButton(BuildContext context, BonsaiCollection model) =>
      Visibility(
        visible: !_isEdit,
        child: FloatingActionButton(
          onPressed: _startEdit,
          tooltip: "Edit".i18n,
          child: Icon(Icons.edit),
        ),
      );

  bool _isCreateNew() => id == null;

  BonsaiTree _tree(BonsaiCollection model) => model.findById(id);

  _startEdit() {
    setState(() {
      _isEdit = true;
    });
  }

  _finishEdit(BonsaiCollection model, BonsaiTree updatedTree) {
    bool wasCanceled = updatedTree == null;
    if (wasCanceled && _isCreateNew()) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _isEdit = false;
      if (!wasCanceled) {
        id = model.update(updatedTree).id;
      }
    });
  }
}

class BonsaiTreeForm extends StatefulWidget {
  final BonsaiTree _originalTree;
  final bool _readOnly;
  final Function(BonsaiTree) _finishEdit;
  BonsaiTreeForm(this._originalTree, this._readOnly, this._finishEdit);

  @override
  BonsaiTreeFormState createState() => BonsaiTreeFormState();
}

class BonsaiTreeFormState extends State<BonsaiTreeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BonsaiTreeBuilder _treeBuilder;

  @override
  void initState() {
    super.initState();
    _treeBuilder = BonsaiTreeBuilder(fromTree: widget._originalTree);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
      dragStartBehavior: DragStartBehavior.down,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          mediumSpace,
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    speciesPicker(
                      context,
                      initialValue: _treeBuilder.species,
                      readOnly: widget._readOnly,
                      hint: "The species of the tree".i18n,
                      label: "Species".i18n,
                      onChanged: (value) => setState(() {
                        _treeBuilder.species = value;
                      }),
                    ),
                    mediumSpace,
                    formTextField(context,
                        initialValue: _treeBuilder.treeName,
                        readOnly: widget._readOnly,
                        hint: "Name your tree (optional)".i18n,
                        label: "Name".i18n,
                        onSaved: (value) => _treeBuilder.treeName = value),
                    mediumSpace,
                    formDropdownField(context,
                        label: "Development Level".i18n,
                        value: _treeBuilder.developmentLevel,
                        readOnly: widget._readOnly,
                        values: DevelopmentLevel.values,
                        onSaved: (value) =>
                            _treeBuilder.developmentLevel = value,
                        translate: (value) => value.toString().i18n),
                    mediumSpace,
                    formDropdownField(context,
                        label: "Pot Type".i18n,
                        value: _treeBuilder.potType,
                        readOnly: widget._readOnly,
                        values: PotType.values,
                        onSaved: (value) => _treeBuilder.potType = value,
                        translate: (value) => value.toString().i18n),
                    mediumSpace,
                    formDatePickerField(
                      context,
                      initialValue: _treeBuilder.acquiredAt,
                      readOnly: widget._readOnly,
                      label: "Acquired at".i18n,
                      onChanged: (value) => setState(() {
                        _treeBuilder.acquiredAt = value;
                      }),
                    ),
                    mediumSpace,
                    formTextField(
                      context,
                      initialValue: _treeBuilder.acquiredFrom,
                      readOnly: widget._readOnly,
                      hint: "Where did you acquire the tree from?".i18n,
                      label: "Acquired from".i18n,
                      onSaved: (value) => _treeBuilder.acquiredFrom = value,
                    ),
                    mediumSpace,
                    if (!widget._readOnly)
                      Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                color: Theme.of(context).buttonColor,
                                child: Text("Cancel".i18n),
                                onPressed: _cancel,
                              ),
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text("Save".i18n),
                                onPressed: _save,
                              )
                            ]),
                      ),
                  ])),
        ],
      ),
    ));
  }

  void _cancel() {
    setState(() {
      _treeBuilder = BonsaiTreeBuilder(fromTree: widget._originalTree);
    });
    _formKey.currentState.reset();
    widget._finishEdit(null);
  }

  _save() {
    _formKey.currentState.save();
    BonsaiTree newTree = _treeBuilder.build();
    widget._finishEdit(newTree);
  }
}
