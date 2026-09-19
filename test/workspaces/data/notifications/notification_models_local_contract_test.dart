import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mapuje lokalnego aktora grupy z kontraktu UserId', () {
    final group = NotificationGroupResponse.fromJson(<String, dynamic>{
      'groupKey': 'project:project-1',
      'count': 2,
      'unreadCount': 1,
      'latest': _NotificationFixtures.notificationJson(),
      'notificationIds': <String>['notification-1'],
      'actorAvatars': <Object?>[
        <String, dynamic>{'userId': 'user-1', 'avatarUrl': null},
      ],
      'preview': 'Zmieniono zadanie',
      'isArchived': false,
      'realtimeSequence': 4,
    });

    expect(group.actorAvatars!.single.userId, 'user-1');
    expect(group.realtimeSequence, 4);
    expect(group.latest.category, NotificationCategory.task);
  });

  test('zachowuje typowany błąd parsowania kontraktu', () {
    final error = ApiError.parsing(
      fallbackMessage: 'Nieprawidłowa odpowiedź Notifications.',
    );

    expect(error.type, ApiErrorType.parsing);
    expect(error.message, 'Nieprawidłowa odpowiedź Notifications.');
  });
}

abstract final class _NotificationFixtures {
  static Map<String, dynamic> notificationJson() => <String, dynamic>{
    'id': 'notification-1',
    'sourceModule': 'workspaces',
    'eventType': 'task.updated',
    'entityType': 'Task',
    'entityId': 'task-1',
    'workspaceId': 'workspace-1',
    'title': 'Zadanie zmienione',
    'body': 'Zmieniono zadanie.',
    'deepLink': '/workspaces/workspace-1/tasks/task-1',
    'eventId': 'event-1',
    'contractVersion': 1,
    'createdAtUtc': '2026-09-17T18:00:00Z',
    'readAtUtc': null,
    'isPinned': false,
    'pinnedAtUtc': null,
    'category': 'task',
    'groupKey': 'project:project-1',
    'metadataJson': null,
    'priority': 'normal',
    'digestOnly': false,
  };
}
