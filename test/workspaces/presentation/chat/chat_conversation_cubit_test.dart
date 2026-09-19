import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Atrapowe repozytorium pionu 5A z programowalną odpowiedzią dostawy.
final class _FakeConversationRepository implements ChatConversationRepository {
  _FakeConversationRepository({
    this.conversationResult,
    List<Either<ApiError, ChatMessagePage>>? pageResults,
    this.onSend,
  }) : _pageResults = pageResults ?? <Either<ApiError, ChatMessagePage>>[];

  Either<ApiError, ChatConversation>? conversationResult;
  final List<Either<ApiError, ChatMessagePage>> _pageResults;
  final Future<Either<ApiError, ChatMessage>> Function(ChatSendMessageCommand)?
  onSend;
  final sentCommands = <ChatSendMessageCommand>[];

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) async => conversationResult ?? Right(_conversation());

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async => _pageResults.removeAt(0);

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async {
    sentCommands.add(command);
    return onSend?.call(command) ??
        const Left(
          ApiError(type: ApiErrorType.server, message: 'Błąd wysyłki.'),
        );
  }

  ChatConversation _conversation() => ChatConversation(
    id: 'conversation-1',
    type: 'Channel',
    scopeKind: 'Workspace',
    scopeKey: 'workspace:demo',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    postingPermission: 'Everyone',
    isArchived: false,
  );
}

void main() {
  test(
    'odłącza i czyści zakres po 401 zamiast pokazywać starą historię',
    () async {
      final repository = _FakeConversationRepository(
        conversationResult: const Left(
          ApiError(type: ApiErrorType.unauthorized, message: 'Sesja wygasła.'),
        ),
      );
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
      );

      await cubit.load();

      expect(cubit.state, isA<ChatConversationDetached>());
      expect(
        (cubit.state as ChatConversationDetached).message,
        'Sesja wygasła.',
      );
      await cubit.close();
    },
  );

  test(
    'zachowuje cursor i deduplikuje wiadomość na kolejnej stronie',
    () async {
      final repository = _FakeConversationRepository(
        pageResults: [
          Right(
            ChatMessagePage(
              items: [_ChatConversationFixture.message('message-1')],
              nextCursor: 'c1',
            ),
          ),
          Right(
            ChatMessagePage(
              items: [
                _ChatConversationFixture.message('message-1'),
                _ChatConversationFixture.message(
                  'message-2',
                  clientMessageId: 'client-message-2',
                ),
              ],
            ),
          ),
        ],
      );
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
      );

      await cubit.load();
      await cubit.loadMore();

      final state = cubit.state as ChatConversationReady;
      expect(state.messages.map((message) => message.id), [
        'message-1',
        'message-2',
      ]);
      expect(state.nextCursor, isNull);
      await cubit.close();
    },
  );

  test(
    'retry zachowuje UUID i hash payloadu oraz nie duplikuje wiadomości',
    () async {
      var attempts = 0;
      final repository = _FakeConversationRepository(
        pageResults: [const Right(ChatMessagePage(items: []))],
        onSend: (command) async {
          attempts++;
          if (attempts == 1) {
            return const Left(
              ApiError(type: ApiErrorType.connection, message: 'Offline.'),
            );
          }
          return Right(
            _ChatConversationFixture.message(
              'server-message-1',
              clientMessageId: command.clientMessageId,
              text: command.text,
              payloadHash: command.payloadHash,
            ),
          );
        },
      );
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
      );
      await cubit.load();

      cubit.send('Wiadomość');
      await _ChatConversationFixture.flushMicrotasks();
      var state = cubit.state as ChatConversationReady;
      expect(
        state.messages.single.deliveryState,
        ChatMessageDeliveryState.failed,
      );

      cubit.retry(state.messages.single.clientMessageId);
      await _ChatConversationFixture.flushMicrotasks();
      state = cubit.state as ChatConversationReady;
      expect(state.messages, hasLength(1));
      expect(state.messages.single.id, 'server-message-1');
      expect(
        state.messages.single.deliveryState,
        ChatMessageDeliveryState.sent,
      );
      expect(repository.sentCommands, hasLength(2));
      expect(
        repository.sentCommands.first.clientMessageId,
        repository.sentCommands.last.clientMessageId,
      );
      expect(
        repository.sentCommands.first.payloadHash,
        repository.sentCommands.last.payloadHash,
      );
      await cubit.close();
    },
  );
}

/// Zamyka tworzenie powtarzalnych danych i odroczeń wewnątrz fixture testu.
abstract final class _ChatConversationFixture {
  /// Pompuje zaplanowaną próbę kolejki bez czekania na rzeczywisty zegar.
  static Future<void> flushMicrotasks() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }

  /// Tworzy potwierdzoną wiadomość backendu dla testu redukcji cursorów.
  static ChatMessage message(
    String id, {
    String clientMessageId = 'client-message-1',
    String text = 'Treść',
    String payloadHash = 'hash',
  }) => ChatMessage(
    id: id,
    conversationId: 'conversation-1',
    authorUserId: 'user-1',
    clientMessageId: clientMessageId,
    text: text,
    payloadHash: payloadHash,
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    isDeleted: false,
    deliveryState: ChatMessageDeliveryState.sent,
  );
}
