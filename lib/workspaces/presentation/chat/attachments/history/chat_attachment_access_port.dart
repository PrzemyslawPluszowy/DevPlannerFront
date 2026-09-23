import 'dart:typed_data';

/// Porażka otwarcia załącznika z kodem, komunikatem i `traceId` serwera.
///
/// UI pokazuje dokładnie to, co potwierdził backend; brak portu albo brak
/// biletu nigdy nie udaje udanego pobrania.
final class ChatAttachmentAccessFailure {
  /// Tworzy porażkę na podstawie znormalizowanego błędu API.
  const ChatAttachmentAccessFailure({
    required this.code,
    required this.message,
    this.traceId,
  });

  /// Stabilny kod kontraktu, jeżeli backend go opublikował.
  final String? code;

  /// Czytelny komunikat do pokazania użytkownikowi.
  final String message;

  /// Identyfikator korelacyjny do zgłoszenia problemu.
  final String? traceId;
}

/// Port otwarcia załącznika Chat przez autoryzowaną ścieżkę Storage.
///
/// Presentation nie zna presigned URL ani klienta HTTP: port pobiera bilet
/// pobrania i przekazuje go platformowemu transportowi. Brak portu w drzewie
/// oznacza środowisko bez bezpiecznego pobierania, więc karta załącznika nie
/// pokazuje akcji, której nie da się wykonać.
///
/// Interfejs jest prawdziwym seamem kompozycji (adapter Storage w produkcji,
/// fake w testach), a nie funkcją przekazywaną argumentem; dlatego pozostaje
/// klasą abstrakcyjną, mimo że wizualnie dałoby się go sprowadzić do funkcji.
abstract interface class ChatAttachmentAccessPort {
  /// Otwiera plik Storage na urządzeniu użytkownika.
  ///
  /// `null` oznacza, że platforma przyjęła plik; porażka jest zwracana, a nie
  /// rzucana, żeby UI mogło pokazać kod i `traceId` zamiast pustego ekranu.
  Future<ChatAttachmentAccessFailure?> open(String storageFileId);

  /// Pobiera bajty pliku tym samym autoryzowanym adresem (miniatura obrazu).
  ///
  /// `null` oznacza, że miniatury nie da się pokazać; karta wraca wtedy do
  /// ikony pliku i nie pokazuje użytkownikowi fałszywego podglądu.
  Future<Uint8List?> thumbnail(String storageFileId);
}
