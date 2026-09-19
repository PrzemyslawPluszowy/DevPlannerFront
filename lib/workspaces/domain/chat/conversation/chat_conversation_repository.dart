import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';

/// Kontrakt historii i dostawy jednej rozmowy, odseparowany od listy drawera.
abstract interface class ChatConversationRepository {
  /// Pobiera aktualny snapshot rozmowy oraz sprawdza jej bieżące uprawnienia.
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  );

  /// Pobiera stronę historii bez ukrywania kursora zwróconego przez backend.
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  });

  /// Wysyła intencję o stabilnym `clientMessageId` dla idempotentnego retry.
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  );
}
