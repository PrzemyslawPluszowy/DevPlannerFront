import 'dart:convert';

/// Zatwierdzony przez kontrakt backendu cel odpowiedzi Chat z powiadomienia.
///
/// Endpoint odpowiedzi przyjmuje identyfikator powiadomienia, więc klient nie
/// interpretuje ani nie przekazuje identyfikatora wiadomości. Ten typ jedynie
/// oddziela politykę widoczności akcji od warstwy widgetów; serwer ponownie
/// autoryzuje powiadomienie i członkostwo w rozmowie.
final class NotificationReplyTarget {
  const NotificationReplyTarget._();

  /// Zwraca cel tylko dla powiadomienia Chat lub metadanych wskazujących Chat.
  ///
  /// Wartość identyfikatora pozostaje nieprzezroczysta dla klienta. Backend
  /// jest źródłem prawdy dla jego formatu oraz aktualnego prawa do odpowiedzi.
  static NotificationReplyTarget? tryFromNotification({
    required String entityType,
    String? metadataJson,
  }) {
    if (entityType == 'ChatMessage') return const NotificationReplyTarget._();
    if (metadataJson == null || metadataJson.isEmpty) return null;
    try {
      final decoded = jsonDecode(metadataJson);
      if (decoded is! Map<String, dynamic>) return null;
      return _hasMessageReference(decoded)
          ? const NotificationReplyTarget._()
          : null;
    } on FormatException {
      return null;
    }
  }

  static bool _hasMessageReference(Map<String, dynamic> metadata) =>
      _hasNonBlankString(metadata['chatMessageId']) ||
      _hasNonBlankString(metadata['messageId']);

  static bool _hasNonBlankString(Object? value) =>
      value is String && value.trim().isNotEmpty;
}
