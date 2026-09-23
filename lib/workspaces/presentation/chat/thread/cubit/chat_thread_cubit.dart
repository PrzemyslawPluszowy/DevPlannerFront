import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mały owner historii jednego wątku, bez stanu całej rozmowy.
final class ChatThreadCubit extends Cubit<ChatThreadState> {
  ChatThreadCubit(
    this._repository, {
    required ChatConversationRepository deliveryRepository,
    required this.conversationId,
    required this.threadRootMessageId,
  }) : _deliveryQueue = ChatMessageDeliveryQueue(deliveryRepository),
       super(const ChatThreadLoading()) {
    _deliverySubscription = _deliveryQueue.changes.listen(_onDeliveryChanged);
  }
  final ChatThreadRepository _repository;
  final ChatMessageDeliveryQueue _deliveryQueue;
  final String conversationId;
  final String threadRootMessageId;
  late final StreamSubscription<ChatMessage> _deliverySubscription;
  Future<void> load() async {
    final result = await _repository.listThreadMessages(
      conversationId: conversationId,
      threadRootMessageId: threadRootMessageId,
    );
    if (isClosed) return;
    result.fold(
      (error) {
        if (error.type == ApiErrorType.unauthorized ||
            error.type == ApiErrorType.forbidden) {
          emit(ChatThreadDetached(error.message));
        } else {
          emit(ChatThreadFailure(error.message));
        }
      },
      (page) => emit(
        ChatThreadReady(messages: page.items, nextCursor: page.nextCursor),
      ),
    );
  }

  void sendDraft(ChatComposerDraft draft) {
    if (isClosed || draft.isEmpty || state is! ChatThreadReady) return;
    _replace(
      _deliveryQueue.enqueue(
        conversationId: conversationId,
        draft: draft.copyWith(replyToMessageId: threadRootMessageId),
      ),
    );
  }

  void retry(String clientMessageId) => _deliveryQueue.retry(clientMessageId);

  /// Podmienia wiadomość po zatwierdzonej edycji lub soft-delete.
  void applyMessageActionResult(ChatMessage message) {
    if (isClosed) return;
    _replace(message);
  }

  /// Zatrzymuje lokalną kolejkę po cofnięciu dostępu do wiadomości.
  void detachForMessageAction() {
    if (isClosed) return;
    _deliveryQueue.clear();
    emit(const ChatThreadDetached(''));
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ChatThreadReady ||
        current.nextCursor == null ||
        current.isLoadingMore) {
      return;
    }
    emit(
      ChatThreadReady(
        messages: current.messages,
        nextCursor: current.nextCursor,
        isLoadingMore: true,
      ),
    );
    final result = await _repository.listThreadMessages(
      conversationId: conversationId,
      threadRootMessageId: threadRootMessageId,
      cursor: current.nextCursor,
    );
    if (isClosed || state is! ChatThreadReady) {
      return;
    }
    result.fold(
      (error) {
        if (error.type == ApiErrorType.unauthorized ||
            error.type == ApiErrorType.forbidden) {
          _deliveryQueue.clear();
          emit(ChatThreadDetached(error.message));
          return;
        }
        emit(
          ChatThreadReady(
            messages: current.messages,
            nextCursor: current.nextCursor,
            loadMoreFailed: true,
          ),
        );
      },
      (page) => emit(
        ChatThreadReady(
          messages: _merge((state as ChatThreadReady).messages, page.items),
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  void _onDeliveryChanged(ChatMessage message) {
    if (!isClosed &&
        message.conversationId == conversationId &&
        message.replyToMessageId == threadRootMessageId) {
      _replace(message);
    }
  }

  void _replace(ChatMessage message) {
    final current = state;
    if (current is ChatThreadReady && !isClosed) {
      emit(
        ChatThreadReady(
          messages: _merge(current.messages, [message]),
          nextCursor: current.nextCursor,
        ),
      );
    }
  }

  List<ChatMessage> _merge(
    List<ChatMessage> current,
    List<ChatMessage> incoming,
  ) {
    final merged = List<ChatMessage>.of(current);
    for (final message in incoming) {
      final index = merged.indexWhere(
        (item) =>
            item.id == message.id ||
            item.clientMessageId == message.clientMessageId,
      );
      if (index < 0) {
        merged.add(message);
      } else {
        merged[index] = message;
      }
    }
    return List<ChatMessage>.unmodifiable(merged);
  }

  @override
  Future<void> close() async {
    await _deliverySubscription.cancel();
    await _deliveryQueue.dispose();
    return super.close();
  }
}
