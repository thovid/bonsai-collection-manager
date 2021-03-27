/*
 * Copyright (c) 2021 by Thomas Vidic
 */

enum LogWorkType {
  watered,
  fertilized,
  sprayed,
  wired,
  deadwood,
  pruned,
  repotted,
  custom,
  pinched,
}

enum Tenses {
  present, past
}

mixin HasWorkType {
  LogWorkType get workType;
  set workType(LogWorkType workType);
  String get workTypeName;
  set workTypeName(String name);
}
