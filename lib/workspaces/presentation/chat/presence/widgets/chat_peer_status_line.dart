import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Jedna linia statusu rozmówcy w nagłówku rozmowy 1:1.
///
/// Pokazuje obecność online/offline z snapshotu rozmowy oraz niezależny custom
/// status z REST. Przed pierwszym snapshotem nie zgaduje dostępności.
class ChatPeerStatusLine extends StatefulWidget {
  /// Tworzy linię statusu dla wskazanego użytkownika.
  const ChatPeerStatusLine({required this.userId, super.key});

  /// Kanoniczny UUID rozmówcy.
  final String userId;

  @override
  State<ChatPeerStatusLine> createState() => _ChatPeerStatusLineState();
}

class _ChatPeerStatusLineState extends State<ChatPeerStatusLine> {
  ChatUserStatus? _status;
  int _statusRequestGeneration = 0;
  Timer? _expiryTimer;
  StreamSubscription<ChatConversationPresenceState>? _presenceSubscription;
  ChatUserStatus? _realtimeStatus;
  bool _hasRealtimeStatus = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final presence = context.read<ChatConversationPresenceCubit?>();
    if (_presenceSubscription != null || presence == null) return;
    _applyRealtimeStatus(presence.state);
    _presenceSubscription = presence.stream.listen(_applyRealtimeStatus);
  }

  @override
  void didUpdateWidget(covariant ChatPeerStatusLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _hasRealtimeStatus = false;
      _realtimeStatus = null;
      _expiryTimer?.cancel();
      _expiryTimer = null;
      setState(() => _status = null);
      final presence = context.read<ChatConversationPresenceCubit?>();
      if (presence != null) _applyRealtimeStatus(presence.state);
      unawaited(_load());
    }
  }

  void _applyRealtimeStatus(ChatConversationPresenceState state) {
    if (!state.hasStatusUpdateForUser(widget.userId)) return;
    final status = state.statusForUser(widget.userId);
    if (_hasRealtimeStatus && _realtimeStatus == status) return;
    _hasRealtimeStatus = true;
    _realtimeStatus = status;
    _expiryTimer?.cancel();
    _expiryTimer = null;
    final expiresAtUtc = status?.expiresAtUtc;
    if (expiresAtUtc != null) {
      final delay = expiresAtUtc.difference(DateTime.now().toUtc());
      _expiryTimer = Timer(delay.isNegative ? Duration.zero : delay, () {
        if (!mounted) return;
        setState(() {
          _realtimeStatus = null;
          _status = null;
          _hasRealtimeStatus = false;
        });
        unawaited(_load());
      });
    }
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    final generation = ++_statusRequestGeneration;
    final repository = context.read<ChatPresenceRepository?>();
    if (repository == null || widget.userId.isEmpty) return;
    final result = await repository.getUserStatus(widget.userId);
    if (!mounted || generation != _statusRequestGeneration) return;
    result.fold((_) {}, (status) {
      final nowUtc = DateTime.now().toUtc();
      final activeStatus = status?.isExpiredAt(nowUtc) == true ? null : status;
      _expiryTimer?.cancel();
      final expiresAtUtc = activeStatus?.expiresAtUtc;
      if (expiresAtUtc != null) {
        final delay = expiresAtUtc.difference(nowUtc);
        _expiryTimer = Timer(
          delay.isNegative ? Duration.zero : delay,
          () {
            if (!mounted) return;
            setState(() => _status = null);
            unawaited(_load());
          },
        );
      }
      setState(() => _status = activeStatus);
    });
  }

  @override
  void dispose() {
    _statusRequestGeneration++;
    _expiryTimer?.cancel();
    unawaited(_presenceSubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final livePresence =
        context
            .select<
              ChatConversationPresenceCubit?,
              ChatConversationPresenceState?
            >(
              (cubit) => cubit?.state,
            )
            ?.forUser(widget.userId) ??
        ChatPeerLivePresence.unknown;
    final realtimeStatus = _realtimeStatus;
    final status = _hasRealtimeStatus ? realtimeStatus : _status;
    final chat = context.chatTheme;
    final label = status?.text?.trim();
    final emoji = status?.emoji?.trim();
    final hasEmoji = emoji != null && emoji.isNotEmpty;
    final hasLabel = label != null && label.isNotEmpty;
    final customStatus = [
      if (hasEmoji) emoji,
      if (hasLabel) label,
      if (status?.isDnd == true) context.l10n.chatStatusDnd,
    ].join(' ');
    final presenceLabel = switch (livePresence) {
      ChatPeerLivePresence.online => context.l10n.chatPeerOnline,
      ChatPeerLivePresence.offline => context.l10n.chatPeerOffline,
      ChatPeerLivePresence.unknown => null,
    };
    final text = [
      ?presenceLabel,
      if (customStatus.isNotEmpty) customStatus,
    ].join(' · ');
    if (text.isEmpty) return const SizedBox.shrink();
    final hasLivePresence = livePresence != ChatPeerLivePresence.unknown;
    final color = livePresence == ChatPeerLivePresence.online
        ? chat.presenceOnline
        : chat.metadataText;
    return Row(
      children: [
        if (hasLivePresence) ...[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: chat.metadataStyle.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
