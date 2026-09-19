import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_revision.dart';

/// Port kontrolowanych mutacji wiadomości oraz jej historii rewizji.
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
}
