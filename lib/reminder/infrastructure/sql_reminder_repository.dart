/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'reminder_configuration_table.dart';
import '../../shared/model/model_id.dart';

import '../model/reminder.dart';
import '../../shared/infrastructure/base_repository.dart';

class SQLReminderRepository extends BaseRepository with ReminderRepository {
  @override
  Future<List<ReminderConfiguration>> loadReminderFor(ModelID subjectId) {
    return init()
        .then((db) => ReminderConfigurationTable.readAll(subjectId, db));
  }

  @override
  Future add(ReminderConfiguration reminderConfiguration) {
    return init().then(
        (db) => ReminderConfigurationTable.write(reminderConfiguration, db));
  }

  @override
  Future<void> remove(ModelID<ReminderConfiguration> id) {
    return init().then((db) => ReminderConfigurationTable.delete(id, db));
  }
}
