import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:equatable/equatable.dart';

/// Kryteria sortowania listy plików w eksploratorze.
enum StorageSortField {
  /// Sortowanie po nazwie pliku.
  name,

  /// Sortowanie po dacie utworzenia/modyfikacji.
  updatedAt,

  /// Sortowanie po rozmiarze w bajtach.
  size,
}

/// Kierunek sortowania.
enum StorageSortDirection {
  /// Rosnąco (A-Z, od najmniejszego, od najstarszego).
  ascending,

  /// Malejąco (Z-A, od największego, od najnowszego).
  descending,
}

/// Zestaw parametrów sortowania w eksploratorze plików.
class StorageSortCriteria extends Equatable {
  /// Tworzy kryteria sortowania.
  const StorageSortCriteria({
    this.field = StorageSortField.updatedAt,
    this.direction = StorageSortDirection.descending,
  });

  /// Pole, po którym sortujemy.
  final StorageSortField field;

  /// Kierunek sortowania.
  final StorageSortDirection direction;

  /// Czy sortowanie jest rosnące.
  bool get isAscending => direction == .ascending;

  /// Tworzy kopię z nowymi parametrami.
  StorageSortCriteria copyWith({
    StorageSortField? field,
    StorageSortDirection? direction,
  }) => StorageSortCriteria(
    field: field ?? this.field,
    direction: direction ?? this.direction,
  );

  @override
  List<Object?> get props => [field, direction];
}

/// Zestaw filtrów eksploratora plików.
class StorageBrowserFilter extends Equatable {
  /// Tworzy zestaw filtrów.
  const StorageBrowserFilter({
    this.mimeType,
    this.extension,
    this.aiTag,
    this.aiStatus,
    this.minSizeBytes,
    this.maxSizeBytes,
    this.createdFromUtc,
    this.createdToUtc,
    this.ownerUserId,
  });

  /// Opcjonalny filtr po MIME type (np. 'image/png').
  final String? mimeType;

  /// Opcjonalne rozszerzenie (np. 'pdf').
  final String? extension;

  /// Opcjonalny tag nadany przez AI.
  final String? aiTag;

  /// Opcjonalny status analizy AI.
  final StorageAiStatus? aiStatus;

  /// Minimalny rozmiar pliku w bajtach.
  final int? minSizeBytes;

  /// Maksymalny rozmiar pliku w bajtach.
  final int? maxSizeBytes;

  /// Dolna granica daty utworzenia (UTC).
  final DateTime? createdFromUtc;

  /// Górna granica daty utworzenia (UTC).
  final DateTime? createdToUtc;

  /// Identyfikator właściciela pliku.
  final String? ownerUserId;

  /// Czy jakikolwiek filtr jest aktywny.
  bool get hasActiveFilters =>
      mimeType != null ||
      extension != null ||
      aiTag != null ||
      aiStatus != null ||
      minSizeBytes != null ||
      maxSizeBytes != null ||
      createdFromUtc != null ||
      createdToUtc != null ||
      ownerUserId != null;

  /// Tworzy kopię z zaktualizowanymi polami.
  StorageBrowserFilter copyWith({
    String? mimeType,
    String? extension,
    String? aiTag,
    StorageAiStatus? aiStatus,
    int? minSizeBytes,
    int? maxSizeBytes,
    DateTime? createdFromUtc,
    DateTime? createdToUtc,
    String? ownerUserId,
  }) => StorageBrowserFilter(
    mimeType: mimeType ?? this.mimeType,
    extension: extension ?? this.extension,
    aiTag: aiTag ?? this.aiTag,
    aiStatus: aiStatus ?? this.aiStatus,
    minSizeBytes: minSizeBytes ?? this.minSizeBytes,
    maxSizeBytes: maxSizeBytes ?? this.maxSizeBytes,
    createdFromUtc: createdFromUtc ?? this.createdFromUtc,
    createdToUtc: createdToUtc ?? this.createdToUtc,
    ownerUserId: ownerUserId ?? this.ownerUserId,
  );

  @override
  List<Object?> get props => [
    mimeType,
    extension,
    aiTag,
    aiStatus,
    minSizeBytes,
    maxSizeBytes,
    createdFromUtc,
    createdToUtc,
    ownerUserId,
  ];
}
