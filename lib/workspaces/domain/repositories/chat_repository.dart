import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';

/// Kontrakt globalnego Chat używany przez overlay i ekran rozmowy.
abstract interface class ChatRepository {
  /// Pobiera aktywne rozmowy bieżącego użytkownika.
  Future<Either<ApiError, List<ChatConversationResponse>>> listConversations();

  /// Pobiera ostatnią stronę wiadomości rozmowy.
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  );

  /// Publikuje wiadomość z idempotency key generowanym przez UI.
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  });
}
