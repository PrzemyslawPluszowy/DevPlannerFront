import 'package:bloc/bloc.dart';
import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/admin/domain/ports/admin_user_gateway.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_lifecycle_state.dart';

/// Właściciel pojedynczej akcji lifecycle konta.
final class AdminUserLifecycleCubit extends Cubit<AdminUserLifecycleState> {
  AdminUserLifecycleCubit({required AdminUsersComposition composition})
    : _gateway = composition.gateway,
      super(const AdminUserLifecycleIdle());

  final AdminUserGateway _gateway;

  Future<void> submit({
    required String userId,
    required AdminUserLifecycleAction action,
  }) async {
    emit(const AdminUserLifecycleSubmitting());
    final result = await _gateway.lifecycle(
      AdminUserLifecycleCommand(
        userId: userId,
        action: action,
      ),
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(AdminUserLifecycleFailure(message: error.message)),
      (user) => emit(AdminUserLifecycleSucceeded(user)),
    );
  }
}
