import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';

/// Kontrakt rozwiązania nazwanej dyskusji przypiętej do wiadomości źródłowej.
// Jeden kontrakt chroni UI przed transportowym payloadem `resolve`.
// ignore: one_member_abstracts
abstract interface class ChatDiscussionRepository {
  /// Zwraca istniejącą albo utworzoną dyskusję bez budowania URI w UI.
  Future<Either<ApiError, ChatConversation>> resolveDiscussion({
    required ChatConversation parentConversation,
    required String rootMessageId,
    required String name,
  });
}
