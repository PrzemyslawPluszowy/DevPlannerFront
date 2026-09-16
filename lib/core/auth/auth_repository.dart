import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ready_next/core/auth/auth_api.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_session_storage.dart';

/// Kontrakt repozytorium autoryzacji aplikacji standalone.
abstract class AuthRepository {
  /// Aktualny token dostepowy uzywany przez interceptor HTTP.
  String? get accessToken;

  /// Flaga informujaca, czy sesja jest aktywna.
  bool get isAuthenticated;

  /// Dane aktualnie zalogowanego uzytkownika.
  AuthUser? get currentUser;

  /// Generacja sesji — zmienia sie przy login/logout,
  /// NIE zmienia sie przy refresh tokena.
  ///
  /// Pozwala interceptorowi odroznic zmiane tokena przez refresh
  /// od zmiany tokena przez login/logout innego uzytkownika.
  int get sessionGeneration;

  /// Odtwarza sesje z pamieci lokalnej lub fallbacku startowego.
  Future<void> restoreSession();

  /// Probnie loguje uzytkownika i zapisuje nowa sesje.
  Future<void> login({required String username, required String password});

  /// Probnie odswieza token dostepowy uzywajac refresh tokena.
  Future<bool> tryRefreshSession();

  /// Czyści aktywna sesje i dane lokalne.
  Future<void> logout();
}

/// Wyjatek domenowy logowania z komunikatem prezentowanym w UI.
class AuthLoginException implements Exception {
  /// Tworzy wyjatek logowania.
  const AuthLoginException(this.message);

  final String message;
}

/// Implementacja repozytorium auth oparta o `AuthApi` i lokalny storage sesji.
class AuthRepositoryImpl implements AuthRepository {
  /// Tworzy repozytorium auth.
  AuthRepositoryImpl({
    required this.api,
    AuthSessionStorage? storage,
  }) : _storage = storage ?? HiveAuthSessionStorage();

  final AuthApi api;
  final AuthSessionStorage _storage;
  String? _accessToken;
  String? _refreshToken;
  AuthUser? _currentUser;
  Future<bool>? _refreshInFlight;
  int _sessionGeneration = 0;

  @override
  String? get accessToken => _accessToken;

  @override
  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;

  @override
  int get sessionGeneration => _sessionGeneration;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<void> restoreSession() async {
    _clearMemory();
    final storedSession = await _readStoredSession();
    if (storedSession == null) {
      return;
    }

    final storedToken = storedSession.accessToken.trim();
    final storedRefreshToken = storedSession.refreshToken.trim();

    if (storedToken.isEmpty || storedRefreshToken.isEmpty) {
      await _storage.clear();
      return;
    }

    _accessToken = storedToken;
    _refreshToken = storedRefreshToken;
    _currentUser = _parseStoredUser(storedSession.userJson);

    final refreshResult = await _tryRefreshWithRetry(
      refreshTokenOverride: storedRefreshToken,
    );
    if (refreshResult == _RefreshSessionResult.rejected) {
      await logout();
    }
  }

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await api.login(
        LoginRequest(login: username.trim(), password: password),
      );

      if (response.accessToken.isEmpty) {
        throw const AuthLoginException('Brak tokenu w odpowiedzi logowania.');
      }
      if (response.refreshToken.isEmpty) {
        throw const AuthLoginException(
          'Brak refresh tokenu w odpowiedzi logowania.',
        );
      }
      if ((response.user?.userId ?? 0) <= 0) {
        throw const AuthLoginException(
          'Brak identyfikatora uzytkownika w odpowiedzi logowania.',
        );
      }

      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;
      _currentUser = response.user;
      _sessionGeneration++;

      await _persistCurrentSession(ignoreFailure: true);
      await _persistRememberedUsername(username.trim());
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      final backendMessage = _extractBackendMessage(error.response?.data);

      if (status == 401 || status == 403) {
        throw AuthLoginException(
          backendMessage ?? 'Nieprawidlowy login lub haslo.',
        );
      }
      if (status == 422) {
        throw AuthLoginException(
          backendMessage ?? 'Dane logowania sa niepoprawne (422).',
        );
      }

      throw AuthLoginException(
        backendMessage ?? 'Nie udalo sie zalogowac. Sprobuj ponownie.',
      );
    }
  }

  @override
  Future<bool> tryRefreshSession() {
    if (_refreshInFlight case final current?) {
      return current;
    }

    final inFlight = _tryRefreshWithRetry().then(
      (result) => result == _RefreshSessionResult.success,
    );
    _refreshInFlight = inFlight;

    return inFlight.whenComplete(() {
      _refreshInFlight = null;
    });
  }

  /// Probuje odswiezyc sesje, a przy tymczasowej niedostepnosci backendu
  /// (timeout, 500, brak sieci) wykonuje jedna dodatkowa probe po krotkim
  /// opoznieniu zamiast natychmiastowego wylogowania.
  Future<_RefreshSessionResult> _tryRefreshWithRetry({
    String? refreshTokenOverride,
  }) async {
    final firstAttempt = await _refreshSessionInternal(
      refreshTokenOverride: refreshTokenOverride,
    );
    if (firstAttempt != _RefreshSessionResult.unavailable) {
      return firstAttempt;
    }

    await Future<void>.delayed(const Duration(seconds: 2));
    return _refreshSessionInternal(refreshTokenOverride: refreshTokenOverride);
  }

  Future<_RefreshSessionResult> _refreshSessionInternal({
    String? refreshTokenOverride,
  }) async {
    final token = refreshTokenOverride ?? _refreshToken;
    if (token == null || token.isEmpty) {
      return _RefreshSessionResult.rejected;
    }

    try {
      final response = await api.refreshToken(refreshToken: token);
      if (response.accessToken.isEmpty) {
        return _RefreshSessionResult.rejected;
      }

      final nextRefreshToken = response.refreshToken.isNotEmpty
          ? response.refreshToken
          : token;
      final nextUser = response.user ?? _currentUser;
      if ((nextUser?.userId ?? 0) <= 0) {
        return _RefreshSessionResult.rejected;
      }
      _accessToken = response.accessToken;
      _refreshToken = nextRefreshToken;
      _currentUser = nextUser;
      await _persistCurrentSession(ignoreFailure: true);
      return _RefreshSessionResult.success;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403 || status == 422) {
        return _RefreshSessionResult.rejected;
      }
      return _RefreshSessionResult.unavailable;
    }
  }

  @override
  Future<void> logout() async {
    _clearMemory();
    try {
      await _storage.clear();
    } catch (error, stackTrace) {
      _logStorageFailure(
        operation: 'clear',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _persistCurrentSession({
    required bool ignoreFailure,
  }) async {
    final accessToken = _accessToken?.trim() ?? '';
    final refreshToken = _refreshToken?.trim() ?? '';
    if (accessToken.isEmpty || refreshToken.isEmpty) {
      throw StateError('Nie mozna zapisac niepelnej sesji auth.');
    }

    try {
      await _storage.write(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userJson: switch (_currentUser) {
          final user? => jsonEncode(user.toJson()),
          null => null,
        },
      );
    } catch (error, stackTrace) {
      _logStorageFailure(
        operation: 'write',
        error: error,
        stackTrace: stackTrace,
      );
      if (!ignoreFailure) {
        rethrow;
      }
    }
  }

  void _clearMemory() {
    _accessToken = null;
    _refreshToken = null;
    _currentUser = null;
    _sessionGeneration++;
  }

  AuthUser? _parseStoredUser(String? storedUser) {
    if (storedUser == null || storedUser.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(storedUser);
      if (decoded is Map<String, dynamic>) {
        return AuthUser.fromJson(decoded);
      }
      if (decoded is Map) {
        return AuthUser.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Future<StoredAuthSession?> _readStoredSession() async {
    try {
      return await _storage.read();
    } catch (error, stackTrace) {
      _logStorageFailure(
        operation: 'read',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _persistRememberedUsername(String username) async {
    try {
      await _storage.writeRememberedUsername(username);
    } catch (error, stackTrace) {
      _logStorageFailure(
        operation: 'write_remembered_username',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _logStorageFailure({
    required String operation,
    required Object error,
    required StackTrace stackTrace,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '[AUTH][STORAGE] operation=$operation | '
      'type=${error.runtimeType} | error=$error',
    );
    final firstStackLine = stackTrace.toString().split('\n').firstOrNull;
    if (firstStackLine case final line?) {
      debugPrint('[AUTH][STORAGE][stack] $line');
    }
  }

  String? _extractBackendMessage(dynamic data) {
    if (data case {'error': {'message': final String message}}) {
      return message;
    }

    if (data case {'detail': final String detailMessage}) {
      return detailMessage;
    }

    if (data case {'detail': final List<Object?> details}) {
      for (final item in details) {
        if (item case {'msg': final String message}) {
          return message;
        }
      }
    }

    return null;
  }
}

enum _RefreshSessionResult {
  success,
  rejected,
  unavailable,
}
