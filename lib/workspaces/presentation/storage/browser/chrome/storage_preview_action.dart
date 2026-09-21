import 'dart:async';

import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Otwiera podgląd pliku na rootowym hoście i odświeża listę po sesji edytora.
///
/// Jedno wejście dla listy, siatki, menu kontekstowego i skrótów: dzięki temu
/// modal zawsze trafia na ten sam host, a porty i odświeżenie nie zależą od
/// miejsca kliknięcia. Edytor biurowy zapisuje nową wersję po swoim callbacku,
/// więc powrót do listy musi pokazać dane z serwera.
Future<void> showStoragePreview(
  BuildContext context, {
  required StorageFileResponse file,
}) async {
  final previewCubit = context.read<StoragePreviewCubit>();
  final repository = context.read<StorageRepository>();
  final browser = context.read<StorageBrowserCubit>();
  unawaited(previewCubit.preparePreview(file));
  await DevPlannerModalHost.showDialog<void>(
    context,
    builder: (_) => BlocProvider.value(
      value: previewCubit,
      child: StoragePreviewDialog(
        file: file,
        repository: repository,
        onEditorClosed: () => unawaited(browser.load(showLoading: false)),
      ),
    ),
  );
}
