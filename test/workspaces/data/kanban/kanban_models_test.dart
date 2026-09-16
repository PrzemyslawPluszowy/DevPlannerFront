import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/kanban_enums.dart';

void main() {
  test('akceptuje kontrakt backendu z PascalCase dla swimlane None', () {
    final board = KanbanBoardResponse.fromJson({
      'projectId': 'project-1',
      'swimlaneMode': 'None',
      'settingsVersion': 1,
      'hiddenColumns': <String>[],
      'visibleCardFields': [
        'Assignee',
        'DueDate',
        'Labels',
        'Checklist',
        'Subtasks',
        'TimeTracking',
        'Blockers',
        'CoverAttachment',
        'CustomFields',
      ],
      'defaultCardDensity': 'Comfortable',
      'columns': <Object>[],
    });

    expect(board.swimlaneMode, KanbanSwimlaneMode.none);
    expect(board.toJson()['swimlaneMode'], 'None');
    expect(board.visibleCardFields, [
      KanbanCardField.assignee,
      KanbanCardField.dueDate,
      KanbanCardField.labels,
      KanbanCardField.checklist,
      KanbanCardField.subtasks,
      KanbanCardField.timeTracking,
      KanbanCardField.blockers,
      KanbanCardField.coverAttachment,
      KanbanCardField.customFields,
    ]);
    expect(board.defaultCardDensity, KanbanCardDensity.comfortable);
    expect(board.toJson()['defaultCardDensity'], 'Comfortable');
  });

  test(
    'preferencja Kanban serializuje quick filter i własne zwinięte kolumny',
    () {
      final preference = UserKanbanPreferenceResponse.fromJson({
        'workspaceId': 'workspace-1',
        'projectId': 'project-1',
        'coreUserId': 'user-1',
        'collapsedColumns': ['Done'],
        'collapsedCustomStatusIds': ['status-1'],
        'quickFilter': 'DueSoon',
        'updatedAtUtc': '2026-08-26T10:00:00.000Z',
        'version': 4,
      });

      expect(preference.quickFilter, KanbanQuickFilter.dueSoon);
      expect(preference.collapsedCustomStatusIds, ['status-1']);
      expect(preference.toJson()['quickFilter'], 'DueSoon');
    },
  );
}
