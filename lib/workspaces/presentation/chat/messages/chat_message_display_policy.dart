/// Deterministyczne reguły prezentacji długiej treści wiadomości.
///
/// Nie zmieniają modelu ani danych wysyłanych do API. Widżety używają ich tylko
/// do ograniczenia wysokości historii i dodania punktów łamania linków.
abstract final class ChatMessageDisplayPolicy {
  /// Liczba linii, po której wiadomość dostaje stan zwinięty.
  static const int collapseLineThreshold = 12;

  /// Limit ciągłego tekstu, po którym wiadomość dostaje stan zwinięty.
  static const int collapseCharacterThreshold = 1200;

  /// Czy treść powinna startować zwinięta.
  static bool shouldCollapse(String text) =>
      text.length > collapseCharacterThreshold ||
      text.split('\n').length > collapseLineThreshold;

  /// Dodaje niewidoczne miejsca łamania do renderowania długiego linku.
  ///
  /// Zwrócony tekst służy wyłącznie widokowi. Wywołanie linku i kopiowanie
  /// nadal korzystają z kanonicznego URL-a przechowywanego osobno.
  static String addLinkWrapOpportunities(String value) {
    final runes = value.runes;
    if (runes.length <= 40) return value;
    final buffer = StringBuffer();
    var runLength = 0;
    for (final rune in runes) {
      buffer.writeCharCode(rune);
      runLength++;
      if (runLength == 32 && rune != 0x2f) {
        buffer.write('\u200b');
        runLength = 0;
      } else if (rune == 0x2f || rune == 0x3f || rune == 0x26) {
        runLength = 0;
      }
    }
    return buffer.toString();
  }

  /// Zawija wizualnie URL-e w zwykłym tekście, nawet gdy serwer nie zwrócił
  /// metadanych, które pozwalają uczynić je klikalnymi.
  ///
  /// Nie dodaje linków ani nie zmienia wartości modelu; zmieniony tekst służy
  /// wyłącznie rendererowi. Dla krótkich URL-i zwraca oryginalny ciąg.
  static String addPlainTextUrlWrapOpportunities(String value) {
    final urls = RegExp(r"""https?://[^\s<>"']+""", caseSensitive: false);
    return value.replaceAllMapped(urls, (match) {
      final url = match.group(0)!;
      return addLinkWrapOpportunities(url);
    });
  }
}
