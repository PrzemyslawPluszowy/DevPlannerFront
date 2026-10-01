import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_modal_accessibility_boundary.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_close_confirmation.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_banners.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_body.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_toolbar.dart';
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
          backgroundColor: context.tasksTheme.canvas,
          child: Scaffold(
            backgroundColor: context.tasksTheme.canvas,
            appBar: StorageOfficeEditorAppBar(
              file: file,
              onClose: () => unawaited(_close(context)),
            ),
            body: Column(
              children: [
                const StorageOfficeOperationBanner(),
                const StorageOfficeSaveBanner(),
                StorageOfficePlainFormatBanner(file: file),
                Expanded(
                  child: StorageOfficeEditorBody(
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
    final canClose = await StorageOfficeCloseConfirmation.confirm(
      context,
      hasUnsavedChanges: actions.state.hasUnsavedChanges,
      isAwaitingSaveConfirmation: actions.isAwaitingSaveConfirmation,
      isSaveUnconfirmed:
          actions.state.saveConfirmation ==
          StorageOfficeSaveConfirmation.unconfirmed,
    );
    if (!context.mounted || !_isCurrent(context, actions)) return;
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
      if (!context.mounted || !_isCurrent(context, actions)) return;
    }
    try {
      await hostController.closeEditor().timeout(const Duration(seconds: 30));
    } on Object {
      if (!context.mounted || !_isCurrent(context, actions)) return;
      final forceClose = await StorageOfficeCloseConfirmation.confirmForceClose(
        context,
      );
      if (!context.mounted || !_isCurrent(context, actions)) return;
      if (!forceClose) {
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
    if (context.mounted && _isCurrent(context, actions)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  bool _isCurrent(
    BuildContext context,
    StorageOfficeEditorActionsCubit actions,
  ) =>
      context.mounted &&
      !actions.isClosed &&
      identical(context.read<StorageOfficeEditorActionsCubit>(), actions);

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
