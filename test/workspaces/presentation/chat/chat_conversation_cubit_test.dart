import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_message_merger.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_read_tracker.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Atrapowe repozytorium pionu 5A z programowalną odpowiedzią dostawy.
final class _FakeConversationRepository implements ChatConversationRepository {
  _FakeConversationRepository({
    this.conversationResult,
    List<Either<ApiError, ChatMessagePage>>? pageResults,
    this.onSend,
    this.windowResult,
    this.markReadCompleter,
    this.onListMessages,
    this.onWindow,
  }) : _pageResults = pageResults ?? <Either<ApiError, ChatMessagePage>>[];

  Either<ApiError, ChatConversation>? conversationResult;

  /// Programowalna odpowiedź okna wokół wiadomości; `null` to puste okno.
  Either<ApiError, ChatMessageWindow>? windowResult;
  final List<Either<ApiError, ChatMessagePage>> _pageResults;
  final Future<Either<ApiError, ChatMessage>> Function(ChatSendMessageCommand)?
  onSend;
  final sentCommands = <ChatSendMessageCommand>[];
  final markedReadMessageIds = <String>[];
  final Completer<Either<ApiError, void>>? markReadCompleter;
  final Future<Either<ApiError, ChatMessagePage>> Function()? onListMessages;
  int listMessageCalls = 0;
  final Future<Either<ApiError, ChatMessageWindow>> Function(String)? onWindow;

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) async => conversationResult ?? Right(_conversation());

  @override
  Future<Either<ApiError, ChatMessageWindow>> loadMessageWindow({
    required String conversationId,
    required String messageId,
    int before = 20,
    int after = 20,
  }) async => onWindow != null
      ? await onWindow!(messageId)
      : windowResult ??
            Right(
              ChatMessageWindow(
                anchorMessageId: messageId,
                messages: const <ChatMessage>[],
                hasMoreBefore: false,
                hasMoreAfter: false,
              ),
            );

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async {
    listMessageCalls++;
    final callback = onListMessages;
    if (callback != null) return callback();
    return _pageResults.removeAt(0);
  }

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

  @override
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  }) async {
    markedReadMessageIds.add(messageId);
    final pending = markReadCompleter;
    if (pending != null) return pending.future;
    return const Right(null);
  }
}

void main() {
  test('repeated selection of a loaded message requests a scroll without entering window history', () async {
    final repository = _FakeConversationRepository(
      pageResults: [
        Right(
          ChatMessagePage(items: [_ChatConversationFixture.message('target')]),
        ),
      ],
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'u',
    );
    await cubit.load();
    await cubit.ensureTargetLoaded('target');
    final first = cubit.state as ChatConversationReady;
    expect(first.targetMessageId, 'target');
    expect(first.isWindowedHistory, isFalse);
    await cubit.ensureTargetLoaded('target');
    final second = cubit.state as ChatConversationReady;
    expect(second.targetMessageId, 'target');
    expect(second.targetRequestId, first.targetRequestId + 1);
    expect(second.isWindowedHistory, isFalse);
    await cubit.close();
  });
  test('scalanie nie cofa nowszej edycji i nie wskrzesza usuniętej wersji', () {
    final edited = _ChatConversationFixture.message(
      'm',
      text: 'Nowa',
      version: 3,
    );
    final oldSnapshot = _ChatConversationFixture.message(
      'm',
      text: 'Stara',
      version: 2,
    );
    expect(
      ChatConversationMessageMerger.merge([edited], [oldSnapshot]).single.text,
      'Nowa',
    );
    final deleted = edited.copyWithDeletion(version: 4);
    final staleAck = _ChatConversationFixture.message(
      'm',
      text: 'Nowa',
      version: 4,
    );
    expect(
      ChatConversationMessageMerger.merge(
        [deleted],
        [staleAck],
      ).single.isDeleted,
      true,
    );
  });

  test('skok do dostępnego celu unieważnia starsze okno w locie', () async {
    final pending = Completer<Either<ApiError, ChatMessageWindow>>();
    final repository = _FakeConversationRepository(
      pageResults: [
        Right(
          ChatMessagePage(
            items: [_ChatConversationFixture.message('fresh')],
            nextCursor: 'fresh-cursor',
          ),
        ),
      ],
      onWindow: (_) => pending.future,
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'u',
    );
    await cubit.load();
    final jumping = cubit.ensureTargetLoaded('old');
    await cubit.ensureTargetLoaded('fresh');
    pending.complete(
      Right(
        ChatMessageWindow(
          anchorMessageId: 'old',
          messages: [_ChatConversationFixture.message('old')],
          hasMoreBefore: false,
          hasMoreAfter: true,
        ),
      ),
    );
    await jumping;
    final state = cubit.state as ChatConversationReady;
    expect(state.messages.single.id, 'fresh');
    expect(state.isJumpingToMessage, false);
    expect(state.isWindowedHistory, false);
    expect(state.nextCursor, 'fresh-cursor');
    await cubit.close();
  });

  test('stara paginacja nie zanieczyszcza nowego okna', () async {
    var count = 0;
    final pending = Completer<Either<ApiError, ChatMessagePage>>();
    final repository = _FakeConversationRepository(
      onListMessages: () async {
        if (++count == 1) {
          return Right(
            ChatMessagePage(
              items: [
                _ChatConversationFixture.message(
                  'fresh',
                  clientMessageId: 'fresh',
                ),
              ],
              nextCursor: 'fresh-cursor',
            ),
          );
        }
        return pending.future;
      },
      windowResult: Right(
        ChatMessageWindow(
          anchorMessageId: 'old',
          messages: [
            _ChatConversationFixture.message('old', clientMessageId: 'old'),
          ],
          beforeCursor: 'window-cursor',
          hasMoreBefore: true,
          hasMoreAfter: true,
        ),
      ),
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'u',
    );
    await cubit.load();
    final paging = cubit.loadMore();
    await cubit.ensureTargetLoaded('old');
    expect((cubit.state as ChatConversationReady).nextCursor, 'window-cursor');
    pending.complete(
      Right(
        ChatMessagePage(
          items: [
            _ChatConversationFixture.message(
              'fresh-page2',
              clientMessageId: 'fresh-page2',
            ),
          ],
          nextCursor: 'fresh-page2-cursor',
        ),
      ),
    );
    await paging;
    final state = cubit.state as ChatConversationReady;
    expect(state.isWindowedHistory, true);
    expect(state.messages.map((item) => item.id), ['old']);
    expect(state.nextCursor, 'window-cursor');
    await cubit.close();
  });

  test('replaceHistory nie scala się ze starszym load w locie', () async {
    final olderReload = Completer<Either<ApiError, ChatMessagePage>>();
    final historyReplacement = Completer<Either<ApiError, ChatMessagePage>>();
    var request = 0;
    final repository = _FakeConversationRepository(
      onListMessages: () {
        request++;
        return switch (request) {
          1 => Future.value(
            Right(
              ChatMessagePage(
                items: [_ChatConversationFixture.message('initial')],
              ),
            ),
          ),
          2 => olderReload.future,
          3 => historyReplacement.future,
          _ => throw StateError('unexpected history request $request'),
        };
      },
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'test-user',
    );
    await cubit.load();

    final olderLoad = cubit.load();
    await Future<void>.delayed(Duration.zero);
    final replacementLoad = cubit.load(replaceHistory: true);
    await Future<void>.delayed(Duration.zero);
    expect(repository.listMessageCalls, 3);

    historyReplacement.complete(
      Right(
        ChatMessagePage(
          items: [_ChatConversationFixture.message('latest-window')],
        ),
      ),
    );
    await replacementLoad;
    expect(
      (cubit.state as ChatConversationReady).messages.map((item) => item.id),
      ['latest-window'],
    );

    olderReload.complete(
      Right(
        ChatMessagePage(
          items: [_ChatConversationFixture.message('stale-latest-page')],
        ),
      ),
    );
    await olderLoad;
    expect(
      (cubit.state as ChatConversationReady).messages.map((item) => item.id),
      ['latest-window'],
    );
    await cubit.close();
  });
  test('odczyt widocznej wiadomości jest idempotentny', () async {
    final repository = _FakeConversationRepository(
      pageResults: [
        Right(
          ChatMessagePage(
            items: [_ChatConversationFixture.message('visible-1')],
          ),
        ),
      ],
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'user-2',
    );
    await cubit.load();

    expect(
      await cubit.markVisibleAsRead('visible-1'),
      ChatReadMarkOutcome.marked,
    );
    expect(
      await cubit.markVisibleAsRead('visible-1'),
      ChatReadMarkOutcome.ignored,
    );
    expect(repository.markedReadMessageIds, ['visible-1']);

    await cubit.close();
  });

  test('nie wysyła równoległego odczytu tej samej wiadomości', () async {
    final markReadCompleter = Completer<Either<ApiError, void>>();
    final repository = _FakeConversationRepository(
      pageResults: [
        Right(
          ChatMessagePage(
            items: [_ChatConversationFixture.message('visible-race')],
          ),
        ),
      ],
      markReadCompleter: markReadCompleter,
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'user-2',
    );
    await cubit.load();

    final first = cubit.markVisibleAsRead('visible-race');
    await Future<void>.delayed(Duration.zero);
    expect(
      await cubit.markVisibleAsRead('visible-race'),
      ChatReadMarkOutcome.ignored,
    );
    markReadCompleter.complete(const Right(null));

    expect(await first, ChatReadMarkOutcome.marked);
    expect(repository.markedReadMessageIds, ['visible-race']);
    await cubit.close();
  });

  test('wysyła sam załącznik jako prawidłową treść wiadomości', () async {
    final repository = _FakeConversationRepository(
      pageResults: [const Right(ChatMessagePage(items: []))],
      onSend: (command) async => Right(
        _ChatConversationFixture.message(
          'attachment-message',
          clientMessageId: command.clientMessageId,
          text: command.text,
        ),
      ),
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'test-user',
    );
    await cubit.load();

    final clientMessageId = cubit.sendDraft(
      const ChatComposerDraft(text: '', attachmentIds: ['storage-file-1']),
    );

    expect(clientMessageId, isNotNull);
    await Future<void>.delayed(Duration.zero);
    expect(repository.sentCommands, hasLength(1));
    expect(repository.sentCommands.single.text, isEmpty);
    expect(repository.sentCommands.single.attachmentFileIds, [
      'storage-file-1',
    ]);
    await cubit.close();
  });

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
        currentUserId: 'test-user',
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
        currentUserId: 'test-user',
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
    'normalizuje stronę newest-first i potwierdza najnowszą jako odczytaną',
    () async {
      final older = _ChatConversationFixture.message(
        'older',
        clientMessageId: 'client-older',
        createdAtUtc: DateTime.utc(2026, 9, 23, 10),
      );
      final newest = _ChatConversationFixture.message(
        'newest',
        clientMessageId: 'client-newest',
        createdAtUtc: DateTime.utc(2026, 9, 23, 11),
      );
      final repository = _FakeConversationRepository(
        pageResults: [
          Right(ChatMessagePage(items: [newest, older])),
        ],
      );
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'user-2',
      );

      await cubit.load();
      final state = cubit.state as ChatConversationReady;
      expect(state.messages.map((message) => message.id), ['older', 'newest']);
      expect(
        await cubit.markVisibleAsRead(state.messages.last.id),
        ChatReadMarkOutcome.marked,
      );
      expect(repository.markedReadMessageIds, ['newest']);
      expect(
        await cubit.markVisibleAsRead(older.id),
        ChatReadMarkOutcome.ignored,
      );
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
        currentUserId: 'test-user',
      );
      await cubit.load();

      cubit.send('Wiadomość');
      expect(
        (cubit.state as ChatConversationReady).messages.single.authorUserId,
        'test-user',
      );
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

  test(
    'skok do starej wiadomości pokazuje ciągłe okno i kursor okna',
    () async {
      final repository = _FakeConversationRepository(
        pageResults: [
          Right(
            ChatMessagePage(
              items: [
                _ChatConversationFixture.message(
                  'fresh-1',
                  clientMessageId: 'client-fresh-1',
                ),
              ],
              nextCursor: 'cursor-najnowszy',
            ),
          ),
          const Left(
            ApiError(type: ApiErrorType.server, message: 'Błąd strony.'),
          ),
          Right(
            ChatMessagePage(
              items: [
                _ChatConversationFixture.message(
                  'old-0',
                  clientMessageId: 'client-old-0',
                ),
              ],
            ),
          ),
          Right(
            ChatMessagePage(
              items: [
                _ChatConversationFixture.message(
                  'fresh-2',
                  clientMessageId: 'client-fresh-2',
                ),
              ],
              nextCursor: 'cursor-najnowszy-2',
            ),
          ),
        ],
        windowResult: Right(
          ChatMessageWindow(
            anchorMessageId: 'old-1',
            messages: [
              _ChatConversationFixture.message(
                'old-1',
                clientMessageId: 'client-old-1',
              ),
              _ChatConversationFixture.message(
                'old-2',
                clientMessageId: 'client-old-2',
              ),
            ],
            hasMoreBefore: true,
            hasMoreAfter: true,
            beforeCursor: 'cursor-starszy',
          ),
        ),
      );
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'test-user',
      );
      await cubit.load();

      await cubit.ensureTargetLoaded('old-1');

      var state = cubit.state as ChatConversationReady;
      expect(
        state.messages.map((message) => message.id),
        <String>['old-1', 'old-2'],
        reason: 'okno jest ciągłym zakresem, bez doszycia najnowszej strony',
      );
      expect(state.nextCursor, 'cursor-starszy');
      expect(state.isWindowedHistory, isTrue);
      expect(state.jumpAnchorMessageId, 'old-1');
      expect(state.isJumpingToMessage, isFalse);
      expect(state.jumpFailureCode, isNull);

      cubit.applyMessageActionResult(
        _ChatConversationFixture.message(
          'old-1',
          clientMessageId: 'client-old-1',
          text: 'Zmieniona treść',
        ),
      );
      state = cubit.state as ChatConversationReady;
      expect(state.isWindowedHistory, isTrue);
      expect(state.jumpAnchorMessageId, 'old-1');
      expect(state.messages.first.text, 'Zmieniona treść');

      await cubit.loadMore();
      state = cubit.state as ChatConversationReady;
      expect(state.isWindowedHistory, isTrue);
      expect(state.jumpAnchorMessageId, 'old-1');
      expect(state.isLoadingMore, isFalse);
      expect(state.nextCursor, 'cursor-starszy');
      expect(state.loadError, 'Błąd strony.');

      await cubit.loadMore();
      state = cubit.state as ChatConversationReady;
      expect(state.isWindowedHistory, isTrue);
      expect(state.jumpAnchorMessageId, 'old-1');
      expect(state.isLoadingMore, isFalse);
      expect(state.nextCursor, isNull);
      expect(
        state.messages.map((message) => message.id),
        <String>['old-0', 'old-1', 'old-2'],
      );

      // Wyjście z trybu okna pobiera najnowszą stronę od nowa.
      await cubit.exitWindowHistory();

      state = cubit.state as ChatConversationReady;
      expect(state.messages.map((message) => message.id), <String>['fresh-2']);
      expect(state.isWindowedHistory, isFalse);
      expect(state.nextCursor, 'cursor-najnowszy-2');
      await cubit.close();
    },
  );

  test(
    'okno bez starszego kursora nie odziedzicza kursora najnowszej strony',
    () async {
      final repository = _FakeConversationRepository(
        pageResults: [
          Right(
            ChatMessagePage(
              items: [_ChatConversationFixture.message('latest')],
              nextCursor: 'cursor-najnowszy',
            ),
          ),
        ],
        windowResult: Right(
          ChatMessageWindow(
            anchorMessageId: 'old-target',
            messages: [_ChatConversationFixture.message('old-target')],
            hasMoreBefore: false,
            hasMoreAfter: true,
          ),
        ),
      );
      final cubit = ChatConversationCubit(
        repository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'test-user',
      );
      await cubit.load();

      await cubit.ensureTargetLoaded('old-target');
      final state = cubit.state as ChatConversationReady;
      expect(state.isWindowedHistory, isTrue);
      expect(state.jumpAnchorMessageId, 'old-target');
      expect(state.nextCursor, isNull);

      await cubit.loadMore();
      expect(repository.listMessageCalls, 1);
      await cubit.close();
    },
  );

  test('wysłanie zamienia etykietę wzmianki na token UUID', () async {
    const peer = '22222222-2222-2222-2222-222222222222';
    final repository = _FakeConversationRepository(
      pageResults: [const Right(ChatMessagePage(items: []))],
      onSend: (command) async => Right(
        _ChatConversationFixture.message(
          'server-message-1',
          clientMessageId: command.clientMessageId,
          text: command.text,
          payloadHash: command.payloadHash,
        ),
      ),
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'test-user',
    );
    await cubit.load();

    cubit.sendDraft(
      const ChatComposerDraft(
        text: 'Hej @Jan, zobacz',
        mentions: [ChatMentionReference(userId: peer, label: 'Jan')],
      ),
    );
    await _ChatConversationFixture.flushMicrotasks();

    expect(repository.sentCommands, hasLength(1));
    expect(
      repository.sentCommands.single.text,
      'Hej @$peer, zobacz',
      reason: 'composer pokazuje nazwę, a transport musi nieść stabilny UUID',
    );
    await cubit.close();
  });

  test('brak wiadomości w oknie daje komunikat, nie pustą historię', () async {
    final repository = _FakeConversationRepository(
      pageResults: [
        Right(
          ChatMessagePage(
            items: [_ChatConversationFixture.message('fresh-1')],
          ),
        ),
      ],
      windowResult: const Left(
        ApiError(
          type: ApiErrorType.notFound,
          message: 'chat.messages.not_found',
          apiCode: 'chat.messages.not_found',
        ),
      ),
    );
    final cubit = ChatConversationCubit(
      repository: repository,
      conversationId: 'conversation-1',
      currentUserId: 'test-user',
    );
    await cubit.load();

    await cubit.ensureTargetLoaded('missing-1');

    final state = cubit.state as ChatConversationReady;
    expect(
      state.messages.map((message) => message.id),
      <String>['fresh-1'],
      reason: 'nieudany skok nie może wyczyścić pobranej historii',
    );
    expect(state.jumpFailureCode, 'chat.messages.not_found');
    await cubit.close();
  });
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
    int version = 1,
    DateTime? createdAtUtc,
  }) => ChatMessage(
    id: id,
    conversationId: 'conversation-1',
    authorUserId: 'user-1',
    clientMessageId: clientMessageId,
    text: text,
    payloadHash: payloadHash,
    version: version,
    createdAtUtc: createdAtUtc ?? DateTime.utc(2026),
    isDeleted: false,
    deliveryState: ChatMessageDeliveryState.sent,
  );
}
