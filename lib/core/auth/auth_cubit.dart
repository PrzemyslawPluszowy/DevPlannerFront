import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_state.dart';

/// Cubit odpowiedzialny za cykl zycia sesji standalone.
class AuthCubit extends Cubit<AuthState> {
  /// Tworzy cubit sesji na bazie repozytorium autoryzacji.
  AuthCubit({
    required this.authRepository,
    this._beforeLogout,
  }) : super(const AuthLoading());

  final AuthRepository authRepository;
  final Future<void> Function()? _beforeLogout;

  /// Odtwarza sesje i emituje stan poczatkowy.
  Future<void> restoreSession() async {
    emit(const AuthLoading());
    await authRepository.restoreSession();

    if (authRepository.isAuthenticated) {
      emit(AuthAuthenticated(user: authRepository.currentUser));
      return;
    }

    emit(const AuthUnauthenticated());
  }

  /// Probuje zalogowac uzytkownika podanym loginem i haslem.
  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      await authRepository.login(username: username, password: password);
      emit(AuthAuthenticated(user: authRepository.currentUser));
    } on AuthLoginException catch (error) {
      emit(AuthUnauthenticated(message: error.message));
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[AUTH][LOGIN] Unexpected error '
          '${error.runtimeType}: $error',
        );
        final firstStackLine = stackTrace.toString().split('\n').firstOrNull;
        if (firstStackLine case final line?) {
          debugPrint('[AUTH][LOGIN][stack] $line');
        }
      }
      emit(
        const AuthUnauthenticated(
          message: 'Nie udalo sie zalogowac. Sprobuj ponownie.',
        ),
      );
    }
  }

  /// Wylogowuje i wraca do stanu niezalogowanego.
  Future<void> logout() async {
    await _beforeLogout?.call();
    emit(const AuthLoading());
    await authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
