import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:equatable/equatable.dart';

sealed class StorageShareDirectoryState extends Equatable {
  const StorageShareDirectoryState();

  @override
  List<Object?> get props => [];
}

final class StorageShareDirectoryIdle extends StorageShareDirectoryState {
  const StorageShareDirectoryIdle();
}

final class StorageShareDirectoryLoading extends StorageShareDirectoryState {
  const StorageShareDirectoryLoading(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class StorageShareDirectoryReady extends StorageShareDirectoryState {
  StorageShareDirectoryReady({
    required this.query,
    required List<LocalUserDirectoryResponse> users,
  }) : users = List.unmodifiable(users);

  final String query;
  final List<LocalUserDirectoryResponse> users;

  @override
  List<Object?> get props => [query, users];
}

final class StorageShareDirectoryFailure extends StorageShareDirectoryState {
  const StorageShareDirectoryFailure({
    required this.query,
    required this.error,
  });

  final String query;
  final ApiError error;

  @override
  List<Object?> get props => [query, error];
}
