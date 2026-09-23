import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_filter.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Chat transport enum values decode and encode exact backend strings',
    () {
      const conversationTypes = <ChatConversationType, String>{
        ChatConversationType.direct: 'Direct',
        ChatConversationType.group: 'Group',
        ChatConversationType.channel: 'Channel',
        ChatConversationType.broadcast: 'Broadcast',
        ChatConversationType.discussion: 'Discussion',
      };
      const scopeKinds = <ChatScopeKind, String>{
        ChatScopeKind.global: 'Global',
        ChatScopeKind.workspace: 'Workspace',
        ChatScopeKind.project: 'Project',
        ChatScopeKind.resource: 'Resource',
      };
      const notificationPreferences = <ChatNotificationPreference, String>{
        ChatNotificationPreference.all: 'All',
        ChatNotificationPreference.mentionsOnly: 'MentionsOnly',
        ChatNotificationPreference.muted: 'Muted',
        ChatNotificationPreference.highOnly: 'HighOnly',
      };
      const deliveryStatuses = <ChatMessageDeliveryStatus, String>{
        ChatMessageDeliveryStatus.sending: 'Sending',
        ChatMessageDeliveryStatus.sent: 'Sent',
        ChatMessageDeliveryStatus.delivered: 'Delivered',
        ChatMessageDeliveryStatus.read: 'Read',
        ChatMessageDeliveryStatus.failed: 'Failed',
      };
      const inboxFilters = <ChatInboxFilter, String>{
        ChatInboxFilter.all: 'All',
        ChatInboxFilter.unread: 'Unread',
        ChatInboxFilter.direct: 'Direct',
        ChatInboxFilter.groups: 'Groups',
        ChatInboxFilter.channels: 'Channels',
        ChatInboxFilter.archived: 'Archived',
        ChatInboxFilter.mentions: 'Mentions',
      };
      const memberRoles = <ChatMemberRole, String>{
        ChatMemberRole.member: 'Member',
        ChatMemberRole.owner: 'Owner',
        ChatMemberRole.moderator: 'Moderator',
        ChatMemberRole.observer: 'Observer',
      };

      expect(
        conversationTypes.keys,
        unorderedEquals(ChatConversationType.values),
      );
      expect(scopeKinds.keys, unorderedEquals(ChatScopeKind.values));
      expect(
        notificationPreferences.keys,
        unorderedEquals(ChatNotificationPreference.values),
      );
      expect(
        deliveryStatuses.keys,
        unorderedEquals(ChatMessageDeliveryStatus.values),
      );
      expect(inboxFilters.keys, unorderedEquals(ChatInboxFilter.values));
      expect(memberRoles.keys, unorderedEquals(ChatMemberRole.values));

      for (final entry in inboxFilters.entries) {
        expect(entry.key.wireValue, entry.value);
      }
      for (final entry in memberRoles.entries) {
        expect(entry.key.wireValue, entry.value);
        expect(ChatMemberRole.fromWire(entry.value), entry.key);
      }

      for (final entry in conversationTypes.entries) {
        final payload = ResolveChatConversationPayload.fromJson({
          'type': entry.value,
          'scopeKind': 'Global',
          'scopeKey': 'enum-contract',
        });
        expect(payload.type, entry.key);
        expect(payload.toJson()['type'], entry.value);
      }

      for (final entry in scopeKinds.entries) {
        final payload = ResolveChatConversationPayload.fromJson({
          'type': 'Direct',
          'scopeKind': entry.value,
          'scopeKey': 'enum-contract',
        });
        expect(payload.scopeKind, entry.key);
        expect(payload.toJson()['scopeKind'], entry.value);
      }

      for (final entry in notificationPreferences.entries) {
        final json = <String, dynamic>{
          'conversationId': 'conversation-1',
          'userId': 'user-1',
          'preference': entry.value,
        };
        expect(
          ChatNotificationPreferenceResponse.fromJson(json).preference,
          entry.key,
        );
        expect(
          UpdateChatNotificationPreferencePayload(
            preference: entry.key,
          ).toJson()['preference'],
          entry.value,
        );
      }

      for (final entry in deliveryStatuses.entries) {
        final json = <String, dynamic>{
          'messageId': 'message-1',
          'recipientUserId': 'user-1',
          'status': entry.value,
          'updatedAtUtc': '2026-09-23T12:00:00Z',
        };
        final response = ChatMessageDeliveryResponse.fromJson(json);
        expect(response.status, entry.key);
        expect(response.toJson()['status'], entry.value);
      }
    },
  );
}
