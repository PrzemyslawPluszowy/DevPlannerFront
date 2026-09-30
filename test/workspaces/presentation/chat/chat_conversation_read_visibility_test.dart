import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_read_tracker.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium liczące wywołania odczytu; historia jest ustalona.
final class _ReadTrackingRepository implements ChatConversationRepository {
  _ReadTrackingRepository({required this.messages});

  final List<ChatMessage> messages;
  final List<String> readCalls = <String>[];
  bool failNextRead = false;

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(String id) async =>
      Right(
        ChatConversation(
          id: id,
          type: 'group',
          scopeKind: 'global',
          scopeKey: 'global:grupa',
          version: 1,
          createdAtUtc: DateTime.utc(2026, 9, 21),
          postingPermission: 'Everyone',
          isArchived: false,
          name: 'Grupa',
        ),
      );

  @override
  Future<Either<ApiError, ChatMessageWindow>> loadMessageWindow({
    required String conversationId,
    required String messageId,
    int before = 20,
    int after = 20,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async => Right(ChatMessagePage(items: messages, nextCursor: 'older'));

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  }) async {
    readCalls.add(messageId);
    if (failNextRead) {
      failNextRead = false;
      return const Left(
        ApiError(type: ApiErrorType.connection, message: 'Offline.'),
      );
    }
    return const Right(null);
  }
}

ChatMessage message({
  required String id,
  required String authorUserId,
  bool isDeleted = false,
}) => ChatMessage(
  id: id,
  conversationId: 'conversation-1',
  authorUserId: authorUserId,
  clientMessageId: 'client-$id',
  text: 'Treść $id',
  payloadHash: 'hash',
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9, 21),
  isDeleted: isDeleted,
  deliveryState: ChatMessageDeliveryState.sent,
);

void main() {
  const currentUserId = 'me';

  Future<ChatConversationCubit> loadCubit(
    _ReadTrackingRepository repository,
  ) async {
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: currentUserId,
    );
    await cubit.load();
    return cubit;
  }

  group('ChatConversationCubit — widoczność odczytu', () {
    test('samo pobranie historii nie oznacza odczytu', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[message(id: 'm1', authorUserId: 'peer')],
      );

      final cubit = await loadCubit(repository);

      expect(cubit.state, isA<ChatConversationReady>());
      expect(
        repository.readCalls,
        isEmpty,
        reason: 'tło i pobranie historii nie mogą oznaczać odczytu',
      );
      await cubit.close();
    });

    test(
      'widok oznaczający odczyt wysyła jedno żądanie i jest idempotentny',
      () async {
        final repository = _ReadTrackingRepository(
          messages: <ChatMessage>[message(id: 'm1', authorUserId: 'peer')],
        );
        final cubit = await loadCubit(repository);

        final first = await cubit.markVisibleAsRead('m1');
        final second = await cubit.markVisibleAsRead('m1');

        expect(first, ChatReadMarkOutcome.marked);
        expect(
          second,
          ChatReadMarkOutcome.ignored,
          reason: 'powtórzenie dla tej samej wiadomości nic nie wysyła',
        );
        expect(repository.readCalls, <String>['m1']);
        expect(cubit.lastReadMessageId, 'm1');
        await cubit.close();
      },
    );

    test(
      'widoczna własna wiadomość przesuwa kursor odczytu rozmowy',
      () async {
        final repository = _ReadTrackingRepository(
          messages: <ChatMessage>[
            message(id: 'm1', authorUserId: currentUserId),
          ],
        );
        final cubit = await loadCubit(repository);

        expect(await cubit.markVisibleAsRead('m1'), ChatReadMarkOutcome.marked);
        expect(repository.readCalls, <String>['m1']);
        expect(cubit.lastReadMessageId, 'm1');
        await cubit.close();
      },
    );

    test('pomija wiadomości lokalne i usunięte', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[
          message(id: 'local:client-1', authorUserId: ''),
          message(id: 'm2', authorUserId: 'peer', isDeleted: true),
        ],
      );
      final cubit = await loadCubit(repository);

      expect(
        await cubit.markVisibleAsRead('local:client-1'),
        ChatReadMarkOutcome.ignored,
      );
      expect(await cubit.markVisibleAsRead('m2'), ChatReadMarkOutcome.ignored);
      expect(repository.readCalls, isEmpty);
      await cubit.close();
    });

    test('nieznany identyfikator nie tworzy żądania', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[message(id: 'm1', authorUserId: 'peer')],
      );
      final cubit = await loadCubit(repository);

      expect(
        await cubit.markVisibleAsRead('nie-istnieje'),
        ChatReadMarkOutcome.ignored,
      );
      expect(repository.readCalls, isEmpty);
      await cubit.close();
    });

    test('kursor odczytu nie cofa się do starszej wiadomości', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[
          message(id: 'm1', authorUserId: 'peer'),
          message(id: 'm2', authorUserId: 'peer'),
        ],
      );
      final cubit = await loadCubit(repository);

      expect(await cubit.markVisibleAsRead('m2'), ChatReadMarkOutcome.marked);
      expect(await cubit.markVisibleAsRead('m1'), ChatReadMarkOutcome.ignored);
      expect(repository.readCalls, <String>['m2']);
      expect(cubit.lastReadMessageId, 'm2');
      await cubit.close();
    });

    test('raportuje błąd API osobno i można ponowić ten sam odczyt', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[message(id: 'm1', authorUserId: 'peer')],
      )..failNextRead = true;
      final cubit = await loadCubit(repository);

      expect(
        await cubit.markVisibleAsRead('m1'),
        ChatReadMarkOutcome.failed,
      );
      expect(cubit.lastReadMessageId, isNull);
      expect(
        await cubit.markVisibleAsRead('m1'),
        ChatReadMarkOutcome.marked,
      );
      expect(repository.readCalls, <String>['m1', 'm1']);
      expect(cubit.lastReadMessageId, 'm1');
      await cubit.close();
    });
  });
}
