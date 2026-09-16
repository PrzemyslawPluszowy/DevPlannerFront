import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';

/// Baza stanów dla zarządzania udostępnieniami pliku.
sealed class StorageSharingState extends Equatable {
  const StorageSharingState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy.
final class StorageSharingInitial extends StorageSharingState {
  const StorageSharingInitial();
}

/// Trwa ładowanie listy grantów udostępnienia.
final class StorageSharingLoading extends StorageSharingState {
  const StorageSharingLoading();
}

/// Lista udostępnień została załadowana.
final class StorageSharingReady extends StorageSharingState {
  const StorageSharingReady({
    required this.shares,
    this.isMutating = false,
    this.createdShareToken,
  });

  /// Lista aktywnych grantów.
  final List<StorageFileShareResponse> shares;

  /// Czy aktualnie trwa mutacja (dodawanie/usuwanie grantu).
  final bool isMutating;

  /// Ostatnio wygenerowany token publicznego linku.
  final String? createdShareToken;

  StorageSharingReady copyWith({
    List<StorageFileShareResponse>? shares,
    bool? isMutating,
    String? createdShareToken,
  }) {
    return StorageSharingReady(
      shares: shares ?? this.shares,
      isMutating: isMutating ?? this.isMutating,
      createdShareToken: createdShareToken ?? this.createdShareToken,
    );
  }

  @override
  List<Object?> get props => [shares, isMutating, createdShareToken];
}

/// Błąd pobierania lub modyfikacji udostępnień.
final class StorageSharingFailure extends StorageSharingState {
  const StorageSharingFailure({
    required this.message,
    this.code,
  });

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}
