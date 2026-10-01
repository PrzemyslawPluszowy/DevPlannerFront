import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:equatable/equatable.dart';

/// Typ wykonanej mutacji na plikach.
enum StorageFileMutationType {
  /// Zmiana stanu ulubionego.
  favoriteToggled,

  /// Ukrycie pliku na liście Udostępnione bieżącego użytkownika.
  sharedFileDismissed,

  /// Zmiana opisu pliku.
  descriptionUpdated,

  /// Zmiana nazwy pliku.
  renamed,

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

  /// Przeniesienie pliku do innego folderu.
  moved,

  /// Dodanie pliku do folderu jako nowy placement.
  placementCreated,
}

enum StorageFileMutationMessage {
  partialDelete,
  deleteFailed,

  /// Przeniesienie części elementów nie powiodło się.
  partialMove,

  /// Konflikt wersji placementu: stan na ekranie był nieaktualny.
  placementConflict,
}

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
    this.apiError,
    this.apiErrorsById = const {},
    this.notAttemptedIds = const [],
  });

  /// Identyfikatory elementów, dla których operacja się powiodła.
  final List<String> succeededIds;

  /// Identyfikatory elementów, dla których wystąpił błąd.
  final List<String> failedIds;

  /// Komunikat błędu dla nieudanych operacji.
  final String errorMessage;
  final StorageFileMutationMessage? messageCode;
  final ApiError? apiError;
  final Map<String, ApiError> apiErrorsById;

  /// Elementy pominięte po ograniczeniu żądań; nie są błędami wykonania.
  final List<String> notAttemptedIds;

  @override
  List<Object?> get props => [
    succeededIds,
    failedIds,
    errorMessage,
    messageCode,
    apiError,
    apiErrorsById,
    notAttemptedIds,
  ];
}

/// Stan błędu operacji.
class StorageFileMutationFailure extends StorageFileMutationState {
  /// Tworzy stan błędu.
  const StorageFileMutationFailure({
    required this.message,
    this.statusCode,
    this.backendCode,
    this.apiCode,
    this.traceId,
    this.messageCode,
    this.apiError,
    this.apiErrorsById = const {},
    this.notAttemptedIds = const [],
  });

  factory StorageFileMutationFailure.fromApiError(
    ApiError error, {
    StorageFileMutationMessage? messageCode,
  }) => StorageFileMutationFailure(
    message: error.message,
    statusCode: error.statusCode,
    backendCode: error.backendCode,
    apiCode: error.apiCode,
    traceId: error.traceId,
    messageCode: messageCode,
    apiError: error,
  );

  /// Komunikat błędu.
  final String message;

  /// Opcjonalny kod HTTP.
  final int? statusCode;

  /// Opcjonalny numeryczny kod błędu backendu.
  final int? backendCode;

  /// Opcjonalny stabilny kod kontraktu, np. `storage.placement_conflict`.
  final String? apiCode;

  /// Opcjonalny identyfikator śledzenia żądania.
  final String? traceId;

  /// Typ komunikatu, gdy backend nie podał własnej treści.
  final StorageFileMutationMessage? messageCode;

  /// Full API diagnostics retained for a foreground editor or preview.
  final ApiError? apiError;

  /// All per-item errors when a bulk action has more than one failure.
  final Map<String, ApiError> apiErrorsById;

  /// Elementy pominięte po ograniczeniu żądań; nie są błędami wykonania.
  final List<String> notAttemptedIds;

  @override
  List<Object?> get props => [
    message,
    statusCode,
    backendCode,
    apiCode,
    traceId,
    messageCode,
    apiError,
    apiErrorsById,
    notAttemptedIds,
  ];
}
