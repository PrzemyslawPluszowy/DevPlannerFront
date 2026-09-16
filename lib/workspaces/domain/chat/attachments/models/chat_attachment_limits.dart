/// Niezmienialne limity wejścia załączników jednej wiadomości Chat.
final class ChatAttachmentLimits {
  /// Tworzy limity stosowane lokalnie przed jakimkolwiek uploadem.
  const ChatAttachmentLimits({
    this.maxFiles = 20,
    this.maxFileSizeBytes = 50 * 1024 * 1024,
    this.maxMessageSizeBytes = 100 * 1024 * 1024,
  }) : assert(maxFiles > 0, 'maxFiles musi być dodatnie.'),
       assert(maxFileSizeBytes > 0, 'maxFileSizeBytes musi być dodatnie.'),
       assert(
         maxMessageSizeBytes > 0,
         'maxMessageSizeBytes musi być dodatnie.',
       );

  /// Maksymalna liczba plików w jednej wiadomości.
  final int maxFiles;

  /// Maksymalny rozmiar jednego pliku: 50 MiB.
  final int maxFileSizeBytes;

  /// Maksymalny łączny rozmiar plików: 100 MiB.
  final int maxMessageSizeBytes;
}
