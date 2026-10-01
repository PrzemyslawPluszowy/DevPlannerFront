import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:equatable/equatable.dart';

/// Stan ostatniej operacji tworzenia dokumentu.
sealed class StorageDocumentMutationState extends Equatable {
  /// Tworzy stan operacji.
  const StorageDocumentMutationState();

  /// Zakres, dla którego rozpoczęto operację.
  StorageScope? get scope;

  /// Identyfikator pojedynczej intencji i jej idempotentnych ponowień.
  int? get operationId;

  @override
  List<Object?> get props => [scope, operationId];
}

/// Brak aktywnej lub zakończonej operacji.
final class StorageDocumentMutationInitial
    extends StorageDocumentMutationState {
  /// Tworzy stan początkowy.
  const StorageDocumentMutationInitial();

  @override
  StorageScope? get scope => null;

  @override
  int? get operationId => null;
}

/// Trwa tworzenie dokumentu.
final class StorageDocumentMutationLoading
    extends StorageDocumentMutationState {
  /// Tworzy stan ładowania dla jednej operacji.
  const StorageDocumentMutationLoading({
    required this.scope,
    required this.operationId,
  });

  @override
  final StorageScope scope;

  @override
  final int operationId;
}

/// Dokument został utworzony.
final class StorageDocumentMutationSuccess
    extends StorageDocumentMutationState {
  /// Zwraca utworzony plik i jego zakres operacji.
  const StorageDocumentMutationSuccess({
    required this.file,
    required this.scope,
    required this.operationId,
  });

  /// Utworzony dokument.
  final StorageFileResponse file;

  @override
  final StorageScope scope;

  @override
  final int operationId;

  @override
  List<Object?> get props => [...super.props, file];
}

/// Tworzenie dokumentu zakończyło się błędem.
final class StorageDocumentMutationFailure
    extends StorageDocumentMutationState {
  /// Tworzy błąd dla zachowanej operacji, którą można jawnie ponowić.
  const StorageDocumentMutationFailure({
    required this.error,
    required this.scope,
    required this.operationId,
  });

  /// Pełna odpowiedź API, w tym walidacja i termin `Retry-After`.
  final ApiError error;

  String get message => error.message;
  String? get apiCode => error.apiCode;
  String? get traceId => error.traceId;

  @override
  final StorageScope scope;

  @override
  final int operationId;

  @override
  List<Object?> get props => [...super.props, error];
}
