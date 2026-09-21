import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:equatable/equatable.dart';

/// Stan operacji utworzenia dokumentu.
sealed class StorageDocumentMutationState extends Equatable {
  /// Tworzy stan operacji.
  const StorageDocumentMutationState();

  @override
  List<Object?> get props => [];
}

/// Brak aktywnej operacji.
final class StorageDocumentMutationInitial
    extends StorageDocumentMutationState {
  /// Tworzy stan początkowy.
  const StorageDocumentMutationInitial();
}

/// Trwa tworzenie dokumentu.
final class StorageDocumentMutationLoading
    extends StorageDocumentMutationState {
  /// Tworzy stan ładowania.
  const StorageDocumentMutationLoading();
}

/// Dokument został utworzony.
final class StorageDocumentMutationSuccess
    extends StorageDocumentMutationState {
  /// Zwraca utworzony plik.
  const StorageDocumentMutationSuccess(this.file);

  /// Utworzony dokument.
  final StorageFileResponse file;

  @override
  List<Object?> get props => [file];
}

/// Backend odrzucił tworzenie dokumentu.
final class StorageDocumentMutationFailure
    extends StorageDocumentMutationState {
  /// Tworzy stan błędu.
  const StorageDocumentMutationFailure(
    this.message, {
    this.apiCode,
    this.traceId,
  });

  /// Komunikat do pokazania użytkownikowi.
  final String message;

  /// Opcjonalny stabilny kod kontraktu.
  final String? apiCode;

  /// Opcjonalny identyfikator śledzenia żądania.
  final String? traceId;

  @override
  List<Object?> get props => [message];
}
