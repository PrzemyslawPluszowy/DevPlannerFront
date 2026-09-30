import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_reducer.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';

/// Właściciel lokalnych subskrypcji historii i utraty dostępu jednego wątku.
final class ChatThreadRealtimeCoordinator {
  ChatThreadRealtimeCoordinator({
    required this.conversationId,
    required this.threadRootMessageId,
    required this.currentMessages,
    required this.currentRoot,
    required this.applyRoot,
    required this.applyMessages,
    required this.reload,
    required this.detach,
    required this.isClosed,
    Stream<ChatConversationRealtimeEvent>? events,
    Stream<ChatConversationState>? parentStates,
  }) {
    _events = events?.listen(_onEvent);
    _parentStates = parentStates?.listen((state) {
      if (state is ChatConversationDetached && !isClosed()) detach();
    });
  }

  final String conversationId;
  final String threadRootMessageId;
  final List<ChatMessage>? Function() currentMessages;
  final ChatMessage? Function() currentRoot;
  final void Function(ChatMessage) applyRoot;
  final void Function(List<ChatMessage>) applyMessages;
  final Future<void> Function() reload;
  final void Function() detach;
  final bool Function() isClosed;
  final ChatConversationRealtimeReducer _reducer =
      ChatConversationRealtimeReducer();
  StreamSubscription<ChatConversationRealtimeEvent>? _events;
  StreamSubscription<ChatConversationState>? _parentStates;
  bool _reloadInFlight = false;
  bool _reloadPending = false;
  bool _disposed = false;
  final List<ChatConversationRealtimeEvent> _bufferedEvents = [];
  bool _bufferOverflow = false;

  /// Redukuje zdarzenia odebrane po uchwyceniu snapshotu pierwszego requestu.
  void historyLoaded() {
    final pending = List<ChatConversationRealtimeEvent>.of(_bufferedEvents);
    _bufferedEvents.clear();
    pending.forEach(_onEvent);
    if (_bufferOverflow) {
      _bufferOverflow = false;
      unawaited(_reload());
    }
  }

  void _onEvent(ChatConversationRealtimeEvent event) {
    if (_disposed || isClosed() || event.conversationId != conversationId) {
      return;
    }
    final messages = currentMessages();
    if (messages == null) {
      if (_bufferedEvents.length < 256) {
        _bufferedEvents.add(event);
      } else {
        _bufferOverflow = true;
      }
      return;
    }
    final reduction = _reducer.apply(messages: messages, event: event);
    switch (reduction.decision) {
      case ChatConversationRealtimeDecision.applied:
        final root = currentRoot();
        if (event.message?.id == threadRootMessageId) {
          applyRoot(event.message!);
        } else if (event.kind ==
                ChatConversationRealtimeEventKind.messageDeleted &&
            event.messageId == threadRootMessageId &&
            root != null &&
            event.messageVersion != null &&
            event.messageVersion! >= root.version) {
          applyRoot(root.copyWithDeletion(version: event.messageVersion!));
        }
        applyMessages(reduction.messages.where(_belongsToThread).toList());
      case ChatConversationRealtimeDecision.refreshMessageDelivery:
      case ChatConversationRealtimeDecision.refreshMessageSnapshot:
      case ChatConversationRealtimeDecision.refreshConversation:
      case ChatConversationRealtimeDecision.resyncRequired:
        unawaited(_reload());
      case ChatConversationRealtimeDecision.ignored:
        break;
    }
  }

  bool _belongsToThread(ChatMessage message) =>
      message.threadRootMessageId == threadRootMessageId ||
      message.replyToMessageId == threadRootMessageId;

  Future<void> _reload() async {
    _reloadPending = true;
    if (_reloadInFlight) return;
    _reloadInFlight = true;
    try {
      do {
        _reloadPending = false;
        if (_disposed || isClosed()) return;
        await reload();
      } while (_reloadPending && !_disposed && !isClosed());
    } finally {
      _reloadInFlight = false;
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    _bufferedEvents.clear();
    await _events?.cancel();
    await _parentStates?.cancel();
    _reducer.clear();
  }
}
