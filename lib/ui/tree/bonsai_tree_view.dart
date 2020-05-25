/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/domain/tree/bonsai_collection.dart';
import 'package:bonsaicollectionmanager/domain/tree/bonsai_tree.dart';
import 'package:bonsaicollectionmanager/ui/base/base_view.dart';
import 'package:bonsaicollectionmanager/ui/shared/spaces.dart';
import 'package:bonsaicollectionmanager/ui/shared/widget_factory.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BonsaiTreeView extends StatefulWidget {
  final BonsaiCollection collection;
  final BonsaiTreeID id;
  BonsaiTreeView(this.collection, this.id);

  @override
  BonsaiTreeViewState createState() => BonsaiTreeViewState();
}

class BonsaiTreeViewState extends State<BonsaiTreeView>
    with Screen<BonsaiCollection> {
  String _title;
  BonsaiTree _tree;
  bool _isEdit;

  @override
  void initState() {
    super.initState();
    _tree = _isCreateNew() ? null : widget.collection.findById(widget.id);
    _title = _tree?.displayName ?? 'Add new tree';
    _isEdit = _isCreateNew();
  }

  @override
  BonsaiCollection initialModel(BuildContext context) => widget.collection;

  @override
  String title(BuildContext context, BonsaiCollection model) => _title;

  @override
  Widget body(BuildContext context, BonsaiCollection model) {
    return BonsaiTreeForm(_tree, !_isEdit, _finishEdit);
  }

  @override
  Widget floatingActionButton(BuildContext context, BonsaiCollection model) =>
      Visibility(
        visible: !_isEdit,
        child: FloatingActionButton(
          onPressed: _startEdit,
          tooltip: 'Edit',
          child: Icon(Icons.edit),
        ),
      );

  bool _isCreateNew() => widget.id == null;

  _startEdit() {
    setState(() {
      _isEdit = true;
    });
  }

  _finishEdit(BonsaiTree updatedTree) {
    bool wasCanceled = updatedTree == null;
    if (wasCanceled && _isCreateNew()) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _isEdit = false;
      if (!wasCanceled) {
        _tree = widget.collection.update(updatedTree);
        _title = _tree.displayName;
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
                      hint: 'The species of the tree',
                      label: 'Species',
                      onChanged: (value) => setState(() {
                        _treeBuilder.species = value;
                      }),
                    ),
                    mediumSpace,
                    formTextField(context,
                        initialValue: _treeBuilder.treeName,
                        readOnly: widget._readOnly,
                        hint: 'Name of the tree (optional)',
                        label: 'Name',
                        onSaved: (value) => _treeBuilder.treeName = value),
                    mediumSpace,
                    formDropdownField(
                      context,
                      value: _treeBuilder.developmentLevel,
                      readOnly: widget._readOnly,
                      values: DevelopmentLevel.values,
                      onSaved: (value) => _treeBuilder.developmentLevel = value,
                    ),
                    mediumSpace,
                    formDropdownField(
                      context,
                      value: _treeBuilder.potType,
                      readOnly: widget._readOnly,
                      values: PotType.values,
                      onSaved: (value) => _treeBuilder.potType = value,
                    ),
                    mediumSpace,
                    formDatePickerField(
                      context,
                      initialValue: _treeBuilder.acquiredAt,
                      readOnly: widget._readOnly,
                      label: 'Acquired at',
                      onChanged: (value) => setState(() {
                        _treeBuilder.acquiredAt = value;
                      }),
                    ),
                    mediumSpace,
                    formTextField(
                      context,
                      initialValue: _treeBuilder.acquiredFrom,
                      readOnly: widget._readOnly,
                      hint: 'Where the tree was acquired from',
                      label: 'Acquired from',
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
                                child: Text('Cancel'),
                                onPressed: _cancel,
                              ),
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text('Save'),
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
