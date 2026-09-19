/// Odpowiedź błędu kontraktu standalone DevPlanner.
///
/// Samodzielne API zwraca stabilny, tekstowy kod (`kanban.version_conflict`),
/// bezpieczny komunikat, opcjonalną mapę błędów walidacji oraz `traceId`.
/// Ten model czyta go bez rzutowania, bo rzutowanie gubi kod, komunikat
/// i identyfikator korelacji, przez co błąd staje się nierozpoznawalny.
final class DevPlannerApiErrorResponse {
  const DevPlannerApiErrorResponse({
    required this.code,
    required this.message,
    this.fields = const {},
    this.traceId,
  });

  /// Czyta kontrakt błędów z mapy JSON; zwraca `null`, gdy kształt nie pasuje.
  static DevPlannerApiErrorResponse? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final code = raw['code'];
    final message = raw['message'];
    if (code is! String || code.isEmpty) return null;
    if (message is! String || message.isEmpty) return null;

    return DevPlannerApiErrorResponse(
      code: code,
      message: message,
      fields: _readFields(raw['fields']),
      traceId: switch (raw['traceId']) {
        final String traceId when traceId.isNotEmpty => traceId,
        _ => null,
      },
    );
  }

  /// Stabilny, anglojęzyczny kod błędu do obsługi programowej.
  final String code;

  /// Bezpieczny komunikat błędu przeznaczony do wyświetlenia użytkownikowi.
  final String message;

  /// Mapa błędów walidacji: nazwa pola i lista komunikatów.
  final Map<String, List<String>> fields;

  /// Identyfikator żądania do korelacji z logami backendu.
  final String? traceId;

  static Map<String, List<String>> _readFields(Object? raw) {
    if (raw is! Map) return const {};
    final result = <String, List<String>>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key is! String) continue;
      if (value is List) {
        final messages = [
          for (final item in value)
            if (item is String && item.isNotEmpty) item,
        ];
        if (messages.isNotEmpty) result[key] = messages;
      } else if (value is String && value.isNotEmpty) {
        result[key] = [value];
      }
    }
    return result;
  }
}
