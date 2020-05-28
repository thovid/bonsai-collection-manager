/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:async';
import 'dart:ui';

import 'package:i18n_extension/i18n_widget.dart';

const List<Locale> supportedLanguageCodes = const [
  const Locale('en', ''),
  const Locale('de', ''),
];

String extractSupportedLanguageCode(Locale locale) {
  if (supportedLanguageCodes.contains(locale)) return locale.languageCode;
  return 'en';
}

Future<Locale> fetchLocale() {
  var completer = Completer<Locale>();
  var completeWithLocale = (Locale locale) {
    if (completer.isCompleted) {
      I18n.observeLocale = null;
    } else {
      completer.complete(locale);
    }
  };
  I18n.observeLocale =
      ({Locale oldLocale, Locale newLocale}) => completeWithLocale(newLocale);
  if (I18n.locale != null) completeWithLocale(I18n.locale);
  return completer.future;
}
