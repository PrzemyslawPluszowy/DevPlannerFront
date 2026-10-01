import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_dismiss_shared_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Potwierdza ukrycie pliku wyłącznie dla aktualnego właściciela i zakresu.
final class StorageDismissSharedAction {
  const StorageDismissSharedAction._();

  static Future<void> confirm(BuildContext context, String fileId) async {
    final browser = context.read<StorageBrowserCubit>();
    final mutation = context.read<StorageFileMutationCubit>();
    final scope = browser.currentScope;
    if (!scope.isSharedWithMe || browser.isClosed || mutation.isClosed) return;
    final confirmed = await StorageDismissSharedConfirmation.show(context);
    if (!context.mounted ||
        confirmed != true ||
        browser.isClosed ||
        mutation.isClosed ||
        browser.currentScope != scope ||
        !identical(context.read<StorageBrowserCubit>(), browser) ||
        !identical(context.read<StorageFileMutationCubit>(), mutation)) {
      return;
    }
    await mutation.dismissSharedFile(fileId);
  }
}
