import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:equatable/equatable.dart';

/// Filtry listy kont administracyjnych.
final class AdminUserQuery extends Equatable {
  const AdminUserQuery({
    this.search,
    this.status,
    this.cursor,
    this.emailConfirmed,
    this.roleCode,
    this.limit = 50,
  });

  final String? search;
  final AdminUserStatus? status;
  final String? cursor;
  final bool? emailConfirmed;
  final String? roleCode;
  final int limit;

  AdminUserQuery copyWith({
    String? search,
    AdminUserStatus? status,
    String? cursor,
    bool? emailConfirmed,
    String? roleCode,
    int? limit,
    bool clearSearch = false,
    bool clearStatus = false,
    bool clearCursor = false,
    bool clearEmailConfirmed = false,
    bool clearRoleCode = false,
  }) => AdminUserQuery(
    search: clearSearch ? null : search ?? this.search,
    status: clearStatus ? null : status ?? this.status,
    cursor: clearCursor ? null : cursor ?? this.cursor,
    emailConfirmed: clearEmailConfirmed
        ? null
        : emailConfirmed ?? this.emailConfirmed,
    roleCode: clearRoleCode ? null : roleCode ?? this.roleCode,
    limit: limit ?? this.limit,
  );

  @override
  List<Object?> get props => [
    search,
    status,
    cursor,
    emailConfirmed,
    roleCode,
    limit,
  ];
}

final class AdminUserPage extends Equatable {
  const AdminUserPage({required this.users, this.nextCursor});

  final List<AdminUser> users;
  final String? nextCursor;

  @override
  List<Object?> get props => [users, nextCursor];
}

/// Dokładny wynik `PUT /roles`: backend zwraca tylko identyfikator i role.
final class AdminUserRolesResult extends Equatable {
  const AdminUserRolesResult({required this.userId, required this.roleCodes});

  final String userId;
  final Set<String> roleCodes;

  @override
  List<Object?> get props => [userId, roleCodes];
}

/// Dokładny wynik aktywacji/dezaktywacji, włącznie z flagą idempotencji.
final class AdminUserLifecycleResult extends Equatable {
  const AdminUserLifecycleResult({required this.user, required this.changed});

  final AdminUser user;
  final bool changed;

  @override
  List<Object?> get props => [user, changed];
}

final class AdminUserCreateCommand extends Equatable {
  const AdminUserCreateCommand({
    required this.login,
    required this.email,
    required this.displayName,
  });

  final String login;
  final String email;
  final String displayName;
  @override
  List<Object?> get props => [login, email, displayName];
}

final class AdminUserUpdateCommand extends Equatable {
  const AdminUserUpdateCommand({
    required this.userId,
    this.login,
    this.email,
    this.displayName,
    this.mustChangePassword,
  });

  final String userId;
  final String? login;
  final String? email;
  final String? displayName;
  final bool? mustChangePassword;

  @override
  List<Object?> get props => [
    userId,
    login,
    email,
    displayName,
    mustChangePassword,
  ];
}

final class AdminUserRoleCommand extends Equatable {
  const AdminUserRoleCommand({
    required this.userId,
    required this.roles,
  });

  final String userId;
  final Set<String> roles;
  @override
  List<Object?> get props => [userId, roles];
}

enum AdminUserLifecycleAction {
  deactivate,
  reactivate,
}

final class AdminUserLifecycleCommand extends Equatable {
  const AdminUserLifecycleCommand({
    required this.userId,
    required this.action,
  });

  final String userId;
  final AdminUserLifecycleAction action;
  @override
  List<Object?> get props => [userId, action];
}
