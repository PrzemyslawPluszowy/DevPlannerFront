import 'package:equatable/equatable.dart';

/// Stan zaznaczenia plików i folderów w eksploratorze Storage.
class StorageSelectionState extends Equatable {
  /// Tworzy stan zaznaczenia.
  const StorageSelectionState({
    this.selectedFileIds = const {},
    this.selectedFolderIds = const {},
    this.anchorId,
    this.canDelete = false,
    this.canDownloadZip = false,
    this.canShare = false,
    this.canFavorite = false,
  });

  /// Zbiór identyfikatorów zaznaczonych plików.
  final Set<String> selectedFileIds;

  /// Zbiór identyfikatorów zaznaczonych folderów.
  final Set<String> selectedFolderIds;

  /// Ostatnio kliknięty element jako punkt odniesienia dla zaznaczenia z klawiszem Shift.
  final String? anchorId;

  /// Czy użytkownik może usunąć zaznaczone elementy.
  final bool canDelete;

  /// Czy zaznaczone pliki można pobrać w archiwum ZIP.
  final bool canDownloadZip;

  /// Czy zaznaczone elementy można udostępnić.
  final bool canShare;

  /// Czy zaznaczone pliki można dodać do ulubionych.
  final bool canFavorite;

  /// Łączna liczba zaznaczonych elementów.
  int get count => selectedFileIds.length + selectedFolderIds.length;

  /// Czy cokolwiek jest zaznaczone.
  bool get hasSelection => count > 0;

  /// Czy wskazany plik jest zaznaczony.
  bool isFileSelected(String fileId) => selectedFileIds.contains(fileId);

  /// Czy wskazany folder jest zaznaczony.
  bool isFolderSelected(String folderId) =>
      selectedFolderIds.contains(folderId);

  /// Tworzy kopię stanu z możliwością aktualizacji pól.
  StorageSelectionState copyWith({
    Set<String>? selectedFileIds,
    Set<String>? selectedFolderIds,
    String? anchorId,
    bool clearAnchor = false,
    bool? canDelete,
    bool? canDownloadZip,
    bool? canShare,
    bool? canFavorite,
  }) => StorageSelectionState(
    selectedFileIds: selectedFileIds ?? this.selectedFileIds,
    selectedFolderIds: selectedFolderIds ?? this.selectedFolderIds,
    anchorId: clearAnchor ? null : (anchorId ?? this.anchorId),
    canDelete: canDelete ?? this.canDelete,
    canDownloadZip: canDownloadZip ?? this.canDownloadZip,
    canShare: canShare ?? this.canShare,
    canFavorite: canFavorite ?? this.canFavorite,
  );

  @override
  List<Object?> get props => [
    selectedFileIds,
    selectedFolderIds,
    anchorId,
    canDelete,
    canDownloadZip,
    canShare,
    canFavorite,
  ];
}
