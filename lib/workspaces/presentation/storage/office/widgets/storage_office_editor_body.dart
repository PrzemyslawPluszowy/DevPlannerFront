import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_failure_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class StorageOfficeEditorBody extends StatelessWidget {
  const StorageOfficeEditorBody({
    required this.hostController,
    required this.onClose,
    super.key,
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
          StorageOfficeFailure(:final message, :final error) =>
            StoragePreviewFailureView(
              title: context.l10n.storageOfficeSessionFailure,
              message: message,
              error: error,
              onRetry: context.read<StorageOfficeCubit>().initSession,
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
