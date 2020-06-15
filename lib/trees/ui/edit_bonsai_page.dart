/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/trees/ui/view_bonsai_tabbed_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/spaces.dart';
import '../../shared/ui/widget_factory.dart';
import '../i18n/bonsai_tree_view.i18n.dart';
import '../model/bonsai_tree_collection.dart';
import '../model/bonsai_tree_with_images.dart';
import '../model/bonsai_tree_data.dart';
import './species_picker.dart';

class EditBonsaiPage extends StatefulWidget {
  static const route_name = '/edit-tree';

  final BonsaiTreeWithImages tree;

  EditBonsaiPage({this.tree});

  @override
  _EditBonsaiPageState createState() => _EditBonsaiPageState();
}

class _EditBonsaiPageState extends State<EditBonsaiPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BonsaiTreeDataBuilder _treeBuilder;

  @override
  void initState() {
    super.initState();
    _treeBuilder = BonsaiTreeDataBuilder(fromTree: widget.tree?.treeData);
  }

  @override
  void didUpdateWidget(EditBonsaiPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _treeBuilder = BonsaiTreeDataBuilder(fromTree: widget.tree?.treeData);
  }

  @override
  Widget build(BuildContext context) => Consumer<BonsaiTreeCollection>(
        builder: (context, collection, _) => SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: _buildTitle(),
            actions: [
              FlatButton(
                onPressed: () => _save(collection),
                child: Text('Save'.i18n,
                    style: Theme.of(context).textTheme.subtitle1),
              ),
            ],
          ),
          body: _buildBody(context),
        )),
      );

  Text _buildTitle() => Text(widget.tree?.displayName ?? 'Add new tree'.i18n);

  Scrollbar _buildBody(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
      dragStartBehavior: DragStartBehavior.down,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          mediumVerticalSpace,
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
                    mediumVerticalSpace,
                    formTextField(context,
                        initialValue: _treeBuilder.treeName,
                        readOnly: false,
                        hint: "Name your tree (optional)".i18n,
                        label: "Name".i18n,
                        onSaved: (value) => _treeBuilder.treeName = value),
                    mediumVerticalSpace,
                    formDropdownField(context,
                        label: "Development Level".i18n,
                        value: _treeBuilder.developmentLevel,
                        readOnly: false,
                        values: DevelopmentLevel.values,
                        onSaved: (value) =>
                            _treeBuilder.developmentLevel = value,
                        translate: (value) => value.toString().i18n),
                    mediumVerticalSpace,
                    formDropdownField(context,
                        label: "Pot Type".i18n,
                        value: _treeBuilder.potType,
                        readOnly: false,
                        values: PotType.values,
                        onSaved: (value) => _treeBuilder.potType = value,
                        translate: (value) => value.toString().i18n),
                    mediumVerticalSpace,
                    formDatePickerField(
                      context,
                      initialValue: _treeBuilder.acquiredAt,
                      readOnly: false,
                      label: "Acquired at".i18n,
                      onChanged: (value) => _treeBuilder.acquiredAt = value,
                    ),
                    mediumVerticalSpace,
                    formTextField(
                      context,
                      initialValue: _treeBuilder.acquiredFrom,
                      readOnly: false,
                      hint: "Where did you acquire the tree from?".i18n,
                      label: "Acquired from".i18n,
                      onSaved: (value) => _treeBuilder.acquiredFrom = value,
                    ),
                    mediumVerticalSpace,
                  ])),
        ],
      ),
    ));
  }

  Future<void> _save(BonsaiTreeCollection bonsaiCollection) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    BonsaiTreeData treeData = _treeBuilder.build();

    if (widget.tree != null) {
      widget.tree.treeData = treeData;
      bonsaiCollection.update(widget.tree);
      Navigator.of(context).pop(widget.tree);
      return;
    }

    final BonsaiTreeWithImages newTree = await bonsaiCollection.add(treeData);
    Navigator.of(context).pushReplacementNamed(ViewBonsaiTabbedPage.route_name,
        arguments: newTree);
  }
}
