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
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_close_confirmation.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_status_label.dart';
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
  Widget build(BuildContext context) => MultiBlocListener(
    listeners: [
      BlocListener<
        StorageOfficeEditorActionsCubit,
        StorageOfficeEditorActionsState
      >(
        listenWhen: (previous, current) =>
            previous.noticeRevision != current.noticeRevision,
        listener: _showNotice,
      ),
      BlocListener<
        StorageOfficeEditorActionsCubit,
        StorageOfficeEditorActionsState
      >(
        listenWhen: (previous, current) =>
            previous.saveConfirmation != current.saveConfirmation &&
            (current.saveConfirmation ==
                    StorageOfficeSaveConfirmation.confirmed ||
                current.saveConfirmation ==
                    StorageOfficeSaveConfirmation.unconfirmed),
        listener: _showSaveConfirmationNotice,
      ),
    ],
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
            body: Column(
              children: [
                const _StorageOfficeOperationBanner(),
                const _StorageOfficeSaveBanner(),
                _StorageOfficePlainFormatBanner(file: file),
                Expanded(
                  child: _StorageOfficeEditorBody(
                    hostController: hostController,
                    onClose: () => unawaited(_close(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _close(BuildContext context) async {
    final actions = context.read<StorageOfficeEditorActionsCubit>();
    if (!actions.beginClosing()) return;
    final canClose = await confirmStorageOfficeClose(
      context,
      hasUnsavedChanges: actions.state.hasUnsavedChanges,
      isAwaitingSaveConfirmation: actions.isAwaitingSaveConfirmation,
      isSaveUnconfirmed:
          actions.state.saveConfirmation ==
          StorageOfficeSaveConfirmation.unconfirmed,
    );
    if (!context.mounted) return;
    if (!canClose) {
      actions.cancelClosing();
      return;
    }
    // Zamknięcie nie może wyprzedzić potwierdzenia zapisu: odświeżenie listy
    // wykonane przed callbackiem pokazałoby starą wersję pliku, zwłaszcza
    // w kompozycji bez kanału realtime. Czekanie jest ograniczone oknem kontroli,
    // a decyzja użytkownika o zamknięciu nadal obowiązuje.
    if (actions.isAwaitingSaveConfirmation) {
      await actions.waitForConfirmedSave();
      if (!context.mounted) return;
    }
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

  void _showSaveConfirmationNotice(
    BuildContext context,
    StorageOfficeEditorActionsState state,
  ) {
    final confirmed =
        state.saveConfirmation == StorageOfficeSaveConfirmation.confirmed;
    final message = confirmed
        ? context.l10n.storageOfficeSavedChanges
        : context.l10n.storageOfficeSaveUnconfirmed;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: confirmed ? 5 : 15),
      ),
    );
  }
}

/// TXT/CSV cannot carry comments back into the original file after export.
final class _StorageOfficePlainFormatBanner extends StatelessWidget {
  const _StorageOfficePlainFormatBanner({required this.file});

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
        color: context.colors.tertiary.withValues(alpha: 0.10),
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
      const SizedBox(width: 12),
      status,
    ],
  );
}

/// Stały komunikat o zmianach, których backend jeszcze nie potwierdził.
/// Snackbar znika zbyt szybko, by mógł chronić użytkownika przed utratą pracy.
final class _StorageOfficeSaveBanner extends StatelessWidget {
  const _StorageOfficeSaveBanner();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        StorageOfficeEditorActionsCubit,
        StorageOfficeEditorActionsState
      >(
        buildWhen: (previous, current) =>
            previous.hasUnsavedChanges != current.hasUnsavedChanges ||
            previous.saveConfirmation != current.saveConfirmation,
        builder: (context, actions) {
          if (!actions.hasUnsavedChanges &&
              actions.saveConfirmation !=
                  StorageOfficeSaveConfirmation.awaitingServer &&
              actions.saveConfirmation !=
                  StorageOfficeSaveConfirmation.unconfirmed &&
              actions.saveConfirmation !=
                  StorageOfficeSaveConfirmation.confirmed) {
            return const SizedBox.shrink();
          }
          final isUnconfirmed =
              actions.saveConfirmation ==
              StorageOfficeSaveConfirmation.unconfirmed;
          final color = isUnconfirmed
              ? context.colors.error
              : actions.saveConfirmation ==
                    StorageOfficeSaveConfirmation.confirmed
              ? context.colors.primary
              : context.colors.tertiary;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: color.withValues(alpha: 0.10),
            child: StorageOfficeStatusLabel(actions: actions),
          );
        },
      );
}

final class _StorageOfficeOperationBanner extends StatelessWidget {
  const _StorageOfficeOperationBanner();

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
            color: context.colors.primary.withValues(alpha: 0.10),
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
            // Dokument sam raportuje połączenie i stan zapisu; bez tego ekran
            // nie wie, czy użytkownik widzi zapisane zmiany.
            onDocumentReady: () =>
                context.read<StorageOfficeEditorActionsCubit>().sessionReady(),
            onDocumentStateChanged: (isModified) => context
                .read<StorageOfficeEditorActionsCubit>()
                .documentStateChanged(isModified: isModified),
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
              if (actions.state.isPrinting || actions.state.isSavingCopy) {
                return;
              }
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
