import 'dart:convert';

import 'package:devplanner/shared/data/models/bad_response.dart';
import 'package:devplanner/shared/data/models/devplanner_api_error_response.dart';

/// Parsuje body i nagłówki błędnej odpowiedzi HTTP bez zależności od Dio.
final class ApiErrorResponseParser {
  const ApiErrorResponseParser._();

  /// Odczytuje legacy shape oraz kontrakt `code/message/fields/traceId`.
  static ParsedApiErrorResponse parse(Object? rawData) {
    final normalized = _decodeJson(rawData);
    final legacy = _parseLegacy(normalized);
    final contract = DevPlannerApiErrorResponse.tryFromJson(normalized);
    return ParsedApiErrorResponse(
      legacy: legacy,
      contract: contract,
      message: _extractMessage(normalized, legacy, contract),
      fields: contract?.fields ?? const {},
    );
  }

  /// Mapuje status HTTP do kategorii błędu używanej przez aplikację.
  static ApiErrorStatusType statusType(int? statusCode) => switch (statusCode) {
    null => ApiErrorStatusType.unknown,
    400 => ApiErrorStatusType.badResponse,
    401 => ApiErrorStatusType.unauthorized,
    403 => ApiErrorStatusType.forbidden,
    404 => ApiErrorStatusType.notFound,
    409 => ApiErrorStatusType.conflict,
    422 => ApiErrorStatusType.validation,
    final int code when code >= 500 => ApiErrorStatusType.server,
    _ => ApiErrorStatusType.badResponse,
  };

  /// Bezpieczny komunikat zastępczy dla typowych statusów HTTP.
  static String? fallbackForStatus(int? statusCode) => switch (statusCode) {
    400 => 'Zapytanie do API jest niepoprawne.',
    401 => 'Sesja wygasla lub brak autoryzacji.',
    403 => 'Brak uprawnien do wykonania tej operacji.',
    404 => 'Nie znaleziono wskazanego zasobu.',
    409 => 'Operacja jest w konflikcie z aktualnym stanem danych.',
    422 => 'Backend odrzucil dane wejsciowe.',
    final int code when code >= 500 => 'Wystapil blad serwera.',
    _ => null,
  };

  /// Odczytuje sekundy lub standardową datę HTTP z nagłówka `Retry-After`.
  static DateTime? parseRetryAfter(String? header, {DateTime? nowUtc}) {
    final value = header?.trim();
    if (value == null || value.isEmpty) return null;
    final seconds = int.tryParse(value);
    if (seconds != null && seconds >= 0) {
      if (seconds > 8000000000000) return null;
      return (nowUtc ?? DateTime.now().toUtc()).add(Duration(seconds: seconds));
    }
    final match = RegExp(
      r'^(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun), (\d{2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d{2}):(\d{2}):(\d{2}) GMT$',
    ).firstMatch(value);
    if (match == null) return null;
    const months = <String, int>{
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    try {
      final month = months[match[2]]!;
      final day = int.parse(match[1]!);
      final date = DateTime.utc(
        int.parse(match[3]!),
        month,
        day,
        int.parse(match[4]!),
        int.parse(match[5]!),
        int.parse(match[6]!),
      );
      if (date.day != day || date.month != month) return null;
      return date;
    } on FormatException {
      return null;
    }
  }

  static Object? _decodeJson(Object? rawData) {
    final String text;
    if (rawData is String) {
      text = rawData;
    } else if (rawData is List<int>) {
      // ResponseType.bytes dotyczy także błędnej odpowiedzi endpointu ZIP.
      // Nie dekodujemy dowolnych liczb ani uszkodzonego UTF-8 z podmianą znaków.
      if (rawData.any((byte) => byte < 0 || byte > 255)) return rawData;
      try {
        text = utf8.decode(rawData);
      } on FormatException {
        return rawData;
      }
    } else {
      return rawData;
    }
    if (text.trim().isEmpty) return rawData;
    try {
      return jsonDecode(text);
    } on FormatException {
      return rawData;
    }
  }

  static BadResponse? _parseLegacy(Object? rawData) {
    if (rawData is! Map) return null;
    try {
      return BadResponse.fromJson(Map<String, dynamic>.from(rawData));
    } on Object {
      return null;
    }
  }

  static String? _extractMessage(
    Object? rawData,
    BadResponse? legacy,
    DevPlannerApiErrorResponse? contract,
  ) {
    if (contract?.message case final String message when message.isNotEmpty) {
      return message;
    }
    if (legacy?.error?.message case final String message
        when message.isNotEmpty) {
      return message;
    }
    if (legacy?.detail case final List<BadResponseValidationError> details
        when details.isNotEmpty) {
      return details.map((detail) => detail.msg).join('\n');
    }
    if (rawData is! Map) return null;
    final errors = rawData['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final messages = errors.values.expand(_extractErrorMessages).toList();
      if (messages.isNotEmpty) return messages.join('\n');
    }
    if (errors is List && errors.isNotEmpty) {
      final messages = errors
          .map(_extractErrorListMessage)
          .whereType<String>()
          .toList();
      if (messages.isNotEmpty) return messages.join('\n');
    }
    for (final key in const ['detail', 'message', 'error']) {
      final value = rawData[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  static Iterable<String> _extractErrorMessages(Object? value) sync* {
    switch (value) {
      case final String message when message.trim().isNotEmpty:
        yield message.trim();
      case final List<dynamic> items:
        for (final item in items) {
          final message = _extractErrorListMessage(item);
          if (message != null) yield message;
        }
      case final Map<dynamic, dynamic> map:
        final message = _extractErrorListMessage(map);
        if (message != null) yield message;
    }
  }

  static String? _extractErrorListMessage(Object? error) => switch (error) {
    final String message when message.trim().isNotEmpty => message.trim(),
    final Map<dynamic, dynamic> item => switch (item['message']) {
      final String message when message.trim().isNotEmpty => message.trim(),
      _ => null,
    },
    _ => null,
  };
}

/// Parsed, privacy-safe response metadata for the normalized API error.
final class ParsedApiErrorResponse {
  const ParsedApiErrorResponse({
    required this.legacy,
    required this.contract,
    required this.message,
    required this.fields,
  });

  final BadResponse? legacy;
  final DevPlannerApiErrorResponse? contract;
  final String? message;
  final Map<String, List<String>> fields;
}

/// Status classification independent of the `ApiErrorType` declaration.
enum ApiErrorStatusType {
  unknown,
  badResponse,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  server,
}
