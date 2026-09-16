import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_scope.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';

void main() {
  test('odtwarza widok Shared i folder z deep linku', () {
    final scope = StorageScopeRouteCodec.fromPersonalUri(
      Uri.parse('/me/files?view=shared&folder=folder-1'),
    );

    expect(scope, const StorageScope.shared(folderId: 'folder-1'));
  });

  test('koduje projekt i folder w kanonicznym URL', () {
    final location = StorageScopeRouteCodec.location(
      const StorageScope.project(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        folderId: 'folder-1',
      ),
    );

    expect(
      location,
      '/workspaces/workspace-1/projects/project-1/files?folder=folder-1',
    );
  });

  test('koduje workspace i folder w kanonicznym URL', () {
    final location = StorageScopeRouteCodec.location(
      const StorageScope.workspace('workspace-1', folderId: 'folder-1'),
    );

    expect(location, '/workspaces/workspace-1/files?folder=folder-1');
  });
}
