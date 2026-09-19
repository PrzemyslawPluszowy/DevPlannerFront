import 'package:devplanner/admin/domain/ports/admin_user_gateway.dart';

/// Jawny composition root administracji użytkownikami.
///
/// Permission flags służą wyłącznie do affordance UI. Backend ponownie ocenia
/// każdą operację i może odrzucić ją kodem 401/403/409.
final class AdminUsersComposition {
  const AdminUsersComposition({
    required this.gateway,
    required this.currentUserId,
    this.permissions = const <String>{},
  });

  final AdminUserGateway gateway;
  final String currentUserId;
  final Set<String> permissions;

  bool get canReadUsers => permissions.contains('users.read');
  bool get canManageUsers => permissions.contains('users.manage');
  bool get canReadAudit => permissions.contains('audit.read');
}
