import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:devplanner/admin/data/adapters/admin_user_api_transport.dart';
import 'package:devplanner/foundation/config/app_env.dart';
import 'package:devplanner/foundation/http/csrf_cookie_reader_stub.dart'
    if (dart.library.js_interop) 'package:devplanner/foundation/http/csrf_cookie_reader_web.dart'
    as csrf_platform;
import 'package:devplanner/foundation/http/devplanner_http_diagnostics_interceptor.dart';
import 'package:devplanner/me/data/me_api_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Wyjątek rzucany przez transport sesyjny w przypadku awarii połączenia sieciowego.
final class DevPlannerHttpTransportException implements Exception {
  const DevPlannerHttpTransportException({
    required this.message,
    this.cause,
  });

  /// Komunikat błędu połączenia.
  final String message;

  /// Pierwotna przyczyna błędu sieciowego (np. wyjątek Dio).
  final Object? cause;

  @override
  String toString() =>
      'DevPlannerHttpTransportException: $message (cause: $cause)';
}

/// Metody HTTP wspierane przez [DevPlannerHttpTransport].
enum DevPlannerHttpMethod { get, post, patch, put, delete, head }

/// Ujednolicone żądanie HTTP dla wszystkich domen DevPlanner.
final class DevPlannerHttpRequest {
  const DevPlannerHttpRequest({
    required this.method,
    required this.path,
    this.query = const <String, String>{},
    this.body,
    this.rawBytes,
    this.contentType,
    this.filename,
    this.headers = const <String, String>{},
    this.correlationId,
  });

  /// Metoda HTTP.
  final DevPlannerHttpMethod method;

  /// Ścieżka URL (względna względem [AppEnv.apiBaseUrl] lub pełny URI).
  final String path;

  /// Parametry zapytania (query string).
  final Map<String, String> query;

  /// Opcjonalne ciało zapytania (mapa JSON, lista lub obiekt).
  final Object? body;

  /// Surowe bajty do przesłania (np. upload pliku awatara).
  final Uint8List? rawBytes;

  /// Typ MIME ciała zapytania (np. `image/jpeg`).
  final String? contentType;

  /// Nazwa pliku dla formularza multipart (np. `avatar.jpg`).
  final String? filename;

  /// Dodatkowe nagłówki żądania.
  final Map<String, String> headers;

  /// Opcjonalny identyfikator korelacji przekazany z zewnątrz.
  final String? correlationId;
}

/// Ujednolicona odpowiedź HTTP transportu sesyjnego.
final class DevPlannerHttpResponse {
  const DevPlannerHttpResponse({
    required this.statusCode,
    this.body,
    this.headers = const <String, List<String>>{},
    this.traceId,
  });

  /// Kod statusu HTTP odpowiedzi.
  final int statusCode;

  /// Sparsowane ciało odpowiedzi (obiekt JSON, lista lub surowe dane).
  final Object? body;

  /// Nagłówki odpowiedzi serwera.
  final Map<String, List<String>> headers;

  /// Identyfikator korelacji powiązany z żądaniem i błędem (`TraceId`).
  final String? traceId;
}

/// Główny, produkcyjny transport HTTP sesji DevPlanner.
///
/// Implementuje:
/// - Dla Web: transport oparty o cookies (`HttpOnly`, `SameSite=Lax`, CSRF header `X-DevPlanner-CSRF`).
/// - Dla Desktop: transport dołączający wyłącznie pamięciowy Bearer token z
///   jawnego koordynatora sesji.
/// - Korelację zapytań z nagłówkami `X-Correlation-ID` i `X-Request-ID`.
/// - Ustandaryzowaną obsługę błędów `ApiErrorResponse` (`code`, `message`, `fields`, `traceId`).
class DevPlannerHttpTransport {
  DevPlannerHttpTransport({
    Dio? dio,
    String? baseUrl,
    this._tokenProvider,
    this._unauthorizedRecovery,
    this._csrfTokenProvider,
    this.enableDiagnosticLogging = kDebugMode,
    Talker? talker,
    this._diagnosticLog,
    String Function()? correlationIdGenerator,
    bool? isWeb,
  }) : _baseUrl = baseUrl ?? AppEnv.apiBaseUrl,
       _correlationIdGenerator =
           correlationIdGenerator ?? _defaultCorrelationIdGenerator,
       _isWeb = isWeb ?? kIsWeb,
       _talker = talker ?? TalkerFlutter.init(),
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl ?? AppEnv.apiBaseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 20),
               sendTimeout: const Duration(seconds: 20),
               headers: const {'Accept': 'application/json'},
             ),
           ) {
    _configureApiClientDio();
  }

  final String _baseUrl;

  /// Bazowy adres API wykorzystywany przez transport.
  String get baseUrl => _baseUrl;

  final FutureOr<String?> Function()? _tokenProvider;
  final Future<String?> Function(String? failedAccessToken)?
  _unauthorizedRecovery;
  final FutureOr<String?> Function()? _csrfTokenProvider;
  final String Function() _correlationIdGenerator;
  final bool _isWeb;
  final bool enableDiagnosticLogging;
  final void Function(String message)? _diagnosticLog;
  final Talker _talker;
  final Dio _dio;
  final csrf_platform.CsrfCookieReader _csrfCookieReader =
      const csrf_platform.CsrfCookieReader();

  bool _apiClientDioConfigured = false;

  /// Zwraca adapter zgodny z kontraktem [AdminUserApiTransport].
  ///
  /// Administracja użytkownikami jest celowo dostępna wyłącznie przez webowy
  /// BFF oparty o cookie. Desktopowy transport z bearerem nie może stać się
  /// przypadkowym obejściem tej granicy.
  AdminUserApiTransport? get asAdminTransport {
    if (!isBffCookieTransport) return null;
    return DevPlannerAdminUserApiTransport._(this);
  }

  /// Czy ten transport może być użyty przez produkcyjną ścieżkę `/admin`.
  ///
  /// Brak token providera/vaultu jest częścią kontraktu: BFF sesję utrzymuje
  /// przeglądarka, a Flutter wysyła tylko cookies i CSRF.
  bool get isBffCookieTransport => _isWeb && _tokenProvider == null;

  /// Czy transport może zostać użyty do złożenia klienta domenowego.
  ///
  /// Web wymaga cookie BFF bez bearerów. Desktop wymaga jawnie przekazanego
  /// providera access tokenu; brak źródła poświadczenia nie
  /// może przypadkiem utworzyć klienta, który będzie wysyłał anonimowe żądania.
  bool get supportsStandaloneApiClients =>
      isBffCookieTransport || (!_isWeb && _tokenProvider != null);

  /// Bezpieczny dostęp do Dio dla wygenerowanych klientów Retrofit.
  ///
  /// Interceptory są instalowane w konstruktorze i powtarzają zasady
  /// [execute]: Web usuwa Authorization i używa cookie/CSRF, Desktop pobiera
  /// access token wyłącznie z providera. Presentation nie dostaje tego
  /// obiektu — używa go wyłącznie composition root warstwy data.
  Dio get apiDio => _dio;

  /// Provider tokenu tylko dla desktopowego SignalR.
  ///
  /// Web nie udostępnia tokenu do kodu klienta, dlatego nie tworzymy tam
  /// klienta realtime wymagającego `accessTokenFactory`.
  Future<String?> Function()? get realtimeAccessTokenProvider {
    if (_isWeb || !supportsStandaloneApiClients) return null;
    return _resolveBearerToken;
  }

  /// Pobiera bieżący token CSRF dla browserowego negotiate SignalR.
  Future<String?> getRealtimeCsrfToken() => _resolveCsrfToken();

  /// Zwraca adapter zgodny z kontraktem [MeApiTransport].
  MeApiTransport get asMeTransport => DevPlannerMeApiTransport(this);

  /// Wykonuje ujednolicone zapytanie HTTP i zwraca przetworzoną odpowiedź.
  Future<DevPlannerHttpResponse> execute(DevPlannerHttpRequest request) async {
    final traceId = request.correlationId ?? _correlationIdGenerator();
    final requestHeaders = <String, dynamic>{
      ...request.headers,
      'X-Correlation-ID': traceId,
      'X-Request-ID': traceId,
    };

    final extra = <String, dynamic>{};

    if (_isWeb) {
      // Web/BFF nie przyjmuje bearerów z kodu Fluttera, nawet jeśli ktoś
      // przekazałby taki nagłówek w żądaniu domenowym.
      requestHeaders.remove('Authorization');
      requestHeaders.remove('authorization');
      extra['withCredentials'] = true;

      if (_isMutating(request.method)) {
        final csrfToken = await _resolveCsrfToken();
        if (csrfToken != null && csrfToken.isNotEmpty) {
          requestHeaders['X-DevPlanner-CSRF'] = csrfToken;
        }
      }
    } else {
      // Desktop authorization is installed by the shared Dio interceptor.
    }

    final dynamic requestData;
    if (request.rawBytes case final bytes?) {
      if (request.filename case final filename?) {
        // Formularz multipart dla przesłania pliku (np. awatara)
        final contentTypeHeader = request.contentType;
        requestData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            bytes,
            filename: filename,
            contentType: contentTypeHeader != null
                ? DioMediaType.parse(contentTypeHeader)
                : null,
          ),
        });
      } else {
        requestData = bytes;
      }
    } else if (request.body != null) {
      requestData = request.body;
      requestHeaders.putIfAbsent('Content-Type', () => 'application/json');
    } else {
      requestData = null;
    }

    try {
      final response = await _dio.request<dynamic>(
        request.path,
        data: requestData,
        queryParameters: request.query.isNotEmpty ? request.query : null,
        options: Options(
          method: request.method.name.toUpperCase(),
          headers: requestHeaders,
          extra: extra,
          validateStatus: (status) => status != null,
        ),
      );

      final statusCode = response.statusCode ?? 500;
      final normalizedBody = _normalizeResponseBody(
        statusCode: statusCode,
        rawBody: response.data,
        fallbackTraceId: traceId,
      );

      final responseHeaders = <String, List<String>>{};
      response.headers.forEach((name, values) {
        responseHeaders[name.toLowerCase()] = values;
      });

      return DevPlannerHttpResponse(
        statusCode: statusCode,
        body: normalizedBody,
        headers: responseHeaders,
        traceId: traceId,
      );
    } on DioException catch (dioError) {
      // Jeśli serwer odesłał odpowiedź z kodem błędu mimo wyjątku Dio
      if (dioError.response case final errorResponse?) {
        final statusCode = errorResponse.statusCode ?? 500;
        final normalizedBody = _normalizeResponseBody(
          statusCode: statusCode,
          rawBody: errorResponse.data,
          fallbackTraceId: traceId,
        );
        return DevPlannerHttpResponse(
          statusCode: statusCode,
          body: normalizedBody,
          traceId: traceId,
        );
      }

      // Brak odpowiedzi oznacza błąd połączenia sieciowego
      throw DevPlannerHttpTransportException(
        message:
            'Błąd połączenia sieciowego podczas żądania do: ${request.path}',
        cause: dioError,
      );
    } catch (unexpectedError) {
      throw DevPlannerHttpTransportException(
        message: 'Nieoczekiwany błąd transportu HTTP: $unexpectedError',
        cause: unexpectedError,
      );
    }
  }

  void _configureApiClientDio() {
    if (_apiClientDioConfigured) return;
    _apiClientDioConfigured = true;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['X-Correlation-ID'] ??= _correlationIdGenerator();
          options.headers['X-Request-ID'] ??=
              options.headers['X-Correlation-ID'];

          if (_isWeb) {
            // BFF cookie jest jedynym mechanizmem sesji Web. Nie kopiujemy
            // Authorization nawet wtedy, gdy klient domenowy podał je ręcznie.
            options.headers.remove('Authorization');
            options.headers.remove('authorization');
            options.extra['withCredentials'] = true;
            if (_isMutatingName(options.method) &&
                !options.headers.containsKey('X-DevPlanner-CSRF')) {
              final csrfToken = await _resolveCsrfToken();
              if (csrfToken != null && csrfToken.isNotEmpty) {
                options.headers['X-DevPlanner-CSRF'] = csrfToken;
              }
            }
          } else {
            final token = await _resolveBearerToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] =
                  'Bearer ${_normalizeToken(token)}';
              options.extra['_devplanner.failed_access_token'] = token;
            } else {
              options.headers.remove('Authorization');
            }
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          // Ten klient akceptuje każdy status (`validateStatus`), więc także 401
          // przychodzi jako odpowiedź. Warunek jest dokładny: odzyskiwanie
          // sesji dotyczy wyłącznie 401. Ponowienie odpowiedzi, która się
          // udała (albo którą Backend świadomie odrzucił), wysyłałoby tę samą
          // mutację dwa razy, a przy zapisie wersjonowanym kończyło się
          // fałszywym konfliktem 409 na drugim żądaniu.
          final retried = await _retryUnauthorized(
            response.requestOptions,
            statusCode: response.statusCode,
          );
          if (retried != null) {
            handler.resolve(retried);
            return;
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          // Ścieżka dla konfiguracji, w której 401 przychodzi jako wyjątek.
          // Błąd sieci nie ma statusu, więc nie uruchamia odzyskiwania sesji.
          final retried = await _retryUnauthorized(
            error.requestOptions,
            statusCode: error.response?.statusCode,
          );
          if (retried != null) {
            handler.resolve(retried);
            return;
          }
          handler.next(error);
        },
      ),
    );
    if (enableDiagnosticLogging) {
      _dio.interceptors.add(
        DevPlannerHttpDiagnosticsInterceptor(_talker, write: _diagnosticLog),
      );
    }
  }

  Future<String?> _resolveCsrfToken() async {
    if (_csrfTokenProvider != null) {
      return _csrfTokenProvider();
    }
    return _csrfCookieReader.read();
  }

  Future<String?> _resolveBearerToken() async {
    return _tokenProvider?.call();
  }

  /// Odzyskuje sesję i powtarza żądanie wyłącznie po odpowiedzi 401.
  ///
  /// Status jest warunkiem wejścia, a nie kontekstem: wołane dla innej
  /// odpowiedzi powtarzałoby żądanie, które już się udało albo które Backend
  /// świadomie odrzucił z innego powodu.
  Future<Response<dynamic>?> _retryUnauthorized(
    RequestOptions options, {
    required int? statusCode,
  }) async {
    if (statusCode != 401 ||
        _isWeb ||
        options.responseType == ResponseType.stream ||
        options.data is FormData ||
        options.extra['_devplanner.auth_retry_count'] == 1 ||
        _unauthorizedRecovery == null ||
        options.extra['_devplanner.retrying'] == true) {
      return null;
    }
    // Only one replay is allowed; FormData is deliberately not replayed as a
    // multipart stream can already have been consumed.
    final failedToken =
        options.extra['_devplanner.failed_access_token'] as String?;
    final recovered = await _unauthorizedRecovery(failedToken);
    if (recovered == null || recovered.isEmpty) return null;
    final headers = Map<String, dynamic>.from(options.headers)
      ..remove('Authorization')
      ..remove('authorization');
    final extra = Map<String, dynamic>.from(options.extra)
      ..['_devplanner.auth_retry_count'] = 1
      ..['_devplanner.retrying'] = true;
    final retry = options.copyWith(headers: headers, extra: extra);
    return _dio.fetch<dynamic>(retry);
  }

  static String _normalizeToken(String token) {
    const prefix = 'Bearer ';
    if (token.startsWith(prefix)) {
      return token.substring(prefix.length).trim();
    }
    return token.trim();
  }

  static Object? _normalizeResponseBody({
    required int statusCode,
    required Object? rawBody,
    required String fallbackTraceId,
  }) {
    final normalizedRawBody = _decodeJsonString(rawBody);

    if (statusCode < 400) {
      return normalizedRawBody;
    }

    // Dla kodów błędów normalizujemy strukturę do ApiErrorResponse
    if (normalizedRawBody is Map) {
      final map = <String, Object?>{};
      for (final entry in normalizedRawBody.entries) {
        if (entry.key is String) {
          map[entry.key as String] = entry.value;
        }
      }
      map['traceId'] ??= fallbackTraceId;
      map['code'] ??= 'http.status_$statusCode';
      map['message'] ??= _fallbackMessageForStatus(statusCode);
      return map;
    }

    return <String, Object?>{
      'code': 'http.status_$statusCode',
      'message':
          normalizedRawBody is String && normalizedRawBody.trim().isNotEmpty
          ? normalizedRawBody
          : _fallbackMessageForStatus(statusCode),
      'fields': null,
      'traceId': fallbackTraceId,
    };
  }

  static String _fallbackMessageForStatus(int statusCode) =>
      switch (statusCode) {
        400 => 'Nieprawidłowe żądanie.',
        401 => 'Sesja wygasła. Zaloguj się ponownie.',
        403 => 'Brak uprawnień do wykonania operacji.',
        404 => 'Nie znaleziono żądanego zasobu.',
        409 => 'Wystąpił konflikt podczas przetwarzania żądania.',
        422 => 'Błąd walidacji danych wejściowych.',
        _ when statusCode >= 500 =>
          'Serwer napotkał błąd. Spróbuj ponownie później.',
        _ => 'Żądanie odrzucone z kodem $statusCode.',
      };

  static bool _isMutating(DevPlannerHttpMethod method) => switch (method) {
    DevPlannerHttpMethod.get || DevPlannerHttpMethod.head => false,
    _ => true,
  };

  static bool _isMutatingName(String method) {
    final normalized = method.toUpperCase();
    return normalized != 'GET' && normalized != 'HEAD';
  }

  static Object? _decodeJsonString(Object? body) {
    if (body is! String || body.trim().isEmpty) return body;
    try {
      return jsonDecode(body);
    } on FormatException {
      return body;
    }
  }

  static String _defaultCorrelationIdGenerator() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final buffer = StringBuffer();
    for (var index = 0; index < bytes.length; index++) {
      if (index == 4 || index == 6 || index == 8 || index == 10) {
        buffer.write('-');
      }
      buffer.write(bytes[index].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}

/// Implementacja [AdminUserApiTransport] delegująca do [DevPlannerHttpTransport].
final class DevPlannerAdminUserApiTransport implements AdminUserApiTransport {
  factory DevPlannerAdminUserApiTransport(DevPlannerHttpTransport transport) {
    if (!transport.isBffCookieTransport) {
      throw StateError(
        'Administracja użytkownikami wymaga transportu BFF/cookie.',
      );
    }
    return DevPlannerAdminUserApiTransport._(transport);
  }

  const DevPlannerAdminUserApiTransport._(this._transport);

  final DevPlannerHttpTransport _transport;

  @override
  Future<AdminUserApiResponse> send(AdminUserApiRequest request) async {
    final method = switch (request.method) {
      AdminUserApiMethod.get => DevPlannerHttpMethod.get,
      AdminUserApiMethod.post => DevPlannerHttpMethod.post,
      AdminUserApiMethod.patch => DevPlannerHttpMethod.patch,
      AdminUserApiMethod.put => DevPlannerHttpMethod.put,
    };

    final response = await _transport.execute(
      DevPlannerHttpRequest(
        method: method,
        path: request.path,
        query: request.query,
        body: request.body,
      ),
    );

    return AdminUserApiResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }
}

/// Implementacja [MeApiTransport] delegująca do [DevPlannerHttpTransport].
final class DevPlannerMeApiTransport implements MeApiTransport {
  const DevPlannerMeApiTransport(this._transport);

  final DevPlannerHttpTransport _transport;

  @override
  Future<MeApiResponse> send(MeApiRequest request) async {
    final method = switch (request.method) {
      MeApiMethod.get => DevPlannerHttpMethod.get,
      MeApiMethod.post => DevPlannerHttpMethod.post,
      MeApiMethod.patch => DevPlannerHttpMethod.patch,
      MeApiMethod.put => DevPlannerHttpMethod.put,
      MeApiMethod.delete => DevPlannerHttpMethod.delete,
    };

    final response = await _transport.execute(
      DevPlannerHttpRequest(
        method: method,
        path: request.path,
        query: request.query,
        body: request.body,
        rawBytes: request.rawBytes,
        contentType: request.contentType,
        filename: request.filename,
      ),
    );

    return MeApiResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }
}
