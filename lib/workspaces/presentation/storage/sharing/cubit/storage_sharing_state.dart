import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:equatable/equatable.dart';

/// Stan zarządzania udostępnieniami pojedynczego pliku.
sealed class StorageSharingState extends Equatable {
  const StorageSharingState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed pierwszym odczytem grantów.
final class StorageSharingInitial extends StorageSharingState {
  const StorageSharingInitial();
}

/// Pierwszy odczyt grantów nie ma jeszcze danych do pokazania.
final class StorageSharingLoading extends StorageSharingState {
  const StorageSharingLoading();
}

/// Granty pozostają dostępne podczas odświeżania albo błędu mutacji.
final class StorageSharingReady extends StorageSharingState {
  StorageSharingReady({
    required List<StorageFileShareResponse> shares,
    this.isMutating = false,
    this.isRefreshing = false,
    this.retryEnabledRevision = 0,
    this.createdShareToken,
    this.mutationError,
    this.loadError,
  }) : shares = List.unmodifiable(shares);

  final List<StorageFileShareResponse> shares;
  final bool isMutating;
  final bool isRefreshing;
  final int retryEnabledRevision;
  final String? createdShareToken;
  final ApiError? mutationError;
  final ApiError? loadError;

  StorageSharingReady copyWith({
    List<StorageFileShareResponse>? shares,
    bool? isMutating,
    bool? isRefreshing,
    int? retryEnabledRevision,
    String? createdShareToken,
    ApiError? mutationError,
    ApiError? loadError,
    bool clearCreatedShareToken = false,
    bool clearMutationError = false,
    bool clearLoadError = false,
  }) => StorageSharingReady(
    shares: shares ?? this.shares,
    isMutating: isMutating ?? this.isMutating,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    retryEnabledRevision: retryEnabledRevision ?? this.retryEnabledRevision,
    createdShareToken: clearCreatedShareToken
        ? null
        : createdShareToken ?? this.createdShareToken,
    mutationError: clearMutationError
        ? null
        : mutationError ?? this.mutationError,
    loadError: clearLoadError ? null : loadError ?? this.loadError,
  );

  @override
  List<Object?> get props => [
    shares,
    isMutating,
    isRefreshing,
    retryEnabledRevision,
    createdShareToken,
    mutationError,
    loadError,
  ];
}

/// Błąd pierwszego odczytu; pełne dane API pozostają dostępne dla UI.
final class StorageSharingFailure extends StorageSharingState {
  const StorageSharingFailure(this.error);

  final ApiError error;
  String get message => error.message;
  String? get code => error.contractCode ?? error.apiCode;

  @override
  List<Object?> get props => [error];
}
