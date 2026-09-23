/// Filtr serwerowej skrzynki rozmów Chat.
///
/// Wartości tekstowe są jedynym kontraktem transportu; warstwa prezentacji nie
/// buduje zapytań samodzielnie.
enum ChatInboxFilter {
  /// Wszystkie aktywne rozmowy, bez archiwum.
  all('All'),

  /// Wyłącznie rozmowy z nieprzeczytanymi wiadomościami.
  unread('Unread'),

  /// Wyłącznie rozmowy 1:1.
  direct('Direct'),

  /// Wyłącznie grupy.
  groups('Groups'),

  /// Wyłącznie kanały i ogłoszenia.
  channels('Channels'),

  /// Wyłącznie rozmowy, w których wspomniano bieżącego użytkownika.
  ///
  /// Filtr korzysta z serwerowego rejestru wzmianek, a nie z przeszukiwania
  /// pobranej treści, więc działa także poza pierwszą stroną skrzynki.
  mentions('Mentions'),

  /// Wyłącznie archiwum.
  archived('Archived');

  const ChatInboxFilter(this.wireValue);

  /// Wartość wysyłana do backendu.
  final String wireValue;
}
