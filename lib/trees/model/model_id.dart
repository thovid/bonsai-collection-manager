/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import 'package:uuid/uuid.dart';

class ModelID<T> {
  static final uuid = Uuid();
  final String _id;

  ModelID._internal(this._id);
  ModelID.newId() : this._internal(uuid.v4());
  factory ModelID.fromID(String id) {
    if (id == null) return null;
    return ModelID._internal(id);
  }

  String get value => _id;

  @override
  operator ==(other) => _id == other._id;
  @override
  int get hashCode => _id.hashCode;
}

