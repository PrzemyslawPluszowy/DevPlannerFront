import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';

/// Posiada subskrypcje SignalR i odświeża autorytatywne delivery ACK.
final class ChatConversationRealtimeCoordinator {
  ChatConversationRealtimeCoordinator({
    required this.conversationId,
    required this.repository,
    required this.realtime,
    required this.isClosed,
    required this.currentState,
    required this.emitReady,
    required this.detach,
    required this.replaceMessage,
    required this.resync,
  });

  final String conversationId;
  final ChatConversationRepository repository;
  final ChatConversationRealtimeClient? realtime;
  final bool Function() isClosed;
  final ChatConversationState Function() currentState;
  final void Function(ChatConversationReady state) emitReady;
  final void Function(String message) detach;
  final void Function(ChatMessage message) replaceMessage;
  final Future<void> Function() resync;

  final ChatConversationRealtimeReducer _reducer =
      ChatConversationRealtimeReducer();
  final Set<String> _messageRefreshInFlight = <String>{};
  final Set<String> _messageRefreshPending = <String>{};
  final Set<String> _readCursorRefreshPending = <String>{};
  bool _readCursorRefreshInFlight = false;
  bool _conversationRefreshInFlight = false;
  bool _conversationRefreshPending = false;
  StreamSubscription<ChatConversationRealtimeEvent>? _events;
  StreamSubscription<ChatConversationRealtimeError>? _errors;

  /// Stan pisania należy do lifecycle tej samej dzierżawy realtime.
  Future<void> notifyTyping(bool isTyping) async {
    if (isClosed()) return;
    try {
      await realtime?.setTyping(isTyping);
    } on Object {
      // Sygnał ulotny nie może przerwać edycji po zerwaniu połączenia.
    }
  }

  Future<void> start() async {
    final service = realtime;
    if (service == null || _events != null || isClosed()) return;
    try {
      _events = service.conversationEvents.listen(_onEvent);
      _errors = service.conversationErrors.listen((error) {
        if (error.kind == ChatConversationRealtimeErrorKind.accessRevoked) {
          detach(error.message);
          return;
        }
        final current = currentState();
        if (isClosed() || current is! ChatConversationReady) return;
        emitReady(current.copyWith(realtimeError: error.message));
      });
      await service.start(conversationId);
    } on Object catch (error) {
      await stop();
      final current = currentState();
      if (!isClosed() && current is ChatConversationReady) {
        emitReady(current.copyWith(realtimeError: error.toString()));
      }
    }
  }

  void _onEvent(ChatConversationRealtimeEvent event) {
    final current = currentState();
    if (isClosed() ||
        current is! ChatConversationReady ||
        event.conversationId != conversationId) {
      return;
    }
    // Okno historii ignoruje nowe/edytowane wpisy, ale przyjmuje ACK oraz
    // usunięcia, które muszą też wyczyścić cytaty zapamiętane w odpowiedziach.
    if (current.isWindowedHistory &&
        event.kind !=
            ChatConversationRealtimeEventKind.messageDeliveryChanged &&
        event.kind !=
            ChatConversationRealtimeEventKind.messageSnapshotChanged &&
        event.kind != ChatConversationRealtimeEventKind.conversationChanged &&
        event.kind !=
            ChatConversationRealtimeEventKind.conversationPinsChanged &&
        event.kind != ChatConversationRealtimeEventKind.messageDeleted) {
      return;
    }
    final reduction = _reducer.apply(messages: current.messages, event: event);
    switch (reduction.decision) {
      case ChatConversationRealtimeDecision.applied:
        emitReady(current.copyWith(messages: reduction.messages));
      case ChatConversationRealtimeDecision.ignored:
        return;
      case ChatConversationRealtimeDecision.refreshMessageDelivery:
        final messageId = event.messageId;
        if (messageId != null &&
            current.messages.any((message) => message.id == messageId)) {
          if (event.isReadReceipt) {
            unawaited(_refreshReadCursor(messageId));
          } else {
            unawaited(_refreshMessageSnapshot(messageId));
          }
        }
        return;
      case ChatConversationRealtimeDecision.refreshMessageSnapshot:
        final messageId = event.messageId;
        if (messageId != null &&
            current.messages.any((message) => message.id == messageId)) {
          unawaited(_refreshMessageSnapshot(messageId));
        }
        return;
      case ChatConversationRealtimeDecision.refreshConversation:
        unawaited(_refreshConversation());
        return;
      case ChatConversationRealtimeDecision.resyncRequired:
        unawaited(resync());
    }
  }

  Future<void> _refreshReadCursor(String cursorMessageId) async {
    if (!_readCursorRefreshPending.add(cursorMessageId) &&
        _readCursorRefreshInFlight) {
      return;
    }
    if (_readCursorRefreshInFlight) return;
    _readCursorRefreshInFlight = true;
    try {
      while (_readCursorRefreshPending.isNotEmpty && !isClosed()) {
        final current = currentState();
        if (current is! ChatConversationReady) return;
        final pendingIds = _readCursorRefreshPending.toSet();
        _readCursorRefreshPending.clear();
        final cursorIndexes = pendingIds
            .map(
              (id) =>
                  current.messages.indexWhere((message) => message.id == id),
            )
            .where((index) => index >= 0)
            .toList(growable: false);
        if (cursorIndexes.isEmpty) continue;
        final lastAffectedIndex = cursorIndexes.reduce((a, b) => a > b ? a : b);
        final affected = current.messages
            .take(lastAffectedIndex + 1)
            .where(
              (message) =>
                  !message.id.startsWith('local:') && !message.isDeleted,
            )
            .toList(growable: false);
        final affectedIds = affected.map((message) => message.id).toSet();

        // A server window can contain at most 50 messages on either side.
        // Center each 101-message segment on its middle row so every currently
        // loaded receipt affected by the cursor can be refreshed in a bounded
        // number of requests, including paged and windowed histories.
        for (var start = 0; start < affected.length; start += 101) {
          final anchorIndex = (start + 50).clamp(0, affected.length - 1);
          final anchor = affected[anchorIndex];
          final latest = currentState();
          if (isClosed() || latest is! ChatConversationReady) return;
          final result = await repository.loadMessageWindow(
            conversationId: conversationId,
            messageId: anchor.id,
            before: 50,
            after: 50,
          );
          if (isClosed() || currentState() is! ChatConversationReady) return;
          result.fold(
            (error) {
              if (error.type == ApiErrorType.unauthorized ||
                  error.type == ApiErrorType.forbidden) {
                detach(error.message);
              }
            },
            (window) {
              for (final message in window.messages) {
                if (affectedIds.contains(message.id)) replaceMessage(message);
              }
            },
          );
        }
      }
    } finally {
      _readCursorRefreshPending.clear();
      _readCursorRefreshInFlight = false;
    }
  }

  Future<void> _refreshMessageSnapshot(String messageId) async {
    if (!_messageRefreshInFlight.add(messageId)) {
      _messageRefreshPending.add(messageId);
      return;
    }
    try {
      do {
        _messageRefreshPending.remove(messageId);
        final current = currentState();
        if (isClosed() ||
            current is! ChatConversationReady ||
            !current.messages.any((message) => message.id == messageId)) {
          return;
        }
        final result = await repository.loadMessageWindow(
          conversationId: conversationId,
          messageId: messageId,
        );
        if (isClosed() || currentState() is! ChatConversationReady) return;
        result.fold(
          (error) {
            if (error.type == ApiErrorType.unauthorized ||
                error.type == ApiErrorType.forbidden) {
              detach(error.message);
            }
          },
          (window) {
            final latest = currentState();
            final refreshed = window.messages
                .where((message) => message.id == messageId)
                .firstOrNull;
            if (latest is ChatConversationReady && refreshed != null) {
              replaceMessage(refreshed);
            }
          },
        );
      } while (_messageRefreshPending.contains(messageId) && !isClosed());
    } finally {
      _messageRefreshInFlight.remove(messageId);
      _messageRefreshPending.remove(messageId);
    }
  }

  Future<void> _refreshConversation() async {
    if (_conversationRefreshInFlight) {
      _conversationRefreshPending = true;
      return;
    }
    _conversationRefreshInFlight = true;
    try {
      do {
        _conversationRefreshPending = false;
        final result = await repository.getConversation(conversationId);
        if (isClosed()) return;
        result.fold(
          (error) {
            if (error.type == ApiErrorType.unauthorized ||
                error.type == ApiErrorType.forbidden) {
              detach(error.message);
              return;
            }
            final current = currentState();
            if (current is ChatConversationReady) {
              emitReady(current.copyWith(realtimeError: error.message));
            }
          },
          (conversation) {
            final current = currentState();
            if (current is ChatConversationReady) {
              emitReady(current.copyWith(conversation: conversation));
            }
          },
        );
      } while (_conversationRefreshPending && !isClosed());
    } finally {
      _conversationRefreshPending = false;
      _conversationRefreshInFlight = false;
    }
  }

  Future<void> stop() async {
    await _events?.cancel();
    _events = null;
    await _errors?.cancel();
    _errors = null;
    _reducer.clear();
    await realtime?.stop();
  }
}
