import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Jeden właściciel zasobów podglądu dla wiersza i menu plików zadania.
abstract final class TaskAttachmentPreviewLauncher {
  static Future<void> open(
    BuildContext context,
    StorageFileResponse file,
  ) async {
    if (!context.mounted || !file.canPreview) return;
    final repository = context.read<StorageRepository>();
    final attachments = context.read<TaskAttachmentsCubit>();
    if (attachments.isClosed) return;
    final preview = StoragePreviewCubit(repository: repository);
    final mutation = StorageFileMutationCubit(
      repository: repository,
      downloadTransport: context.read<DownloadTransport>(),
    );
    try {
      await preview.preparePreview(file);
      if (!context.mounted || !_isCurrent(context, repository, attachments)) {
        return;
      }
      await DevPlannerModalHost.showDialog<void>(
        context,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: preview),
            BlocProvider.value(value: mutation),
          ],
          child: StoragePreviewDialog(file: file, repository: repository),
        ),
      );
      if (!context.mounted || !_isCurrent(context, repository, attachments)) {
        return;
      }
      if (mutation.state is StorageFileMutationSuccess) {
        await attachments.load();
      }
    } finally {
      await preview.close();
      await mutation.close();
    }
  }

  static bool _isCurrent(
    BuildContext context,
    StorageRepository repository,
    TaskAttachmentsCubit attachments,
  ) =>
      context.mounted &&
      !attachments.isClosed &&
      identical(repository, context.read<StorageRepository>()) &&
      identical(attachments, context.read<TaskAttachmentsCubit>());
}
