import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit zarządzający zaznaczeniem plików i folderów oraz wyliczaniem dostępnych akcji.
final class StorageSelectionCubit extends Cubit<StorageSelectionState> {
  /// Tworzy cubit z pustym zaznaczeniem.
  StorageSelectionCubit() : super(const StorageSelectionState());

  final Map<String, StorageFileResponse> _selectedFiles = {};
  final Map<String, StorageFolderResponse> _selectedFolders = {};

  /// Jedyny zaznaczony plik albo `null`, gdy wybór nie jest jednoznaczny.
  StorageFileResponse? get singleSelectedFile =>
      _selectedFiles.length == 1 && _selectedFolders.isEmpty
      ? _selectedFiles.values.single
      : null;

  /// Jedyny zaznaczony folder albo `null`, gdy wybór nie jest jednoznaczny.
  StorageFolderResponse? get singleSelectedFolder =>
      _selectedFolders.length == 1 && _selectedFiles.isEmpty
      ? _selectedFolders.values.single
      : null;

  /// Przełącza zaznaczenie pojedynczego pliku z opcjonalną obsługą zaznaczenia zakresu z Shift.
  void toggleFile(
    StorageFileResponse file, {
    bool isShiftPressed = false,
    List<StorageFileResponse> allFiles = const [],
  }) {
    final currentFiles = Set<String>.from(state.selectedFileIds);

    if (isShiftPressed && state.anchorId != null && allFiles.isNotEmpty) {
      final anchorIndex = allFiles.indexWhere((f) => f.id == state.anchorId);
      final targetIndex = allFiles.indexWhere((f) => f.id == file.id);

      if (anchorIndex != -1 && targetIndex != -1) {
        final start = anchorIndex < targetIndex ? anchorIndex : targetIndex;
        final end = anchorIndex < targetIndex ? targetIndex : anchorIndex;
        for (var i = start; i <= end; i++) {
          currentFiles.add(allFiles[i].id);
        }
        _emitWithPermissions(
          selectedFiles: currentFiles,
          selectedFolders: state.selectedFolderIds,
          anchorId: file.id,
          allFiles: allFiles,
        );
        return;
      }
    }

    if (currentFiles.contains(file.id)) {
      currentFiles.remove(file.id);
      _selectedFiles.remove(file.id);
    } else {
      currentFiles.add(file.id);
      _selectedFiles[file.id] = file;
    }

    _emitWithPermissions(
      selectedFiles: currentFiles,
      selectedFolders: state.selectedFolderIds,
      anchorId: file.id,
      allFiles: allFiles,
    );
  }

  /// Przełącza zaznaczenie folderu.
  void toggleFolder(
    StorageFolderResponse folder, {
    List<StorageFileResponse> allFiles = const [],
    List<StorageFolderResponse> allFolders = const [],
  }) {
    final currentFolders = Set<String>.from(state.selectedFolderIds);
    if (currentFolders.contains(folder.id)) {
      currentFolders.remove(folder.id);
      _selectedFolders.remove(folder.id);
    } else {
      currentFolders.add(folder.id);
      _selectedFolders[folder.id] = folder;
    }

    _emitWithPermissions(
      selectedFiles: state.selectedFileIds,
      selectedFolders: currentFolders,
      anchorId: folder.id,
      allFiles: allFiles,
      allFolders: allFolders,
    );
  }

  /// Zaznacza wszystkie widoczne elementy na stronie.
  void selectAll({
    required List<StorageFileResponse> files,
    required List<StorageFolderResponse> folders,
  }) {
    _selectedFiles
      ..clear()
      ..addEntries(files.map((file) => MapEntry(file.id, file)));
    _selectedFolders
      ..clear()
      ..addEntries(folders.map((folder) => MapEntry(folder.id, folder)));
    final fileIds = files.map((f) => f.id).toSet();
    final folderIds = folders.map((f) => f.id).toSet();

    _emitWithPermissions(
      selectedFiles: fileIds,
      selectedFolders: folderIds,
      anchorId: null,
      allFiles: files,
      allFolders: folders,
    );
  }

  /// Czyści całe zaznaczenie.
  void clearSelection() {
    _selectedFiles.clear();
    _selectedFolders.clear();
    emit(const StorageSelectionState());
  }

  /// Zawęża zaznaczenie do elementów, które nadal są na liście.
  ///
  /// Odświeżenie po zdarzeniu realtime zmienia zawartość folderu, więc element
  /// usunięty przez inną osobę nie może zostać zaznaczony: akcje zbiorcze
  /// pokazywałyby wtedy uprawnienia do plików, których już nie ma. Świeże
  /// odpowiedzi podmieniają też uprawnienia elementów, które zostały — plik
  /// udostępniony w międzyczasie ma inne `canDelete` niż przed chwilą.
  void retain({
    required List<StorageFileResponse> allFiles,
    required List<StorageFolderResponse> allFolders,
  }) {
    final fileIds = allFiles.map((file) => file.id).toSet();
    final folderIds = allFolders.map((folder) => folder.id).toSet();
    final anchorId = state.anchorId;
    _emitWithPermissions(
      selectedFiles: Set<String>.from(state.selectedFileIds)
        ..removeWhere((id) => !fileIds.contains(id)),
      selectedFolders: Set<String>.from(state.selectedFolderIds)
        ..removeWhere((id) => !folderIds.contains(id)),
      anchorId:
          anchorId != null &&
              (fileIds.contains(anchorId) || folderIds.contains(anchorId))
          ? anchorId
          : null,
      allFiles: allFiles,
      allFolders: allFolders,
    );
  }

  void _emitWithPermissions({
    required Set<String> selectedFiles,
    required Set<String> selectedFolders,
    required String? anchorId,
    List<StorageFileResponse> allFiles = const [],
    List<StorageFolderResponse> allFolders = const [],
  }) {
    if (selectedFiles.isEmpty && selectedFolders.isEmpty) {
      emit(const StorageSelectionState());
      return;
    }

    for (final file in allFiles.where(
      (file) => selectedFiles.contains(file.id),
    )) {
      _selectedFiles[file.id] = file;
    }
    for (final folder in allFolders.where(
      (folder) => selectedFolders.contains(folder.id),
    )) {
      _selectedFolders[folder.id] = folder;
    }
    _selectedFiles.removeWhere((id, _) => !selectedFiles.contains(id));
    _selectedFolders.removeWhere((id, _) => !selectedFolders.contains(id));

    final selectedFileList = selectedFiles
        .map((id) => _selectedFiles[id])
        .whereType<StorageFileResponse>()
        .toList();
    final selectedFolderList = selectedFolders
        .map((id) => _selectedFolders[id])
        .whereType<StorageFolderResponse>()
        .toList();

    final hasCompleteCapabilityData =
        selectedFileList.length == selectedFiles.length &&
        selectedFolderList.length == selectedFolders.length;

    final canDelete =
        hasCompleteCapabilityData &&
        selectedFileList.every((f) => f.canDelete) &&
        selectedFolderList.every((f) => f.canDelete);

    final canDownloadZip =
        hasCompleteCapabilityData &&
        selectedFileList.isNotEmpty &&
        selectedFolderList.isEmpty &&
        selectedFileList.every((file) => file.canRead);

    final canShare =
        hasCompleteCapabilityData &&
        ((selectedFileList.length == 1 &&
                selectedFolderList.isEmpty &&
                selectedFileList.single.canShare) ||
            (selectedFolderList.length == 1 &&
                selectedFileList.isEmpty &&
                selectedFolderList.single.canShare));

    final canFavorite =
        hasCompleteCapabilityData &&
        selectedFileList.isNotEmpty &&
        selectedFolderList.isEmpty &&
        selectedFileList.every((file) => file.canRead);

    emit(
      StorageSelectionState(
        selectedFileIds: selectedFiles,
        selectedFolderIds: selectedFolders,
        anchorId: anchorId,
        canDelete: canDelete,
        canDownloadZip: canDownloadZip,
        canShare: canShare,
        canFavorite: canFavorite,
      ),
    );
  }
}
