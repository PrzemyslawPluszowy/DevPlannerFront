import 'package:dio/dio.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/network/app_api_factory.dart';

/// Interceptor odpowiedzialny za pojedynczy retry po 401 z odswiezeniem sesji.
///
/// Dziedziczy po [QueuedInterceptor], aby kolejkowac rownolegle requesty
/// 401 — zamiast retryowac wszystkie naraz, przetwarza je sekwencyjnie.
///
/// Uzywa generacji sesji ([AppApiFactory.sessionGenerationKey]) do odroznienia
/// zmiany tokena przez refresh (bezpieczny retry) od zmiany tokena
/// przez login/logout innego uzytkownika (odrzucenie requestu).
class AuthRefreshInterceptor extends QueuedInterceptor {
  /// Tworzy interceptor odswiezania sesji.
  AuthRefreshInterceptor({
    required this._dio,
    required this._authRepository,
    required this._onLogout,
  });

  static const retryAfterRefreshKey = 'retry_after_refresh';

  final Dio _dio;
  final AuthRepository _authRepository;
  final Future<void> Function() _onLogout;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final statusCode = err.response?.statusCode;
    final isUnauthorized = statusCode == 401;
    final alreadyRetried = request.extra[retryAfterRefreshKey] == true;

    if (!isUnauthorized || alreadyRetried) {
      if (isUnauthorized && alreadyRetried) {
        await _safeLogout();
      }
      handler.next(err);
      return;
    }

    // Jesli sesja zmienila sie od momentu wyslania requestu
    // (login/logout innego uzytkownika), nie retryujemy — request
    // nalezal do starej sesji i nie powinien byc powtorzony.
    final requestGeneration =
        request.extra[AppApiFactory.sessionGenerationKey] as int?;
    final currentGeneration = _authRepository.sessionGeneration;
    if (requestGeneration != null && requestGeneration != currentGeneration) {
      handler.next(err);
      return;
    }

    // Sprawdza, czy token zostal juz odswiezony przez wczesniejszy
    // request z kolejki (ta sama generacja sesji) — jesli tak,
    // pomija refresh i od razu retryuje z aktualnym tokenem.
    final requestToken = _extractBearerToken(request.headers['Authorization']);
    final currentToken = _authRepository.accessToken;
    final tokenAlreadyRefreshed =
        requestToken != null &&
        currentToken != null &&
        currentToken != requestToken;

    if (!tokenAlreadyRefreshed) {
      final refreshed = await _authRepository.tryRefreshSession();
      if (!refreshed) {
        await _safeLogout();
        handler.next(err);
        return;
      }
    }

    final refreshedAccessToken = _authRepository.accessToken?.trim();
    if (refreshedAccessToken == null || refreshedAccessToken.isEmpty) {
      await _safeLogout();
      handler.next(err);
      return;
    }

    final retriedOptions = request.copyWith(
      headers: {
        ...request.headers,
        'Authorization': 'Bearer $refreshedAccessToken',
      },
      extra: {...request.extra, retryAfterRefreshKey: true},
    );

    try {
      // Nie wolno wykonywać retry przez [_dio]: ten interceptor jest kolejką,
      // a ponowione żądanie wróciłoby do tej samej oczekującej kolejki.
      final response = await _createRetryClient().fetch<dynamic>(
        retriedOptions,
      );
      handler.resolve(response);
    } on DioException catch (retriedError) {
      final retriedStatusCode = retriedError.response?.statusCode;
      if (retriedStatusCode == 401) {
        await _safeLogout();
      }
      handler.next(retriedError);
    }
  }

  /// Tworzy klient tylko dla pojedynczego retry, bez interceptorów aplikacji.
  ///
  /// Adapter HTTP jest współdzielony z głównym klientem, więc retry zachowuje
  /// tę samą konfigurację sieci, ale nie może wejść ponownie do kolejki auth.
  Dio _createRetryClient() {
    final retryClient = Dio(_dio.options);
    retryClient.httpClientAdapter = _dio.httpClientAdapter;
    return retryClient;
  }

  /// Wyodrebnia surowy token z naglowka `Authorization: Bearer <token>`.
  String? _extractBearerToken(Object? headerValue) {
    if (headerValue is! String || headerValue.isEmpty) {
      return null;
    }
    final bearerPrefix = RegExp(r'^Bearer\s+', caseSensitive: false);
    return headerValue.replaceFirst(bearerPrefix, '');
  }

  /// Bezpieczne wywolanie logout — lapie wyjatki, zeby nie przerwac
  /// obslugi bledu w interceptorze.
  Future<void> _safeLogout() async {
    try {
      await _onLogout();
    } catch (_) {
      // Logout nie powinien przerywac propagacji bledu sieciowego.
    }
  }
}
