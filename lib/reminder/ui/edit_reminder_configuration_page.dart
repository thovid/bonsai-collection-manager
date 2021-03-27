/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/widget_factory.dart';
import '../../shared/ui/spaces.dart';
import '../../worktype/ui/work_type_selector.dart';
import '../model/reminder.dart';
import '../i18n/view_reminder_configuration_page.i18n.dart';

class EditReminderConfigurationPage extends StatefulWidget {
  static const route_name = '/reminder/edit-configuration';
  static const route_name_create = '/logbook/create-configuration';

  final ReminderConfiguration reminderConfiguration;

  EditReminderConfigurationPage({this.reminderConfiguration});
  @override
  _EditReminderConfigurationPageState createState() {
    return _EditReminderConfigurationPageState();
  }
}

class _EditReminderConfigurationPageState
    extends State<EditReminderConfigurationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ReminderConfigurationBuilder _configurationBuilder;
  TextEditingController _frequencyController = TextEditingController();
  TextEditingController _repetitionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initFromWidget();
  }

  @override
  void didUpdateWidget(EditReminderConfigurationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initFromWidget();
  }

  void _initFromWidget() {
    _configurationBuilder = ReminderConfigurationBuilder(
        fromConfiguration: widget.reminderConfiguration);
    _configurationBuilder.workTypeName =
        widget.reminderConfiguration?.workTypeName ??
            _configurationBuilder?.workType?.toString()?.i18n ??
            '';
    _frequencyController.text = "${_configurationBuilder.frequency}";
    _repetitionsController.text = "1"; // TODO
    /*
    _entryBuilder.workType =
        widget.entry?.entry?.workType ?? widget.initialWorkType;
    _entryBuilder.workTypeName = widget.entry?.entry?.workTypeName ??
        widget.initialWorkType?.toString()?.i18n ??
        '';*/
  }

  @override
  void dispose() {
    _frequencyController.dispose();
    _repetitionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<ReminderList>(
        builder: (context, reminderList, _) => SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: _buildTitle(),
            actions: [
              TextButton(
                onPressed: () => _save(reminderList),
                child: Text('Save'.i18n,
                    style: Theme.of(context).textTheme.subtitle1),
              ),
            ],
          ),
          body: _buildBody(context),
        )),
      );

  Widget _buildTitle() => Text(widget.reminderConfiguration != null
      ? 'Edit reminder'.i18n
      : 'Create reminder'.i18n);

  Future _save(ReminderList reminderList) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
  }

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
                    hasWorkType: _configurationBuilder,
                  ),
                  mediumVerticalSpace,
                  formDatePickerField(
                    context,
                    initialValue: _configurationBuilder.firstReminder,
                    firstDate: _configurationBuilder.firstReminder,
                    label: 'On'.i18n,
                    readOnly: false,
                    onChanged: (value) =>
                        _configurationBuilder.firstReminder = value,
                  ),
                  mediumVerticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Repeat".i18n),
                      smallHorizontalSpace,
                      Checkbox(
                        value: _configurationBuilder.repeat,
                        onChanged: (value) {
                          setState(() {
                            _configurationBuilder.repeat = value;
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Every".i18n),
                      smallHorizontalSpace,
                      FixedSize(
                        child: TextField(
                          controller: _frequencyController,
                          decoration: InputDecoration(
                              counterText: "",
                              filled: _configurationBuilder.repeat),
                          enabled: _configurationBuilder.repeat,
                          maxLength: 2,
                          keyboardType: TextInputType.numberWithOptions(),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            final parsed = int.tryParse(value);
                            if (parsed != null) {
                              setState(() {
                                _configurationBuilder.frequency = parsed;
                              });
                            }
                          },
                        ),
                      ),
                      smallHorizontalSpace,
                      Flexible(
                        child: formDropdownField(
                          context,
                          value: _configurationBuilder.frequencyUnit,
                          readOnly: !_configurationBuilder.repeat,
                          values: FrequencyUnit.values,
                          translate: (value) => value.toString().i18n,
                          onSaved: (value) {
                            _configurationBuilder.frequencyUnit = value;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  smallVerticalSpace,
                  Text("Ends".i18n),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: RadioListTile(
                                title: Text(
                                    EndingConditionType.never.toString().i18n),
                                value: EndingConditionType.never,
                                groupValue:
                                    _configurationBuilder.endingConditionType,
                                onChanged: _configurationBuilder.repeat
                                    ? (value) {
                                        setState(() {
                                          _configurationBuilder
                                              .endingConditionType = value;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: RadioListTile(
                                title: Text(EndingConditionType.after_date
                                    .toString()
                                    .i18n),
                                value: EndingConditionType.after_date,
                                groupValue:
                                    _configurationBuilder.endingConditionType,
                                onChanged: _configurationBuilder.repeat
                                    ? (value) {
                                        setState(() {
                                          _configurationBuilder
                                              .endingConditionType = value;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                            Flexible(
                              child: formDatePickerField(
                                context,
                                readOnly: !_configurationBuilder.repeat ||
                                    EndingConditionType.after_date !=
                                        _configurationBuilder
                                            .endingConditionType,
                                firstDate: _configurationBuilder.firstReminder,
                                initialValue:
                                    _configurationBuilder.firstReminder,
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: RadioListTile(
                                title: Text(EndingConditionType
                                    .after_repetitions
                                    .toString()
                                    .i18n),
                                value: EndingConditionType.after_repetitions,
                                groupValue:
                                    _configurationBuilder.endingConditionType,
                                onChanged: _configurationBuilder.repeat
                                    ? (value) {
                                        setState(() {
                                          _configurationBuilder
                                              .endingConditionType = value;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                            Flexible(
                              child: FixedSize(
                                child: TextField(
                                  controller: _repetitionsController,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      filled: _configurationBuilder.repeat &&
                                          EndingConditionType
                                                  .after_repetitions ==
                                              _configurationBuilder
                                                  .endingConditionType),
                                  enabled: _configurationBuilder.repeat &&
                                      EndingConditionType.after_repetitions ==
                                          _configurationBuilder
                                              .endingConditionType,
                                  maxLength: 2,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    final parsed = int.tryParse(value);
                                    if (parsed != null) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ),
                            smallHorizontalSpace,
                            Text("Repetitions".i18n),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      );
}

class FixedSize extends StatelessWidget {
  final TextField child;
  FixedSize({this.child});

  @override
  Widget build(BuildContext context) {
    final double width = _calculateSize(
      style: child.style ?? Theme.of(context).textTheme.subtitle1,
      textAlign: child.textAlign,
      strutStyle: child.strutStyle,
      maxLines: child.maxLines,
      textDirection: child.textDirection ?? TextDirection.ltr,
    ).width;
    return Container(width: width, child: child);
  }

  Size _calculateSize({
    TextStyle style,
    TextAlign textAlign,
    StrutStyle strutStyle,
    int maxLines,
    TextDirection textDirection,
  }) {
    final int length = (child.maxLength ?? 9) + 3;
    String text = String.fromCharCodes(List.filled(length, 57));

    final painter = TextPainter(
      text: TextSpan(
        style: style,
        text: text,
      ),
      textAlign: textAlign,
      strutStyle: strutStyle,
      maxLines: maxLines,
      textDirection: textDirection,
    )..layout();
    return painter.size;
  }
}
