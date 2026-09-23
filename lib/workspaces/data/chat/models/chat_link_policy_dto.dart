import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';

/// Odpowiedź polityki snippetów z `GET /api/v1/chat/link-policy`.
///
/// To mały, ręczny DTO bez kodegenu: trzy liczby nie uzasadniają generowania
/// kolejnego modelu freezed, a mapowanie jest tu jednym miejscem do sprawdzenia.
final class ChatLinkPolicyDtoResponse {
  /// Tworzy odpowiedź z wartościami serwera.
  const ChatLinkPolicyDtoResponse({
    required this.snippetThresholdCharacters,
    required this.snippetMaxCharacters,
    required this.snippetInputMaxCharacters,
    required this.messageMaxCharacters,
  });

  /// Odtwarza odpowiedź z JSON.
  factory ChatLinkPolicyDtoResponse.fromJson(Map<String, dynamic> json) =>
      ChatLinkPolicyDtoResponse(
        snippetThresholdCharacters: _requireInt(
          json,
          'snippetThresholdCharacters',
        ),
        snippetMaxCharacters: _requireInt(json, 'snippetMaxCharacters'),
        snippetInputMaxCharacters: _requireInt(
          json,
          'snippetInputMaxCharacters',
        ),
        messageMaxCharacters: _requireInt(json, 'messageMaxCharacters'),
      );

  /// Minimalna długość wklejenia, od której można zaproponować plik TXT.
  final int snippetThresholdCharacters;

  /// Maksymalna liczba znaków zwracana w przygotowanym snippecie.
  final int snippetMaxCharacters;

  /// Maksymalna długość wejścia przyjmowanego przez przygotowanie snippet-u.
  final int snippetInputMaxCharacters;

  /// Maksymalna długość tekstu pojedynczej wiadomości.
  final int messageMaxCharacters;

  /// Mapuje odpowiedź na model domenowy.
  ChatLinkPolicy toDomain() => ChatLinkPolicy(
    snippetThresholdCharacters: snippetThresholdCharacters,
    snippetMaxCharacters: snippetMaxCharacters,
    snippetInputMaxCharacters: snippetInputMaxCharacters,
    messageMaxCharacters: messageMaxCharacters,
  );

  /// Czyta liczbę albo zgłasza błąd parsowania zamiast podstawiać zero.
  static int _requireInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Brak pola $key w odpowiedzi polityki snippetów.');
  }
}
