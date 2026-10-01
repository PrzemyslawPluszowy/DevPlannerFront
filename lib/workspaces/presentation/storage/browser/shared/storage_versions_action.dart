import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Otwiera historię i odświeża wyłącznie nadal aktualną listę plików.
final class StorageVersionsAction {
  const StorageVersionsAction._();

  static Future<void> show(
    BuildContext context,
    StorageFileResponse file,
    StorageShellCapabilities capabilities,
  ) async {
    final browser = context.read<StorageBrowserCubit>();
    final repository = context.read<StorageRepository>();
    final transport = context.read<DownloadTransport>();
    final scope = browser.currentScope;
    final restored = await StorageVersionsDialog.show(
      context,
      file: file,
      repository: repository,
      downloadTransport: transport,
      canDeleteVersions:
          capabilities.canManageVersions && file.canManageVersions,
    );
    if (!context.mounted ||
        restored != true ||
        browser.isClosed ||
        browser.currentScope != scope ||
        !identical(context.read<StorageBrowserCubit>(), browser) ||
        !identical(context.read<StorageRepository>(), repository) ||
        !identical(context.read<DownloadTransport>(), transport)) {
      return;
    }
    await browser.load(showLoading: false);
  }
}
