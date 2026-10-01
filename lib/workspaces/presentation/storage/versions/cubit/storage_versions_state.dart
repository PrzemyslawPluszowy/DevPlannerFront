import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:equatable/equatable.dart';

enum StorageVersionsErrorOperation { load, download, restore, delete }

/// Stan historii wersji pojedynczego pliku.
sealed class StorageVersionsState extends Equatable {
  const StorageVersionsState();

  @override
  List<Object?> get props => [];
}

final class StorageVersionsInitial extends StorageVersionsState {
  const StorageVersionsInitial();
}

final class StorageVersionsLoading extends StorageVersionsState {
  const StorageVersionsLoading();
}

final class StorageVersionsReady extends StorageVersionsState {
  const StorageVersionsReady({
    required this.versions,
    this.busyVersion,
    this.isRefreshing = false,
    this.apiError,
    this.errorOperation,
  });

  final List<StorageFileVersionResponse> versions;
  final int? busyVersion;
  final bool isRefreshing;
  final ApiError? apiError;
  final StorageVersionsErrorOperation? errorOperation;

  StorageVersionsReady copyWith({
    int? busyVersion,
    bool clearBusy = false,
    bool? isRefreshing,
    ApiError? apiError,
    StorageVersionsErrorOperation? errorOperation,
    bool clearError = false,
  }) => StorageVersionsReady(
    versions: versions,
    busyVersion: clearBusy ? null : (busyVersion ?? this.busyVersion),
    isRefreshing: isRefreshing ?? this.isRefreshing,
    apiError: clearError ? null : (apiError ?? this.apiError),
    errorOperation: clearError ? null : (errorOperation ?? this.errorOperation),
  );

  @override
  List<Object?> get props => [
    versions,
    busyVersion,
    isRefreshing,
    apiError,
    errorOperation,
  ];
}

final class StorageVersionsFailure extends StorageVersionsState {
  const StorageVersionsFailure(this.message, {this.apiError});

  final String message;
  final ApiError? apiError;

  @override
  List<Object?> get props => [message, apiError];
}
