import 'package:bloc/bloc.dart';
import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/admin/domain/ports/admin_user_gateway.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_form_state.dart';

/// Mały, jednorazowy lifecycle formularza utworzenia/edycji konta.
final class AdminUserFormCubit extends Cubit<AdminUserFormState> {
  AdminUserFormCubit({required AdminUsersComposition composition})
    : _gateway = composition.gateway,
      super(const AdminUserFormIdle());

  final AdminUserGateway _gateway;

  Future<void> create({
    required String login,
    required String email,
    required String displayName,
  }) async {
    final normalized = _validate(
      login: login,
      email: email,
      displayName: displayName,
    );
    if (normalized == null) return;
    final normalizedLogin = normalized.login;
    if (normalizedLogin == null) return;
    emit(const AdminUserFormSubmitting());
    final result = await _gateway.create(
      AdminUserCreateCommand(
        login: normalizedLogin,
        email: normalized.email,
        displayName: normalized.displayName,
      ),
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(AdminUserFormFailure(message: error.message)),
      (user) => emit(AdminUserFormSucceeded(user)),
    );
  }

  Future<void> update({
    required String userId,
    String? login,
    required String email,
    required String displayName,
    bool? mustChangePassword,
  }) async {
    final normalized = _validate(
      email: email,
      displayName: displayName,
    );
    if (normalized == null) return;
    emit(const AdminUserFormSubmitting());
    final result = await _gateway.update(
      AdminUserUpdateCommand(
        userId: userId,
        login: login?.trim().isEmpty == true ? null : login?.trim(),
        email: normalized.email,
        displayName: normalized.displayName,
        mustChangePassword: mustChangePassword,
      ),
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(AdminUserFormFailure(message: error.message)),
      (user) => emit(AdminUserFormSucceeded(user)),
    );
  }

  _NormalizedAdminUser? _validate({
    String? login,
    required String email,
    required String displayName,
  }) {
    final normalizedEmail = email.trim();
    final normalizedDisplayName = displayName.trim();
    final normalizedLogin = login?.trim();
    if (normalizedEmail.isEmpty || normalizedDisplayName.isEmpty) {
      emit(const AdminUserFormFailure(isValidation: true));
      return null;
    }
    if (normalizedLogin != null && normalizedLogin.isEmpty) {
      emit(const AdminUserFormFailure(isValidation: true));
      return null;
    }
    return _NormalizedAdminUser(
      login: normalizedLogin,
      email: normalizedEmail,
      displayName: normalizedDisplayName,
    );
  }
}

final class _NormalizedAdminUser {
  const _NormalizedAdminUser({
    this.login,
    required this.email,
    required this.displayName,
  });

  final String? login;
  final String email;
  final String displayName;
}
