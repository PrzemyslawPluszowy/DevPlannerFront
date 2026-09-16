import 'package:equatable/equatable.dart';

/// Jedyny bezpieczny rezultat przygotowania załącznika do wysłania wiadomości.
///
/// Identyfikator Storage jest ujawniany dopiero po potwierdzonym
/// `Clean+Ready`; `sessionId` pozostaje potrzebny ownerowi aż do potwierdzonej
/// wysyłki wiadomości.
final class ChatAttachmentPreparedFile extends Equatable {
  const ChatAttachmentPreparedFile({
    required this.storageFileId,
    required this.sessionId,
  });

  final String storageFileId;
  final String sessionId;

  @override
  List<Object?> get props => [storageFileId, sessionId];
}
