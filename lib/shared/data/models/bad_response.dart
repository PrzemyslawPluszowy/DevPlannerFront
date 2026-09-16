import 'package:json_annotation/json_annotation.dart';

part 'bad_response.g.dart';

/// Ustandaryzowany model odpowiedzi blednej zwracanej przez API.
///
/// Obsluguje dwa najczestsze formaty:
/// - `{ "error": { "code": ..., "message": ... } }`
/// - `{ "detail": [ ... ] }` (bledy walidacji).
@JsonSerializable()
class BadResponse {
  /// Tworzy obiekt odpowiedzi blednej.
  const BadResponse({this.error, this.detail});

  /// Tworzy obiekt z mapy JSON.
  factory BadResponse.fromJson(Map<String, dynamic> json) =>
      _$BadResponseFromJson(json);

  /// Szczegoly bledu domenowego/autoryzacyjnego.
  final BadResponseError? error;

  /// Lista bledow walidacyjnych.
  final List<BadResponseValidationError>? detail;

  /// Serializuje obiekt do mapy JSON.
  Map<String, dynamic> toJson() => _$BadResponseToJson(this);
}

/// Szczegoly pojedynczego bledu biznesowego lub autoryzacyjnego.
@JsonSerializable()
class BadResponseError {
  /// Tworzy obiekt bledu.
  const BadResponseError({required this.code, required this.message});

  /// Tworzy obiekt z mapy JSON.
  factory BadResponseError.fromJson(Map<String, dynamic> json) =>
      _$BadResponseErrorFromJson(json);

  /// Kod bledu (najczesciej kod HTTP).
  final int code;

  /// Czytelny komunikat bledu.
  final String message;

  /// Serializuje obiekt do mapy JSON.
  Map<String, dynamic> toJson() => _$BadResponseErrorToJson(this);
}

/// Szczegoly bledu walidacji pola wejsciowego.
@JsonSerializable()
class BadResponseValidationError {
  /// Tworzy obiekt bledu walidacji.
  const BadResponseValidationError({
    required this.loc,
    required this.msg,
    required this.type,
    this.input,
    this.ctx,
  });

  /// Tworzy obiekt z mapy JSON.
  factory BadResponseValidationError.fromJson(Map<String, dynamic> json) =>
      _$BadResponseValidationErrorFromJson(json);

  /// Sciezka lokalizacji bledu (np. `query -> firma`).
  final List<Object?> loc;

  /// Komunikat bledu walidacji.
  final String msg;

  /// Typ bledu walidacji.
  final String type;

  /// Oryginalna wartosc przekazana przez klienta.
  final Object? input;

  /// Dodatkowy kontekst bledu.
  final Map<String, dynamic>? ctx;

  /// Serializuje obiekt do mapy JSON.
  Map<String, dynamic> toJson() => _$BadResponseValidationErrorToJson(this);
}
