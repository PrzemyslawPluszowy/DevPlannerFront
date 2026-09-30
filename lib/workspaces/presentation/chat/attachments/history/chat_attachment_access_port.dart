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

  /// Kopiuje załącznik wiadomości do prywatnego Storage bieżącego użytkownika.
  Future<ChatAttachmentSaveResult> saveToStorage({
    required String messageId,
    required String storageFileId,
  });

  /// Pobiera małą miniaturę przez endpoint Chat sprawdzający członkostwo.
  ///
  /// `null` oznacza, że miniatury nie da się pokazać; karta wraca wtedy do
  /// ikony pliku i nie pokazuje użytkownikowi fałszywego podglądu.
  Future<Uint8List?> thumbnail({
    required String messageId,
    required String storageFileId,
  });

  /// Pobiera pełny obraz dopiero po jawnym otwarciu podglądu przez użytkownika.
  Future<Uint8List?> fullImage(String storageFileId);
}

/// Wynik serwerowego zapisu kopii załącznika.
final class ChatAttachmentSaveResult {
  const ChatAttachmentSaveResult({
    this.storageFileId,
    this.fileName,
    this.canEditOnline = false,
    this.failure,
  });

  final String? storageFileId;
  final String? fileName;
  final bool canEditOnline;
  final ChatAttachmentAccessFailure? failure;

  bool get succeeded => storageFileId != null && failure == null;
}
