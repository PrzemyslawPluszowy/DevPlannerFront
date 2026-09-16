import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ready_next/core/config/app_api_module.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// Wspolna fabryka klientow HTTP opartych o `Dio`.
///
/// Zapewnia:
/// - konfiguracje timeoutow i naglowkow,
/// - Bearer token (statyczny albo dynamiczny provider).
class AppApiFactory {
  const AppApiFactory._();

  static const requestModuleKey = 'app_api_module';

  /// Klucz `extra` przechowujacy generacje sesji w momencie wyslania requestu.
  static const sessionGenerationKey = 'app_session_generation';

  static bool _shouldEnableLogging(bool enableLogging) {
    return enableLogging && kDebugMode;
  }

  static dynamic _truncateResponseData(dynamic data, {int maxItems = 6}) {
    if (data == null) return null;
    if (data is List) {
      if (data.length <= maxItems) {
        return data
            .map((item) => _truncateResponseData(item, maxItems: maxItems))
            .toList();
      }
      final remaining = data.length - maxItems;
      final truncated = data
          .take(maxItems)
          .map((item) => _truncateResponseData(item, maxItems: maxItems))
          .toList();
      truncated.add(
        '... [obcięto $remaining z ${data.length} elementów listy (limit $maxItems)]',
      );
      return truncated;
    }
    if (data is Map) {
      final map = <String, dynamic>{};
      for (final entry in data.entries) {
        map[entry.key.toString()] = _truncateResponseData(
          entry.value,
          maxItems: maxItems,
        );
      }
      return map;
    }
    if (data is String) {
      final lines = data.split('\n');
      if (lines.length > 50) {
        final remaining = lines.length - 50;
        return '${lines.take(50).join('\n')}\n... [obcięto $remaining linii]';
      }
      return data;
    }
    return data;
  }

  static Dio _createBaseDio({
    required String baseUrl,
    required Duration connectTimeout,
    required Duration receiveTimeout,
  }) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: const {'Accept': 'application/json'},
      ),
    );
  }

  static void _addLoggingInterceptor(
    Dio dio, {
    required bool enableLogging,
    Talker? talker,
  }) {
    final shouldEnableLogging = _shouldEnableLogging(enableLogging);
    dio.interceptors.add(
      _TruncatingTalkerDioLogger(
        talker: talker ?? Talker(),
        settings: TalkerDioLoggerSettings(
          enabled: shouldEnableLogging,
          // Talker nie redaguje Bearer tokenow samodzielnie. Ukrywamy ten
          // naglowek rowniez w loggerze, aby nie wyciekl po wlaczeniu
          // printRequestHeaders ani w przyszlych zmianach konfiguracji.
          hiddenHeaders: const {'Authorization'},
          printResponseTime: true,
        ),
      ),
    );
  }

  /// Tworzy wspolna instancje `Dio` do wszystkich klientow Retrofit.
  static Dio createDio({
    required String baseUrl,
    required AppApiModule module,
    String? accessToken,
    String? Function()? accessTokenProvider,
    CancelToken Function()? cancelTokenProvider,
    int Function()? sessionGenerationProvider,
    bool enableLogging = kDebugMode,
    Talker? talker,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    final shouldEnableLogging = _shouldEnableLogging(enableLogging);
    final dio = _createBaseDio(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.cancelToken ??= cancelTokenProvider?.call();
          options.extra[requestModuleKey] = module.name;
          if (sessionGenerationProvider case final provider?) {
            options.extra[sessionGenerationKey] = provider();
          }
          final resolvedToken = accessTokenProvider?.call() ?? accessToken;
          if (resolvedToken != null && resolvedToken.isNotEmpty) {
            options.headers['Authorization'] =
                'Bearer ${_normalizeToken(resolvedToken)}';
          } else {
            options.headers.remove('Authorization');
          }
          if (shouldEnableLogging) {
            final hasAuthorizationHeader = options.headers.containsKey(
              'Authorization',
            );
            final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
            if (hasAuthorizationHeader) {
              sanitizedHeaders['Authorization'] = _maskAuthorizationHeader(
                sanitizedHeaders['Authorization']?.toString(),
              );
            }
            debugPrint(
              '[AppApiFactory] Authorization header: '
              '${hasAuthorizationHeader ? 'present' : 'missing'}',
            );
            debugPrint(
              '[AppApiFactory] Request headers: $sanitizedHeaders',
            );
          }
          handler.next(options);
        },
      ),
    );

    _addLoggingInterceptor(
      dio,
      enableLogging: enableLogging,
      talker: talker,
    );

    return dio;
  }

  /// Tworzy klient `Dio` dla endpointow auth bez naglowka `Authorization`.
  static Dio createAuthDio({
    required String baseUrl,
    required AppApiModule module,
    bool enableLogging = kDebugMode,
    Talker? talker,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    final dio = _createBaseDio(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra[requestModuleKey] = module.name;
          handler.next(options);
        },
      ),
    );

    _addLoggingInterceptor(
      dio,
      enableLogging: enableLogging,
      talker: talker,
    );

    return dio;
  }

  /// Tworzy gotowy klient `InventoryApi`.
  static InventoryApi create({
    required String baseUrl,
    required AppApiModule module,
    String? accessToken,
    String? Function()? accessTokenProvider,
    CancelToken Function()? cancelTokenProvider,
    int Function()? sessionGenerationProvider,
    bool enableLogging = kDebugMode,
    Talker? talker,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    final dio = createDio(
      baseUrl: baseUrl,
      module: module,
      accessToken: accessToken,
      accessTokenProvider: accessTokenProvider,
      cancelTokenProvider: cancelTokenProvider,
      sessionGenerationProvider: sessionGenerationProvider,
      enableLogging: enableLogging,
      talker: talker,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );

    return InventoryApi(dio);
  }

  /// Normalizuje token tak, aby uniknac podwojnego prefiksu `Bearer `.
  static String _normalizeToken(String token) {
    const prefix = 'Bearer ';
    if (token.startsWith(prefix)) {
      return token.substring(prefix.length);
    }
    return token;
  }

  /// Maskuje token w naglowku `Authorization`, zostawiajac tylko krotki fragment.
  static String _maskAuthorizationHeader(String? headerValue) {
    if (headerValue == null || headerValue.isEmpty) {
      return 'missing';
    }

    const prefix = 'Bearer ';
    final normalized = headerValue.startsWith(prefix)
        ? headerValue.substring(prefix.length)
        : headerValue;

    if (normalized.length <= 10) {
      return '$prefix***';
    }

    final start = normalized.substring(0, 6);
    final end = normalized.substring(normalized.length - 4);
    return '$prefix$start...$end';
  }
}

/// Logger Dio dla Talkera obcinający ogromne odpowiedzi JSON do maksymalnie 100 linii.
class _TruncatingTalkerDioLogger extends TalkerDioLogger {
  _TruncatingTalkerDioLogger({
    super.talker,
    super.settings,
  });

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (settings.enabled) {
      final truncatedData = AppApiFactory._truncateResponseData(response.data);
      if (identical(truncatedData, response.data)) {
        super.onResponse(response, handler);
      } else {
        final clonedResponse = Response<dynamic>(
          requestOptions: response.requestOptions,
          data: truncatedData,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
          headers: response.headers,
        );
        super.onResponse(
          clonedResponse,
          _PassthroughResponseInterceptorHandler(handler, response),
        );
      }
    } else {
      super.onResponse(response, handler);
    }
  }
}

/// Pomocniczy handler przekazujący oryginalną (niezmodyfikowaną) odpowiedź do dalszych interceptorów i Retrofit.
class _PassthroughResponseInterceptorHandler
    extends ResponseInterceptorHandler {
  _PassthroughResponseInterceptorHandler(
    this._realHandler,
    this._originalResponse,
  );

  final ResponseInterceptorHandler _realHandler;
  final Response<dynamic> _originalResponse;

  @override
  void next(Response<dynamic> response) {
    _realHandler.next(_originalResponse);
  }

  @override
  void resolve(Response<dynamic> response) {
    _realHandler.resolve(_originalResponse);
  }

  @override
  void reject(
    DioException error, [
    bool callFollowingErrorInterceptor = false,
  ]) {
    _realHandler.reject(error, callFollowingErrorInterceptor);
  }
}
