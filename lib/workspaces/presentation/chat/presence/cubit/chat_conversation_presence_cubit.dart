import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChatPeerLivePresence { unknown, online, offline }

final class ChatConversationPresenceState extends Equatable {
  const ChatConversationPresenceState({
    this.snapshot,
    this.userStatuses = const {},
  });

  final ChatConversationPresenceSnapshot? snapshot;
  final Map<String, ChatUserStatus?> userStatuses;

  bool hasStatusUpdateForUser(String userId) =>
      userStatuses.containsKey(userId);

  ChatUserStatus? statusForUser(String userId) => userStatuses[userId];

  ChatPeerLivePresence forUser(String userId) {
    final current = snapshot;
    if (current == null) return ChatPeerLivePresence.unknown;
    return current.onlineUserIds.contains(userId)
        ? ChatPeerLivePresence.online
        : ChatPeerLivePresence.offline;
  }

  @override
  List<Object?> get props => [snapshot, userStatuses];
}

/// Stan online rozmówców z autoryzowanego snapshotu SignalR.
final class ChatConversationPresenceCubit
    extends Cubit<ChatConversationPresenceState> {
  ChatConversationPresenceCubit({
    required ChatConversationRealtimeClient? realtime,
  }) : super(const ChatConversationPresenceState()) {
    _subscription = realtime?.presenceSnapshots.listen(_onSnapshot);
    _statusSubscription = realtime?.userStatusChanges.listen(_onStatusChange);
  }

  StreamSubscription<ChatConversationPresenceSnapshot?>? _subscription;
  StreamSubscription<ChatUserStatusChanged>? _statusSubscription;

  void _onSnapshot(ChatConversationPresenceSnapshot? snapshot) {
    emit(
      ChatConversationPresenceState(
        snapshot: snapshot,
        userStatuses: state.userStatuses,
      ),
    );
  }

  void _onStatusChange(ChatUserStatusChanged change) {
    emit(
      ChatConversationPresenceState(
        snapshot: state.snapshot,
        userStatuses: Map<String, ChatUserStatus?>.unmodifiable(
          <String, ChatUserStatus?>{
            ...state.userStatuses,
            change.userId: change.status,
          },
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _statusSubscription?.cancel();
    return super.close();
  }
}
