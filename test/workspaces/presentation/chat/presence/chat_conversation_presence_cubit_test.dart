import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'do pierwszego snapshotu nie zgaduje, po nim rozróżnia online i offline',
    () async {
      final controller =
          StreamController<ChatConversationPresenceSnapshot?>.broadcast();
      final cubit = ChatConversationPresenceCubit(
        realtime: _RealtimePresenceFake(
          controller.stream,
          const Stream<ChatUserStatusChanged>.empty(),
        ),
      );

      expect(cubit.state.forUser('peer'), ChatPeerLivePresence.unknown);
      controller.add(
        ChatConversationPresenceSnapshot(
          conversationId: 'conversation-1',
          changedAtUtc: DateTime.utc(2026, 9, 22),
          users: const [
            ChatConversationPresenceUser(
              userId: 'peer',
              connectionCount: 2,
              isOnline: true,
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.forUser('peer'), ChatPeerLivePresence.online);
      expect(cubit.state.forUser('other'), ChatPeerLivePresence.offline);

      await cubit.close();
      await controller.close();
    },
  );

  test('wyczyszczenie snapshotu po odsubskrypcji wraca do unknown', () async {
    final controller =
        StreamController<ChatConversationPresenceSnapshot?>.broadcast();
    final cubit = ChatConversationPresenceCubit(
      realtime: _RealtimePresenceFake(
        controller.stream,
        const Stream<ChatUserStatusChanged>.empty(),
      ),
    );
    controller.add(
      ChatConversationPresenceSnapshot(
        conversationId: 'conversation-1',
        changedAtUtc: _fixedUtc,
        users: const [],
      ),
    );
    controller.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.forUser('peer'), ChatPeerLivePresence.unknown);
    await cubit.close();
    await controller.close();
  });

  test('zachowuje statusy live i rozróżnia wyczyszczenie statusu', () async {
    final presenceController =
        StreamController<ChatConversationPresenceSnapshot?>.broadcast();
    final statusController =
        StreamController<ChatUserStatusChanged>.broadcast();
    final cubit = ChatConversationPresenceCubit(
      realtime: _RealtimePresenceFake(
        presenceController.stream,
        statusController.stream,
      ),
    );
    final initialSnapshot = ChatConversationPresenceSnapshot(
      conversationId: 'conversation-1',
      changedAtUtc: _fixedUtc,
      users: const <ChatConversationPresenceUser>[
        ChatConversationPresenceUser(
          userId: 'peer',
          connectionCount: 1,
          isOnline: true,
        ),
      ],
    );
    presenceController.add(initialSnapshot);
    statusController.add(
      ChatUserStatusChanged(
        userId: 'peer',
        status: ChatUserStatus(
          userId: 'peer',
          text: 'Na urlopie',
          isDnd: false,
          updatedAtUtc: _fixedUtc,
        ),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.statusForUser('peer')?.text, 'Na urlopie');
    expect(cubit.state.forUser('peer'), ChatPeerLivePresence.online);
    statusController.add(
      const ChatUserStatusChanged(userId: 'peer', status: null),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.hasStatusUpdateForUser('peer'), isTrue);
    expect(cubit.state.statusForUser('peer'), isNull);
    expect(cubit.state.snapshot, initialSnapshot);

    await cubit.close();
    await presenceController.close();
    await statusController.close();
  });
}

final DateTime _fixedUtc = DateTime.utc(2026, 9, 22);

final class _RealtimePresenceFake implements ChatConversationRealtimeClient {
  const _RealtimePresenceFake(this.presenceSnapshots, this.userStatusChanges);

  @override
  final Stream<ChatConversationPresenceSnapshot?> presenceSnapshots;

  @override
  final Stream<ChatUserStatusChanged> userStatusChanges;

  @override
  Stream<ChatConversationRealtimeEvent> get conversationEvents =>
      const Stream<ChatConversationRealtimeEvent>.empty();

  @override
  Stream<ChatConversationRealtimeError> get conversationErrors =>
      const Stream<ChatConversationRealtimeError>.empty();

  @override
  Future<void> heartbeatPresence() async {}

  @override
  Future<void> setTyping(bool isTyping) async {}

  @override
  Future<void> start(String conversationId) async {}

  @override
  Future<void> stop() async {}
}
