import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';

/// Port zarządzania rozmowami: tworzenie, szczegóły, archiwum i opuszczenie.
///
/// Port jest osobny od skrzynki i historii, bo zmienia lifecycle rozmowy, a nie
/// jej treść. Idempotencję tworzenia rozmowy 1:1 egzekwuje backend.
abstract interface class ChatConversationManagementRepository {
  /// Tworzy albo zwraca istniejącą rozmowę dla wskazanego zakresu.
  Future<Either<ApiError, ChatConversation>> createConversation(
    ChatConversationCreateCommand command,
  );

  /// Zmienia nazwę i politykę publikacji rozmowy.
  Future<Either<ApiError, ChatConversation>> updateDetails({
    required String conversationId,
    required String? name,
    required String postingPermission,
  });

  /// Archiwizuje rozmowę dla wszystkich jej członków.
  Future<Either<ApiError, void>> archiveConversation(String conversationId);

  /// Przywraca zarchiwizowaną rozmowę.
  Future<Either<ApiError, void>> restoreConversation(String conversationId);

  /// Opuszcza rozmowę bieżącym użytkownikiem.
  Future<Either<ApiError, void>> leaveConversation(String conversationId);

  /// Zwraca zarchiwizowane rozmowy użytkownika.
  Future<Either<ApiError, List<ChatConversation>>> listArchivedConversations();
}
