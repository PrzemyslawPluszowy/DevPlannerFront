import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:equatable/equatable.dart';

/// Baza stanów sesji edytora OnlyOffice.
sealed class StorageOfficeState extends Equatable {
  const StorageOfficeState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed pobraniem tokenu sesji.
final class StorageOfficeInitial extends StorageOfficeState {
  const StorageOfficeInitial();
}

/// Trwa inicjalizacja sesji OnlyOffice przez API.
final class StorageOfficeLoading extends StorageOfficeState {
  const StorageOfficeLoading();
}

/// Sesja została pomyślnie utworzona i jest gotowa do osadzenia lub otwarcia.
final class StorageOfficeReady extends StorageOfficeState {
  const StorageOfficeReady({
    required this.session,
    this.isClosing = false,
  });

  /// Dane sesji OnlyOffice z tokenem i URL serwera.
  final OnlyOfficeSessionResponse session;

  /// Czy trwa zamykanie lub odświeżanie sesji.
  final bool isClosing;

  @override
  List<Object?> get props => [session, isClosing];
}

/// Błąd inicjalizacji sesji dokumentu.
final class StorageOfficeFailure extends StorageOfficeState {
  const StorageOfficeFailure({
    required this.message,
    this.code,
    this.error,
  });

  final String message;
  final String? code;
  final ApiError? error;

  @override
  List<Object?> get props => [message, code, error];
}
