import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_revision.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium akcji rejestrujące wywołania i pozwalające wymusić błąd.
final class _ActionsFake implements ChatMessageActionsRepository {
  ApiError? failure;
  final List<String> calls = <String>[];
  Set<String> pinned = <String>{};
  Set<String> bookmarked = <String>{};
  Completer<Either<ApiError, List<ChatPinnedMessage>>>? pinsCompleter;

  Either<ApiError, T> _guard<T>(String call, T value) {
    calls.add(call);
    final error = failure;
    return error != null ? Left(error) : Right(value);
  }

  /// Wariant dla operacji bez wartości zwracanej.
  Either<ApiError, void> _guardVoid(String call) {
    calls.add(call);
    final error = failure;
    return error != null ? Left(error) : const Right<ApiError, void>(null);
  }

  @override
  Future<Either<ApiError, ChatPinnedMessage>> pinMessage({
    required String conversationId,
    required String messageId,
  }) async {
    pinned.add(messageId);
    return _guard(
      'pin:$messageId',
      ChatPinnedMessage(
        id: 'pin-$messageId',
        conversationId: conversationId,
        messageId: messageId,
        pinnedByUserId: 'me',
        pinnedAtUtc: DateTime.utc(2026, 9, 21),
      ),
    );
  }

  @override
  Future<Either<ApiError, void>> unpinMessage({
    required String conversationId,
    required String messageId,
  }) async {
    pinned.remove(messageId);
    return _guardVoid('unpin:$messageId');
  }

  @override
  Future<Either<ApiError, List<ChatPinnedMessage>>> listPins(
    String conversationId,
  ) async {
    calls.add('listPins');
    if (pinsCompleter case final completer?) return completer.future;
    final error = failure;
    if (error != null) return Left(error);
    return Right(
      <ChatPinnedMessage>[
        for (final id in pinned)
          ChatPinnedMessage(
            id: 'pin-$id',
            conversationId: conversationId,
            messageId: id,
            pinnedByUserId: 'me',
            pinnedAtUtc: DateTime.utc(2026, 9, 21),
          ),
      ],
    );
  }

  @override
  Future<Either<ApiError, ChatBookmark>> bookmarkMessage({
    required String messageId,
    String? note,
  }) async {
    bookmarked.add(messageId);
    return _guard(
      'bookmark:$messageId',
      ChatBookmark(
        id: 'bookmark-$messageId',
        messageId: messageId,
        conversationId: 'conversation-1',
        userId: 'me',
        note: note,
        createdAtUtc: DateTime.utc(2026, 9, 21),
      ),
    );
  }

  @override
  Future<Either<ApiError, void>> removeBookmark(String messageId) async {
    bookmarked.remove(messageId);
    return _guardVoid('removeBookmark:$messageId');
  }

  @override
  Future<Either<ApiError, List<ChatBookmark>>> listBookmarks() async => _guard(
    'listBookmarks',
    <ChatBookmark>[
      for (final id in bookmarked)
        ChatBookmark(
          id: 'bookmark-$id',
          messageId: id,
          conversationId: 'conversation-1',
          userId: 'me',
          createdAtUtc: DateTime.utc(2026, 9, 21),
        ),
    ],
  );

  @override
  Future<Either<ApiError, ChatMessageReaction>> addReaction({
    required String messageId,
    required String emoji,
  }) async => _guard(
    'react:$messageId:$emoji',
    ChatMessageReaction(
      id: 'reaction-$messageId',
      messageId: messageId,
      userId: 'me',
      emoji: emoji,
      createdAtUtc: DateTime.utc(2026, 9, 21),
    ),
  );

  @override
  Future<Either<ApiError, void>> removeReaction({
    required String messageId,
    required String emoji,
  }) async => _guardVoid('removeReaction:$messageId:$emoji');

  @override
  Future<Either<ApiError, List<ChatMessageReaction>>> listReactions(
    String messageId,
  ) async => _guard('listReactions', const <ChatMessageReaction>[]);

  @override
  Future<Either<ApiError, ChatMessage>> forwardMessage({
    required String messageId,
    required String targetConversationId,
    required String clientMessageId,
  }) async => _guard(
    'forward:$messageId:$targetConversationId:$clientMessageId',
    _message(messageId),
  );

  @override
  Future<Either<ApiError, ChatMessage>> editMessage({
    required String messageId,
    required String text,
    required String? deltaJson,
    required int version,
  }) async => _guard('edit:$messageId', _message(messageId));

  @override
  Future<Either<ApiError, void>> deleteMessage({
    required String messageId,
    required int version,
  }) async => _guardVoid('delete:$messageId');

  @override
  Future<Either<ApiError, List<ChatMessageRevision>>> listRevisions(
    String messageId,
  ) async => _guard('listRevisions', const <ChatMessageRevision>[]);

  static ChatMessage _message(String id) => ChatMessage(
    id: id,
    conversationId: 'conversation-1',
    authorUserId: 'me',
    clientMessageId: 'client-$id',
    text: 'Treść',
    payloadHash: 'hash',
    version: 1,
    createdAtUtc: DateTime.utc(2026, 9, 21),
    isDeleted: false,
    deliveryState: ChatMessageDeliveryState.sent,
  );
}

void main() {
  group('ChatMessageSecondaryActionsCubit', () {
    test('przypięcie i odpięcie zmienia stan realnym skutkiem', () async {
      final repository = _ActionsFake();
      final cubit = ChatMessageSecondaryActionsCubit(repository: repository);

      await cubit.togglePin(
        conversationId: 'conversation-1',
        messageId: 'message-1',
        isPinned: false,
      );
      expect(
        cubit.state.lastCompleted,
        ChatMessageSecondaryAction.pin,
        reason: 'menu pokazuje potwierdzenie po realnym przypięciu',
      );
      expect(cubit.state.pinnedConversationId, 'conversation-1');

      expect(cubit.state.pinnedMessageIds, contains('message-1'));

      await cubit.togglePin(
        conversationId: 'conversation-1',
        messageId: 'message-1',
        isPinned: true,
      );
      expect(repository.calls, contains('unpin:message-1'));
      expect(cubit.state.pinnedMessageIds, isNot(contains('message-1')));
      await cubit.close();
    });

    test('zakładka i jej usunięcie aktualizują zbiór użytkownika', () async {
      final repository = _ActionsFake();
      final cubit = ChatMessageSecondaryActionsCubit(repository: repository);

      await cubit.toggleBookmark(messageId: 'message-1', isBookmarked: false);
      expect(cubit.state.bookmarkedMessageIds, contains('message-1'));

      await cubit.toggleBookmark(messageId: 'message-1', isBookmarked: true);
      expect(cubit.state.bookmarkedMessageIds, isEmpty);
      await cubit.close();
    });

    test('spóźniony odczyt przypięć nie nadpisuje udanej zmiany', () async {
      final repository = _ActionsFake()
        ..pinsCompleter =
            Completer<Either<ApiError, List<ChatPinnedMessage>>>();
      final cubit = ChatMessageSecondaryActionsCubit(repository: repository);

      final loading = cubit.loadConversationPins('conversation-1');
      await cubit.togglePin(
        conversationId: 'conversation-1',
        messageId: 'message-1',
        isPinned: false,
      );
      repository.pinsCompleter!.complete(const Right(<ChatPinnedMessage>[]));
      await loading;

      expect(cubit.state.pinnedMessageIds, contains('message-1'));
      await cubit.close();
    });

    test('reakcja i jej usunięcie trafiają do portu z emoji', () async {
      final repository = _ActionsFake();
      final cubit = ChatMessageSecondaryActionsCubit(repository: repository);

      await cubit.react(messageId: 'message-1', emoji: '👍');
      await cubit.removeReaction(messageId: 'message-1', emoji: '👍');

      expect(repository.calls, <String>[
        'react:message-1:👍',
        'removeReaction:message-1:👍',
      ]);
      await cubit.close();
    });

    test('forward przekazuje stabilny idempotency key', () async {
      final repository = _ActionsFake();
      final cubit = ChatMessageSecondaryActionsCubit(repository: repository);

      await cubit.forward(
        messageId: 'message-1',
        targetConversationId: 'conversation-2',
        clientMessageId: 'client-key-1',
      );

      expect(
        repository.calls.single,
        'forward:message-1:conversation-2:client-key-1',
      );
      expect(cubit.state.forwardedMessageId, 'message-1');
      await cubit.close();
    });

    test(
      'błąd portu jest raportowany kodem przy wiadomości, bez pętli',
      () async {
        final repository = _ActionsFake()
          ..failure = const ApiError(
            type: ApiErrorType.forbidden,
            message: 'chat.messages.action_failed',
            apiCode: 'chat.messages.action_failed',
            statusCode: 403,
          );
        final cubit = ChatMessageSecondaryActionsCubit(repository: repository);

        await cubit.react(messageId: 'message-1', emoji: '✅');

        expect(
          cubit.state.failureFor('message-1'),
          'chat.messages.action_failed',
        );
        expect(cubit.state.isPending('message-1'), isFalse);
        expect(cubit.state.lastCompleted, isNull);

        cubit.clearFailure('message-1');
        expect(cubit.state.failureFor('message-1'), isNull);
        await cubit.close();
      },
    );

    test(
      'równoległa akcja dla tej samej wiadomości nie dubluje żądania',
      () async {
        final repository = _ActionsFake();
        final cubit = ChatMessageSecondaryActionsCubit(repository: repository);

        final first = cubit.react(messageId: 'message-1', emoji: '👍');
        final second = cubit.react(messageId: 'message-1', emoji: '✅');
        await Future.wait(<Future<void>>[first, second]);

        expect(repository.calls, hasLength(1));
        await cubit.close();
      },
    );
  });
}
