import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';

sealed class StorageUserSearchState extends Equatable {
  const StorageUserSearchState();

  @override
  List<Object?> get props => [];
}

final class StorageUserSearchInitial extends StorageUserSearchState {
  const StorageUserSearchInitial();
}

final class StorageUserSearchUnavailable extends StorageUserSearchState {
  const StorageUserSearchUnavailable();
}

final class StorageUserSearchLoading extends StorageUserSearchState {
  const StorageUserSearchLoading(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class StorageUserSearchReady extends StorageUserSearchState {
  const StorageUserSearchReady({required this.query, required this.users});

  final String query;
  final List<ReadyDirectoryUserResponse> users;

  @override
  List<Object?> get props => [query, users];
}

final class StorageUserSearchFailure extends StorageUserSearchState {
  const StorageUserSearchFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
