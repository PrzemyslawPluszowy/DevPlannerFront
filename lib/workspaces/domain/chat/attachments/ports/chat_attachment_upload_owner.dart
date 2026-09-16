import 'package:ready_next/workspaces/domain/chat/attachments/models/chat_attachment_prepared_file.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';

/// Lifecycle jednego pliku należącego do kolejki composera.
///
/// Port pozwala kolejce agregować zaakceptowane pliki bez znajomości HTTP,
/// ticketów Storage ani konkretnej implementacji Cubita pojedynczego uploadu.
abstract interface class ChatAttachmentUploadOwner {
  /// Rozpoczyna przygotowanie jednego, wcześniej zaakceptowanego pliku.
  Future<void> start(String conversationId, StorageUploadInput input);

  /// Jest dostępny wyłącznie po zakończonym `Clean+Ready`.
  ChatAttachmentPreparedFile? get preparedFile;

  /// Unieważnia sesję i zatrzymuje polling niegotowego pliku.
  Future<void> revoke();

  /// Zwalnia sesję dopiero po potwierdzonym wysłaniu wiadomości.
  void markConsumed(String sessionId);

  /// Kończy lokalny lifecycle ownera.
  Future<void> close();
}
