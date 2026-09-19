import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:equatable/equatable.dart';

sealed class AdminUserLifecycleState extends Equatable {
  const AdminUserLifecycleState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class AdminUserLifecycleIdle extends AdminUserLifecycleState {
  const AdminUserLifecycleIdle();
}

final class AdminUserLifecycleSubmitting extends AdminUserLifecycleState {
  const AdminUserLifecycleSubmitting();
}

final class AdminUserLifecycleSucceeded extends AdminUserLifecycleState {
  const AdminUserLifecycleSucceeded(this.result);

  final AdminUserLifecycleResult result;

  @override
  List<Object?> get props => [result];
}

final class AdminUserLifecycleFailure extends AdminUserLifecycleState {
  const AdminUserLifecycleFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
