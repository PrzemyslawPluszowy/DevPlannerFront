import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lokalny owner edycji, usunięcia i historii pojedynczej wiadomości.
final class ChatMessageActionsCubit extends Cubit<ChatMessageActionsState> {
  /// Tworzy Cubit oparty wyłącznie na domenowym porcie wiadomości.
  ChatMessageActionsCubit({required this.repository})
    : super(const ChatMessageActionsIdle());

  final ChatMessageActionsRepository repository;
  int _generation = 0;

  /// Wysyła edycję ze snapshotem `Version`, bez optymistycznego nadpisania.
  Future<void> edit({
    required ChatMessage message,
    required String text,
  }) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty || isClosed) return;
    final generation = ++_generation;
    emit(ChatMessageActionsInProgress(message.id));
    final result = await repository.editMessage(
      messageId: message.id,
      text: normalizedText,
      deltaJson: message.deltaJson,
      version: message.version,
    );
    if (isClosed || generation != _generation) return;
    result.fold(
      _emitError,
      (updated) => emit(ChatMessageActionsUpdated(updated)),
    );
  }

  /// Wykonuje soft delete dopiero po potwierdzeniu API.
  Future<void> delete(ChatMessage message) async {
    if (isClosed) return;
    final generation = ++_generation;
    emit(ChatMessageActionsInProgress(message.id));
    final result = await repository.deleteMessage(
      messageId: message.id,
      version: message.version,
    );
    if (isClosed || generation != _generation) return;
    result.fold(
      _emitError,
      (_) => emit(
        ChatMessageActionsDeleted(
          message.copyWithDeletion(version: message.version + 1),
        ),
      ),
    );
  }

  /// Pobiera historię rewizji; nie zmienia treści aktualnej wiadomości.
  Future<void> loadRevisions(String messageId) async {
    if (isClosed) return;
    final generation = ++_generation;
    emit(ChatMessageActionsInProgress(messageId));
    final result = await repository.listRevisions(messageId);
    if (isClosed || generation != _generation) return;
    result.fold(
      _emitError,
      (revisions) => emit(
        ChatMessageActionsRevisions(
          messageId: messageId,
          revisions: List<ChatMessageRevision>.unmodifiable(revisions),
        ),
      ),
    );
  }

  void _emitError(ApiError error) {
    if (isClosed) return;
    if (error.type == ApiErrorType.unauthorized ||
        error.type == ApiErrorType.forbidden) {
      emit(ChatMessageActionsAccessRevoked(error.message));
      return;
    }
    final messageId = switch (state) {
      ChatMessageActionsInProgress(:final messageId) => messageId,
      _ => '',
    };
    if (error.type == ApiErrorType.conflict) {
      emit(
        ChatMessageActionsConflict(
          messageId: messageId,
          message: error.message,
        ),
      );
      return;
    }
    emit(
      ChatMessageActionsFailure(messageId: messageId, message: error.message),
    );
  }
}
