import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_response.freezed.dart';
part 'api_error_response.g.dart';

/// Wspólny kontrakt bezpiecznej odpowiedzi błędu API Workspaces.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ApiErrorResponse with _$ApiErrorResponse {
  /// Tworzy błąd z kodem programowym, komunikatem i identyfikatorem żądania.
  const factory ApiErrorResponse({
    required String code,
    required String message,
    Map<String, List<String>>? fields,
    required String traceId,
  }) = _ApiErrorResponse;

  /// Odtwarza błąd z odpowiedzi JSON backendu.
  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);
}
