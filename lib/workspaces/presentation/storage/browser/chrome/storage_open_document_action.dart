import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Otwiera dokument biurowy w edytorze OnlyOffice.
///
/// Po zamknięciu sesji lista jest wczytywana ponownie, bo OnlyOffice zapisuje
/// nową wersję po swoim callbacku: bez tego użytkownik widziałby nazwę i rozmiar
/// sprzed edycji. Odświeżenie nie zmienia folderu ani zaznaczenia, więc wraca do
/// tego samego miejsca, w którym przerwał pracę.
Future<void> runStorageOpenOfficeDocument(
  BuildContext context, {
  required StorageFileResponse file,
}) async {
  final repository = context.read<StorageRepository>();
  final browser = context.read<StorageBrowserCubit>();

  await StorageOfficeEditorDialog.show(
    context,
    file: file,
    repository: repository,
  );
  if (!context.mounted) return;
  await browser.load(showLoading: false);
}
