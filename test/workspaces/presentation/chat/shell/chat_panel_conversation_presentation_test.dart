import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_item.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_participant.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_presentation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 9, 24);

  ChatConversation conversation(String type) => ChatConversation(
    id: 'conversation-1',
    type: type,
    scopeKind: 'global',
    scopeKey: 'global:conversation-1',
    version: 1,
    createdAtUtc: now,
    postingPermission: 'Everyone',
    isArchived: false,
    name: 'Zespół',
  );

  ChatInboxParticipant participant({
    required String id,
    required bool current,
    String? name,
    String? avatarUrl,
  }) => ChatInboxParticipant(
    userId: id,
    isCurrentUser: current,
    displayName: name,
    avatarUrl: avatarUrl,
  );

  ChatInboxItem inbox({
    required ChatConversation conversation,
    required String role,
    List<ChatInboxParticipant>? participants,
    int participantCount = 2,
  }) => ChatInboxItem(
    conversation: conversation,
    lastActivityAtUtc: now,
    unreadCount: 0,
    isMuted: false,
    isDraft: false,
    role: role,
    participantCount: participantCount,
    participants:
        participants ??
        <ChatInboxParticipant>[
          participant(id: 'me', current: true, name: 'Ja'),
          participant(
            id: 'peer',
            current: false,
            name: 'Ala Kowalska',
            avatarUrl: '/avatars/peer',
          ),
        ],
  );

  test('DM pokazuje profil rozmówcy i nazwę tylko we wskaźniku pisania', () {
    final chat = conversation('direct');
    final presentation = ChatPanelConversationPresentation(
      conversation: chat,
      inboxItem: inbox(conversation: chat, role: 'Member'),
    );

    expect(presentation.title, 'Ala Kowalska');
    expect(presentation.headerAvatarUserId, 'peer');
    expect(presentation.headerAvatarUrl, '/avatars/peer');
    expect(presentation.typingParticipantLabels, <String, String>{
      'peer': 'Ala Kowalska',
    });
    expect(presentation.participantLabels, isEmpty);
    expect(presentation.participantAvatarUrls, isEmpty);
    expect(presentation.participantCount, 0);
    expect(presentation.mentionAllEnabled, isFalse);
  });

  test('grupa używa etykiet i avatarów uczestników oraz liczby z serwera', () {
    final chat = conversation('group');
    final presentation = ChatPanelConversationPresentation(
      conversation: chat,
      inboxItem: inbox(
        conversation: chat,
        role: 'Moderator',
        participantCount: 9,
      ),
    );

    expect(presentation.title, isNull);
    expect(presentation.headerAvatarUserId, isNull);
    expect(presentation.participantCount, 9);
    expect(presentation.participantLabels['peer'], 'Ala Kowalska');
    expect(presentation.participantAvatarUrls['peer'], '/avatars/peer');
    expect(presentation.typingParticipantLabels['peer'], 'Ala Kowalska');
    expect(presentation.mentionAllEnabled, isTrue);
  });

  test('brak danych inboxa nie wymyśla profilu ani uprawnień', () {
    for (final type in <String>['direct', 'group', 'channel', 'broadcast']) {
      final presentation = ChatPanelConversationPresentation(
        conversation: conversation(type),
        inboxItem: null,
      );

      expect(presentation.title, isNull);
      expect(presentation.headerAvatarUserId, isNull);
      expect(presentation.headerAvatarUrl, isNull);
      expect(presentation.participantLabels, isEmpty);
      expect(presentation.participantAvatarUrls, isEmpty);
      expect(presentation.typingParticipantLabels, isEmpty);
      expect(presentation.participantCount, 0);
      expect(presentation.mentionAllEnabled, isFalse);
    }
  });

  test('tylko Owner lub Moderator mogą zobaczyć @all w group/channel', () {
    for (final type in <String>['group', 'channel', 'broadcast']) {
      for (final role in <String>['Owner', 'Moderator']) {
        final chat = conversation(type);
        expect(
          ChatPanelConversationPresentation(
            conversation: chat,
            inboxItem: inbox(conversation: chat, role: role),
          ).mentionAllEnabled,
          isTrue,
          reason: '$type/$role',
        );
      }
      for (final role in <String>['Member', 'Observer', 'Unknown']) {
        final chat = conversation(type);
        expect(
          ChatPanelConversationPresentation(
            conversation: chat,
            inboxItem: inbox(conversation: chat, role: role),
          ).mentionAllEnabled,
          isFalse,
          reason: '$type/$role',
        );
      }
    }
  });
}
