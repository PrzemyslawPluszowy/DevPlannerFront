import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';

/// Typ wykonanej mutacji na plikach.
enum StorageFileMutationType {
  /// Zmiana stanu ulubionego.
  favoriteToggled,

  /// Zmiana opisu pliku.
  descriptionUpdated,

  /// Usunięcie pojedynczego pliku do kosza.
  deleted,

  /// Przywrócenie pliku z kosza.
  restored,

  /// Zbiorcze usunięcie elementów.
  bulkDeleted,

  /// Pobranie archiwum ZIP.
  zipDownloaded,

  /// Pobranie pojedynczego pliku.
  fileDownloaded,
}

enum StorageFileMutationMessage { partialDelete, deleteFailed }

/// Bazowy stan mutacji plików.
sealed class StorageFileMutationState extends Equatable {
  /// Tworzy bazowy stan mutacji plików.
  const StorageFileMutationState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy.
class StorageFileMutationInitial extends StorageFileMutationState {
  /// Tworzy stan początkowy.
  const StorageFileMutationInitial();
}

/// Stan trwającej operacji.
class StorageFileMutationLoading extends StorageFileMutationState {
  /// Tworzy stan ładowania.
  const StorageFileMutationLoading({this.message});

  /// Opcjonalny opis trwającej operacji (np. "Pobieranie ZIP...").
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Stan sukcesu mutacji pojedynczego lub wielu plików.
class StorageFileMutationSuccess extends StorageFileMutationState {
  /// Tworzy stan sukcesu.
  const StorageFileMutationSuccess({
    required this.type,
    this.file,
    this.fileId,
    this.affectedCount = 1,
  });

  /// Typ wykonanej operacji.
  final StorageFileMutationType type;

  /// Zwrócony lub zaktualizowany plik.
  final StorageFileResponse? file;

  /// Identyfikator zmienionego pliku.
  final String? fileId;

  /// Liczba zmodyfikowanych obiektów.
  final int affectedCount;

  @override
  List<Object?> get props => [type, file, fileId, affectedCount];
}

/// Stan częściowego sukcesu operacji masowych (np. usunięto 4 z 5 plików).
class StorageFileMutationPartialSuccess extends StorageFileMutationState {
  /// Tworzy stan częściowego sukcesu.
  const StorageFileMutationPartialSuccess({
    required this.succeededIds,
    required this.failedIds,
    required this.errorMessage,
    this.messageCode,
  });

  /// Identyfikatory elementów, dla których operacja się powiodła.
  final List<String> succeededIds;

  /// Identyfikatory elementów, dla których wystąpił błąd.
  final List<String> failedIds;

  /// Komunikat błędu dla nieudanych operacji.
  final String errorMessage;
  final StorageFileMutationMessage? messageCode;

  @override
  List<Object?> get props => [
    succeededIds,
    failedIds,
    errorMessage,
    messageCode,
  ];
}

/// Stan błędu operacji.
class StorageFileMutationFailure extends StorageFileMutationState {
  /// Tworzy stan błędu.
  const StorageFileMutationFailure({
    required this.message,
    this.statusCode,
    this.backendCode,
    this.messageCode,
  });

  /// Komunikat błędu.
  final String message;

  /// Opcjonalny kod HTTP.
  final int? statusCode;

  /// Opcjonalny kod błędu backendu.
  final int? backendCode;

  final StorageFileMutationMessage? messageCode;

  @override
  List<Object?> get props => [message, statusCode, backendCode, messageCode];
}
