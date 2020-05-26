/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'dart:ui';

const supportedLanguageCodes = const [
  const Locale('en', ''),
  const Locale('de', ''),
];

String extractSupportedLanguageCode(Locale locale) {
  if (supportedLanguageCodes.contains(locale)) return locale.languageCode;
  return 'en';
}
