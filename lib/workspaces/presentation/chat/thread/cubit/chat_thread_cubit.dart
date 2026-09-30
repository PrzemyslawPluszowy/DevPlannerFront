import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_message_merger.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_realtime_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mały owner historii jednego wątku, bez stanu całej rozmowy.
final class ChatThreadCubit extends Cubit<ChatThreadState> {
  ChatThreadCubit(
    this._repository, {
    required ChatConversationRepository deliveryRepository,
    required this.currentUserId,
    required this.conversationId,
    required this.threadRootMessageId,
    Stream<ChatConversationRealtimeEvent>? conversationEvents,
    Stream<ChatConversationState>? parentConversationStates,
    ChatConversationState? initialParentConversationState,
    ChatMessage? rootMessage,
  }) : _deliveryQueue = ChatMessageDeliveryQueue(
         deliveryRepository,
         userId: currentUserId,
       ),
       super(const ChatThreadLoading()) {
    _rootMessage = rootMessage;
    _deliverySubscription = _deliveryQueue.changes.listen(_onDeliveryChanged);
    _realtimeCoordinator = ChatThreadRealtimeCoordinator(
      conversationId: conversationId,
      threadRootMessageId: threadRootMessageId,
      currentMessages: () =>
          state is ChatThreadReady ? (state as ChatThreadReady).messages : null,
      currentRoot: () => _rootMessage,
      applyRoot: _applyRoot,
      applyMessages: _applyRealtimeMessages,
      reload: () => load(preserveHistory: true),
      detach: detachForMessageAction,
      isClosed: () => isClosed || _closing || state is ChatThreadDetached,
      events: conversationEvents,
      parentStates: parentConversationStates,
    );
    if (initialParentConversationState is ChatConversationDetached) {
      detachForMessageAction();
    }
  }
  final ChatThreadRepository _repository;
  final ChatMessageDeliveryQueue _deliveryQueue;
  final String currentUserId;
  final String conversationId;
  final String threadRootMessageId;
  late final StreamSubscription<ChatMessage> _deliverySubscription;
  late final ChatThreadRealtimeCoordinator _realtimeCoordinator;
  int _generation = 0;
  bool _closing = false;
  ChatMessage? _rootMessage;
  ChatMessage? get rootMessage => _rootMessage;

  void _applyRoot(ChatMessage message) {
    final current = state;
    if (_rootMessage != null && message.version < _rootMessage!.version) return;
    _rootMessage = message;
    if (current is ChatThreadReady) _applyRealtimeMessages(current.messages);
  }

  Future<void> load({bool preserveHistory = false}) async {
    if (isClosed || _closing || state is ChatThreadDetached) return;
    final generation = ++_generation;
    final result = await _repository.listThreadMessages(
      conversationId: conversationId,
      threadRootMessageId: threadRootMessageId,
    );
    if (isClosed || _closing || generation != _generation) return;
    result.fold(
      (error) {
        if (error.type == ApiErrorType.unauthorized ||
            error.type == ApiErrorType.forbidden) {
          detachForMessageAction(reason: error.message);
        } else {
          emit(ChatThreadFailure(error.message));
        }
      },
      (page) {
        final latest = state;
        emit(
          ChatThreadReady(
            messages: _merge(
              preserveHistory && latest is ChatThreadReady
                  ? latest.messages
                  : const [],
              page.items,
            ),
            nextCursor: preserveHistory && latest is ChatThreadReady
                ? latest.nextCursor
                : page.nextCursor,
          ),
        );
        _realtimeCoordinator.historyLoaded();
      },
    );
  }

  String? sendDraft(ChatComposerDraft draft) {
    if (isClosed || _closing || draft.isEmpty || state is! ChatThreadReady) {
      return null;
    }
    final message = _deliveryQueue.enqueue(
      conversationId: conversationId,
      draft: draft.copyWith(replyToMessageId: threadRootMessageId),
    );
    _replace(message);
    return message.clientMessageId;
  }

  void retry(String clientMessageId) => _deliveryQueue.retry(clientMessageId);

  /// Podmienia wiadomość po zatwierdzonej edycji lub soft-delete.
  void applyMessageActionResult(ChatMessage message) {
    if (isClosed) return;
    _replace(message);
  }

  /// Zatrzymuje lokalną kolejkę po cofnięciu dostępu do wiadomości.
  void detachForMessageAction({String reason = ''}) {
    if (isClosed) return;
    ++_generation;
    _deliveryQueue.clear();
    emit(ChatThreadDetached(reason));
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ChatThreadReady ||
        current.nextCursor == null ||
        current.isLoadingMore) {
      return;
    }
    final generation = _generation;
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
    if (isClosed ||
        _closing ||
        generation != _generation ||
        state is! ChatThreadReady) {
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
            messages: (state as ChatThreadReady).messages,
            nextCursor: (state as ChatThreadReady).nextCursor,
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
        (message.replyToMessageId == threadRootMessageId ||
            message.threadRootMessageId == threadRootMessageId)) {
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
          isLoadingMore: current.isLoadingMore,
          loadMoreFailed: current.loadMoreFailed,
        ),
      );
    }
  }

  List<ChatMessage> _merge(
    List<ChatMessage> current,
    List<ChatMessage> incoming,
  ) {
    return ChatConversationMessageMerger.merge(current, incoming);
  }

  void _applyRealtimeMessages(List<ChatMessage> messages) {
    final current = state;
    if (isClosed || _closing || current is! ChatThreadReady) return;
    emit(
      ChatThreadReady(
        messages: _merge(const [], messages),
        nextCursor: current.nextCursor,
        isLoadingMore: current.isLoadingMore,
        loadMoreFailed: current.loadMoreFailed,
      ),
    );
  }

  @override
  Future<void> close() async {
    _closing = true;
    ++_generation;
    await _realtimeCoordinator.dispose();
    await _deliverySubscription.cancel();
    await _deliveryQueue.dispose();
    return super.close();
  }
}
