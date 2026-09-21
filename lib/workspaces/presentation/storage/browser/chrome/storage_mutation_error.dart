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
    this.onRetry,
  });

  /// Komunikat dla użytkownika.
  final String message;

  /// Stabilny kod kontraktu, np. `storage.placement_conflict`.
  final String? code;

  /// Identyfikator śledzenia żądania.
  final String? traceId;

  /// Ponowienie tej samej operacji; brak akcji oznacza brak przycisku, bo nie
  /// każda mutacja da się bezpiecznie powtórzyć bez odtworzenia intencji.
  final VoidCallback? onRetry;
}
