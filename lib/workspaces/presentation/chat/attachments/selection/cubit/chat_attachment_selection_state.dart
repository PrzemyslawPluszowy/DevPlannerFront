import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';

/// Niemutowalny snapshot lokalnego wyboru załączników composera.
sealed class ChatAttachmentSelectionState {
  /// Tworzy aktualny, bezpieczny snapshot wyboru.
  const ChatAttachmentSelectionState();
}

/// Gotowy snapshot; `disposalFailed` nigdy nie przywraca odłączonych plików.
final class ChatAttachmentSelectionReady extends ChatAttachmentSelectionState {
  /// Tworzy snapshot z zaakceptowanymi plikami i ostatnimi odrzuceniami.
  ChatAttachmentSelectionReady({
    List<ChatAttachment> attachments = const <ChatAttachment>[],
    List<ChatAttachmentRejection> rejections =
        const <ChatAttachmentRejection>[],
    this.disposalFailed = false,
  }) : attachments = List.unmodifiable(attachments),
       rejections = List.unmodifiable(rejections);

  /// Pliki zachowane lokalnie; tylko `clean` może trafić do przyszłej wysyłki.
  final List<ChatAttachment> attachments;

  /// Odrzucone elementy ostatniej próby wyboru, bez danych do uploadu.
  final List<ChatAttachmentRejection> rejections;

  /// Informacja diagnostyczna po nieudanej, już odłączonej utylizacji.
  final bool disposalFailed;
}
