import 'dart:convert';

import 'package:devplanner/shared/data/models/bad_response.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Typ bledu API znormalizowany dla warstw repository i presentation.
enum ApiErrorType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  canceled,
  connection,
  parsing,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  server,
  badResponse,
  unknown,
}

/// Ustandaryzowany blad API zwracany przez repository.
class ApiError extends Equatable {
  /// Tworzy blad API z kompletem danych diagnostycznych.
  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.backendCode,
    this.apiCode,
    this.traceId,
  });

  /// Tworzy znormalizowany blad na podstawie `DioException`.
  factory ApiError.fromDioException(
    DioException error, {
    required String fallbackMessage,
  }) {
    final statusCode = error.response?.statusCode;
    final badResponse = _parseBadResponse(error.response?.data);
    final backendMessage = _extractBackendMessage(
      error.response?.data,
      badResponse,
    );
    final backendCode = badResponse?.error?.code;

    return switch (error.type) {
      DioExceptionType.connectionTimeout => const ApiError(
        type: ApiErrorType.connectionTimeout,
        message: 'Przekroczono czas polaczenia z serwerem.',
      ),
      DioExceptionType.sendTimeout => const ApiError(
        type: ApiErrorType.sendTimeout,
        message: 'Przekroczono czas wysylania danych do serwera.',
      ),
      DioExceptionType.receiveTimeout => const ApiError(
        type: ApiErrorType.receiveTimeout,
        message: 'Serwer zbyt dlugo zwracal odpowiedz.',
      ),
      DioExceptionType.transformTimeout => const ApiError(
        type: ApiErrorType.receiveTimeout,
        message: 'Serwer zbyt dlugo zwracal odpowiedz.',
      ),
      DioExceptionType.cancel => const ApiError(
        type: ApiErrorType.canceled,
        message: 'Zapytanie zostalo anulowane.',
      ),
      DioExceptionType.connectionError => const ApiError(
        type: ApiErrorType.connection,
        message: 'Nie mozna polaczyc sie z serwerem.',
      ),
      DioExceptionType.badCertificate => const ApiError(
        type: ApiErrorType.connection,
        message: 'Certyfikat polaczenia jest nieprawidlowy.',
      ),
      DioExceptionType.badResponse => ApiError._fromStatusCode(
        statusCode: statusCode,
        backendCode: backendCode,
        backendMessage: backendMessage,
      ),
      DioExceptionType.unknown => ApiError(
        type: statusCode == null
            ? ApiErrorType.unknown
            : statusCode == 400
            ? ApiErrorType.badResponse
            : statusCode == 401
            ? ApiErrorType.unauthorized
            : statusCode == 403
            ? ApiErrorType.forbidden
            : statusCode == 404
            ? ApiErrorType.notFound
            : statusCode == 409
            ? ApiErrorType.conflict
            : statusCode == 422
            ? ApiErrorType.validation
            : statusCode >= 500
            ? ApiErrorType.server
            : ApiErrorType.badResponse,
        statusCode: statusCode,
        backendCode: backendCode,
        message:
            backendMessage ??
            error.message ??
            _fallbackForStatus(statusCode) ??
            fallbackMessage,
      ),
    };
  }

  /// Tworzy blad parsowania odpowiedzi API lub modelu transportowego.
  factory ApiError.parsing({
    required String fallbackMessage,
  }) {
    return ApiError(
      type: ApiErrorType.parsing,
      message: fallbackMessage,
    );
  }

  const ApiError._fromStatusCode({
    required this.statusCode,
    required this.backendCode,
    required String? backendMessage,
  }) : apiCode = null,
       traceId = null,
       type = statusCode == 400
           ? ApiErrorType.badResponse
           : statusCode == 401
           ? ApiErrorType.unauthorized
           : statusCode == 403
           ? ApiErrorType.forbidden
           : statusCode == 404
           ? ApiErrorType.notFound
           : statusCode == 409
           ? ApiErrorType.conflict
           : statusCode == 422
           ? ApiErrorType.validation
           : (statusCode ?? 0) >= 500
           ? ApiErrorType.server
           : ApiErrorType.badResponse,
       message =
           backendMessage ??
           (backendCode == null ? null : 'Blad API ($backendCode)') ??
           (statusCode == 400
               ? 'Nieprawidlowe zapytanie.'
               : statusCode == 401
               ? 'Sesja wygasla. Zaloguj sie ponownie.'
               : statusCode == 403
               ? 'Brak uprawnien do wykonania akcji.'
               : statusCode == 404
               ? 'Nie znaleziono zasobu.'
               : statusCode == 409
               ? 'Konflikt danych na serwerze.'
               : statusCode == 422
               ? 'Blad walidacji danych.'
               : (statusCode ?? 0) >= 500
               ? 'Blad serwera. Sprobuj ponownie.'
               : null) ??
           'Wystapil blad odpowiedzi serwera.';

  /// Kategoria bledu do logiki aplikacyjnej.
  final ApiErrorType type;

  /// Czytelny komunikat do UI.
  final String message;

  /// Kod HTTP zwrocony przez backend.
  final int? statusCode;

  /// Kod biznesowy zwrocony przez backend.
  final int? backendCode;

  /// Stabilny tekstowy kod błędu z kontraktu standalone API.
  ///
  /// Starsze endpointy używają numerycznego [backendCode]. Nowe kontrakty
  /// DevPlanner zwracają `ApiErrorResponse.code`, dlatego nie można go
  /// bezpiecznie rzutować ani tracić podczas mapowania.
  final String? apiCode;

  /// Identyfikator korelacyjny zwrócony przez backend, jeżeli go opublikował.
  final String? traceId;

  @override
  List<Object?> get props => [
    type,
    message,
    statusCode,
    backendCode,
    apiCode,
    traceId,
  ];

  static String? _fallbackForStatus(int? statusCode) {
    return switch (statusCode) {
      400 => 'Zapytanie do API jest niepoprawne.',
      401 => 'Sesja wygasla lub brak autoryzacji.',
      403 => 'Brak uprawnien do wykonania tej operacji.',
      404 => 'Nie znaleziono wskazanego zasobu.',
      409 => 'Operacja jest w konflikcie z aktualnym stanem danych.',
      422 => 'Backend odrzucil dane wejsciowe.',
      final int code when code >= 500 => 'Wystapil blad serwera.',
      _ => null,
    };
  }

  static BadResponse? _parseBadResponse(Object? rawData) {
    try {
      if (rawData case final Map<String, dynamic> map) {
        return BadResponse.fromJson(map);
      }
      if (rawData case final String value when value.trim().isNotEmpty) {
        final decoded = jsonDecode(value);
        if (decoded case final Map<String, dynamic> map) {
          return BadResponse.fromJson(map);
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static String? _extractBackendMessage(
    Object? rawData,
    BadResponse? badResponse,
  ) {
    if (badResponse?.error?.message case final String message
        when message.isNotEmpty) {
      return message;
    }

    if (badResponse?.detail case final List<BadResponseValidationError> details
        when details.isNotEmpty) {
      return details.map((detail) => detail.msg).join('\n');
    }

    if (rawData case final Map<String, dynamic> map) {
      if (map['errors'] case final Map<String, dynamic> errorsMap
          when errorsMap.isNotEmpty) {
        final messages = errorsMap.values
            .expand<String>(_extractErrorMessages)
            .toList(growable: false);

        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }
      if (map['errors'] case final List<dynamic> errors
          when errors.isNotEmpty) {
        final messages = errors
            .map(_extractErrorListMessage)
            .whereType<String>()
            .toList(growable: false);

        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }
      if (map['detail'] case final String detail when detail.isNotEmpty) {
        return detail;
      }
      if (map['message'] case final String message when message.isNotEmpty) {
        return message;
      }
      if (map['error'] case final String error when error.isNotEmpty) {
        return error;
      }
    }

    return null;
  }

  static Iterable<String> _extractErrorMessages(Object? value) sync* {
    switch (value) {
      case final String message when message.trim().isNotEmpty:
        yield message.trim();
      case final List<dynamic> items:
        for (final item in items) {
          final extracted = _extractErrorListMessage(item);
          if (extracted case final message?) {
            yield message;
          }
        }
      case final Map<String, dynamic> map:
        final extracted = _extractErrorListMessage(map);
        if (extracted case final message?) {
          yield message;
        }
    }
  }

  static String? _extractErrorListMessage(Object? error) {
    return switch (error) {
      final String message when message.trim().isNotEmpty => message.trim(),
      final Map<String, dynamic> item => switch (item['message']) {
        final String message when message.trim().isNotEmpty => message.trim(),
        _ => null,
      },
      _ => null,
    };
  }
}
