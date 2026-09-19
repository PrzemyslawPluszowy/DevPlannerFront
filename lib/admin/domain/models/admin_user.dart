import 'package:equatable/equatable.dart';

/// Lifecycle konta lokalnego DevPlanner.
///
/// Wartości są celowo domenowe; mapowanie transportowe należy do adaptera
/// dostarczonego po opublikowaniu kontraktu OpenAPI backendu.
enum AdminUserStatus {
  pendingActivation,
  active,
  deactivated,
  locked,
}

/// Użytkownik widoczny w administracji lokalnej tożsamości.
final class AdminUser extends Equatable {
  const AdminUser({
    required this.userId,
    required this.login,
    required this.email,
    required this.displayName,
    required this.status,
    this.roles = const <String>{},
    this.emailVerified = false,
    this.mustChangePassword = false,
    this.createdAtUtc,
    this.updatedAtUtc,
    this.deactivatedAtUtc,
  });

  /// Kanoniczny identyfikator lokalnego konta.
  final String userId;
  final String login;
  final String email;
  final String displayName;
  final AdminUserStatus status;
  final Set<String> roles;
  final bool emailVerified;
  final bool mustChangePassword;
  final DateTime? createdAtUtc;
  final DateTime? updatedAtUtc;
  final DateTime? deactivatedAtUtc;

  bool hasRole(String role) => roles.contains(role);

  @override
  List<Object?> get props => [
    userId,
    login,
    email,
    displayName,
    status,
    roles,
    emailVerified,
    mustChangePassword,
    createdAtUtc,
    updatedAtUtc,
    deactivatedAtUtc,
  ];
}

/// Stabilne kody ról znane UX. Backend nadal jest autorytetem dla przypisania.
abstract final class AdminRoleCodes {
  static const systemAdmin = 'SystemAdmin';
  static const user = 'User';
}
