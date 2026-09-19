import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:equatable/equatable.dart';

/// Lifecycle lokalnego załącznika; publikacja wymaga potwierdzenia `clean`.
enum ChatAttachmentStatus { processing, scanning, clean, infected, failed }

/// Typowa reprezentacja pliku wybranego przed powstaniem kontraktu uploadu Chat.
final class ChatAttachment extends Equatable {
  /// Tworzy lokalny załącznik gotowy do przyszłego przetwarzania.
  const ChatAttachment({
    required this.localId,
    required this.input,
    this.status = ChatAttachmentStatus.processing,
  });

  /// Identyfikator lokalny; nie jest identyfikatorem pliku Storage.
  final String localId;

  /// Metadane i bajty/ścieżka dostarczone przez neutralny adapter platformy.
  final StorageUploadInput input;

  /// Stan bezpieczeństwa pliku, domyślnie przed skanowaniem.
  final ChatAttachmentStatus status;

  /// Zwraca kopię z wyłącznie dozwoloną zmianą lifecycle.
  ChatAttachment withStatus(ChatAttachmentStatus nextStatus) =>
      ChatAttachment(localId: localId, input: input, status: nextStatus);

  @override
  List<Object?> get props => [localId, input, status];
}
