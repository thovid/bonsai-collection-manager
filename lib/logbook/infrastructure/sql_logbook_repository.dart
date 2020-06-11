/*
 * Copyright (c) 2020 by Thomas Vidic
 */

import '../../shared/model/model_id.dart';
import '../../shared/infrastructure/base_repository.dart';
import '../model/logbook.dart';
import './logbook_entry_table.dart';

class SQLLogbookRepository extends BaseRepository with LogbookRepository {
  @override
  Future<void> add(LogbookEntry logbookEntry, ModelID subjectId) async =>
      init().then((db) => LogbookEntryTable.write(logbookEntry, subjectId, db));

  @override
  Future<void> delete(ModelID<LogbookEntry> id) async =>
      init().then((db) => LogbookEntryTable.delete(id, db));

  @override
  Future<List<LogbookEntry>> loadLogbook(ModelID subjectId) async =>
      init().then((db) => LogbookEntryTable.readAll(subjectId, db));
}
