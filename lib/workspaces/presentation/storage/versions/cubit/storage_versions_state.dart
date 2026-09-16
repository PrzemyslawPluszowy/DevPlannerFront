import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';

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
  const StorageVersionsReady({required this.versions, this.busyVersion});

  final List<StorageFileVersionResponse> versions;
  final int? busyVersion;

  StorageVersionsReady copyWith({int? busyVersion, bool clearBusy = false}) =>
      StorageVersionsReady(
        versions: versions,
        busyVersion: clearBusy ? null : (busyVersion ?? this.busyVersion),
      );

  @override
  List<Object?> get props => [versions, busyVersion];
}

final class StorageVersionsFailure extends StorageVersionsState {
  const StorageVersionsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
