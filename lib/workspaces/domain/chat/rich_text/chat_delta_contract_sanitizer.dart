import 'dart:convert';

/// Normalizuje Delta wejściowe z Quilla do kontraktu publikowanego przez Chat.
///
/// Quill potrafi wkleić HTML z formatami i embedami spoza UI czatu. Zostawienie
/// ich w dokumencie powodowałoby odrzucenie POST przez Backend albo utratę
/// formatowania po wysłaniu. Tekst pozostaje, a nieobsługiwane embedy dostają
/// widoczny znacznik zamiast znikać.
abstract final class ChatDeltaContractSanitizer {
  static const int _maxDeltaJsonLength = 200000;
  static const int _maxOperationCount = 10000;
  static final RegExp _languagePattern = RegExp(r'^[A-Za-z0-9_+#.-]{1,32}$');

  /// Zwraca wyłącznie tekstowe operacje `insert` z atrybutami wspieranymi przez Chat.
  static List<Map<String, Object?>> sanitize(Iterable<Object?> operations) {
    final result = <Map<String, Object?>>[];
    for (final raw in operations) {
      if (raw is! Map<Object?, Object?>) continue;
      final insert = raw['insert'];
      if (insert is String) {
        final attributes = _attributes(raw['attributes']);
        result.add(<String, Object?>{
          'insert': insert,
          if (attributes.isNotEmpty) 'attributes': attributes,
        });
      } else if (insert is Map<Object?, Object?>) {
        result.add(<String, Object?>{'insert': _embedPlaceholder(insert)});
      }
    }
    return result;
  }

  /// Normalizuje serializowaną Deltę przed wysłaniem jej przez API Chat.
  ///
  /// Niepoprawna lub pusta Delta oznacza brak formatowania; tekst wiadomości
  /// nadal jest wysyłany osobnym polem. Dzięki temu wklejony HTML Quilla nie
  /// może wprowadzić atrybutów spoza kontraktu Backend.
  static String? sanitizeJson(String? deltaJson) {
    if (deltaJson == null ||
        deltaJson.isEmpty ||
        deltaJson.length > _maxDeltaJsonLength) {
      return null;
    }
    try {
      final decoded = jsonDecode(deltaJson);
      if (decoded is! List<Object?> || decoded.length > _maxOperationCount) {
        return null;
      }
      final operations = sanitize(decoded);
      if (operations.isEmpty) return null;
      final normalized = jsonEncode(operations);
      return normalized.length <= _maxDeltaJsonLength ? normalized : null;
    } on FormatException {
      return null;
    }
  }

  static Map<String, Object?> _attributes(Object? raw) {
    if (raw is! Map<Object?, Object?>) return const <String, Object?>{};
    final result = <String, Object?>{};
    for (final entry in raw.entries) {
      final name = entry.key;
      final value = entry.value;
      if (name is! String) continue;
      if (const <String>{
        'bold',
        'italic',
        'underline',
        'strike',
        'code',
        'blockquote',
      }.contains(name)) {
        if (value == true) result[name] = true;
      } else if (name == 'link' && _isSafeLink(value)) {
        result[name] = value;
      } else if (name == 'list' && (value == 'bullet' || value == 'ordered')) {
        result[name] = value;
      } else if (name == 'code-block' &&
          (value == true ||
              value is String && _languagePattern.hasMatch(value))) {
        result[name] = value;
      }
    }
    return result;
  }

  static bool _isSafeLink(Object? value) {
    if (value is! String || value.length > 2048 || value.trim().isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.hasAuthority &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  static String _embedPlaceholder(Map<Object?, Object?> embed) {
    final names = embed.keys.whereType<String>().toSet();
    if (names.contains('image')) {
      return '[wklejony obraz — dodaj jako załącznik]';
    }
    if (names.contains('video')) {
      return '[wklejone wideo — dodaj jako załącznik]';
    }
    if (names.contains('link')) {
      return '[wklejony element linku]';
    }
    return '[nieobsługiwany element]';
  }
}
