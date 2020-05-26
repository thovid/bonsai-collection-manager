/*
 * Copyright (c) 2020 by Thomas Vidic
 */

// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages/messages_all.dart';

class I10L {
  final String localeName;

  I10L(this.localeName);

  String get app_title => Intl.message('Bonsai Collection Manager',
      name: 'app_title', desc: 'title of the app', locale: localeName);

  String get add_new_tree => Intl.message('Add new tree',
      name: 'add_new_tree',
      desc: 'title of add tree screen',
      locale: localeName);

  String get edit => Intl.message('edit',
      name: 'edit', desc: 'edit button text', locale: localeName);

  String get species_hint => Intl.message('The species of the tree',
      name: 'species_hint',
      desc: 'hint shown for species selection',
      locale: localeName);

  String get species => Intl.message('Species',
      name: 'species', desc: 'species label', locale: localeName);

  String get tree_name_hint => Intl.message('Name of the tree (optional)',
      name: 'tree_name_hint',
      desc: 'hint shown for tree name',
      locale: localeName);

  String get tree_name => Intl.message('Name',
      name: 'tree_name', desc: 'tree name label', locale: localeName);

  String get acquired_at => Intl.message('Acquired at',
      name: 'acquired_at', desc: 'acquired at label', locale: localeName);

  String get acquired_from_hint =>
      Intl.message('Where the tree was acquired from',
          name: 'acquired_from_hint',
          desc: 'hint shown for acquired from',
          locale: localeName);

  String get acquired_from => Intl.message('Acquired from',
      name: 'acquired_from', desc: 'acquired from label', locale: localeName);

  String get cancel => Intl.message('Cancel',
      name: 'cancel', desc: 'cancel button text', locale: localeName);

  String get save => Intl.message('Save',
      name: 'save', desc: 'save button text', locale: localeName);

  String get add_tree => Intl.message('Add Tree',
      name: 'add_tree', desc: 'add tree button text', locale: localeName);

  String get collection_title => Intl.message('Collection',
      name: 'collection_title',
      desc: 'title of the collection view',
      locale: localeName);

  static Future<I10L> load(Locale locale) {
    final String localeName = Intl.canonicalizedLocale(
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString());
    return initializeMessages(localeName).then((_) {
      return I10L(localeName);
    });
  }

  static I10L of(BuildContext context) {
    return Localizations.of<I10L>(context, I10L);
  }
}

class BCMLocalizationsDelegate extends LocalizationsDelegate<I10L> {
  const BCMLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<I10L> load(Locale locale) => I10L.load(locale);

  @override
  bool shouldReload(BCMLocalizationsDelegate old) => false;
}
