import 'dart:math';

/// Tworzy UUID v4 dla idempotentnych prób wysłania bez używania czasu jako ID.
final class ChatClientMessageIdFactory {
  /// Tworzy fabrykę z opcjonalnym generatoriem dla deterministycznych testów.
  ChatClientMessageIdFactory({Random? random})
    : _random = random ?? Random.secure();

  final Random _random;

  /// Zwraca nowy UUID v4 zapisany potem bez zmian przy każdym retry.
  String create() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final buffer = StringBuffer();
    for (var index = 0; index < bytes.length; index++) {
      if (index == 4 || index == 6 || index == 8 || index == 10) {
        buffer.write('-');
      }
      buffer.write(bytes[index].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
