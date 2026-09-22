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

  /// Wyłącznie archiwum.
  archived('Archived');

  const ChatInboxFilter(this.wireValue);

  /// Wartość wysyłana do backendu.
  final String wireValue;
}
