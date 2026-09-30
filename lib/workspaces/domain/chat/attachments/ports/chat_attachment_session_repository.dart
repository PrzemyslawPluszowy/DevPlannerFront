import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/models/chat_attachment_prepared_file.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/models/chat_attachment_session.dart';

/// Kontrakt wydania i anulowania prywatnej sesji uploadu Chat.
abstract interface class ChatAttachmentSessionRepository {
  /// Wydaje krótką sesję powiązaną wyłącznie z jedną rozmową i użytkownikiem.
  Future<Either<ApiError, ChatAttachmentSession>> createAttachmentSession(
    String conversationId,
  );

  /// Kopiuje wyłącznie własny, Clean+Ready plik prywatny do aktywnej sesji.
  Future<Either<ApiError, ChatAttachmentPreparedFile>> copyPrivateFileToSession({
    required String conversationId,
    required String sessionId,
    required String sourceStorageFileId,
  });

  /// Anuluje niezużytą sesję; backend pozostaje źródłem autoryzacji i cleanupu.
  Future<Either<ApiError, void>> cancelAttachmentSession({
    required String conversationId,
    required String sessionId,
  });
}
