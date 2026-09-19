import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:devplanner/auth/data/adapters/desktop_pkce_auth_adapter.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

final class DesktopPkceProtocolException implements Exception {
  const DesktopPkceProtocolException(this.message, {required this.code});
  final String message;
  final String code;
  @override
  String toString() => 'DesktopPkceProtocolException($code): $message';
}

final class PlatformDesktopPkceSessionTransport
    implements DesktopPkceSessionTransport {
  PlatformDesktopPkceSessionTransport({required this.baseUrl, Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  final String baseUrl;
  final Dio _dio;
  String? _accessToken;

  String? get accessToken => _accessToken;

  @override
  Future<DesktopAuthorizationResult> authorizeInteractively() async {
    _accessToken = null;
    final server = await _bindLoopback();
    final state = _random(32);
    final nonce = _random(32);
    final verifier = _random(64);
    final challenge = base64Url
        .encode(sha256.convert(utf8.encode(verifier)).bytes)
        .replaceAll('=', '');
    final callback = Uri(
      scheme: 'http',
      host: '127.0.0.1',
      port: server.port,
      path: '/callback',
    );
    final authorization = Uri.parse(baseUrl)
        .resolve('/connect/authorize')
        .replace(
          queryParameters: {
            'client_id': 'devplanner-desktop',
            'response_type': 'code',
            'redirect_uri': callback.toString(),
            'scope': 'openid profile offline_access devplanner.api',
            'state': state,
            'nonce': nonce,
            'code_challenge': challenge,
            'code_challenge_method': 'S256',
          },
        );
    try {
      await _openBrowser(authorization.toString());
      final request = await _callback(server)
          .timeout(const Duration(minutes: 2));
      // HttpRequest.uri is origin-form for an inbound request, so it does not
      // carry the authority from the browser URL. The listener is bound to
      // IPv4 loopback and the peer check makes that boundary explicit.
      if (request.uri.path != '/callback' ||
          request.connectionInfo?.remoteAddress.isLoopback != true) {
        throw const DesktopPkceProtocolException(
          'Nieprawidłowy adres callbacku.',
          code: 'auth.pkce.callback_invalid',
        );
      }
      if (request.uri.queryParameters['state'] != state) {
        throw const DesktopPkceProtocolException(
          'Nieprawidłowy stan logowania.',
          code: 'auth.pkce.state_mismatch',
        );
      }
      final error = request.uri.queryParameters['error'];
      final code = request.uri.queryParameters['code'];
      if (error != null || code == null || code.isEmpty) {
        throw const DesktopPkceProtocolException(
          'Logowanie zostało odrzucone.',
          code: 'auth.pkce.callback_error',
        );
      }
      await _reply(request);
      final response = await _dio.post<Map<String, dynamic>>(
        '/connect/token',
        data: {
          'grant_type': 'authorization_code',
          'client_id': 'devplanner-desktop',
          'redirect_uri': callback.toString(),
          'code': code,
          'code_verifier': verifier,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return await _tokenResult(response.data);
    } on TimeoutException {
      _accessToken = null;
      throw const DesktopPkceProtocolException(
        'Przekroczono czas oczekiwania na logowanie.',
        code: 'auth.pkce.timeout',
      );
    } on Object {
      _accessToken = null;
      rethrow;
    } finally {
      await server.close(force: true);
    }
  }

  @override
  Future<DesktopAuthorizationResult?> restoreSession({
    required String refreshToken,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/connect/token',
        data: {
          'grant_type': 'refresh_token',
          'client_id': 'devplanner-desktop',
          'refresh_token': refreshToken,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return await _tokenResult(response.data);
    } on DioException catch (error) {
      _accessToken = null;
      if (_shouldDiscardRefreshToken(error)) return null;
      rethrow;
    } catch (_) {
      _accessToken = null;
      rethrow;
    }
  }

  @override
  Future<void> revoke({required String refreshToken}) async {
    _accessToken = null;
    await _dio.post<void>(
      '/connect/revocation',
      data: {
        'client_id': 'devplanner-desktop',
        'token': refreshToken,
        'token_type_hint': 'refresh_token',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) =>
      throw const DesktopPkceProtocolException(
        'Użyj authorizeInteractively.',
        code: 'auth.pkce.interactive_required',
      );

  @override
  Future<DesktopAuthorizationResult> completeAuthorization({
    required String code,
    required String state,
  }) => throw const DesktopPkceProtocolException(
    'Użyj authorizeInteractively.',
    code: 'auth.pkce.interactive_required',
  );

  Future<HttpServer> _bindLoopback() async {
    final random = Random.secure();
    final candidates = <int>{
      for (var i = 0; i < 12; i++) 49152 + random.nextInt(16384),
    };
    for (final port in candidates) {
      try {
        return await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      } on SocketException {
        continue;
      }
    }
    throw const DesktopPkceProtocolException(
      'Nie udało się otworzyć callbacku logowania.',
      code: 'auth.pkce.callback_bind_failed',
    );
  }

  Future<HttpRequest> _callback(HttpServer server) async {
    final request = await server.first;
    return request;
  }

  Future<void> _reply(HttpRequest request) async {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write(
        '<!doctype html><title>DevPlanner</title><p>Logowanie zakończone. Możesz zamknąć tę kartę.</p>',
      );
    await request.response.close();
  }

  Future<DesktopAuthorizationResult> _tokenResult(
    Map<String, dynamic>? body,
  ) async {
    final access = body?['access_token'] as String?;
    final refresh = body?['refresh_token'] as String?;
    if (access == null || refresh == null) {
      throw const DesktopPkceProtocolException(
        'Niepoprawna odpowiedź tokenowa.',
        code: 'auth.pkce.token_invalid',
      );
    }
    _debug('token exchange succeeded; validating /api/v1/me/');
    final user = await _fetchCurrentUser(access);
    _accessToken = access;
    return DesktopAuthorizationResult(
      refreshToken: refresh,
      user: user,
    );
  }

  Future<AuthUser> _fetchCurrentUser(String accessToken) async {
    late Response<Map<String, dynamic>> response;
    try {
      response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/me/',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } on DioException catch (error, stackTrace) {
      _debug(
        'GET /api/v1/me/ failed type=${error.type} '
        'status=${error.response?.statusCode}',
      );
      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace, label: '[auth] /me');
      }
      rethrow;
    }
    final body = response.data;
    final userId = body?['userId'] as String?;
    final login = body?['login'] as String?;
    if (userId == null || login == null || userId.isEmpty || login.isEmpty) {
      throw const DesktopPkceProtocolException(
        'Niepoprawny profil użytkownika.',
        code: 'auth.pkce.profile_invalid',
      );
    }
    return AuthUser(
      userId: userId,
      login: login,
      displayName: login,
      permissions: (body?['permissions'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toSet(),
    );
  }

  void _debug(String message) {
    if (kDebugMode) debugPrint('[auth.pkce] $message');
  }

  /// Rozróżnia odrzucony lokalny refresh token od błędu transportu.
  ///
  /// Odpowiedź 400/401 dla żądania `grant_type=refresh_token` oznacza, że
  /// serwer nie może odtworzyć tej lokalnej sesji. Nie dotyczy to błędów
  /// połączenia, TLS ani 5xx — te pozostają widoczne i nie kasują tokenu.
  bool _shouldDiscardRefreshToken(DioException error) {
    final status = error.response?.statusCode;
    if (status != HttpStatus.badRequest && status != HttpStatus.unauthorized) {
      return false;
    }
    final data = error.response?.data;
    if (kDebugMode) {
      _debug(
        'refresh restore rejected with OIDC error='
        '${data is Map ? data['error'] : 'unknown'}',
      );
    }
    return true;
  }

  String _random(int length) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  Future<void> _openBrowser(String url) async {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      throw const DesktopPkceProtocolException(
        'Nie udało się otworzyć systemowej przeglądarki.',
        code: 'auth.pkce.browser_launch_failed',
      );
    }
  }
}
