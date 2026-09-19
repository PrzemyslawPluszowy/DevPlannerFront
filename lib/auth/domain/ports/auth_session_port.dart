import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:flutter/foundation.dart';

abstract interface class AuthSessionPort extends Listenable {
  AuthSessionSnapshot get snapshot;
}

final class AuthSessionController extends ChangeNotifier
    implements AuthSessionPort {
  AuthSessionController({AuthSessionSnapshot? initial})
    : _snapshot = initial ?? const AuthSessionSnapshot.signedOut();

  AuthSessionSnapshot _snapshot;
  int _generation = 0;
  int get generation => _generation;

  @override
  AuthSessionSnapshot get snapshot => _snapshot;

  void setRestoring() => _set(const AuthSessionSnapshot.restoring());

  void setSignedOut({String? message}) {
    _generation++;
    _set(AuthSessionSnapshot.signedOut(message: message));
  }

  void setSignedIn(
    AuthUser user, {
    AuthClientKind clientKind = AuthClientKind.webBff,
  }) => _set(
    AuthSessionSnapshot(
      status: AuthSessionStatus.signedIn,
      user: user,
      clientKind: clientKind,
    ),
  );

  void setMfaRequired() => _set(
    const AuthSessionSnapshot(
      status: AuthSessionStatus.mfaRequired,
    ),
  );

  void _set(AuthSessionSnapshot next) {
    if (_snapshot == next) return;
    _snapshot = next;
    notifyListeners();
  }
}
