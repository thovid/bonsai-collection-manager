/*
 * Copyright (c) 2021 by Thomas Vidic
 */

import 'package:bonsaicollectionmanager/reminder/model/reminder.dart';
import 'package:bonsaicollectionmanager/shared/model/model_id.dart';
import 'package:bonsaicollectionmanager/worktype/model/work_type.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../utils/test_mocks.dart';

main() {
  final ModelID subjectId = ModelID.newId();
// TODO test ending condition
  test('can create reminder configuration', () async {
    final ReminderConfiguration reminderConfiguration =
        (ReminderConfigurationBuilder()
              ..treeName = "My Tree"
              ..subjectID = subjectId
              ..workType = LogWorkType.fertilized
              ..workTypeName = "fertilize"
              ..frequency = 4
              ..frequencyUnit = FrequencyUnit.weeks
              ..firstReminder = DateTime.now())
            .build();

    expect(reminderConfiguration.frequency, equals(4));
    expect(reminderConfiguration.frequencyUnit, equals(FrequencyUnit.weeks));
  });
}
