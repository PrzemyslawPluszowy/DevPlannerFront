import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/core/network/app_api_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Bazowa klasa pomocnicza dla repository wywolujacych API.
abstract class ApiRepository {  /// Owijka na wywolanie API z centralnym mapowaniem `DioException`.
  Future<Either<ApiError, T>> guardApiCall<T>(
    Future<T> Function() call, {
    required String fallbackMessage,
    String? parsingMessage,
  }) async {
    try {
      return Right(await call());
    } on DioException catch (error, stackTrace) {
      await _reportDioExceptionToSentry(
        error: error,
        stackTrace: stackTrace,
        fallbackMessage: fallbackMessage,
      );
      _logDioException(error, stackTrace, fallbackMessage);
      return Left(
        ApiError.fromDioException(
          error,
          fallbackMessage: fallbackMessage,
        ),
      );
    } on Object catch (error, stackTrace) {
      await _reportParsingExceptionToSentry(
        error: error,
        stackTrace: stackTrace,
        parsingMessage: parsingMessage,
      );
      _logParsingException(
        error: error,
        stackTrace: stackTrace,
        parsingMessage: parsingMessage,
      );
      return Left(
        ApiError.parsing(
          fallbackMessage:
              parsingMessage ?? 'Nie udalo sie przetworzyc odpowiedzi API.',
        ),
      );
    }
  }

  Future<void> _reportDioExceptionToSentry({
    required DioException error,
    required StackTrace stackTrace,
    required String fallbackMessage,
  }) async {
    if (!Sentry.isEnabled || !_shouldCaptureHandledDioException(error)) {
      return;
    }

    final request = error.requestOptions;
    final moduleName = request.extra[AppApiFactory.requestModuleKey]
        ?.toString();

    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) async {
        scope.level = SentryLevel.error;
        await scope.setTag('handled_api_error', 'true');
        if (moduleName case final value? when value.trim().isNotEmpty) {
          await scope.setTag('http_module', value.trim());
        }
        await scope.setContexts('api_request', {
          'method': request.method,
          'path': request.path,
          'dio_type': error.type.name,
          'fallback_message': fallbackMessage,
        });
      },
    );
  }

  bool _shouldCaptureHandledDioException(DioException error) {
    if (error.type == DioExceptionType.cancel) {
      return false;
    }

    // `sentry_dio` raportuje bledy z kodem HTTP, ale nie obejmuje przypadkow
    // bez odpowiedzi serwera, ktore na webie zdarzaja sie najczesciej
    // (timeout, CORS, network error).
    return error.response?.statusCode == null;
  }

  Future<void> _reportParsingExceptionToSentry({
    required Object error,
    required StackTrace stackTrace,
    String? parsingMessage,
  }) async {
    if (!Sentry.isEnabled) {
      return;
    }

    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) async {
        scope.level = SentryLevel.error;
        await scope.setTag('api_parsing_error', 'true');
        await scope.setContexts('api_parsing', {
          'message':
              parsingMessage ?? 'Nie udalo sie przetworzyc odpowiedzi API.',
          'error_type': error.runtimeType.toString(),
        });
      },
    );
  }

  void _logDioException(
    DioException error,
    StackTrace stackTrace,
    String fallbackMessage,
  ) {
    if (!kDebugMode) {
      return;
    }

    final request = error.requestOptions;
    final method = request.method;
    final endpoint = request.path;
    final response = error.response;
    final status = response?.statusCode;
    final responseType = response?.data.runtimeType;
    // Kod kontraktu, komunikat i traceId rozpoznają przyczynę błędu bez
    // debuggera; sam status HTTP nie mówi, która reguła Backendu odrzuciła
    // żądanie.
    final contract = ApiError.fromDioException(
      error,
      fallbackMessage: fallbackMessage,
    );

    debugPrint(
      '[API][DIO] $method $endpoint | type=${error.type} | status=$status | '
      'code=${contract.apiCode ?? contract.backendCode ?? '-'} | '
      'traceId=${contract.traceId ?? response?.headers.value('x-trace-id') ?? '-'} | '
      'fallback="$fallbackMessage" | responseType=$responseType | '
      'body=${debugResponseShape(response?.data)} | '
      'message=${contract.message}',
    );
    debugPrintStack(label: '[API][DIO][stack]', stackTrace: stackTrace);
  }

  void _logParsingException({
    required Object error,
    required StackTrace stackTrace,
    String? parsingMessage,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '[API][PARSING] ${error.runtimeType}: $error | '
      'message="${parsingMessage ?? 'Nie udalo sie przetworzyc odpowiedzi API.'}"',
    );
    debugPrintStack(label: '[API][PARSING][stack]', stackTrace: stackTrace);
  }
}

/// Opisuje kształt ciała odpowiedzi bez ujawniania jego wartości.
///
/// Log może trafić do konsoli, zrzutu ekranu albo zgłoszenia błędu, a w ciele
/// odpowiedzi bywają tokeny, adresy e-mail i wartości formularzy — również na
/// endpointach logowania, odzyskiwania konta i aktywacji. Dlatego zostają same
/// nazwy pól, liczba elementów albo rozmiar tekstu, nigdy treść.
@visibleForTesting
String debugResponseShape(Object? body, {int maxFields = 12}) {
  switch (body) {
    case null:
      return 'brak';
    case final Map<Object?, Object?> map:
      final fields = map.keys.take(maxFields).join(',');
      return 'fields=${map.length > maxFields ? '$fields…' : fields}';
    case final List<Object?> list:
      return 'items=${list.length}';
    case final String text:
      return 'text=${text.length}b';
    default:
      return 'type=${body.runtimeType}';
  }
}
