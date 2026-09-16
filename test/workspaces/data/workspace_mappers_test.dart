import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/data/workspaces/mappers/workspace_mappers.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';

void main() {
  test('mapuje pełną odpowiedź listy do modelu domenowego', () {
    const response = WorkspaceListItemResponse(
      id: 'workspace-1',
      name: 'Marketing',
      description: 'Kampanie',
      icon: 'campaign',
      primaryColor: '#356AE6',
      isPinned: true,
      isHidden: true,
      sortPosition: 3,
    );

    final result = mapWorkspaceListItem(response);

    expect(result.id, 'workspace-1');
    expect(result.name, 'Marketing');
    expect(result.description, 'Kampanie');
    expect(result.icon, 'campaign');
    expect(result.primaryColor, '#356AE6');
    expect(result.isPinned, isTrue);
    expect(result.isHidden, isTrue);
    expect(result.sortPosition, 3);
  });
}
