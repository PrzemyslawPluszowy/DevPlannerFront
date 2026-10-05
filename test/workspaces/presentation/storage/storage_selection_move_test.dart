import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_support/storage_shell_harness.dart';

void main() {
  test(
    'bulk move requires every file editable and active; folders excluded',
    () async {
      final cubit = StorageSelectionCubit();
      addTearDown(cubit.close);
      final editable = storageTestFile().copyWith(
        canEdit: true,
        isDeleted: false,
      );
      final denied = editable.copyWith(id: 'denied', canEdit: false);
      final deleted = editable.copyWith(id: 'deleted', isDeleted: true);
      cubit.toggleFile(editable);
      expect(cubit.state.canMove, isTrue);
      cubit.toggleFile(denied);
      expect(cubit.state.canMove, isFalse);
      cubit.toggleFile(denied);
      expect(cubit.state.canMove, isTrue);
      cubit.toggleFile(deleted);
      expect(cubit.state.canMove, isFalse);
      cubit.toggleFile(deleted);
      cubit.toggleFolder(storageTestFolder());
      expect(cubit.state.canMove, isFalse);
      cubit.clearSelection();
      expect(cubit.state.canMove, isFalse);
    },
  );

  test(
    'missing capability snapshot fails closed and realtime revoke updates move',
    () async {
      final cubit = StorageSelectionCubit();
      addTearDown(cubit.close);
      final file = storageTestFile().copyWith(canEdit: true, isDeleted: false);
      cubit.emit(const StorageSelectionState(selectedFileIds: {'missing'}));
      cubit.toggleFile(file);
      expect(cubit.state.canMove, isFalse);
      cubit.clearSelection();
      cubit.toggleFile(file);
      expect(cubit.state.canMove, isTrue);
      cubit.retain(allFiles: [file.copyWith(canEdit: false)], allFolders: []);
      expect(cubit.state.canMove, isFalse);
    },
  );
}
