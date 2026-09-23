/// Polityka snippetów i linków potwierdzona przez serwer.
///
/// Klient nie powtarza progów backendu: wartości pochodzą z
/// `GET /api/v1/chat/link-policy`, więc decyzja „tekst czy plik TXT” opiera się
/// na tych samych liczbach, których używa przygotowanie snippet-u.
final class ChatLinkPolicy {
  /// Tworzy politykę z wartościami serwera.
  const ChatLinkPolicy({
    required this.snippetThresholdCharacters,
    required this.snippetMaxCharacters,
    required this.snippetInputMaxCharacters,
    required this.messageMaxCharacters,
  });

  /// Minimalna długość wklejenia, od której można zaproponować plik TXT.
  final int snippetThresholdCharacters;

  /// Maksymalna liczba znaków zwracana w przygotowanym snippecie.
  final int snippetMaxCharacters;

  /// Maksymalna długość wejścia przyjmowanego przez przygotowanie snippet-u.
  final int snippetInputMaxCharacters;

  /// Maksymalna długość tekstu pojedynczej wiadomości.
  final int messageMaxCharacters;
}
