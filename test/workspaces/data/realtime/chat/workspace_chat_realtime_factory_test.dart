import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WorkspaceChatRealtimeFactory buildFactory() => WorkspaceChatRealtimeFactory(
    baseUrl: 'http://127.0.0.1:1',
    credentials: WorkspaceRealtimeCredentials.bearer(() async => 'token'),
  );

  group('WorkspaceChatRealtimeFactory', () {
    test('ta sama rozmowa nie tworzy drugiego połączenia', () async {
      final factory = buildFactory();

      final first = factory.open('conversation-1');
      final second = factory.open('conversation-1');

      expect(factory.openConversationCount, 1);
      expect(second.conversationId, first.conversationId);
      await factory.release('conversation-1');
      expect(
        factory.openConversationCount,
        1,
        reason: 'druga dzierżawa trzyma połączenie',
      );
      await factory.release('conversation-1');
      expect(factory.openConversationCount, 0);
    });

    test('różne rozmowy mają osobne subskrypcje', () async {
      final factory = buildFactory();

      factory.open('conversation-1');
      factory.open('conversation-2');

      expect(factory.openConversationCount, 2);
      await factory.closeAll();
      expect(factory.openConversationCount, 0);
    });

    test('dispose dzierżawy zwalnia połączenie dokładnie raz', () async {
      final factory = buildFactory();
      final lease = factory.open('conversation-1');

      await lease.dispose();
      await lease.dispose();

      expect(factory.openConversationCount, 0);
      expect(factory.isClosed, isFalse);
    });

    test('po zamknięciu sesji nie można otworzyć nowej subskrypcji', () async {
      final factory = buildFactory();
      factory.open('conversation-1');

      await factory.closeAll();

      expect(factory.isClosed, isTrue);
      expect(() => factory.open('conversation-2'), throwsA(isA<StateError>()));
      expect(factory.openConversationCount, 0);
    });

    test('pusta rozmowa jest błędem programisty, nie cichym połączeniem', () {
      final factory = buildFactory();

      expect(() => factory.open('   '), throwsA(isA<ArgumentError>()));
      expect(factory.openConversationCount, 0);
    });
  });
}
