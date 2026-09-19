import 'package:bloc/bloc.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';

typedef AuthAction = Future<void> Function();

sealed class AuthActionState {
  const AuthActionState();
}

final class AuthActionIdle extends AuthActionState {
  const AuthActionIdle();
}

final class AuthActionSubmitting extends AuthActionState {
  const AuthActionSubmitting();
}

final class AuthActionFailure extends AuthActionState {
  const AuthActionFailure(this.message);
  final String message;
}

final class AuthActionSucceeded extends AuthActionState {
  const AuthActionSucceeded();
}

final class AuthActionCubit extends Cubit<AuthActionState> {
  AuthActionCubit({required this._action}) : super(const AuthActionIdle());

  final AuthAction _action;

  Future<void> submit() async {
    emit(const AuthActionSubmitting());
    try {
      await _action();
      emit(const AuthActionSucceeded());
    } on AuthFailure catch (error) {
      emit(AuthActionFailure(error.message));
    } catch (_) {
      emit(const AuthActionFailure('Nie udało się wykonać operacji.'));
    }
  }
}
