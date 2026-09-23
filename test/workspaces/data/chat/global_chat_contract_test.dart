import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('global Chat local identity contract', () {
    test('serializes conversation scope with local user UUIDs', () {
      final payload = ResolveChatConversationPayload.fromJson({
        'type': 'Direct',
        'scopeKind': 'Global',
        'scopeKey': 'direct:11111111-1111-1111-1111-111111111111',
        'workspaceId': null,
        'projectId': null,
        'name': null,
        'directConversationKey': 'direct-key',
        'userIds': [
          '11111111-1111-1111-1111-111111111111',
          '22222222-2222-2222-2222-222222222222',
        ],
        'discussionRootMessageId': null,
        'postingPermission': 'Everyone',
        'scopeProvider': null,
        'scopeResourceType': null,
        'scopeResourceId': null,
      });

      expect(payload.userIds, hasLength(2));
      expect(payload.toJson()['type'], 'Direct');
      expect(payload.toJson()['scopeKind'], 'Global');
      expect(payload.toJson().keys, contains('userIds'));
      expect(payload.toJson().keys, isNot(contains('coreUserIds')));
      expect(payload.toJson().keys, isNot(contains('readyUserIds')));
    });

    test('maps message window anchor and before cursor', () {
      final window = ChatMessageWindowResponse.fromJson({
        'conversationId': '44444444-4444-4444-4444-444444444444',
        'anchorMessageId': '33333333-3333-3333-3333-333333333333',
        'messages': <Object?>[],
        'hasMoreBefore': true,
        'hasMoreAfter': false,
        'beforeCursor': 'cursor-1',
      });

      expect(window.anchorMessageId, '33333333-3333-3333-3333-333333333333');
      expect(window.hasMoreBefore, isTrue);
      expect(window.hasMoreAfter, isFalse);
      expect(window.beforeCursor, 'cursor-1');
    });

    test('maps backend message author and attachment UUIDs', () {
      final message = ChatMessageResponse.fromJson({
        'id': '33333333-3333-3333-3333-333333333333',
        'conversationId': '44444444-4444-4444-4444-444444444444',
        'authorUserId': '11111111-1111-1111-1111-111111111111',
        'clientMessageId': 'client-1',
        'text': 'Cześć',
        'deltaJson': null,
        'replyToMessageId': null,
        'payloadHash': 'hash',
        'version': 1,
        'createdAtUtc': '2026-01-01T10:00:00Z',
        'isDeleted': false,
        'links': null,
        'reactions': null,
        'attachments': [
          {
            'id': '55555555-5555-5555-5555-555555555555',
            'messageId': '33333333-3333-3333-3333-333333333333',
            'storageFileId': '66666666-6666-6666-6666-666666666666',
            'attachedByUserId': '11111111-1111-1111-1111-111111111111',
            'position': 0,
            'createdAtUtc': '2026-01-01T10:00:00Z',
          },
        ],
        'threadRootMessageId': null,
        'isEdited': false,
        'deletedAtUtc': null,
      });

      expect(message.authorUserId, '11111111-1111-1111-1111-111111111111');
      expect(
        message.attachments!.single.attachedByUserId,
        message.authorUserId,
      );
      expect(message.toJson().keys, isNot(contains('authorCoreUserId')));
    });
  });
}
