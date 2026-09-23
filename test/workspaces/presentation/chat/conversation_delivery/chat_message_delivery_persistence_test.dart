import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/delivery/chat_pending_send_store_impl.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

final class _PendingStoreFake implements ChatPendingSendStore {
  final Map<String, List<PendingChatSend>> byUser =
      <String, List<PendingChatSend>>{};
  int clearCalls = 0;

  @override
  Future<List<PendingChatSend>> read({
    required String userId,
    String? conversationId,
  }) async => (byUser[userId] ?? const <PendingChatSend>[])
      .where(
        (entry) =>
            conversationId == null || entry.conversationId == conversationId,
      )
      .toList(growable: false);

  @override
  Future<void> save({
    required String userId,
    required PendingChatSend pending,
  }) async {
    byUser[userId] = <PendingChatSend>[
      for (final entry in byUser[userId] ?? const <PendingChatSend>[])
        if (entry.clientMessageId != pending.clientMessageId) entry,
      pending,
    ];
  }

  @override
  Future<void> remove({
    required String userId,
    required String clientMessageId,
  }) async {
    byUser[userId] = (byUser[userId] ?? const <PendingChatSend>[])
        .where((entry) => entry.clientMessageId != clientMessageId)
        .toList(growable: false);
  }

  @override
  Future<void> clearForUser({required String userId}) async {
    clearCalls++;
    byUser.remove(userId);
  }
}

/// Repozytorium symulujące realne odpowiedzi backendu dla kolejki wysyłki.
final class _DeliveryRepositoryFake implements ChatConversationRepository {
  _DeliveryRepositoryFake({
    this.firstResult,
    this.thenResult,
  });

  /// Wynik pierwszej próby; brak oznacza sukces.
  ApiError? firstResult;

  /// Wynik kolejnych prób; brak oznacza sukces.
  ApiError? thenResult;

  final List<ChatSendMessageCommand> commands = <ChatSendMessageCommand>[];
  int attempts = 0;

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async {
    commands.add(command);
    attempts++;
    final error = attempts == 1 ? firstResult : thenResult;
    if (error != null) return Left(error);
    return Right(
      ChatMessage(
        id: 'server-${command.clientMessageId}',
        conversationId: command.conversationId,
        authorUserId: 'user-1',
        clientMessageId: command.clientMessageId,
        text: command.text,
        payloadHash: command.payloadHash,
        version: 1,
        createdAtUtc: DateTime.utc(2026, 9, 21),
        isDeleted: false,
        deliveryState: ChatMessageDeliveryState.sent,
      ),
    );
  }

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(String id) async =>
      throw UnimplementedError();

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
  }) async => throw UnimplementedError();

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

const _draft = ChatComposerDraft(
  text: 'Treść do ponowienia',
  attachmentIds: <String>['file-1'],
);

void main() {
  const userId = 'user-1';
  const conversationId = 'conversation-1';

  group('ChatMessageDeliveryQueue — trwałość i polityka retry', () {
    test('rozłączenie po HTTP 2xx scala potwierdzenie bez duplikatu', () async {
      // Pierwsza próba: serwer zapisał wiadomość, ale odpowiedź przepadła.
      final repository = _DeliveryRepositoryFake(
        firstResult: const ApiError(
          type: ApiErrorType.connection,
          message: 'Połączenie przerwane po zapisie.',
        ),
      );
      final queue = ChatMessageDeliveryQueue(repository, userId: userId);
      final changes = <ChatMessage>[];
      final subscription = queue.changes.listen(changes.add);

      final optimistic = queue.enqueue(
        conversationId: conversationId,
        draft: _draft,
      );
      await Future<void>.delayed(Duration.zero);
      expect(changes.last.deliveryState, ChatMessageDeliveryState.failed);

      // Ponowienie z tym samym clientMessageId zwraca istniejącą wiadomość.
      queue.retry(optimistic.clientMessageId);
      await Future<void>.delayed(Duration.zero);

      expect(repository.commands, hasLength(2));
      expect(
        repository.commands[1].clientMessageId,
        repository.commands[0].clientMessageId,
        reason: 'retry nie może zmienić identyfikatora idempotencji',
      );
      expect(
        repository.commands[1].payloadHash,
        repository.commands[0].payloadHash,
      );
      expect(changes.last.deliveryState, ChatMessageDeliveryState.sent);
      expect(
        changes.map((message) => message.clientMessageId).toSet(),
        hasLength(1),
        reason: 'odzyskane potwierdzenie nie tworzy drugiego wpisu',
      );

      await subscription.cancel();
      await queue.dispose();
    });

    test(
      'konflikt payloadu kończy się błędem bez automatycznej pętli',
      () async {
        final repository = _DeliveryRepositoryFake(
          firstResult: const ApiError(
            type: ApiErrorType.validation,
            message: 'Ten clientMessageId został już użyty z inną treścią.',
            statusCode: 400,
            apiCode: 'validation.failed',
          ),
          thenResult: const ApiError(
            type: ApiErrorType.validation,
            message: 'Ten clientMessageId został już użyty z inną treścią.',
            statusCode: 400,
          ),
        );
        final queue = ChatMessageDeliveryQueue(repository, userId: userId);
        final changes = <ChatMessage>[];
        final subscription = queue.changes.listen(changes.add);

        queue.enqueue(conversationId: conversationId, draft: _draft);
        await Future<void>.delayed(Duration.zero);

        expect(changes.last.deliveryState, ChatMessageDeliveryState.failed);
        expect(changes.last.deliveryError, contains('clientMessageId'));
        expect(
          repository.attempts,
          1,
          reason: '400 nie jest ponawiane automatycznie',
        );

        await subscription.cancel();
        await queue.dispose();
      },
    );

    test('odmowa dostępu nie wchodzi w pętlę ponowień', () async {
      final repository = _DeliveryRepositoryFake(
        firstResult: const ApiError(
          type: ApiErrorType.forbidden,
          message: 'Brak dostępu.',
          statusCode: 403,
        ),
      );
      final queue = ChatMessageDeliveryQueue(repository, userId: userId);
      final subscription = queue.changes.listen((_) {});

      queue.enqueue(conversationId: conversationId, draft: _draft);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(repository.attempts, 1);
      await subscription.cancel();
      await queue.dispose();
    });

    test('restart wznawia intencję z tym samym clientMessageId', () async {
      final repository = _DeliveryRepositoryFake();
      repository.firstResult = const ApiError(
        type: ApiErrorType.connection,
        message: 'Offline.',
      );
      final store = _PendingStoreFake();
      final firstQueue = ChatMessageDeliveryQueue(
        repository,
        userId: userId,
        pendingStore: store,
      );
      final optimistic = firstQueue.enqueue(
        conversationId: conversationId,
        draft: _draft,
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        store.byUser[userId],
        hasLength(1),
        reason: 'nieudana próba zostaje w trwałym magazynie',
      );
      await firstQueue.dispose();

      // Nowa sesja aplikacji: nowa kolejka czyta magazyn i ponawia wysyłkę.
      final secondQueue = ChatMessageDeliveryQueue(
        repository,
        userId: userId,
        pendingStore: store,
      )..bindConversation(conversationId);
      final changes = <ChatMessage>[];
      final subscription = secondQueue.changes.listen(changes.add);
      final restored = await secondQueue.restorePending();
      await Future<void>.delayed(Duration.zero);

      expect(restored, 1);
      expect(
        repository.commands.last.clientMessageId,
        optimistic.clientMessageId,
        reason: 'wznowienie używa identyfikatora zapisanego przed restartem',
      );
      expect(changes.last.deliveryState, ChatMessageDeliveryState.sent);
      expect(
        store.byUser[userId],
        isEmpty,
        reason: 'potwierdzona intencja znika z magazynu',
      );

      await subscription.cancel();
      await secondQueue.dispose();
    });

    test('wylogowanie usuwa trwałe intencje poprzedniej sesji', () async {
      final repository = _DeliveryRepositoryFake(
        firstResult: const ApiError(
          type: ApiErrorType.connection,
          message: 'Offline.',
        ),
      );
      final store = _PendingStoreFake();
      final queue = ChatMessageDeliveryQueue(
        repository,
        userId: userId,
        pendingStore: store,
      );
      queue.enqueue(conversationId: conversationId, draft: _draft);
      await Future<void>.delayed(Duration.zero);
      expect(store.byUser[userId], hasLength(1));

      await queue.clearForSession();

      expect(store.clearCalls, 1);
      expect(store.byUser, isEmpty);
      await queue.dispose();
    });
  });

  group('ChatPendingSendStoreImpl', () {
    test(
      'serializuje zapis i usunięcie bez odtworzenia potwierdzonej wysyłki',
      () async {
        final storage = _MockSecureStorage();
        final firstWrite = Completer<void>();
        String? stored;
        var writes = 0;
        when(
          () => storage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => stored);
        when(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            wOptions: any(named: 'wOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
          ),
        ).thenAnswer((invocation) async {
          writes++;
          final value = invocation.namedArguments[#value] as String;
          if (writes == 1) await firstWrite.future;
          stored = value;
        });
        final store = ChatPendingSendStoreImpl(storage: storage, isWeb: false);
        const pending = PendingChatSend(
          clientMessageId: 'client-1',
          conversationId: conversationId,
          draft: _draft,
          attempts: 1,
        );

        final save = store.save(userId: userId, pending: pending);
        await Future<void>.delayed(Duration.zero);
        expect(writes, 1, reason: 'pierwszy zapis powinien czekać na keychain');

        var readFinished = false;
        final readAfterSave = store.read(userId: userId).then((entries) {
          readFinished = true;
          return entries;
        });
        await Future<void>.delayed(Duration.zero);
        expect(readFinished, isFalse, reason: 'odczyt czeka na zapis');

        final remove = store.remove(
          userId: userId,
          clientMessageId: pending.clientMessageId,
        );
        await Future<void>.delayed(Duration.zero);
        expect(writes, 1, reason: 'usunięcie czeka za trwającym zapisem');

        firstWrite.complete();
        await Future.wait(<Future<void>>[save, remove]);

        expect((await readAfterSave).single.clientMessageId, 'client-1');
        expect(await store.read(userId: userId), isEmpty);
        expect(writes, 2, reason: 'usunięcie zapisuje pusty stan po zapisie');
      },
    );

    test(
      'nie utrwala niczego, gdy platforma nie ma szyfrowanego magazynu',
      () async {
        final storage = _MockSecureStorage();
        final store = ChatPendingSendStoreImpl(storage: storage, isWeb: true);

        await store.save(
          userId: userId,
          pending: const PendingChatSend(
            clientMessageId: 'client-1',
            conversationId: conversationId,
            draft: _draft,
            attempts: 1,
          ),
        );

        expect(store.isDurable, isFalse);
        expect(await store.read(userId: userId), isEmpty);
        verifyNever(
          () => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
            iOptions: any(named: 'iOptions'),
            aOptions: any(named: 'aOptions'),
            lOptions: any(named: 'lOptions'),
            wOptions: any(named: 'wOptions'),
            webOptions: any(named: 'webOptions'),
            mOptions: any(named: 'mOptions'),
          ),
        );
      },
    );

    test('na desktopie zapisuje i odczytuje intencję bez tokenów', () async {
      final storage = _MockSecureStorage();
      String? written;
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          wOptions: any(named: 'wOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
        ),
      ).thenAnswer((invocation) async {
        written = invocation.namedArguments[#value] as String;
      });
      when(() => storage.read(key: any(named: 'key'))).thenAnswer(
        (_) async => written,
      );
      final store = ChatPendingSendStoreImpl(storage: storage, isWeb: false);

      await store.save(
        userId: userId,
        pending: const PendingChatSend(
          clientMessageId: 'client-1',
          conversationId: conversationId,
          draft: _draft,
          attempts: 2,
        ),
      );
      final restored = await store.read(userId: userId);

      expect(store.isDurable, isTrue);
      expect(restored.single.clientMessageId, 'client-1');
      expect(restored.single.attempts, 2);
      expect(restored.single.draft.attachmentIds, <String>['file-1']);
      expect(
        written,
        isNot(contains('token')),
        reason: 'magazyn nie może zawierać sekretów',
      );
    });

    test('usuwa intencję po potwierdzeniu', () async {
      final storage = _MockSecureStorage();
      String? written;
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
          iOptions: any(named: 'iOptions'),
          aOptions: any(named: 'aOptions'),
          lOptions: any(named: 'lOptions'),
          wOptions: any(named: 'wOptions'),
          webOptions: any(named: 'webOptions'),
          mOptions: any(named: 'mOptions'),
        ),
      ).thenAnswer((invocation) async {
        written = invocation.namedArguments[#value] as String;
      });
      when(() => storage.read(key: any(named: 'key'))).thenAnswer(
        (_) async => written,
      );
      final store = ChatPendingSendStoreImpl(storage: storage, isWeb: false);
      await store.save(
        userId: userId,
        pending: const PendingChatSend(
          clientMessageId: 'client-1',
          conversationId: conversationId,
          draft: _draft,
          attempts: 1,
        ),
      );

      await store.remove(userId: userId, clientMessageId: 'client-1');

      expect(await store.read(userId: userId), isEmpty);
    });
  });
}
