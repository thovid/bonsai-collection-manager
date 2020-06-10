/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../shared/ui/spaces.dart';
import '../../shared/ui/widget_factory.dart';
import '../i18n/view_logbook_entry_page.i18n.dart';
import '../model/logbook.dart';
import './work_type_panel.dart';
import './view_logbook_entry_page.dart';

class EditLogbookEntryPage extends StatefulWidget {
  static const route_name = '/logbook/edit-entry';

  final LogbookEntryWithImages entry;
  final LogWorkType initialWorkType;

  EditLogbookEntryPage({this.entry, this.initialWorkType});

  @override
  _EditLogbookEntryPageState createState() => _EditLogbookEntryPageState();
}

class _EditLogbookEntryPageState extends State<EditLogbookEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LogbookEntryBuilder _entryBuilder;
  TextEditingController _workTypeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initFromWidget();
  }

  @override
  void didUpdateWidget(EditLogbookEntryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initFromWidget();
  }

  void _initFromWidget() {
    _entryBuilder = LogbookEntryBuilder(fromEntry: widget.entry?.entry);
    _entryBuilder.workType =
        widget.entry?.entry?.workType ?? widget.initialWorkType;
    _entryBuilder.workTypeName = widget.entry?.entry?.workTypeName ??
        widget.initialWorkType?.toString()?.i18n ??
        '';
    _workTypeNameController.text = _entryBuilder.workTypeName;
  }

  @override
  Widget build(BuildContext context) => Consumer<Logbook>(
        builder: (context, Logbook logbook, _) => SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: _buildTitle(),
            actions: [
              FlatButton(
                onPressed: () => _save(logbook),
                child: Text('Save'.i18n,
                    style: Theme.of(context).textTheme.subtitle1),
              ),
            ],
          ),
          body: _buildBody(context),
        )),
      );

  Widget _buildBody(BuildContext context) => Scrollbar(
          child: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              mediumVerticalSpace,
              _buildWorkTypeSelector(),
              mediumVerticalSpace,
              formDatePickerField(
                context,
                initialValue: _entryBuilder.date,
                label: 'Date'.i18n,
                readOnly: false,
                onChanged: (value) => _entryBuilder.date = value,
              ),
              mediumVerticalSpace,
              formTextField(
                context,
                initialValue: _entryBuilder.notes,
                label: 'Notes'.i18n,
                hint: 'Add some notes'.i18n,
                readOnly: false,
                lines: 3,
                onSaved: (value) => _entryBuilder.notes = value,
              ),
            ],
          ),
        ),
      ));

  Widget _buildTitle() =>
      Text(widget.entry != null ? 'Edit entry'.i18n : 'Create entry'.i18n);

  Future _save(Logbook logbook) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    LogbookEntry entry = _entryBuilder.build();
    if (widget.entry != null) {
      widget.entry.entry = entry;
      logbook.update(widget.entry);
      Navigator.of(context).pop(widget.entry);
      return;
    }

    final LogbookEntryWithImages newEntry = await logbook.add(entry);
    Navigator.of(context).pushReplacementNamed(ViewLogbookEntryPage.route_name,
        arguments: Tuple2(logbook, newEntry));
  }

  Widget _buildWorkTypeSelector() {
    return Row(
      children: <Widget>[
        Flexible(
          child: DropdownButtonFormField<LogWorkType>(
            isExpanded: true,
            selectedItemBuilder: (_) => LogWorkType.values
                .map((e) => Center(child: workTypeIconFor(e)))
                .toList(),
            value: _entryBuilder.workType,
            items: _buildWorkTypeItems(),
            onChanged: (value) {
              _entryBuilder.workType = value;
              _workTypeNameController.text = value.toString().i18n;
              setState(() {});
            },
          ),
        ),
        smallHorizontalSpace,
        Flexible(
          flex: 3,
          child: TextFormField(
            controller: _workTypeNameController,
            onSaved: (newValue) => _entryBuilder.workTypeName = newValue,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<LogWorkType>> _buildWorkTypeItems() =>
      LogWorkType.values
          .map((e) => DropdownMenuItem(
                child: Center(child: workTypeIconFor(e)),
                value: e,
              ))
          .toList();
}
