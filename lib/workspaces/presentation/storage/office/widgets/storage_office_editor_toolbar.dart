import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_status_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class StorageOfficeEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const StorageOfficeEditorAppBar({
    required this.file,
    required this.onClose,
    super.key,
  });

  final StorageFileResponse file;
  final VoidCallback onClose;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        StorageOfficeEditorActionsCubit,
        StorageOfficeEditorActionsState
      >(
        builder: (context, actions) => AppBar(
          toolbarHeight: 44,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: context.tasksTheme.commandBarSurface,
          surfaceTintColor: Colors.transparent,
          foregroundColor: context.colors.onSurface,

          title: _StorageOfficeEditorTitle(
            fileName: file.originalFileName,
            status: StorageOfficeStatusLabel(actions: actions),
          ),
          leading: IconButton(
            icon: const Icon(AppIcons.close),
            tooltip: context.l10n.close,
            onPressed:
                actions.isClosing ||
                    actions.isSavingCopy ||
                    actions.isPrinting ||
                    actions.isDownloading
                ? null
                : onClose,
          ),
          actions: [
            if (actions.saveConfirmation ==
                StorageOfficeSaveConfirmation.unconfirmed)
              TextButton(
                key: const ValueKey('storage_office_retry_save'),
                onPressed: actions.isClosing || actions.hasUnsavedChanges
                    ? null
                    : context
                          .read<StorageOfficeEditorActionsCubit>()
                          .requestSave,
                child: Text(context.l10n.retry),
              ),
            _StorageOfficeEditorActionButton(
              tooltip: context.l10n.storageOfficeSaveCopyAction,
              icon: AppIcons.saveCopy,
              isLoading: actions.isSavingCopy,
              onPressed:
                  actions.isSavingCopy ||
                      actions.isPrinting ||
                      actions.isDownloading ||
                      actions.isClosing ||
                      !actions.isSessionReady
                  ? null
                  : () => context
                        .read<StorageOfficeEditorActionsCubit>()
                        .saveCopy(
                          sessionToken: _sessionToken(context),
                        ),
            ),
            _StorageOfficeEditorActionButton(
              tooltip: context.l10n.storageOfficePrintAction,
              icon: AppIcons.print,
              isLoading: actions.isPrinting,
              onPressed:
                  actions.isPrinting ||
                      actions.isSavingCopy ||
                      actions.isDownloading ||
                      actions.isClosing ||
                      !actions.isSessionReady
                  ? null
                  : () => context
                        .read<StorageOfficeEditorActionsCubit>()
                        .requestPrint(
                          sessionToken: _sessionToken(context),
                        ),
            ),
            _StorageOfficeEditorActionButton(
              tooltip: context.l10n.storageDownloadAction,
              icon: AppIcons.download,
              isLoading: actions.isDownloading,
              onPressed:
                  actions.isDownloading ||
                      actions.isSavingCopy ||
                      actions.isPrinting ||
                      actions.isClosing ||
                      !actions.isSessionReady
                  ? null
                  : () => context
                        .read<StorageOfficeEditorActionsCubit>()
                        .requestDownload(),
            ),
            const _StorageOfficeSessionMode(),
          ],
        ),
      );

  String? _sessionToken(BuildContext context) {
    final state = context.read<StorageOfficeCubit>().state;
    return state is StorageOfficeReady ? state.session.token : null;
  }
}

final class _StorageOfficeEditorTitle extends StatelessWidget {
  const _StorageOfficeEditorTitle({
    required this.fileName,
    required this.status,
  });

  final String fileName;
  final Widget status;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        AppIcons.documentText,
        size: 20,
        color: context.tasksTheme.selectionAccent,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          fileName,
          style: context.text.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: 12),
      status,
    ],
  );
}

final class _StorageOfficeEditorActionButton extends StatelessWidget {
  const _StorageOfficeEditorActionButton({
    required this.tooltip,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: isLoading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon),
  );
}

final class _StorageOfficeSessionMode extends StatelessWidget {
  const _StorageOfficeSessionMode();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageOfficeCubit, StorageOfficeState>(
        builder: (context, state) {
          if (state is! StorageOfficeReady) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: context.tasksTheme.cardSurface,
                border: Border.all(color: context.tasksTheme.cardBorder),
                borderRadius: BorderRadius.circular(
                  context.tasksTheme.controlRadius,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.session.canEdit ? AppIcons.code : AppIcons.lock,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    state.session.canEdit
                        ? context.l10n.storageOfficeEditMode
                        : context.l10n.storageOfficeViewMode,
                    style: context.tasksTheme.metaText,
                  ),
                ],
              ),
            ),
          );
        },
      );
}
