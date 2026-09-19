import 'package:devplanner/auth/domain/models/auth_models.dart';

abstract interface class AuthGateway {
  Future<AuthUser?> restoreSession();
  Future<AuthUser> signIn(LoginCredentials credentials);
  Future<void> signOut();
  Future<void> activate({required String token, required String password});
  Future<void> requestPasswordReset(String loginOrEmail);
  Future<void> resetPassword({required String token, required String password});
  Future<void> verifyMfa(String code);
}

/// Explicit boundary used until the backend 2/3 OpenAPI contracts exist.
/// It performs no HTTP calls and stores no credentials or tokens.
final class UnavailableAuthGateway implements AuthGateway {
  const UnavailableAuthGateway();

  AuthFailure get _unavailable => const AuthFailure(
    'Logowanie będzie dostępne po podłączeniu kontraktu auth DevPlanner.',
  );

  @override
  Future<AuthUser?> restoreSession() async => null;

  @override
  Future<AuthUser> signIn(LoginCredentials credentials) async =>
      throw _unavailable;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> activate({
    required String token,
    required String password,
  }) async => throw _unavailable;

  @override
  Future<void> requestPasswordReset(String loginOrEmail) async =>
      throw _unavailable;

  @override
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async => throw _unavailable;

  @override
  Future<void> verifyMfa(String code) async => throw _unavailable;
}
