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

enum Tenses { present, past }

mixin HasWorkType {
  LogWorkType get workType;
  String get workTypeName;
  void updateWorkType(LogWorkType workType, String workTypeName);
}
