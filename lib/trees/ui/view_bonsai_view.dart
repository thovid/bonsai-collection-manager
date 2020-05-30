/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/spaces.dart';
import '../model/bonsai_tree.dart';
import '../model/bonsai_collection.dart';
import '../i18n/bonsai_tree_view.i18n.dart';
import './edit_bonsai_view.dart';

class ViewBonsaiView extends StatefulWidget {
  final BonsaiTree initialTree;
  const ViewBonsaiView(this.initialTree);

  @override
  _ViewBonsaiViewState createState() => _ViewBonsaiViewState();
}

class _ViewBonsaiViewState extends State<ViewBonsaiView> {
  BonsaiTree _tree;
  @override
  void initState() {
    super.initState();
    _tree = widget.initialTree;
  }

  @override
  void didUpdateWidget(ViewBonsaiView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tree = widget.initialTree;
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: Consumer<BonsaiCollection>(
          builder: (BuildContext context, BonsaiCollection collection,
                  Widget child) =>
              Scaffold(
                appBar: AppBar(
                  title: _buildTitle(),
                ),
                body: _buildBody(),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _startEdit(collection),
                  tooltip: "Edit".i18n,
                  child: Icon(Icons.edit),
                ),
              )));

  Text _buildTitle() => Text(_tree.displayName);

  void _startEdit(BonsaiCollection collection) async {
    BonsaiTree updatedTree =
        await Navigator.of(context).push(MaterialPageRoute<BonsaiTree>(
            fullscreenDialog: true,
            builder: (BuildContext context) => EditBonsaiView(
                  initialTree: _tree,
                )));
    if (updatedTree != null) {
      collection.add(updatedTree);
      setState(() {
        _tree = updatedTree;
      });
    }
  }

  Widget _buildBody() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * .5 - 20,
          ),
          mediumSpace,
          Container(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Table(
                  columnWidths: {0: FractionColumnWidth(.4)},
                  children: [
                    _tableRow('Species',
                        "${_tree.species.latinName} - ${_tree.species.informalName}"),
                    if (_tree.treeName != null && _tree.treeName.isNotEmpty)
                      _tableRow('Name', _tree.treeName),
                    _tableRow('Development Level',
                        _tree.developmentLevel.toString().i18n),
                    _tableRow('Pot Type', _tree.potType.toString().i18n),
                    _tableRow('Acquired at',
                        DateFormat.yMMMd().format(_tree.acquiredAt)),
                    _tableRow('Acquired from', _tree.acquiredFrom),
                  ],
                ),
              ),
            ),
          )
        ],
      );

  TableRow _tableRow(String labelKey, String value) => TableRow(children: [
        TableCell(
            child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(labelKey.i18n + ':'))),
        TableCell(
            child: Container(
                padding: const EdgeInsets.only(top: 10.0), child: Text(value)))
      ]);
}
