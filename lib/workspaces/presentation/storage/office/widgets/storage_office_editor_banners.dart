import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// TXT/CSV cannot carry comments back into the original file after export.
final class StorageOfficePlainFormatBanner extends StatelessWidget {
  const StorageOfficePlainFormatBanner({required this.file, super.key});

  final StorageFileResponse file;

  @override
  Widget build(BuildContext context) {
    final targetFormat = switch (file.extension
        .replaceFirst('.', '')
        .toLowerCase()) {
      'txt' || 'html' => 'docx',
      'csv' => 'xlsx',
      _ => null,
    };
    if (targetFormat == null) return const SizedBox.shrink();

    return BlocBuilder<
      StorageOfficeEditorActionsCubit,
      StorageOfficeEditorActionsState
    >(
      buildWhen: (previous, current) =>
          previous.isSessionReady != current.isSessionReady ||
          previous.isSavingCopy != current.isSavingCopy ||
          previous.isPrinting != current.isPrinting ||
          previous.isDownloading != current.isDownloading ||
          previous.isClosing != current.isClosing,
      builder: (context, actions) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        color: context.tasksTheme.selectionAccent.withValues(alpha: 0.10),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          children: [
            Text(context.l10n.storageOfficePlainFormatCommentsWarning),
            TextButton(
              onPressed:
                  !actions.isSessionReady ||
                      actions.isSavingCopy ||
                      actions.isPrinting ||
                      actions.isDownloading ||
                      actions.isClosing
                  ? null
                  : () => context
                        .read<StorageOfficeEditorActionsCubit>()
                        .saveCopy(
                          sessionToken: _sessionToken(context),
                          format: targetFormat,
                        ),
              child: Text(
                context.l10n.storageOfficeCreateCommentableCopy(
                  targetFormat.toUpperCase(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _sessionToken(BuildContext context) {
    final state = context.read<StorageOfficeCubit>().state;
    return state is StorageOfficeReady ? state.session.token : null;
  }
}

final class StorageOfficeOperationBanner extends StatelessWidget {
  const StorageOfficeOperationBanner({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        StorageOfficeEditorActionsCubit,
        StorageOfficeEditorActionsState
      >(
        buildWhen: (previous, current) =>
            previous.isSavingCopy != current.isSavingCopy ||
            previous.isPrinting != current.isPrinting ||
            previous.isDownloading != current.isDownloading,
        builder: (context, actions) {
          final label = actions.isSavingCopy
              ? context.l10n.storageOfficeSavingCopy
              : actions.isPrinting
              ? context.l10n.storageOfficePrinting
              : actions.isDownloading
              ? context.l10n.storageDownloadAction
              : null;
          if (label == null) return const SizedBox.shrink();
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: context.tasksTheme.selectionAccent.withValues(alpha: 0.10),
            child: Row(
              children: [
                const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
                Text(label, style: context.text.bodyMedium),
              ],
            ),
          );
        },
      );
}
