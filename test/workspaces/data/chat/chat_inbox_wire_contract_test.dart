import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('skrzynka odczytuje wartości enumów z kontraktu ASP.NET', () {
    final page = ChatInboxPageResponse.fromJson({
      'items': [
        {
          'conversation': {
            'id': '11111111-1111-1111-1111-111111111111',
            'type': 'Direct',
            'scopeKind': 'Global',
            'scopeKey': 'global',
            'version': 1,
            'createdAtUtc': '2026-09-22T12:00:00Z',
          },
          'lastActivityAtUtc': '2026-09-22T12:01:00Z',
        },
      ],
      'nextCursor': null,
      'hasMore': false,
    });

    expect(page.items.single.conversation.type, ChatConversationType.direct);
    expect(page.items.single.conversation.scopeKind, ChatScopeKind.global);
    expect(
      const ResolveChatConversationPayload(
        type: ChatConversationType.group,
        scopeKind: ChatScopeKind.workspace,
        scopeKey: 'workspace',
      ).toJson(),
      containsPair('type', 'Group'),
    );
  });
}
