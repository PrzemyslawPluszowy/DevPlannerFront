/// Zapytanie logowania do endpointu Veloryn Core `/auth/login`.
class LoginRequest {
  /// Tworzy payload logowania na podstawie loginu i hasla.
  const LoginRequest({required this.login, required this.password});

  final String login;
  final String password;

  /// Nazwa zgodna z poprzednim modelem klienta, używana wyłącznie przez testy.
  String get username => login;

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };
}

/// Para tokenow sesyjnych zwracana przez Veloryn Core.
class AuthTokenPair {
  /// Tworzy model odpowiedzi logowania.
  const AuthTokenPair({
    String? accessToken,
    String? token,
    required this.refreshToken,
    this.permissions = const <String>{},
    this.user,
  }) : accessToken = accessToken ?? token ?? '';

  factory AuthTokenPair.fromJson(Map<String, dynamic> json) {
    final accessToken = switch (json) {
      {'accessToken': final String token} when token.trim().isNotEmpty =>
        token.trim(),
      _ => '',
    };
    final refreshToken = switch (json) {
      {'refreshToken': final String t} when t.trim().isNotEmpty => t.trim(),
      {'refresh_token': final String t} when t.trim().isNotEmpty => t.trim(),
      _ => '',
    };

    final permissions = switch (json['permissions']) {
      final List<dynamic> values => Set<String>.unmodifiable(
        values
            .whereType<String>()
            .map((value) => value.trim())
            .where(
              (value) => value.isNotEmpty,
            ),
      ),
      _ => const <String>{},
    };

    final user = switch (json['user']) {
      final Map<String, dynamic> userMap => AuthUser.fromJson(
        userMap,
        permissions: permissions,
      ),
      final Map<dynamic, dynamic> userMap => AuthUser.fromJson(
        Map<String, dynamic>.from(userMap),
        permissions: permissions,
      ),
      _ => null,
    };

    return AuthTokenPair(
      accessToken: accessToken,
      refreshToken: refreshToken,
      permissions: permissions,
      user: user,
    );
  }

  final String accessToken;
  final String refreshToken;
  final Set<String> permissions;
  final AuthUser? user;
}

/// Podstawowe dane użytkownika i prawa modułowe aktualnej sesji Core.
class AuthUser {
  /// Tworzy model uzytkownika sesji.
  const AuthUser({
    required this.userId,
    String? login,
    String? username,
    required this.displayName,
    this.coreUserId,
    this.permissions = const <String>{},
    this.email = '',
    this.avatarUrl,
  }) : login = login ?? username ?? '';

  factory AuthUser.fromJson(
    Map<String, dynamic> json, {
    Set<String> permissions = const <String>{},
  }) {
    final persistedPermissions = switch (json['permissions']) {
      final List<dynamic> values => Set<String>.unmodifiable(
        values
            .whereType<String>()
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty),
      ),
      _ => const <String>{},
    };

    return AuthUser(
      userId: switch (json['readyUserId'] ?? json['usr_id']) {
        final int id => id,
        final String id => int.tryParse(id) ?? 0,
        _ => 0,
      },
      login: (json['login'] as String? ?? json['username'] as String? ?? '')
          .trim(),
      displayName:
          (json['displayName'] as String? ?? json['name'] as String? ?? '')
              .trim(),
      coreUserId: (json['id'] as String? ?? '').trim(),
      avatarUrl: (json['avatarUrl'] as String? ?? json['avatar_url'] as String?)
          ?.trim(),
      permissions: permissions.isEmpty ? persistedPermissions : permissions,
    );
  }

  final int userId;
  final String login;
  final String displayName;
  final String? coreUserId;
  final Set<String> permissions;
  final String email;
  final String? avatarUrl;

  /// Tymczasowa nazwa używana przez istniejące testy warstwy sesji.
  /// Produkcyjny kontrakt Core używa pola [login].
  String get username => login;

  Map<String, dynamic> toJson() => {
    'id': coreUserId,
    'readyUserId': userId,
    'login': login,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'permissions': permissions.toList(growable: false),
  };
}

/// Wylicza stabilny klucz użytkownika używany do danych lokalnych per osoba.
String resolveReadyUserId({
  required AuthUser? user,
  String? hostUserId,
}) {
  if (user case final authUser? when authUser.userId > 0) {
    return authUser.userId.toString();
  }

  final normalizedHostUserId = hostUserId?.trim() ?? '';
  if (normalizedHostUserId.isNotEmpty) {
    return normalizedHostUserId;
  }

  return 'anonymous';
}
