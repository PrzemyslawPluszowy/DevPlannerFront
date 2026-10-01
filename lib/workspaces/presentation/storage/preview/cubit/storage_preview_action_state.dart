import 'package:devplanner/foundation/error/api_error.dart';
import 'package:equatable/equatable.dart';

sealed class StoragePreviewActionState extends Equatable {
  const StoragePreviewActionState();

  @override
  List<Object?> get props => [];
}

final class StoragePreviewActionReady extends StoragePreviewActionState {
  const StoragePreviewActionReady();
}

final class StoragePreviewActionDownloading extends StoragePreviewActionState {
  const StoragePreviewActionDownloading();
}

final class StoragePreviewActionFailed extends StoragePreviewActionState {
  const StoragePreviewActionFailed(this.error);

  final ApiError error;

  @override
  List<Object?> get props => [error];
}
