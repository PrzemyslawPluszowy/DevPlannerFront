/// Świeży, minimalny nagłówek autoryzowanego pliku wyświetlany w Resource Chat.
///
/// Nie jest utrwalany przez globalny kontroler paneli. Żyje wyłącznie w sesji
/// otwartego panelu i jest usuwany po cofnięciu dostępu albo powrocie do listy.
final class ResourceChatFileContext {
  const ResourceChatFileContext({
    required this.fileId,
    required this.fileName,
    required this.ownerUserId,
    required this.accessLevel,
  });

  final String fileId;
  final String fileName;
  final String ownerUserId;
  final String accessLevel;
}
