import 'package:bloc/bloc.dart';
import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/admin/domain/ports/admin_user_gateway.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_roles_state.dart';

/// Właściciel jednej wersjonowanej mutacji ról.
final class AdminUserRolesCubit extends Cubit<AdminUserRolesState> {
  AdminUserRolesCubit({required AdminUsersComposition composition})
    : _gateway = composition.gateway,
      _currentUserId = composition.currentUserId,
      super(const AdminUserRolesIdle());

  final AdminUserGateway _gateway;
  final String _currentUserId;

  Future<void> save({
    required String userId,
    required Set<String> roles,
    Set<String> existingRoles = const <String>{},
  }) async {
    final normalizedRoles = roles.toSet();
    if (userId == _currentUserId &&
        normalizedRoles.contains(AdminRoleCodes.systemAdmin) &&
        !existingRoles.contains(AdminRoleCodes.systemAdmin)) {
      emit(
        const AdminUserRolesFailure(isSelfEscalation: true),
      );
      return;
    }
    emit(const AdminUserRolesSubmitting());
    final result = await _gateway.setRoles(
      AdminUserRoleCommand(
        userId: userId,
        roles: normalizedRoles,
      ),
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(AdminUserRolesFailure(message: error.message)),
      (user) => emit(AdminUserRolesSucceeded(user)),
    );
  }
}
