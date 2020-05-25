/*
 * Copyright (c) 2020 by Thomas Vidic
 */

// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages/messages_all.dart';

class BCMLocalizations {
  final String localeName;

  BCMLocalizations(this.localeName);

  static Future<BCMLocalizations> load(Locale locale) {
    final String localeName = Intl.canonicalizedLocale(
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString());
    return initializeMessages(localeName).then((_) {
      return BCMLocalizations(localeName);
    });
  }

  static BCMLocalizations of(BuildContext context) {
    return Localizations.of<BCMLocalizations>(context, BCMLocalizations);
  }

  String get app_title {
    return Intl.message('Bonsai Collection Manager',
        name: 'app_title', desc: 'title of the app', locale: localeName);
  }
}

class BCMLocalizationsDelegate extends LocalizationsDelegate<BCMLocalizations> {
  const BCMLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<BCMLocalizations> load(Locale locale) => BCMLocalizations.load(locale);

  @override
  bool shouldReload(BCMLocalizationsDelegate old) => false;
}
