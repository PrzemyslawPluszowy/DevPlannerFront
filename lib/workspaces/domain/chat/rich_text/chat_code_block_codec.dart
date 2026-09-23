import 'dart:convert';

/// Buduje i waliduje blok kodu w formacie delty Quill.
///
/// Kontrakt transportu to tablica operacji; atrybut `code-block` należy do
/// operacji kończącej linię, tak samo jak zapisuje to edytor i jak czyta to
/// serwerowy parser wzmianek. Dzięki temu literalne `@all`/`@UUID` w kodzie
/// nie pingują ludzi.
abstract final class ChatCodeBlockCodec {
  /// Maksymalna długość kodu przyjmowana z formularza.
  static const int maxCodeLength = 20_000;

  /// Buduje operacje delty dla bloku kodu.
  ///
  /// Pusty kod zwraca pustą listę, żeby „wstaw kod” nie dodawało pustej linii.
  static List<Map<String, Object?>> build({
    required String code,
    String? language,
  }) {
    final normalized = code.replaceAll('\r\n', '\n').trimRight();
    if (normalized.trim().isEmpty) return const <Map<String, Object?>>[];
    final trimmed = normalized.length > maxCodeLength
        ? normalized.substring(0, maxCodeLength)
        : normalized;
    final normalizedLanguage = language?.trim();
    final blockAttribute = <String, Object?>{
      'code-block': normalizedLanguage == null || normalizedLanguage.isEmpty
          ? true
          : normalizedLanguage,
    };
    final operations = <Map<String, Object?>>[];
    // Quill applies block formats to each newline. A single formatted newline
    // after a multiline insert formats only its final line.
    for (final line in trimmed.split('\n')) {
      if (line.isNotEmpty) operations.add(<String, Object?>{'insert': line});
      operations.add(<String, Object?>{
        'insert': '\n',
        'attributes': blockAttribute,
      });
    }
    return operations;
  }

  /// Serializuje operacje do JSON-a przyjmowanego przez API.
  static String encode({required String code, String? language}) =>
      jsonEncode(build(code: code, language: language));
}
