import 'dart:math';

/// Generator klucza idempotencji draftu kreatora projektu.
///
/// Klucz musi być UUID-em akceptowanym przez Backend. Implementacja nie zależy
/// od pakietu `uuid`, bo kreator potrzebuje wyłącznie identyfikatora wersji 4
/// i musi być deterministyczny w testach.
final class ProjectSetupIdempotencyKey {
  const ProjectSetupIdempotencyKey._();

  /// Tworzy nowy klucz idempotencji w formacie UUID v4.
  static String generate([Random? random]) {
    final source = random ?? Random.secure();
    final bytes = List<int>.generate(16, (_) => source.nextInt(256));
    // Wersja 4 i wariant RFC 4122: Backend waliduje format przez Guid.TryParse.
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    bytes[8] = (bytes[8] & 0x3F) | 0x80;
    final hex = [
      for (final byte in bytes) byte.toRadixString(16).padLeft(2, '0'),
    ].join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
