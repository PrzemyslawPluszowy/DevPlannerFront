import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:equatable/equatable.dart';

/// Typ wykonanej mutacji na folderze.
enum StorageFolderMutationType { created, updated, moved, deleted, restored }

/// Bazowy stan mutacji folderów.
sealed class StorageFolderMutationState extends Equatable {
  const StorageFolderMutationState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy.
final class StorageFolderMutationInitial extends StorageFolderMutationState {
  const StorageFolderMutationInitial();
}

/// Stan trwającej operacji sieciowej.
final class StorageFolderMutationLoading extends StorageFolderMutationState {
  const StorageFolderMutationLoading();
}

/// Stan powodzenia mutacji folderu.
final class StorageFolderMutationSuccess extends StorageFolderMutationState {
  const StorageFolderMutationSuccess({
    required this.type,
    this.folder,
    this.folderId,
  });

  final StorageFolderMutationType type;
  final StorageFolderResponse? folder;
  final String? folderId;

  @override
  List<Object?> get props => [type, folder, folderId];
}

/// Stan błędu operacji na folderze z kompletnymi danymi API.
final class StorageFolderMutationFailure extends StorageFolderMutationState {
  const StorageFolderMutationFailure({
    required this.error,
    this.retryEnabledRevision = 0,
  });

  final ApiError error;
  final int retryEnabledRevision;

  /// Pola zachowane dla dotychczasowych listenerów powłoki.
  String get message => error.message;
  int? get statusCode => error.statusCode;
  String? get apiCode => error.contractCode ?? error.apiCode;
  String? get traceId => error.traceId;
  int? get backendCode => error.backendCode;

  StorageFolderMutationFailure copyWith({int? retryEnabledRevision}) =>
      StorageFolderMutationFailure(
        error: error,
        retryEnabledRevision: retryEnabledRevision ?? this.retryEnabledRevision,
      );

  @override
  List<Object?> get props => [error, retryEnabledRevision];
}
