import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Przenosi wskazane pliki do folderu wybranego w pickerze.
///
/// Jedno wejście dla menu kontekstowego i paska akcji masowych: picker zwraca
/// cel, a przeniesienie idzie przez ten sam przypadek użycia Cubita, więc
/// pojedynczy element i wiele elementów nie mają dwóch różnych implementacji.
Future<void> runStorageMoveToFolderAction(
  BuildContext context, {
  required List<String> fileIds,
}) async {
  if (fileIds.isEmpty) return;
  final scope = context.read<StorageBrowserCubit>().currentScope;
  final repository = context.read<StorageRepository>();
  final target = await StorageFolderPickerDialog.show(
    context,
    repository: repository,
    scope: scope,
    // Folder, z którego przenosimy, nie jest celem samym w sobie.
    disabledFolderIds: {?scope.folderId},
  );
  if (target == null || !context.mounted) return;
  await runStorageMoveToFolder(context, fileIds: fileIds, target: target);
}

/// Przenosi wskazane pliki do wskazanego folderu.
///
/// Używane przez upuszczenie elementu na folder: ten sam przypadek użycia co
/// picker, tylko cel pochodzi z gestu zamiast z dialogu.
Future<void> runStorageMoveToFolder(
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
