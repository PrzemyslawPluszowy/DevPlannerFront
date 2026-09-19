import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:equatable/equatable.dart';

sealed class AdminUsersState extends Equatable {
  const AdminUsersState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class AdminUsersInitial extends AdminUsersState {
  const AdminUsersInitial();
}

final class AdminUsersLoading extends AdminUsersState {
  const AdminUsersLoading({this.previousUsers = const <AdminUser>[]});

  final List<AdminUser> previousUsers;

  @override
  List<Object?> get props => [previousUsers];
}

final class AdminUsersReady extends AdminUsersState {
  const AdminUsersReady({
    required this.users,
    required this.query,
    this.nextCursor,
    this.isLoadingMore = false,
    this.error,
  });

  final List<AdminUser> users;
  final AdminUserQuery query;
  final String? nextCursor;
  final bool isLoadingMore;
  final String? error;

  AdminUsersReady copyWith({
    List<AdminUser>? users,
    AdminUserQuery? query,
    String? nextCursor,
    bool? isLoadingMore,
    String? error,
    bool clearNextCursor = false,
    bool clearError = false,
  }) => AdminUsersReady(
    users: users ?? this.users,
    query: query ?? this.query,
    nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: clearError ? null : error ?? this.error,
  );

  @override
  List<Object?> get props => [
    users,
    query,
    nextCursor,
    isLoadingMore,
    error,
  ];
}

final class AdminUsersFailure extends AdminUsersState {
  const AdminUsersFailure(
    this.message, {
    this.previousUsers = const <AdminUser>[],
  });

  final String message;
  final List<AdminUser> previousUsers;

  @override
  List<Object?> get props => [message, previousUsers];
}
