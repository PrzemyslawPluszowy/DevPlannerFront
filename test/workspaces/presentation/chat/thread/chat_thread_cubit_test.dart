import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'event odebrany podczas initial load zostaje zredukowany po snapshocie',
    () async {
      final events = StreamController<ChatConversationRealtimeEvent>();
      final repository = _DelayedThreadRepo();
      final cubit = ChatThreadCubit(
        repository,
        deliveryRepository: _DeliveryRepo(),
        currentUserId: 'user',
        conversationId: 'c',
        threadRootMessageId: 'root',
        conversationEvents: events.stream,
      );
      final loading = cubit.load();
      events.add(
        _threadEvent(
          ChatConversationRealtimeEventKind.messageCreated,
          1,
          message: _remoteReply('r', 1, 'Remote podczas load'),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      repository.pending.complete(const Right(ChatMessagePage(items: [])));
      await loading;
      expect(
        (cubit.state as ChatThreadReady).messages.single.text,
        'Remote podczas load',
      );
      await cubit.close();
      await events.close();
    },
  );
  test(
    'initial parent detached blokuje request i wysyłkę od konstrukcji',
    () async {
      final repository = _DelayedThreadRepo();
      final cubit = ChatThreadCubit(
        repository,
        deliveryRepository: _DeliveryRepo(),
        currentUserId: 'user',
        conversationId: 'c',
        threadRootMessageId: 'root',
        initialParentConversationState: const ChatConversationDetached(
          'revoke',
        ),
      );
      await cubit.load();
      expect(cubit.state, isA<ChatThreadDetached>());
      expect(
        cubit.sendDraft(const ChatComposerDraft(text: 'Odpowiedź')),
        isNull,
      );
      await cubit.close();
    },
  );
  test(
    'remote delete root usuwa także tekst i cytaty nagłówka wątku',
    () async {
      final events = StreamController<ChatConversationRealtimeEvent>();
      final cubit = ChatThreadCubit(
        _ReadyThreadRepo(),
        deliveryRepository: _DeliveryRepo(),
        currentUserId: 'user',
        conversationId: 'c',
        threadRootMessageId: 'root',
        rootMessage: _remoteReply('root', 1, 'Pierwotny'),
        conversationEvents: events.stream,
      );
      await cubit.load();
      events.add(
        _threadEvent(
          ChatConversationRealtimeEventKind.messageDeleted,
          1,
          messageId: 'root',
          version: 2,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(cubit.rootMessage?.isDeleted, true);
      await cubit.close();
      await events.close();
    },
  );

  test(
    'wątek przyjmuje remote create edit delete i izoluje inną gałąź',
    () async {
      final events = StreamController<ChatConversationRealtimeEvent>();
      final cubit = ChatThreadCubit(
        _ReadyThreadRepo(),
        deliveryRepository: _DeliveryRepo(),
        currentUserId: 'user',
        conversationId: 'c',
        threadRootMessageId: 'root',
        conversationEvents: events.stream,
      );
      await cubit.load();
      events.add(
        _threadEvent(
          ChatConversationRealtimeEventKind.messageCreated,
          1,
          message: _remoteReply('r', 1, 'Pierwsza'),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect((cubit.state as ChatThreadReady).messages.single.text, 'Pierwsza');
      events.add(
        _threadEvent(
          ChatConversationRealtimeEventKind.messageCreated,
          2,
          message: _remoteReply('other', 1, 'Inny wątek', root: 'other-root'),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect((cubit.state as ChatThreadReady).messages, hasLength(1));
      events.add(
        _threadEvent(
          ChatConversationRealtimeEventKind.messageUpdated,
          3,
          message: _remoteReply('r', 2, 'Zmieniona'),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(
        (cubit.state as ChatThreadReady).messages.single.text,
        'Zmieniona',
      );
      events.add(
        _threadEvent(
          ChatConversationRealtimeEventKind.messageDeleted,
          4,
          messageId: 'r',
          version: 3,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(
        (cubit.state as ChatThreadReady).messages.single.isDeleted,
        isTrue,
      );
      await cubit.close();
      await events.close();
    },
  );
  test('parent revoke usuwa historię i unieważnia opóźniony load', () async {
    final parent = StreamController<ChatConversationState>();
    final repository = _DelayedThreadRepo();
    final cubit = ChatThreadCubit(
      repository,
      deliveryRepository: _DeliveryRepo(),
      currentUserId: 'user',
      conversationId: 'c',
      threadRootMessageId: 'root',
      parentConversationStates: parent.stream,
    );
    final loading = cubit.load();
    parent.add(const ChatConversationDetached('revoke'));
    await Future<void>.delayed(Duration.zero);
    repository.pending.complete(const Right(ChatMessagePage(items: [])));
    await loading;
    expect(cubit.state, isA<ChatThreadDetached>());
    expect(cubit.sendDraft(const ChatComposerDraft(text: 'Odpowiedź')), isNull);
    await cubit.close();
    await parent.close();
  });

  test('wątek fail-closed po forbidden', () async {
    final cubit = ChatThreadCubit(
      _ThreadRepo.left(),
      deliveryRepository: _DeliveryRepo(),
      currentUserId: 'user',
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
      currentUserId: 'user',
      conversationId: 'c',
      threadRootMessageId: 'root',
    );
    await cubit.load();
    final clientId = cubit.sendDraft(
      const ChatComposerDraft(text: 'Odpowiedź'),
    );
    expect(clientId, isNotNull);
    expect(
      clientId,
      (cubit.state as ChatThreadReady).messages.single.clientMessageId,
    );
    final optimistic = cubit.state as ChatThreadReady;
    expect(optimistic.messages.single.authorUserId, 'user');
    await Future<void>.delayed(Duration.zero);

    final state = cubit.state as ChatThreadReady;
    expect(state.messages, hasLength(1));
    expect(state.messages.single.replyToMessageId, 'root');
    expect(state.messages.single.authorUserId, 'user');
    await cubit.close();
  });

  test('błąd doładowania zachowuje historię i można ponowić kursor', () async {
    final repository = _PagedThreadRepo();
    final cubit = ChatThreadCubit(
      repository,
      deliveryRepository: _DeliveryRepo(),
      currentUserId: 'user',
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

final class _DelayedThreadRepo implements ChatThreadRepository {
  final pending = Completer<Either<ApiError, ChatMessagePage>>();
  @override
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  }) => pending.future;
}

ChatMessage _remoteReply(
  String id,
  int version,
  String text, {
  String root = 'root',
}) => ChatMessage(
  id: id,
  conversationId: 'c',
  authorUserId: 'peer',
  clientMessageId: 'client:$id',
  text: text,
  replyToMessageId: root,
  threadRootMessageId: root,
  payloadHash: 'hash',
  version: version,
  createdAtUtc: DateTime.utc(2026),
  isDeleted: false,
  deliveryState: ChatMessageDeliveryState.sent,
);
ChatConversationRealtimeEvent _threadEvent(
  ChatConversationRealtimeEventKind kind,
  int seq, {
  ChatMessage? message,
  String? messageId,
  int? version,
}) => ChatConversationRealtimeEvent(
  eventId: 'e$seq',
  sequence: seq,
  conversationId: 'c',
  kind: kind,
  isReplay: false,
  message: message,
  messageId: messageId ?? message?.id,
  messageVersion: version ?? message?.version,
);
