import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializuje zakres, folder i allowlistowany format dokumentu', () {
    const payload = CreateStorageDocumentPayload(
      name: 'Plan kwartalny',
      format: StorageDocumentFormat.ods,
      module: StorageModule.workspaces,
      resourceType: StorageResourceType.project,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      folderId: 'folder-1',
    );

    expect(payload.toJson(), {
      'name': 'Plan kwartalny',
      'format': 'Ods',
      'module': 'Workspaces',
      'resourceType': 'Project',
      'projectId': 'project-1',
      'workspaceId': 'workspace-1',
      'folderId': 'folder-1',
    });
  });
}
