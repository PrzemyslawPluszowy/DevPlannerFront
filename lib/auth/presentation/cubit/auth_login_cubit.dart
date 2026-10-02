import 'package:bloc/bloc.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/use_cases/auth_use_cases.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

sealed class AuthLoginState {
  const AuthLoginState();
}

final class AuthLoginIdle extends AuthLoginState {
  const AuthLoginIdle();
}

final class AuthLoginSubmitting extends AuthLoginState {
  const AuthLoginSubmitting();
}

final class AuthLoginRedirecting extends AuthLoginState {
  const AuthLoginRedirecting();
}

final class AuthLoginFailure extends AuthLoginState {
  const AuthLoginFailure(this.message);
  final String message;
}

final class AuthLoginSucceeded extends AuthLoginState {
  const AuthLoginSucceeded();
}

final class AuthLoginCubit extends Cubit<AuthLoginState> {
  AuthLoginCubit({required this._useCases}) : super(const AuthLoginIdle());

  final AuthUseCases _useCases;

  static const _redirectStartedCode = 'auth.bff.redirect_started';

  Future<void> submit({required String login, required String password}) async {
    if (login.trim().isEmpty || password.isEmpty) return;
    await _signIn(LoginCredentials(login: login.trim(), password: password));
  }

  /// Starts the interactive browser flow owned by the selected auth client.
  ///
  /// Web BFF intentionally does not accept credentials from Flutter. The
  /// browser performs the login at the backend and returns through its
  /// callback, so this path must not validate or persist form fields.
  Future<void> startInteractive({String? returnTo}) => _signIn(
    const LoginCredentials(login: '', password: ''),
    returnTo: returnTo,
  );

  Future<void> _signIn(
    LoginCredentials credentials, {
    String? returnTo,
  }) async {
    emit(const AuthLoginSubmitting());
    try {
      await _useCases.signIn(credentials, returnTo: returnTo);
      if (isClosed) return;
      emit(const AuthLoginSucceeded());
    } on AuthFailure catch (error) {
      if (isClosed) return;
      if (kDebugMode) {
        debugPrint('[auth] failure code=${error.code}: ${error.message}');
      }
      if (error.code == _redirectStartedCode) {
        emit(const AuthLoginRedirecting());
        return;
      }
      emit(AuthLoginFailure(error.message));
    } catch (error, stackTrace) {
      if (isClosed) return;
      if (kDebugMode) {
        debugPrint('[auth] unexpected failure: ${error.runtimeType}');
        if (error case final PlatformException platformError) {
          debugPrint(
            '[auth] platform failure code=${platformError.code} '
            'message=${platformError.message ?? '<none>'} '
            'detailsType=${platformError.details.runtimeType}',
          );
        }
        debugPrintStack(stackTrace: stackTrace, label: '[auth] stack');
      }
      emit(const AuthLoginFailure('Nie udało się wykonać logowania.'));
    }
  }
}
