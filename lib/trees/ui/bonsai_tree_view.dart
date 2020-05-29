/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/shared/ui/image_gallery.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../shared/state/app_context.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isEdit;
  BonsaiTreeID id;
  BonsaiTreeBuilder _treeBuilder;

  BonsaiTreeViewState(this.id);

  @override
  void initState() {
    super.initState();
    _isEdit = _isCreateNew();
  }

  @override
  BonsaiCollection initialModel(BuildContext context) =>
      AppContext.of(context).collection;

  @override
  String title(BuildContext context, BonsaiCollection model) =>
      model.findById(id)?.displayName ?? 'Add new tree'.i18n;

  @override
  Widget body(BuildContext context, BonsaiCollection model) {
    _treeBuilder = BonsaiTreeBuilder(fromTree: _tree(model));
    return Scrollbar(
        child: SingleChildScrollView(
      dragStartBehavior: DragStartBehavior.down,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          //if (!_isEdit) ImageGallery(),
          mediumSpace,
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    speciesPicker(context,
                        initialValue: _treeBuilder.species,
                        readOnly: !_isEdit,
                        hint: "The species of the tree".i18n,
                        label: "Species".i18n,
                        onSaved: (value) => _treeBuilder.species = value),
                    mediumSpace,
                    formTextField(context,
                        initialValue: _treeBuilder.treeName,
                        readOnly: !_isEdit,
                        hint: "Name your tree (optional)".i18n,
                        label: "Name".i18n,
                        onSaved: (value) => _treeBuilder.treeName = value),
                    mediumSpace,
                    formDropdownField(context,
                        label: "Development Level".i18n,
                        value: _treeBuilder.developmentLevel,
                        readOnly: !_isEdit,
                        values: DevelopmentLevel.values,
                        onSaved: (value) =>
                            _treeBuilder.developmentLevel = value,
                        translate: (value) => value.toString().i18n),
                    mediumSpace,
                    formDropdownField(context,
                        label: "Pot Type".i18n,
                        value: _treeBuilder.potType,
                        readOnly: !_isEdit,
                        values: PotType.values,
                        onSaved: (value) => _treeBuilder.potType = value,
                        translate: (value) => value.toString().i18n),
                    mediumSpace,
                    formDatePickerField(
                      context,
                      initialValue: _treeBuilder.acquiredAt,
                      readOnly: !_isEdit,
                      label: "Acquired at".i18n,
                      onChanged: (value) => //setState(() {
                          _treeBuilder.acquiredAt = value,
                      //;
                      //)                }),
                    ),
                    mediumSpace,
                    formTextField(
                      context,
                      initialValue: _treeBuilder.acquiredFrom,
                      readOnly: !_isEdit,
                      hint: "Where did you acquire the tree from?".i18n,
                      label: "Acquired from".i18n,
                      onSaved: (value) => _treeBuilder.acquiredFrom = value,
                    ),
                    mediumSpace,
                  ])),
        ],
      ),
    ));
  }

  @override
  Widget appBarLeading(BuildContext context, BonsaiCollection model) {
    if (!_isEdit || _isCreateNew()) {
      return null;
    }

    return BackButton(
      onPressed: () => _cancel(model),
    );
  }

  @override
  List<Widget> appBarTrailing(BuildContext context, BonsaiCollection model) {
    if (!_isEdit) {
      return [];
    }

    return [
      IconButton(
        icon: Icon(Icons.done),
        onPressed: () => _save(model),
      )
    ];
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

  void _cancel(BonsaiCollection model) {
    _formKey.currentState.reset();

    setState(() {
      _treeBuilder = BonsaiTreeBuilder(fromTree: _tree(model));
      _isEdit = false;
    });
  }

  void _save(BonsaiCollection model) {
    _formKey.currentState.save();

    BonsaiTree updatedTree = _treeBuilder.build();

    model.update(updatedTree).then((value) => {
          setState(() {
            _isEdit = false;
            id = value.id;
          })
        });
  }
}
