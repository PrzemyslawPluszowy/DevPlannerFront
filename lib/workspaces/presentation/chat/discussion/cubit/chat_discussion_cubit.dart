import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/discussion/cubit/chat_discussion_state.dart';

/// Lokalny owner rozwiązania nazwanej dyskusji dla jednego prawego panelu.
final class ChatDiscussionCubit extends Cubit<ChatDiscussionState> {
  ChatDiscussionCubit(this._repository) : super(const ChatDiscussionIdle());

  final ChatDiscussionRepository _repository;

  Future<void> open({
    required ChatConversation parentConversation,
    required String rootMessageId,
    required String name,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || isClosed) return;
    emit(const ChatDiscussionResolving());
    final result = await _repository.resolveDiscussion(
      parentConversation: parentConversation,
      rootMessageId: rootMessageId,
      name: trimmedName,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(_errorState(error)),
      (conversation) => emit(ChatDiscussionReady(conversation)),
    );
  }

  ChatDiscussionState _errorState(ApiError error) =>
      error.type == ApiErrorType.unauthorized ||
          error.type == ApiErrorType.forbidden
      ? ChatDiscussionDetached(error.message)
      : ChatDiscussionFailure(error.message);
}
