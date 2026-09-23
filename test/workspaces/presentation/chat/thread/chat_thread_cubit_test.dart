import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wątek fail-closed po forbidden', () async {
    final cubit = ChatThreadCubit(
      _ThreadRepo.left(),
      deliveryRepository: _DeliveryRepo(),
      conversationId: 'c',
      threadRootMessageId: 'root',
    );
    await cubit.load();
    expect(cubit.state, isA<ChatThreadDetached>());
    await cubit.close();
  });

  test('wątek odrzuca potwierdzenie bez reply do jego root message', () async {
    final cubit = ChatThreadCubit(
      _ReadyThreadRepo(),
      deliveryRepository: _ParentMessageDeliveryRepo(),
      conversationId: 'c',
      threadRootMessageId: 'root',
    );
    await cubit.load();
    cubit.sendDraft(const ChatComposerDraft(text: 'Odpowiedź'));
    await Future<void>.delayed(Duration.zero);

    final state = cubit.state as ChatThreadReady;
    expect(state.messages, hasLength(1));
    expect(state.messages.single.replyToMessageId, 'root');
    await cubit.close();
  });

  test('błąd doładowania zachowuje historię i można ponowić kursor', () async {
    final repository = _PagedThreadRepo();
    final cubit = ChatThreadCubit(
      repository,
      deliveryRepository: _DeliveryRepo(),
      conversationId: 'c',
      threadRootMessageId: 'root',
    );

    await cubit.load();
    await cubit.loadMore();

    var state = cubit.state as ChatThreadReady;
    expect(state.messages.single.id, 'older-message');
    expect(state.nextCursor, 'older-cursor');
    expect(state.isLoadingMore, isFalse);
    expect(state.loadMoreFailed, isTrue);

    await cubit.loadMore();
    state = cubit.state as ChatThreadReady;
    expect(state.messages.single.id, 'older-message');
    expect(state.nextCursor, isNull);
    expect(state.loadMoreFailed, isFalse);
    await cubit.close();
  });
}

final class _ReadyThreadRepo implements ChatThreadRepository {
  @override
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  }) async => const Right(ChatMessagePage(items: []));
}

final class _ThreadRepo implements ChatThreadRepository {
  _ThreadRepo.left();
  @override
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  }) async => const Left(
    ApiError(type: ApiErrorType.forbidden, message: 'Brak dostępu'),
  );
}

final class _PagedThreadRepo implements ChatThreadRepository {
  bool _failedFirstOlderPage = false;

  @override
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  }) async {
    if (cursor == null) {
      return Right(
        ChatMessagePage(items: [_threadMessage()], nextCursor: 'older-cursor'),
      );
    }
    if (!_failedFirstOlderPage) {
      _failedFirstOlderPage = true;
      return const Left(
        ApiError(type: ApiErrorType.connection, message: 'Offline'),
      );
    }
    return const Right(ChatMessagePage(items: []));
  }
}

ChatMessage _threadMessage() => ChatMessage(
  id: 'older-message',
  conversationId: 'c',
  authorUserId: 'user',
  clientMessageId: 'client',
  text: 'Odowiedź',
  payloadHash: 'hash',
  version: 1,
  createdAtUtc: DateTime.utc(2026),
  isDeleted: false,
  deliveryState: ChatMessageDeliveryState.sent,
);

final class _DeliveryRepo implements ChatConversationRepository {
  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) => throw UnimplementedError();
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
  }) => throw UnimplementedError();
  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);
}

final class _ParentMessageDeliveryRepo implements ChatConversationRepository {
  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async => Right(
    ChatMessage(
      id: 'server:${command.clientMessageId}',
      conversationId: command.conversationId,
      authorUserId: 'user',
      clientMessageId: command.clientMessageId,
      text: command.text,
      payloadHash: command.payloadHash,
      version: 1,
      createdAtUtc: DateTime.utc(2026),
      isDeleted: false,
      deliveryState: ChatMessageDeliveryState.sent,
    ),
  );

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) => throw UnimplementedError();

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
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);
}
