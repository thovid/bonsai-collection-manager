/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/images/model/image_gallery_model.dart';
import 'package:bonsaicollectionmanager/shared/state/app_context.dart';
import 'package:bonsaicollectionmanager/trees/model/bonsai_tree_with_images.dart';
import 'package:bonsaicollectionmanager/trees/ui/view_bonsai_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/spaces.dart';
import '../../shared/ui/widget_factory.dart';
import '../i18n/bonsai_tree_view.i18n.dart';
import '../model/bonsai_tree.dart';
import './species_picker.dart';

class EditBonsaiView extends StatefulWidget {
  final BonsaiTree initialTree;

  EditBonsaiView({this.initialTree});

  @override
  _EditBonsaiViewState createState() => _EditBonsaiViewState();
}

class _EditBonsaiViewState extends State<EditBonsaiView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BonsaiTreeBuilder _treeBuilder;

  @override
  void initState() {
    super.initState();
    _treeBuilder = BonsaiTreeBuilder(fromTree: widget.initialTree);
  }

  @override
  void didUpdateWidget(EditBonsaiView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _treeBuilder = BonsaiTreeBuilder(fromTree: widget.initialTree);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          actions: [
            FlatButton(
              onPressed: _save,
              child: Text('Save'.i18n,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white)),
            ),
          ],
        ),
        body: _buildBody(context),
      ));

  Text _buildTitle() =>
      Text(widget.initialTree?.displayName ?? 'Add new tree'.i18n);

  Scrollbar _buildBody(BuildContext context) {
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
                    speciesPicker(context,
                        initialValue: _treeBuilder.species,
                        readOnly: false,
                        hint: "The species of the tree".i18n,
                        label: "Species".i18n,
                        onSaved: (value) => _treeBuilder.species = value),
                    mediumSpace,
                    formTextField(context,
                        initialValue: _treeBuilder.treeName,
                        readOnly: false,
                        hint: "Name your tree (optional)".i18n,
                        label: "Name".i18n,
                        onSaved: (value) => _treeBuilder.treeName = value),
                    mediumSpace,
                    formDropdownField(context,
                        label: "Development Level".i18n,
                        value: _treeBuilder.developmentLevel,
                        readOnly: false,
                        values: DevelopmentLevel.values,
                        onSaved: (value) =>
                            _treeBuilder.developmentLevel = value,
                        translate: (value) => value.toString().i18n),
                    mediumSpace,
                    formDropdownField(context,
                        label: "Pot Type".i18n,
                        value: _treeBuilder.potType,
                        readOnly: false,
                        values: PotType.values,
                        onSaved: (value) => _treeBuilder.potType = value,
                        translate: (value) => value.toString().i18n),
                    mediumSpace,
                    formDatePickerField(
                      context,
                      initialValue: _treeBuilder.acquiredAt,
                      readOnly: false,
                      label: "Acquired at".i18n,
                      onChanged: (value) => _treeBuilder.acquiredAt = value,
                    ),
                    mediumSpace,
                    formTextField(
                      context,
                      initialValue: _treeBuilder.acquiredFrom,
                      readOnly: false,
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

  void _save() {
    _formKey.currentState.save();
    BonsaiTree updatedTree = _treeBuilder.build();
    Navigator.of(context).pop(updatedTree);
  }
}
