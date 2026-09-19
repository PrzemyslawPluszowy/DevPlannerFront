import 'package:devplanner/workspaces/domain/chat/attachments/models/chat_attachment.dart';

/// Przyszła brama usuwania tymczasowych danych załączników po revoke.
///
/// Aktualny etap nie instaluje implementacji, ponieważ backend nie udostępnia
/// bezpiecznego kontraktu porzucenia uploadu Chat.
// Port pozostaje interfejsem, aby adapter nie był callbackiem bez właściciela.
// ignore: one_member_abstracts
abstract interface class ChatAttachmentDisposalPort {
  /// Usuwa tymczasowe dane po ich wcześniejszym lokalnym odłączeniu.
  Future<void> dispose(List<ChatAttachment> attachments);
}
