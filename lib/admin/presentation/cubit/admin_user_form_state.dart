import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:equatable/equatable.dart';

sealed class AdminUserFormState extends Equatable {
  const AdminUserFormState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class AdminUserFormIdle extends AdminUserFormState {
  const AdminUserFormIdle();
}

final class AdminUserFormSubmitting extends AdminUserFormState {
  const AdminUserFormSubmitting();
}

final class AdminUserFormSucceeded extends AdminUserFormState {
  const AdminUserFormSucceeded(this.user);

  final AdminUser user;

  @override
  List<Object?> get props => [user];
}

final class AdminUserFormFailure extends AdminUserFormState {
  const AdminUserFormFailure({this.message, this.isValidation = false});

  final String? message;
  final bool isValidation;

  @override
  List<Object?> get props => [message, isValidation];
}
