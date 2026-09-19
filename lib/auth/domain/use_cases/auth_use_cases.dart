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
    final generation = session.generation;
    session.setRestoring();
    final user = await gateway.restoreSession();
    if (generation != session.generation) return;
    if (user == null) {
      session.setSignedOut();
    } else {
      session.setSignedIn(user, clientKind: clientKind);
    }
  }

  Future<void> signIn(LoginCredentials credentials) async {
    final generation = session.generation;
    final user = await gateway.signIn(credentials);
    if (generation != session.generation) return;
    session.setSignedIn(user, clientKind: clientKind);
  }

  Future<void> signOut() async {
    if (clientKind == AuthClientKind.desktopPkce) {
      // Invalidate pending profile/login publications before any network I/O.
      session.setSignedOut();
      await gateway.signOut();
      return;
    }
    // A failed BFF logout has not necessarily removed the server cookie.
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
