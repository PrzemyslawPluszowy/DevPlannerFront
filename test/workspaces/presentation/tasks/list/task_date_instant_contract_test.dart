import 'dart:io' show Platform;

import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_workflow_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'task date selection preserves local clock and serializes UTC instant',
    () {
      final previous = DateTime.utc(2026, 10, 1, 10, 27, 38, 123, 456);
      final previousLocal = previous.toLocal();
      final selected = TaskDatePicker.asUtcTaskInstant(
        DateTime(2026, 10, 15),
        previous,
      );
      final expected = DateTime(
        2026,
        10,
        15,
        previousLocal.hour,
        previousLocal.minute,
        previousLocal.second,
        previousLocal.millisecond,
        previousLocal.microsecond,
      ).toUtc();

      expect(selected, expected);
      expect(selected!.isUtc, isTrue);
      expect(
        UpdateTaskListItemPayload(
          dueAtUtc: selected,
          expectedVersion: 9,
        ).toJson()['dueAtUtc'],
        selected.toIso8601String(),
      );
      final requestJson = UpdateProjectTaskPayload(
        title: 'Task',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        startAtUtc: selected,
        dueAtUtc: selected,
        position: 0,
        expectedVersion: 9,
      ).toJson();
      expect(requestJson['status'], 'Todo');
      expect(requestJson['priority'], 'Normal');
      expect(requestJson['startAtUtc'], selected.toIso8601String());
      expect(requestJson['dueAtUtc'], selected.toIso8601String());
      expect(
        DateTime.parse(requestJson['dueAtUtc']! as String).toUtc(),
        selected,
      );
    },
  );

  test(
    'new task date is local midnight converted to UTC and clear stays null',
    () {
      final selected = TaskDatePicker.asUtcTaskInstant(
        DateTime(2026, 10, 15),
        null,
      );

      expect(selected, DateTime(2026, 10, 15).toUtc());
      expect(selected!.isUtc, isTrue);
      expect(TaskDatePicker.asUtcTaskInstant(null, selected), isNull);
    },
  );

  test(
    'changing date across a DST boundary preserves local clock precision',
    () {
      final losAngelesBoundary =
          DateTime(2026, 3, 7, 12).timeZoneOffset !=
          DateTime(2026, 3, 9, 12).timeZoneOffset;
      final warsawBoundary =
          DateTime(2026, 3, 28, 12).timeZoneOffset !=
          DateTime(2026, 3, 30, 12).timeZoneOffset;
      final configuredZone = Platform.environment['TZ'];
      final expectsLosAngeles = configuredZone == 'America/Los_Angeles';
      final expectsWarsaw = configuredZone == 'Europe/Warsaw';
      if (expectsLosAngeles) {
        expect(losAngelesBoundary, isTrue);
      } else if (expectsWarsaw) {
        expect(warsawBoundary, isTrue);
      }
      final useLosAngeles =
          expectsLosAngeles || (!expectsWarsaw && losAngelesBoundary);
      final previous = useLosAngeles
          ? DateTime.utc(2026, 3, 7, 14, 30, 45, 678, 901)
          : DateTime.utc(2026, 3, 28, 13, 30, 45, 678, 901);
      final selectedDay = useLosAngeles
          ? DateTime(2026, 3, 9)
          : DateTime(2026, 3, 30);
      final previousLocal = previous.toLocal();
      final selected = TaskDatePicker.asUtcTaskInstant(
        selectedDay,
        previous,
      );
      final updatedLocal = selected!.toLocal();

      if (expectsLosAngeles) {
        expect(previousLocal.timeZoneOffset, const Duration(hours: -8));
        expect(updatedLocal.timeZoneOffset, const Duration(hours: -7));
        expect(previousLocal.timeZoneName, 'PST');
        expect(updatedLocal.timeZoneName, 'PDT');
      } else if (expectsWarsaw) {
        expect(previousLocal.timeZoneOffset, const Duration(hours: 1));
        expect(updatedLocal.timeZoneOffset, const Duration(hours: 2));
        expect(previousLocal.timeZoneName, 'CET');
        expect(updatedLocal.timeZoneName, 'CEST');
      }
      if (expectsLosAngeles || expectsWarsaw) {
        expect(
          previousLocal.timeZoneOffset,
          isNot(updatedLocal.timeZoneOffset),
        );
      }
      expect(updatedLocal.hour, previousLocal.hour);
      expect(updatedLocal.minute, previousLocal.minute);
      expect(updatedLocal.second, previousLocal.second);
      expect(updatedLocal.millisecond, previousLocal.millisecond);
      expect(updatedLocal.microsecond, previousLocal.microsecond);
      expect(selected.isUtc, isTrue);
    },
  );
}
