import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:equatable/equatable.dart';

sealed class AdminUserRolesState extends Equatable {
  const AdminUserRolesState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class AdminUserRolesIdle extends AdminUserRolesState {
  const AdminUserRolesIdle();
}

final class AdminUserRolesSubmitting extends AdminUserRolesState {
  const AdminUserRolesSubmitting();
}

final class AdminUserRolesSucceeded extends AdminUserRolesState {
  const AdminUserRolesSucceeded(this.result);

  final AdminUserRolesResult result;

  @override
  List<Object?> get props => [result];
}

final class AdminUserRolesFailure extends AdminUserRolesState {
  const AdminUserRolesFailure({this.message, this.isSelfEscalation = false});

  final String? message;
  final bool isSelfEscalation;

  @override
  List<Object?> get props => [message, isSelfEscalation];
}
