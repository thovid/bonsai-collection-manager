/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:date_calendar/date_calendar.dart';

int toJulianDayNumber(Calendar date) {
  int year = date.year;
  int month = date.month;
  int day = date.day;

  if (month < 3) {
    month = month + 12;
    year = year - 1;
  }

  return 365 * year +
      year ~/ 4 -
      year ~/ 100 +
      year ~/ 400 +
      day +
      (153 * month + 8) ~/ 5;
}

int differenceInDays(Calendar a, Calendar b) =>
    toJulianDayNumber(a) - toJulianDayNumber(b);
