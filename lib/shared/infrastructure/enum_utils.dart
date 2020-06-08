/*
 * Copyright (c) 2020 by Thomas Vidic
 */

T enumValueFromString<T>(String value, List<T> values) =>
    values.firstWhere((element) => element.toString() == value);
