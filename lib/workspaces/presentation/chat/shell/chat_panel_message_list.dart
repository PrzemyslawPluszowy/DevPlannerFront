import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_read_tracker.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_grouping.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_visibility.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_message_target_scroller.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_message_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SelectedContent;

/// Zwarta lista wiadomości używana wyłącznie w prawym panelu Chat.
final class ChatPanelMessageList extends StatefulWidget {
  const ChatPanelMessageList({
    required this.messages,
    required this.isSending,
    required this.nextCursor,
    required this.isLoadingMore,
    required this.loadMoreFailed,
    this.readAcknowledgementEnabled = true,
    required this.onLoadMore,
    required this.onNewestMessageVisible,
    required this.onReply,
    required this.onEnsureTargetLoaded,
    this.onThread,
    this.targetMessageId,
    this.canModerate = false,
    this.participantLabels = const <String, String>{},
    this.participantAvatarUrls = const <String, String?>{},
    this.compact = true,
    super.key,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  /// Whether lifecycle and route visibility allow a read ACK.
  final bool readAcknowledgementEnabled;
  final Future<void> Function() onLoadMore;
  final Future<ChatReadMarkOutcome> Function(String messageId)
  onNewestMessageVisible;
  final ValueChanged<ChatMessage> onReply;
  final Future<void> Function(String messageId) onEnsureTargetLoaded;

  /// Otwiera wątek wiadomości.
  final ValueChanged<ChatMessage>? onThread;

  /// Wiadomość, do której widok ma przewinąć po otwarciu z wyszukiwania.
  final String? targetMessageId;

  /// Etykiety autorów z katalogu; w DM mapa jest pusta, więc autor się nie pokazuje.
  final Map<String, String> participantLabels;

  /// Adresy avatarów autorów potwierdzone przez katalog uczestników.
  final Map<String, String?> participantAvatarUrls;

  /// Czy rola pozwala moderować cudzą treść; backend i tak egzekwuje ponownie.
  final bool canModerate;

  /// Tryb compact: mniejszy gutter historii i szersze dymki w panelu.
  final bool compact;

  @override
  State<ChatPanelMessageList> createState() => _ChatPanelMessageListState();
}

class _ChatPanelMessageListState extends State<ChatPanelMessageList> {
  /// Odległość od dolnej krawędzi, przy której uznajemy, że użytkownik ją widzi.
  static const double _bottomThreshold = 24;
  static const double _historyEdgeThreshold = 180;

  final GlobalKey _targetKey = GlobalKey();
  final GlobalKey _newestMessageKey = GlobalKey();
  final GlobalKey _viewportKey = GlobalKey();
  final ScrollController _scroll = ScrollController();
  late final ChatMessageTargetScroller _targetScroller;
  bool _atBottom = true;
  int _pendingNew = 0;
  String? _autoRequestedCursor;
  String? _reportedNewestMessageId;
  Timer? _readRetryTimer;
  String? _readRetryMessageId;
  int _readRetryAttempts = 0;
  bool _visibilityCheckScheduled = false;
  bool _hasTextSelection = false;
  String? _replyTargetMessageId;

  void _onSelectionChanged(SelectedContent? content) {
    final hasSelection = content?.plainText.isNotEmpty ?? false;
    if (hasSelection == _hasTextSelection || !mounted) return;
    setState(() => _hasTextSelection = hasSelection);
  }

  @override
  void initState() {
    super.initState();
    _targetScroller = ChatMessageTargetScroller(
      scroll: _scroll,
      targetKey: _targetKey,
      isMounted: () => mounted,
    );
    _scheduleScrollToTarget();
    _scroll.addListener(_onScroll);
    FocusManager.instance.addListener(_scheduleVisibilityCheck);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadMore());
    _scheduleVisibilityCheck();
  }

  @override
  void dispose() {
    _targetScroller.dispose();
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _readRetryTimer?.cancel();
    FocusManager.instance.removeListener(_scheduleVisibilityCheck);
    super.dispose();
  }

  /// Lista jest odwrócona, więc dół historii to pozycja zerowa.
  void _onScroll() {
    _maybeLoadMore();
    _scheduleVisibilityCheck();
    final atBottom = !_scroll.hasClients || _scroll.offset <= _bottomThreshold;
    if (atBottom != _atBottom || (atBottom && _pendingNew != 0)) {
      setState(() {
        _atBottom = atBottom;
        if (atBottom) _pendingNew = 0;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleVisibilityCheck();
  }

  void _scheduleVisibilityCheck() {
    if (_visibilityCheckScheduled) return;
    _visibilityCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visibilityCheckScheduled = false;
      if (!mounted) return;
      if (!widget.readAcknowledgementEnabled) {
        _reportedNewestMessageId = null;
        _cancelReadRetry();
        return;
      }
      if (widget.messages.isEmpty) {
        _reportedNewestMessageId = null;
        _cancelReadRetry();
        return;
      }
      if (ModalRoute.of(context)?.isCurrent == false) {
        _reportedNewestMessageId = null;
        _cancelReadRetry();
        return;
      }
      final messageId = widget.messages.last.id;
      final messageObject = _newestMessageKey.currentContext
          ?.findRenderObject();
      final viewportObject = _viewportKey.currentContext?.findRenderObject();
      if (messageObject is! RenderBox ||
          viewportObject is! RenderBox ||
          !messageObject.attached ||
          !viewportObject.attached ||
          messageObject.size.isEmpty ||
          viewportObject.size.isEmpty) {
        _reportedNewestMessageId = null;
        _cancelReadRetry();
        return;
      }
      final messageRect =
          messageObject.localToGlobal(Offset.zero) & messageObject.size;
      final viewportRect =
          viewportObject.localToGlobal(Offset.zero) & viewportObject.size;
      final isVisible = ChatMessageVisibility.isMajorityVisible(
        messageRect,
        viewportRect,
      );
      if (!isVisible) {
        _reportedNewestMessageId = null;
        _cancelReadRetry();
        return;
      }
      if (_reportedNewestMessageId == messageId) return;
      if (_readRetryMessageId != messageId) {
        _readRetryTimer?.cancel();
        _readRetryMessageId = messageId;
        _readRetryAttempts = 0;
      }
      _reportedNewestMessageId = messageId;
      unawaited(_markNewestMessageRead(messageId));
    });
  }

  Future<void> _markNewestMessageRead(String messageId) async {
    final outcome = await widget.onNewestMessageVisible(messageId);
    if (!mounted || _readRetryMessageId != messageId) return;
    if (outcome != ChatReadMarkOutcome.failed || _readRetryAttempts >= 3) {
      _readRetryTimer?.cancel();
      _readRetryTimer = null;
      return;
    }

    final delay = Duration(seconds: 1 << _readRetryAttempts);
    _readRetryAttempts++;
    _readRetryTimer?.cancel();
    _readRetryTimer = Timer(delay, () {
      if (!mounted || _readRetryMessageId != messageId) return;
      _reportedNewestMessageId = null;
      _scheduleVisibilityCheck();
    });
  }

  void _cancelReadRetry() {
    _readRetryTimer?.cancel();
    _readRetryTimer = null;
    _readRetryMessageId = null;
    _readRetryAttempts = 0;
  }

  /// Pobiera starszą stronę, gdy użytkownik dochodzi do górnej krawędzi.
  ///
  /// Cursor jest traktowany jako nieprzezroczysty klucz; ta sama strona nie
  /// jest automatycznie żądana wielokrotnie po błędzie.
  void _maybeLoadMore() {
    if (!_scroll.hasClients ||
        widget.nextCursor == null ||
        widget.isLoadingMore ||
        widget.loadMoreFailed) {
      return;
    }
    final position = _scroll.position;
    if (position.maxScrollExtent - position.pixels > _historyEdgeThreshold) {
      return;
    }
    final cursor = widget.nextCursor!;
    if (_autoRequestedCursor == cursor) return;
    _autoRequestedCursor = cursor;
    unawaited(widget.onLoadMore());
  }

  void _retryLoadMore() {
    final cursor = widget.nextCursor;
    if (cursor == null || widget.isLoadingMore) return;
    _autoRequestedCursor = cursor;
    unawaited(widget.onLoadMore());
  }

  /// Wraca do najnowszych wiadomości i czyści licznik nowych.
  Future<void> _jumpToLatest() async {
    if (!_scroll.hasClients) return;
    setState(() => _pendingNew = 0);
    await _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(covariant ChatPanelMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.readAcknowledgementEnabled !=
        widget.readAcknowledgementEnabled) {
      if (widget.readAcknowledgementEnabled) {
        _scheduleVisibilityCheck();
      } else {
        _reportedNewestMessageId = null;
        _cancelReadRetry();
      }
    }
    _scheduleVisibilityCheck();
    if (oldWidget.nextCursor != widget.nextCursor ||
        oldWidget.isLoadingMore != widget.isLoadingMore ||
        oldWidget.loadMoreFailed != widget.loadMoreFailed) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadMore());
    }
    if (oldWidget.targetMessageId != widget.targetMessageId) {
      _replyTargetMessageId = null;
    }
    _scheduleScrollToTarget();
    // Wiadomość, która przyszła, gdy użytkownik czyta starszy fragment, nigdy
    // nie przewija mu widoku; tylko liczy się do wskaźnika nad dolną krawędzią.
    final added = ChatMessageGrouping.countNewArrivals(
      oldWidget.messages,
      widget.messages,
    );
    if (added > 0 && !_atBottom) {
      _pendingNew += added;
    }
  }

  /// Przewija do wiadomości z wyszukiwania, gdy ta jest już zbudowana.
  ///
  /// Lista panelu buduje wiersze leniwie, więc skok działa w ramach
  /// załadowanej historii; pozycję spoza strony otwiera doładowanie historii.
  void _scheduleScrollToTarget() {
    final target = _replyTargetMessageId ?? widget.targetMessageId;
    if (target != null &&
        !widget.messages.any((message) => message.id == target)) {
      return;
    }
    _targetScroller.schedule(target, messageCount: widget.messages.length);
  }

  void _openReplyTarget(String messageId) {
    setState(() {
      _replyTargetMessageId = messageId;
    });
    unawaited(widget.onEnsureTargetLoaded(messageId));
    _scheduleScrollToTarget();
  }

  @override
  Widget build(BuildContext context) {
    return ChatPanelMessageListView(
      list: widget,
      scrollController: _scroll,
      viewportKey: _viewportKey,
      newestMessageKey: _newestMessageKey,
      targetKey: _targetKey,
      pendingNew: _pendingNew,
      replyTargetMessageId: _replyTargetMessageId,
      hasTextSelection: _hasTextSelection,
      onSelectionChanged: _onSelectionChanged,
      onRetryLoadMore: _retryLoadMore,
      onJumpToLatest: _jumpToLatest,
      onOpenReplyTarget: _openReplyTarget,
    );
  }
}
