import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_gateway.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';

final class AuthUseCases {
  const AuthUseCases({
    required this.gateway,
    required this.session,
    this.clientKind = AuthClientKind.webBff,
  });

  final AuthGateway gateway;
  final AuthSessionController session;
  final AuthClientKind clientKind;

  Future<void> restoreSession() async {
    session.setRestoring();
    final user = await gateway.restoreSession();
    if (user == null) {
      session.setSignedOut();
    } else {
      session.setSignedIn(user, clientKind: clientKind);
    }
  }

  Future<void> signIn(LoginCredentials credentials) async {
    final user = await gateway.signIn(credentials);
    session.setSignedIn(user, clientKind: clientKind);
  }

  Future<void> signOut() async {
    await gateway.signOut();
    session.setSignedOut();
  }

  Future<void> activate({required String token, required String password}) =>
      gateway.activate(token: token, password: password);

  Future<void> requestPasswordReset(String loginOrEmail) =>
      gateway.requestPasswordReset(loginOrEmail);

  Future<void> resetPassword({
    required String token,
    required String password,
  }) => gateway.resetPassword(token: token, password: password);

  Future<void> verifyMfa(String code) => gateway.verifyMfa(code);
}
