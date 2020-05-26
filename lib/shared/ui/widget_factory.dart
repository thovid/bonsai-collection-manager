/*
 * Copyright (c) 2020 by Thomas Vidic
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Simple helper to create a text form field.
TextFormField formTextField(BuildContext context,
        {String initialValue,
        bool readOnly = true,
        String hint,
        String label,
        Function(String value) onSaved}) =>
    TextFormField(
      cursorColor: Theme.of(context).cursorColor,
      enabled: !readOnly,
      initialValue: initialValue,
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
        Function(T value) onSaved}) =>
    DropdownButtonFormField<T>(
        decoration: InputDecoration(
          filled: !readOnly,
          labelText: label,
        ),
        value: value,
        hint: Text(value.toString()), // hint to show value while disabled
        items: values
            .map(
                (e) => DropdownMenuItem<T>(value: e, child: Text(e.toString())))
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
    bool readOnly,
    Function(DateTime value) onChanged}) {
  final TextEditingController controller =
      TextEditingController(text: _formatDate(initialValue));
  return TextFormField(
    controller: controller,
    cursorColor: Theme.of(context).cursorColor,
    readOnly: true,
    enabled: !readOnly,
    onTap: readOnly
        ? () {}
        : () async {
            DateTime value = (await _getDate(context, initialValue));
            if (value != null) {
              controller.text = _formatDate(value);
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

String _formatDate(DateTime value) => DateFormat.yMMMd().format(value);

Future<DateTime> _getDate(BuildContext context, DateTime initialDate) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(initialDate.year - 80),
    lastDate: DateTime(initialDate.year + 1),
  );
}
