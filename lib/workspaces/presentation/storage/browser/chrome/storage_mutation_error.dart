import 'package:devplanner/foundation/error/api_error.dart';
import 'package:flutter/foundation.dart';

/// Trwały błąd mutacji pokazywany nad listą plików.
///
/// SnackBar znika razem z kodem i możliwością ponowienia, dlatego mutacje
/// (upload, przenoszenie, udostępnianie, tworzenie dokumentu, kosz) raportują
/// błąd tym samym bannerem co wczytywanie zakresu: komunikat, stabilny kod,
/// `traceId`, `Ponów` i `Odśwież`.
@immutable
final class StorageMutationError {
  /// Tworzy opis błędu mutacji.
  const StorageMutationError({
    required this.message,
    this.code,
    this.traceId,
    this.apiError,
    this.onRetry,
    this.apiErrorsById = const {},
    this.notAttemptedIds = const [],
    this.itemLabels = const {},
  });

  /// Komunikat dla użytkownika.
  final String message;

  /// Stabilny kod kontraktu, np. `storage.placement_conflict`.
  final String? code;

  /// Identyfikator śledzenia żądania.
  final String? traceId;

  /// Pełna odpowiedź API, gdy mutacja nie jest wynikiem zbiorczym.
  final ApiError? apiError;

  /// Ponowienie tej samej operacji; brak akcji oznacza brak przycisku, bo nie
  /// każda mutacja da się bezpiecznie powtórzyć bez odtworzenia intencji.
  final VoidCallback? onRetry;

  /// Zachowuje kontrakt, status HTTP, walidację i trace dla każdego elementu.
  final Map<String, ApiError> apiErrorsById;

  /// Zaznaczone elementy, których żądanie nie zostało wysłane po 429.
  final List<String> notAttemptedIds;

  /// Nazwy, które pozwalają użytkownikowi rozpoznać nieudane elementy.
  final Map<String, String> itemLabels;
}
