import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';

/// Typ wykonanej mutacji na folderze.
enum StorageFolderMutationType {
  /// Utworzenie folderu.
  created,

  /// Zmiana nazwy/metadanych folderu.
  updated,

  /// Przeniesienie folderu do innego katalogu.
  moved,

  /// Usunięcie folderu.
  deleted,
}

/// Bazowy stan mutacji folderów.
sealed class StorageFolderMutationState extends Equatable {
  /// Tworzy stan mutacji.
  const StorageFolderMutationState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy.
class StorageFolderMutationInitial extends StorageFolderMutationState {
  /// Tworzy stan początkowy.
  const StorageFolderMutationInitial();
}

/// Stan trwającej operacji sieciowej.
class StorageFolderMutationLoading extends StorageFolderMutationState {
  /// Tworzy stan ładowania.
  const StorageFolderMutationLoading();
}

/// Stan powodzenia mutacji folderu.
class StorageFolderMutationSuccess extends StorageFolderMutationState {
  /// Tworzy stan sukcesu.
  const StorageFolderMutationSuccess({
    required this.type,
    this.folder,
    this.folderId,
  });

  /// Rodzaj zakończonej operacji.
  final StorageFolderMutationType type;

  /// Zwrócony folder (null przy usunięciu).
  final StorageFolderResponse? folder;

  /// Identyfikator usuniętego lub zmodyfikowanego folderu.
  final String? folderId;

  @override
  List<Object?> get props => [type, folder, folderId];
}

/// Stan błędu operacji na folderze.
class StorageFolderMutationFailure extends StorageFolderMutationState {
  /// Tworzy stan błędu.
  const StorageFolderMutationFailure({
    required this.message,
    this.statusCode,
    this.backendCode,
  });

  /// Komunikat błędu.
  final String message;

  /// Opcjonalny kod HTTP.
  final int? statusCode;

  /// Opcjonalny kod błędu backendu.
  final int? backendCode;

  @override
  List<Object?> get props => [message, statusCode, backendCode];
}
