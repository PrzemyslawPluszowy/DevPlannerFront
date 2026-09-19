import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/whiteboard/models/whiteboard_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Kontrakt Whiteboard → Tasks', () {
    test('używa AssigneeUserIds zgodnie z kontraktem backendu', () {
      const payload = CreateTaskFromStickyNotePayload(
        title: 'Zadanie z tablicy',
        priority: TaskPriority.high,
        assigneeUserIds: ['user-1'],
      );

      expect(payload.toJson()['assigneeUserIds'], ['user-1']);
      expect(payload.toJson().containsKey('assigneeCoreUserIds'), isFalse);
      expect(
        CreateTaskFromStickyNotePayload.fromJson(payload.toJson()),
        payload,
      );
    });

    test('serializuje masową konwersję Sticky Notes', () {
      const payload = BulkCreateTasksFromStickyNotesPayload(
        objectIds: ['object-1', 'object-2'],
        assigneeUserIds: ['user-1'],
      );

      final json = payload.toJson();
      expect(json['objectIds'], ['object-1', 'object-2']);
      expect(json['assigneeUserIds'], ['user-1']);
      expect(
        BulkCreateTasksFromStickyNotesPayload.fromJson(json),
        payload,
      );
    });
  });
}
