import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wspólne akcje przenoszenia z pickera, menu i drag & drop.
final class StorageMoveAction {
  const StorageMoveAction._();

  /// Przenosi wskazane pliki do folderu wybranego w pickerze.
  ///
  /// Jedno wejście dla menu kontekstowego i paska akcji masowych: picker zwraca
  /// cel, a przeniesienie idzie przez ten sam przypadek użycia Cubita, więc
  /// pojedynczy element i wiele elementów nie mają dwóch różnych implementacji.
  static Future<void> chooseFolder(
    BuildContext context, {
    required List<String> fileIds,
  }) async {
    if (fileIds.isEmpty) return;
    final browser = context.read<StorageBrowserCubit>();
    final mutation = context.read<StorageFileMutationCubit>();
    final scope = browser.currentScope;
    final requestedIds = List<String>.unmodifiable(fileIds);
    final repository = context.read<StorageRepository>();
    final target = await StorageFolderPickerDialog.show(
      context,
      repository: repository,
      scope: scope,
      // Folder, z którego przenosimy, nie jest celem samym w sobie.
      disabledFolderIds: {?scope.folderId},
    );
    if (target == null ||
        !context.mounted ||
        browser.isClosed ||
        mutation.isClosed ||
        browser.currentScope != scope ||
        !identical(context.read<StorageBrowserCubit>(), browser) ||
        !identical(context.read<StorageFileMutationCubit>(), mutation) ||
        !identical(context.read<StorageRepository>(), repository)) {
      return;
    }
    await _StorageMoveCommand.execute(
      mutation,
      fileIds: requestedIds,
      target: target,
      sourceFolderId: scope.folderId,
    );
  }

  /// Przenosi wskazane pliki do wskazanego folderu.
  ///
  /// Używane przez upuszczenie elementu na folder: ten sam przypadek użycia co
  /// picker, tylko cel pochodzi z gestu zamiast z dialogu.
  static Future<void> moveToFolder(
    BuildContext context, {
    required List<String> fileIds,
    required StorageFolderResponse target,
  }) async {
    if (fileIds.isEmpty) return;
    final cubit = context.read<StorageFileMutationCubit>();
    final sourceFolderId = context
        .read<StorageBrowserCubit>()
        .currentScope
        .folderId;

    await _StorageMoveCommand.execute(
      cubit,
      fileIds: List<String>.unmodifiable(fileIds),
      target: target,
      sourceFolderId: sourceFolderId,
    );
  }
}

/// Wykonuje intencję na właścicielu przechwyconym przed otwarciem pickera.
final class _StorageMoveCommand {
  const _StorageMoveCommand._();

  static Future<void> execute(
    StorageFileMutationCubit cubit, {
    required List<String> fileIds,
    required StorageFolderResponse target,
    required String? sourceFolderId,
  }) async {
    if (cubit.isClosed) return;
    if (fileIds.length == 1) {
      await cubit.moveFileToFolder(
        fileId: fileIds.single,
        targetFolderId: target.id,
        sourceFolderId: sourceFolderId,
      );
      return;
    }
    await cubit.moveFilesToFolder(
      fileIds: fileIds,
      targetFolderId: target.id,
      sourceFolderId: sourceFolderId,
    );
  }
}
