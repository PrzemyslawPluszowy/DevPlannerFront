import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium liczące wywołania odczytu; historia jest ustalona.
final class _ReadTrackingRepository implements ChatConversationRepository {
  _ReadTrackingRepository({required this.messages});

  final List<ChatMessage> messages;
  final List<String> readCalls = <String>[];

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

        expect(first, isTrue);
        expect(
          second,
          isFalse,
          reason: 'powtórzenie dla tej samej wiadomości nic nie wysyła',
        );
        expect(repository.readCalls, <String>['m1']);
        expect(cubit.lastReadMessageId, 'm1');
        await cubit.close();
      },
    );

    test('nie oznacza cudzej historii jako odczytanej poza widokiem', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[
          message(id: 'm1', authorUserId: currentUserId),
        ],
      );
      final cubit = await loadCubit(repository);

      expect(await cubit.markVisibleAsRead('m1'), isFalse);
      expect(
        repository.readCalls,
        isEmpty,
        reason: 'własna wiadomość nie wymaga odczytu',
      );
      await cubit.close();
    });

    test('pomija wiadomości lokalne i usunięte', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[
          message(id: 'local:client-1', authorUserId: ''),
          message(id: 'm2', authorUserId: 'peer', isDeleted: true),
        ],
      );
      final cubit = await loadCubit(repository);

      expect(await cubit.markVisibleAsRead('local:client-1'), isFalse);
      expect(await cubit.markVisibleAsRead('m2'), isFalse);
      expect(repository.readCalls, isEmpty);
      await cubit.close();
    });

    test('nieznany identyfikator nie tworzy żądania', () async {
      final repository = _ReadTrackingRepository(
        messages: <ChatMessage>[message(id: 'm1', authorUserId: 'peer')],
      );
      final cubit = await loadCubit(repository);

      expect(await cubit.markVisibleAsRead('nie-istnieje'), isFalse);
      expect(repository.readCalls, isEmpty);
      await cubit.close();
    });
  });
}
