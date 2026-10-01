import 'package:devplanner/foundation/error/api_error_response_parser.dart';
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

/// Ustandaryzowany błąd API zwracany przez repository.
class ApiError extends Equatable {
  /// Tworzy błąd API z kompletem danych diagnostycznych.
  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.backendCode,
    this.apiCode,
    this.contractCode,
    this.fields = const {},
    this.traceId,
    this.retryAfterUtc,
  });

  /// Normalizuje status, komunikat i bezpieczne metadane z odpowiedzi Dio.
  factory ApiError.fromDioException(
    DioException error, {
    required String fallbackMessage,
  }) {
    final statusCode = error.response?.statusCode;
    final parsed = ApiErrorResponseParser.parse(error.response?.data);
    final retryAfter = ApiErrorResponseParser.parseRetryAfter(
      error.response?.headers.value('retry-after'),
    );
    final contractCode = parsed.contract?.code;
    final traceId = parsed.contract?.traceId;
    final backendCode = parsed.legacy?.error?.code;
    final apiType = switch (error.type) {
      DioExceptionType.connectionTimeout => ApiErrorType.connectionTimeout,
      DioExceptionType.sendTimeout => ApiErrorType.sendTimeout,
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => ApiErrorType.receiveTimeout,
      DioExceptionType.cancel => ApiErrorType.canceled,
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => ApiErrorType.connection,
      DioExceptionType.badResponse ||
      DioExceptionType.unknown => _typeForStatus(statusCode),
    };

    final message = switch (error.type) {
      DioExceptionType.badResponse => _statusMessage(
        statusCode: statusCode,
        backendCode: backendCode,
        backendMessage: parsed.message,
      ),
      DioExceptionType.unknown =>
        parsed.message ??
            error.message ??
            ApiErrorResponseParser.fallbackForStatus(statusCode) ??
            fallbackMessage,
      _ => switch (error.type) {
        DioExceptionType.connectionTimeout =>
          'Przekroczono czas polaczenia z serwerem.',
        DioExceptionType.sendTimeout =>
          'Przekroczono czas wysylania danych do serwera.',
        DioExceptionType.receiveTimeout || DioExceptionType.transformTimeout =>
          'Serwer zbyt dlugo zwracal odpowiedz.',
        DioExceptionType.cancel => 'Zapytanie zostalo anulowane.',
        DioExceptionType.connectionError =>
          'Nie mozna polaczyc sie z serwerem.',
        DioExceptionType.badCertificate =>
          'Certyfikat polaczenia jest nieprawidlowy.',
        DioExceptionType.badResponse ||
        DioExceptionType.unknown => fallbackMessage,
      },
    };

    return ApiError(
      type: apiType,
      message: message,
      statusCode: statusCode,
      backendCode: backendCode,
      apiCode: contractCode,
      contractCode: contractCode,
      fields: parsed.fields,
      traceId: traceId,
      retryAfterUtc: retryAfter,
    );
  }

  /// Tworzy błąd parsowania odpowiedzi API lub modelu transportowego.
  factory ApiError.parsing({required String fallbackMessage}) => ApiError(
    type: ApiErrorType.parsing,
    message: fallbackMessage,
  );

  static ApiErrorType _typeForStatus(int? statusCode) =>
      switch (ApiErrorResponseParser.statusType(statusCode)) {
        ApiErrorStatusType.unknown => ApiErrorType.unknown,
        ApiErrorStatusType.badResponse => ApiErrorType.badResponse,
        ApiErrorStatusType.unauthorized => ApiErrorType.unauthorized,
        ApiErrorStatusType.forbidden => ApiErrorType.forbidden,
        ApiErrorStatusType.notFound => ApiErrorType.notFound,
        ApiErrorStatusType.conflict => ApiErrorType.conflict,
        ApiErrorStatusType.validation => ApiErrorType.validation,
        ApiErrorStatusType.server => ApiErrorType.server,
      };

  static String _statusMessage({
    required int? statusCode,
    required int? backendCode,
    required String? backendMessage,
  }) =>
      backendMessage ??
      (backendCode == null ? null : 'Blad API ($backendCode)') ??
      switch (statusCode) {
        400 => 'Nieprawidlowe zapytanie.',
        401 => 'Sesja wygasla. Zaloguj sie ponownie.',
        403 => 'Brak uprawnien do wykonania akcji.',
        404 => 'Nie znaleziono zasobu.',
        409 => 'Konflikt danych na serwerze.',
        422 => 'Blad walidacji danych.',
        final int code when code >= 500 => 'Blad serwera. Sprobuj ponownie.',
        _ => 'Wystapil blad odpowiedzi serwera.',
      };

  /// Kategoria błędu do logiki aplikacyjnej.
  final ApiErrorType type;

  /// Czytelny komunikat do UI.
  final String message;

  /// Kod HTTP zwrócony przez backend.
  final int? statusCode;

  /// Numeryczny kod błędu legacy API.
  final int? backendCode;

  /// Stabilny kod błędu używany przez bieżący feature lub kontrakt API.
  final String? apiCode;

  /// Niezmieniony kod `code` z kontraktu API, nawet gdy mapper nada lokalny [apiCode].
  final String? contractCode;

  /// Pola walidacji z kontraktu API, bez spłaszczania do tekstu.
  final Map<String, List<String>> fields;

  /// Identyfikator korelacyjny zwrócony przez backend.
  final String? traceId;

  /// Najwcześniejszy czas ponowienia przekazany przez HTTP `Retry-After`.
  final DateTime? retryAfterUtc;

  @override
  List<Object?> get props => [
    type,
    message,
    statusCode,
    backendCode,
    apiCode,
    contractCode,
    fields,
    traceId,
    retryAfterUtc,
  ];
}
