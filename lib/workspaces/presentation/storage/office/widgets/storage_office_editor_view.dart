import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_modal_accessibility_boundary.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Komponuje edytor OnlyOffice, lifecycle modalu i komunikaty operacji Cubitu.
final class StorageOfficeEditorView extends StatelessWidget {
  const StorageOfficeEditorView({
    required this.file,
    required this.hostController,
    super.key,
  });

  final StorageFileResponse file;
  final StorageOnlyOfficeHostController hostController;

  @override
  Widget build(BuildContext context) =>
      BlocListener<
        StorageOfficeEditorActionsCubit,
        StorageOfficeEditorActionsState
      >(
        listenWhen: (previous, current) =>
            previous.noticeRevision != current.noticeRevision,
        listener: _showNotice,
        child: AppModalAccessibilityBoundary(
          onDismiss: () => unawaited(_close(context)),
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) unawaited(_close(context));
            },
            child: Dialog.fullscreen(
              child: Scaffold(
                appBar: _StorageOfficeEditorAppBar(
                  file: file,
                  onClose: () => unawaited(_close(context)),
                ),
                body: _StorageOfficeEditorBody(
                  hostController: hostController,
                  onClose: () => unawaited(_close(context)),
                ),
                floatingActionButton:
                    BlocSelector<
                      StorageOfficeEditorActionsCubit,
                      StorageOfficeEditorActionsState,
                      bool
                    >(
                      selector: (state) => state.isClosing,
                      builder: (context, isClosing) =>
                          FloatingActionButton.small(
                            tooltip: context.l10n.close,
                            onPressed: isClosing
                                ? null
                                : () => unawaited(_close(context)),
                            child: const Icon(AppIcons.close),
                          ),
                    ),
              ),
            ),
          ),
        ),
      );

  Future<void> _close(BuildContext context) async {
    final actions = context.read<StorageOfficeEditorActionsCubit>();
    if (!actions.beginClosing()) return;
    try {
      await hostController.closeEditor().timeout(const Duration(seconds: 30));
    } on Object {
      if (!context.mounted) return;
      final forceClose = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.storageCloseOffice),
          content: Text(context.l10n.storageOfficeCloseUnconfirmed),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(context.l10n.close),
            ),
          ],
        ),
      );
      if (!context.mounted) return;
      if (forceClose != true) {
        actions.cancelClosing();
        return;
      }
      try {
        await hostController.destroyEditor().timeout(
          const Duration(seconds: 3),
        );
      } on Object {
        debugPrint(
          '[storage.onlyoffice] Wymuszone zamknięcie nieodpowiadającego edytora.',
        );
      }
    }
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  void _showNotice(
    BuildContext context,
    StorageOfficeEditorActionsState state,
  ) {
    final notice = state.notice;
    if (notice == null) return;
    final message = switch (notice) {
      StorageOfficeEditorActionSuccess(
        :final fileName,
        kind: StorageOfficeEditorActionSuccessKind.download,
      ) =>
        context.l10n.storageOfficeDownloadSuccess(fileName),
      StorageOfficeEditorActionSuccess(
        :final fileName,
        kind: StorageOfficeEditorActionSuccessKind.saveCopy,
      ) =>
        context.l10n.storageOfficeSaveCopySuccess(fileName),
      StorageOfficeEditorActionFailure(:final message) => message,
      StorageOfficeEditorActionLocalizedFailure(
        code: StorageOfficeEditorActionFailureCode.download,
      ) =>
        context.l10n.storageOfficeDownloadFailure,
      StorageOfficeEditorActionLocalizedFailure(
        code: StorageOfficeEditorActionFailureCode.print,
      ) =>
        context.l10n.storageOfficePrintFailure,
      StorageOfficeEditorActionLocalizedFailure(
        code: StorageOfficeEditorActionFailureCode.saveCopy,
      ) =>
        context.l10n.storageOfficeSaveCopyFailure,
    };
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

final class _StorageOfficeEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _StorageOfficeEditorAppBar({
    required this.file,
    required this.onClose,
  });

  final StorageFileResponse file;
  final VoidCallback onClose;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        StorageOfficeEditorActionsCubit,
        StorageOfficeEditorActionsState
      >(
        builder: (context, actions) => AppBar(
          title: _StorageOfficeEditorTitle(fileName: file.originalFileName),
          leading: IconButton(
            icon: const Icon(AppIcons.close),
            tooltip: context.l10n.close,
            onPressed: actions.isClosing ? null : onClose,
          ),
          actions: [
            _StorageOfficeEditorActionButton(
              tooltip: context.l10n.storageOfficeSaveCopyAction,
              icon: AppIcons.saveCopy,
              isLoading: actions.isSavingCopy,
              onPressed:
                  actions.isSavingCopy ||
                      actions.isPrinting ||
                      actions.isDownloading ||
                      actions.isClosing
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
              onPressed: actions.isPrinting || actions.isClosing
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
              onPressed: actions.isDownloading || actions.isClosing
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
  const _StorageOfficeEditorTitle({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(AppIcons.documentText, size: 20, color: context.colors.primary),
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
            child: Chip(
              label: Text(
                state.session.canEdit
                    ? context.l10n.storageOfficeEditMode
                    : context.l10n.storageOfficeViewMode,
                style: context.text.bodySmall?.copyWith(
                  color: state.session.canEdit
                      ? context.colors.primary
                      : context.colors.onSurfaceVariant,
                ),
              ),
              avatar: Icon(
                state.session.canEdit ? AppIcons.code : AppIcons.lock,
                size: 14,
              ),
            ),
          );
        },
      );
}

final class _StorageOfficeEditorBody extends StatelessWidget {
  const _StorageOfficeEditorBody({
    required this.hostController,
    required this.onClose,
  });

  final StorageOnlyOfficeHostController hostController;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageOfficeCubit, StorageOfficeState>(
        builder: (context, state) => switch (state) {
          StorageOfficeInitial() || StorageOfficeLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          StorageOfficeFailure(:final message) => _StorageOfficeSessionFailure(
            message: message,
          ),
          StorageOfficeReady(:final session) => StorageOnlyOfficeHost(
            session: session,
            hostController: hostController,
            onCloseRequested: onClose,
            onPrintRequested: () => context
                .read<StorageOfficeEditorActionsCubit>()
                .requestPrint(sessionToken: session.token),
            onSaveAsRequested: (saveAs) =>
                context.read<StorageOfficeEditorActionsCubit>().saveCopy(
                  sessionToken: session.token,
                  downloadUrl: saveAs.url,
                  format: saveAs.fileType,
                  suggestedTitle: saveAs.title,
                ),
        onDownloadRequested: (download) {
          final actions = context.read<StorageOfficeEditorActionsCubit>();
          if (actions.state.isPrinting) return;
          unawaited(
            actions.downloadGeneratedFile(
              download,
              sessionToken: session.token,
            ),
          );
        },
          ),
        },
      );
}

final class _StorageOfficeSessionFailure extends StatelessWidget {
  const _StorageOfficeSessionFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.alertCircle, size: 48, color: context.colors.error),
        const SizedBox(height: 16),
        Text(
          context.l10n.storageOfficeSessionFailure,
          style: context.text.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          icon: const Icon(AppIcons.refresh, size: 16),
          label: Text(context.l10n.retry),
          onPressed: () => context.read<StorageOfficeCubit>().initSession(),
        ),
      ],
    ),
  );
}
