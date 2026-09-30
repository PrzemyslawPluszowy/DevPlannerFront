import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_read_tracker.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_unread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lista wiadomości panelu oznaczająca odczyt tylko dla widocznego ekranu.
///
/// Widget zna wyłącznie to, co widzi: sam jest zamontowany, a aplikacja ma stan
/// lifecycle. Dopiero na tej podstawie prosi Cubit o oznaczenie odczytu
/// najnowszej cudzej wiadomości — pobranie historii samo w sobie nie wystarcza.
class ChatPanelReadAwareMessages extends StatefulWidget {
  const ChatPanelReadAwareMessages({
    required this.messages,
    required this.isSending,
    required this.nextCursor,
    required this.isLoadingMore,
    required this.loadMoreFailed,
    required this.onLoadMore,
    required this.onReply,
    this.onThread,
    this.targetMessageId,
    this.canModerate = false,
    this.participantLabels = const <String, String>{},
    this.participantAvatarUrls = const <String, String?>{},
    super.key,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final Future<void> Function() onLoadMore;
  final ValueChanged<ChatMessage> onReply;

  /// Otwiera wątek wiadomości; brak oznacza panel bez wątków.
  final ValueChanged<ChatMessage>? onThread;

  /// Wiadomość, do której widok ma przewinąć.
  final String? targetMessageId;

  /// Czy bieżący użytkownik może moderować cudzą treść.
  final bool canModerate;

  /// Etykiety autorów z katalogu; w DM pusta, więc dymek nie pokazuje autora.
  final Map<String, String> participantLabels;

  /// Profile image URLs from the current conversation's participant directory.
  final Map<String, String?> participantAvatarUrls;

  @override
  State<ChatPanelReadAwareMessages> createState() =>
      ChatPanelReadAwareMessagesState();
}

class ChatPanelReadAwareMessagesState extends State<ChatPanelReadAwareMessages>
    with WidgetsBindingObserver {
  AppLifecycleState _lifecycle = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycle = state;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Panel zamontowany i aplikacja na wierzchu to warunek „faktycznie zobaczone”.
  bool get _isVisible => mounted && _lifecycle == AppLifecycleState.resumed;

  Future<ChatReadMarkOutcome> _onNewestMessageVisible(String messageId) async {
    if (!_isVisible || ModalRoute.of(context)?.isCurrent == false) {
      return ChatReadMarkOutcome.ignored;
    }
    return _markVisibleMessageAsRead(messageId);
  }

  Future<ChatReadMarkOutcome> _markVisibleMessageAsRead(
    String messageId,
  ) async {
    final outcome = await context
        .read<ChatConversationCubit>()
        .markVisibleAsRead(messageId);
    if (outcome != ChatReadMarkOutcome.marked || !mounted) return outcome;
    // Odświeżenie strony inboxa aktualizuje unreadCount samej rozmowy oraz
    // globalny licznik; samo refreshUnreadTotal zostawiałoby wiersz jako unread.
    unawaited(context.read<ChatInboxCubit?>()?.refresh());
    unawaited(context.read<ChatUnreadCubit?>()?.refresh());
    return outcome;
  }

  @override
  Widget build(BuildContext context) => ChatPanelMessageList(
    messages: widget.messages,
    isSending: widget.isSending,
    onReply: widget.onReply,
    onThread: widget.onThread,
    targetMessageId: widget.targetMessageId,
    canModerate: widget.canModerate,
    participantLabels: widget.participantLabels,
    participantAvatarUrls: widget.participantAvatarUrls,
    nextCursor: widget.nextCursor,
    isLoadingMore: widget.isLoadingMore,
    loadMoreFailed: widget.loadMoreFailed,
    readAcknowledgementEnabled: _isVisible,
    onLoadMore: widget.onLoadMore,
    onNewestMessageVisible: _onNewestMessageVisible,
    onEnsureTargetLoaded: (messageId) =>
        context.read<ChatConversationCubit>().ensureTargetLoaded(messageId),
  );
}
