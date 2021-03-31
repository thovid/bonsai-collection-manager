/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:date_calendar/date_calendar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../worktype/model/work_type.dart';
import '../../worktype/ui/work_type_selector.dart';
import '../../shared/ui/toast.dart';
import '../../shared/ui/spaces.dart';
import '../../shared/ui/widget_factory.dart';
import '../i18n/view_logbook_entry_page.i18n.dart';
import '../model/logbook.dart';
import './view_logbook_entry_page.dart';

class EditLogbookEntryPage extends StatefulWidget {
  static const route_name = '/logbook/edit-entry';
  static const route_name_create = '/logbook/create-entry';

  final LogbookEntryWithImages entry;
  final LogWorkType initialWorkType;

  EditLogbookEntryPage({this.entry, this.initialWorkType = LogWorkType.custom});

  @override
  _EditLogbookEntryPageState createState() => _EditLogbookEntryPageState();
}

class _EditLogbookEntryPageState extends State<EditLogbookEntryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LogbookEntryBuilder _entryBuilder;

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
        widget.initialWorkType?.toString()?.tense(Tenses.past) ??
        '';
  }

  @override
  Widget build(BuildContext context) => Consumer<Logbook>(
        builder: (context, Logbook logbook, _) => SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: _buildTitle(),
            actions: [
              TextButton(
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
              WorkTypeSelector(
                hasWorkType: _entryBuilder,
              ),
              mediumVerticalSpace,
              formDatePickerField(
                context,
                initialValue: _entryBuilder.date.toDateTimeLocal(),
                label: 'Date'.i18n,
                readOnly: false,
                onChanged: (value) =>
                    _entryBuilder.date = GregorianCalendar.fromDateTime(value),
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
      await logbook.update(widget.entry);
      Navigator.of(context).pop(widget.entry);
      showInformation(context: context, information: "Entry saved".i18n);
      return;
    }

    final LogbookEntryWithImages newEntry = await logbook.add(entry);
    Navigator.of(context).pushReplacementNamed(ViewLogbookEntryPage.route_name,
        arguments: Tuple2(logbook, newEntry));
    showInformation(context: context, information: "Entry created".i18n);
  }
}
