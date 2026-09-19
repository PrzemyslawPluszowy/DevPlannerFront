import 'package:equatable/equatable.dart';

enum AuthClientKind { webBff, desktopPkce }

enum AuthSessionStatus { restoring, signedOut, signedIn, mfaRequired }

final class AuthUser extends Equatable {
  const AuthUser({
    required this.userId,
    required this.login,
    required this.displayName,
    this.permissions = const <String>{},
  });

  final String userId;
  final String login;
  final String displayName;
  final Set<String> permissions;

  @override
  List<Object?> get props => [userId, login, displayName, permissions];
}

final class AuthSessionSnapshot extends Equatable {
  const AuthSessionSnapshot({
    required this.status,
    this.user,
    this.clientKind = AuthClientKind.webBff,
    this.message,
  });

  const AuthSessionSnapshot.restoring()
    : this(status: AuthSessionStatus.restoring);

  const AuthSessionSnapshot.signedOut({String? message})
    : this(status: AuthSessionStatus.signedOut, message: message);

  final AuthSessionStatus status;
  final AuthUser? user;
  final AuthClientKind clientKind;
  final String? message;

  bool get isAuthenticated => status == AuthSessionStatus.signedIn;

  @override
  List<Object?> get props => [status, user, clientKind, message];
}

final class LoginCredentials extends Equatable {
  const LoginCredentials({required this.login, required this.password});

  final String login;
  final String password;

  @override
  List<Object?> get props => [login, password];
}

final class AuthReturnTo {
  const AuthReturnTo._();

  static String? sanitize(String? raw) {
    final value = raw?.trim() ?? '';
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.hasScheme ||
        uri.hasAuthority ||
        !value.startsWith('/')) {
      return null;
    }
    if (uri.path == '/' || _allowedPrefixes.any(_matches(uri.path))) {
      return uri.toString();
    }
    return null;
  }

  static bool Function(String) _matches(String path) =>
      (prefix) => path == prefix || path.startsWith('$prefix/');

  static const _allowedPrefixes = <String>[
    '/workspaces',
    '/chat',
    '/notifications',
    '/storage',
    '/me',
    '/admin',
  ];
}

final class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.code = 'auth.unavailable'});

  final String message;
  final String code;

  @override
  String toString() => message;
}
