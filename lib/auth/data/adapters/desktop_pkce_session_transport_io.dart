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
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
            ),
          );

  final String baseUrl;
  final Dio _dio;

  @override
  Future<DesktopTokenResult> authorizeInteractively() async {
    final server = await _bindLoopback();
    final state = _random(32);
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
            'scope': 'offline_access devplanner.api',
            'state': state,
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
        await _reply(request, success: false);
        throw const DesktopPkceProtocolException(
          'Nieprawidłowy adres callbacku.',
          code: 'auth.pkce.callback_invalid',
        );
      }
      if (request.uri.queryParameters['state'] != state) {
        await _reply(request, success: false);
        throw const DesktopPkceProtocolException(
          'Nieprawidłowy stan logowania.',
          code: 'auth.pkce.state_mismatch',
        );
      }
      final error = request.uri.queryParameters['error'];
      final code = request.uri.queryParameters['code'];
      if (error != null || code == null || code.isEmpty) {
        await _reply(request, success: false);
        throw const DesktopPkceProtocolException(
          'Logowanie zostało odrzucone.',
          code: 'auth.pkce.callback_error',
        );
      }
      await _reply(request, success: true);
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
      return _tokenResult(response.data);
    } on TimeoutException {
      throw const DesktopPkceProtocolException(
        'Przekroczono czas oczekiwania na logowanie.',
        code: 'auth.pkce.timeout',
      );
    } on DioException {
      throw const DesktopPkceProtocolException(
        'Nie udało się zakończyć logowania. Spróbuj ponownie.',
        code: 'auth.pkce.exchange_unavailable',
      );
    } finally {
      await server.close(force: true);
    }
  }

  @override
  Future<DesktopTokenResult?> restoreSession({
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
      return _tokenResult(response.data);
    } on DioException catch (error) {
      if (_shouldDiscardRefreshToken(error)) return null;
      throw const DesktopPkceProtocolException(
        'Nie udało się odświeżyć sesji. Spróbuj ponownie.',
        code: 'auth.pkce.refresh_unavailable',
      );
    }
  }

  @override
  Future<void> revoke({required String refreshToken}) async {
    try {
      await _dio.post<void>(
        '/connect/revocation',
        data: {
          'client_id': 'devplanner-desktop',
          'token': refreshToken,
          'token_type_hint': 'refresh_token',
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
    } on DioException {
      throw const DesktopPkceProtocolException(
        'Nie udało się unieważnić sesji na serwerze.',
        code: 'auth.pkce.revocation_unavailable',
      );
    }
  }

  @override
  Future<Uri> beginAuthorization({required Uri callbackUri}) =>
      throw const DesktopPkceProtocolException(
        'Użyj authorizeInteractively.',
        code: 'auth.pkce.interactive_required',
      );

  @override
  Future<DesktopTokenResult> completeAuthorization({
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
    await for (final request in server) {
      if (request.uri.path != '/callback') {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        continue;
      }
      if (request.uri.toString().length > 2048 ||
          request.uri.queryParameters.length > 8) {
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
        continue;
      }
      return request;
    }
    throw const DesktopPkceProtocolException(
      'Callback logowania został zamknięty.',
      code: 'auth.pkce.callback_closed',
    );
  }

  Future<void> _reply(HttpRequest request, {required bool success}) async {
    request.response
      ..statusCode = success ? HttpStatus.ok : HttpStatus.badRequest
      ..headers.contentType = ContentType.html
      ..write(
        success
            ? '<!doctype html><title>DevPlanner</title><p>Logowanie zakończone. Możesz zamknąć tę kartę.</p>'
            : '<!doctype html><title>DevPlanner</title><p>Logowanie nie zostało ukończone. Wróć do aplikacji.</p>',
      );
    await request.response.close();
  }

  DesktopTokenResult _tokenResult(Map<String, dynamic>? body) {
    final access = body?['access_token'];
    final refresh = body?['refresh_token'];
    final expiresIn = _readExpiresIn(body?['expires_in']);
    if (access is! String ||
        access.trim().isEmpty ||
        refresh is! String ||
        refresh.trim().isEmpty ||
        expiresIn == null ||
        body?['token_type'] is! String ||
        (body!['token_type'] as String).toLowerCase() != 'bearer') {
      throw const DesktopPkceProtocolException(
        'Niepoprawna odpowiedź tokenowa.',
        code: 'auth.pkce.token_invalid',
      );
    }
    return DesktopTokenResult(
      accessToken: access,
      refreshToken: refresh,
      expiresIn: expiresIn,
    );
  }

  @override
  Future<AuthUser> fetchCurrentUser({required String accessToken}) async {
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
      throw const DesktopPkceProtocolException(
        'Nie udało się pobrać profilu użytkownika.',
        code: 'auth.pkce.profile_unavailable',
      );
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

  Duration? _readExpiresIn(Object? value) {
    final seconds = switch (value) {
      final int value => value,
      final double value
          when value.isFinite && value == value.roundToDouble() =>
        value.toInt(),
      final String value => int.tryParse(value),
      _ => null,
    };
    if (seconds == null || seconds <= 0 || seconds > 86_400) return null;
    return Duration(seconds: seconds);
  }

  void _debug(String message) {
    if (kDebugMode) debugPrint('[auth.pkce] $message');
  }

  /// Rozróżnia odrzucony lokalny refresh token od błędu transportu.
  ///
  /// Jedynie standardowe `invalid_grant` oznacza, że serwer nie może odtworzyć
  /// tej lokalnej sesji. Nie dotyczy to błędów
  /// połączenia, TLS ani 5xx — te pozostają widoczne i nie kasują tokenu.
  bool _shouldDiscardRefreshToken(DioException error) {
    final status = error.response?.statusCode;
    if (status != HttpStatus.badRequest) {
      return false;
    }
    final data = error.response?.data;
    return data is Map && data['error'] == 'invalid_grant';
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
