/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';

/// Simple helper to create a text form field.
TextFormField formTextField(BuildContext context,
        {String initialValue,
        bool readOnly = true,
        String hint,
        String label,
        int lines = 1,
        Function(String value) onSaved}) =>
    TextFormField(
      cursorColor: TextSelectionTheme.of(context).cursorColor,
      enabled: !readOnly,
      initialValue: initialValue,
      minLines: lines,
      maxLines: lines,
      decoration: InputDecoration(
        filled: !readOnly,
        hintText: hint,
        labelText: label,
      ),
      onSaved: onSaved,
      validator: null,
    );

/// Simple helper to create a dropdown form field.
DropdownButtonFormField<T> formDropdownField<T>(context,
        {String label,
        T value,
        bool readOnly = true,
        List<T> values,
        Function(T value) onSaved,
        String Function(T value) translate}) =>
    DropdownButtonFormField<T>(
        decoration: InputDecoration(
          filled: !readOnly,
          labelText: label,
        ),
        value: value,
        hint: Text(translate(value)), // hint to show value while disabled
        items: values
            .map(
                (e) => DropdownMenuItem<T>(value: e, child: Text(translate(e))))
            .toList(),
        onSaved: onSaved,
        onChanged: readOnly
            ? null // null to disable dropdown
            : (_) {});

/// Helper function to create a date field where the value can be edited via a
/// date picker dialog.
TextFormField formDatePickerField(context,
    {String label,
    DateTime initialValue,
    DateTime firstDate,
    bool readOnly,
    Function(DateTime value) onChanged}) {
  final TextEditingController _controller =
      TextEditingController(text: _formatDate(initialValue));
  return TextFormField(
    controller: _controller,
    cursorColor: TextSelectionTheme.of(context).cursorColor,
    readOnly: true,
    enabled: !readOnly,
    onTap: readOnly
        ? () {}
        : () async {
            DateTime value =
                (await _getDate(context, initialValue, firstDate: firstDate));
            if (value != null) {
              _controller.text = _formatDate(value);
              onChanged(value);
            }
          },
    decoration: InputDecoration(
      icon: Icon(Icons.date_range),
      filled: !readOnly,
      labelText: label,
    ),
    validator: null,
  );
}

String _formatDate(DateTime value) =>
    DateFormat.yMMMd(I18n.locale?.toString()).format(value);

Future<DateTime> _getDate(BuildContext context, DateTime initialDate,
    {DateTime firstDate}) {
  firstDate = firstDate ?? DateTime(initialDate.year - 80);
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: DateTime(initialDate.year + 2),
  );
}
