import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_revision.dart';

/// Port kontrolowanych mutacji wiadomości oraz jej historii rewizji.
///
/// Port grupuje akcje, które zmieniają istniejącą wiadomość albo prywatny stan
/// użytkownika wobec niej. Każda akcja ma realny skutek w backendzie; UI nie
/// wywołuje pustych callbacków. Konflikty wersji rozstrzyga `version`, a
/// odpowiedź `429` wymaga respektowania `Retry-After`.
abstract interface class ChatMessageActionsRepository {
  /// Edytuje treść przy dokładnej wersji zwróconej w historii rozmowy.
  Future<Either<ApiError, ChatMessage>> editMessage({
    required String messageId,
    required String text,
    required String? deltaJson,
    required int version,
  });

  /// Wykonuje logiczne usunięcie przy dokładnej wersji wiadomości.
  Future<Either<ApiError, void>> deleteMessage({
    required String messageId,
    required int version,
  });

  /// Zwraca historię poprzednich treści widoczną dla członka rozmowy.
  Future<Either<ApiError, List<ChatMessageRevision>>> listRevisions(
    String messageId,
  );

  /// Przekazuje wiadomość do innej rozmowy, do której użytkownik ma dostęp.
  Future<Either<ApiError, ChatMessage>> forwardMessage({
    required String messageId,
    required String targetConversationId,
    required String clientMessageId,
  });

  /// Przypina wiadomość w rozmowie.
  Future<Either<ApiError, ChatPinnedMessage>> pinMessage({
    required String conversationId,
    required String messageId,
  });

  /// Odpina wiadomość w rozmowie.
  Future<Either<ApiError, void>> unpinMessage({
    required String conversationId,
    required String messageId,
  });

  /// Zwraca przypięte wiadomości rozmowy.
  Future<Either<ApiError, List<ChatPinnedMessage>>> listPins(
    String conversationId,
  );

  /// Zapisuje prywatną zakładkę do wiadomości.
  Future<Either<ApiError, ChatBookmark>> bookmarkMessage({
    required String messageId,
    String? note,
  });

  /// Usuwa prywatną zakładkę.
  Future<Either<ApiError, void>> removeBookmark(String messageId);

  /// Zwraca prywatne zakładki bieżącego użytkownika.
  Future<Either<ApiError, List<ChatBookmark>>> listBookmarks();

  /// Dodaje reakcję emoji do wiadomości.
  Future<Either<ApiError, ChatMessageReaction>> addReaction({
    required String messageId,
    required String emoji,
  });

  /// Usuwa własną reakcję emoji z wiadomości.
  Future<Either<ApiError, void>> removeReaction({
    required String messageId,
    required String emoji,
  });

  /// Zwraca reakcje wiadomości widoczne dla członka rozmowy.
  Future<Either<ApiError, List<ChatMessageReaction>>> listReactions(
    String messageId,
  );
}
