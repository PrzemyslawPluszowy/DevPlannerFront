import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatComposerCubit trwały draft', () {
    test(
      'flush i reopen odtwarzają tekst, Delta, reply oraz kolejność plików',
      () async {
        final repository = _MemoryDraftRepository();
        final first = _ComposerDraftFixture.cubit(repository);
        first.updateRichText(text: 'Treść', deltaJson: '[{"insert":"Treść"}]');
        first.replyTo('message-1');
        first.updateAttachmentIds(['file-2', 'file-1']);
        await first.flush();
        await first.close();

        final reopened = _ComposerDraftFixture.cubit(repository);
        await reopened.restore();

        expect(reopened.state.draft.text, 'Treść');
        expect(reopened.state.draft.deltaJson, '[{"insert":"Treść"}]');
        expect(reopened.state.draft.replyToMessageId, 'message-1');
        expect(reopened.state.draft.attachmentIds, ['file-2', 'file-1']);
        await reopened.close();
      },
    );

    test('debounce zapisuje, a flush nie czeka na timer', () async {
      final repository = _MemoryDraftRepository();
      final cubit = _ComposerDraftFixture.cubit(
        repository,
        debounce: const Duration(milliseconds: 1),
      );

      cubit.updatePlainText('Wersja robocza');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(repository.saveCalls, 1);

      cubit.updatePlainText('Nowsza wersja');
      await cubit.flush();
      expect(repository.saveCalls, 2);
      await cubit.close();
    });

    test('wzmianki przeżywają edycję, a skasowana nazwa je usuwa', () async {
      final repository = _MemoryDraftRepository();
      final cubit = _ComposerDraftFixture.cubit(repository);
      const peer = '22222222-2222-2222-2222-222222222222';

      cubit.updatePlainText('Hej @Ola i @Jan');
      cubit.setMentions(const [
        ChatMentionReference(userId: 'user-ola', label: 'Ola'),
        ChatMentionReference(userId: peer, label: 'Jan'),
      ]);
      expect(cubit.state.draft.mentions, hasLength(2));

      // Edycja bez usunięcia nazw zachowuje wzmianki.
      cubit.updatePlainText('Hej @Ola i @Jan, zobacz');
      expect(cubit.state.draft.mentions, hasLength(2));

      // Skasowanie nazwy z tekstu usuwa wzmiankę, żeby nie pingować bez powodu.
      cubit.updatePlainText('Hej @Ola, zobacz');
      expect(cubit.state.draft.mentions.single.label, 'Ola');
      await cubit.close();
    });

    test('401 lub 403 usuwa prywatny draft fail-closed', () async {
      final repository = _MemoryDraftRepository();
      final cubit = _ComposerDraftFixture.cubit(repository);
      cubit.updatePlainText('Prywatna treść');
      await cubit.flush();

      await cubit.clearForAccessRevoked();

      expect(repository.readSync('user-1', 'conversation-1'), isNull);
      expect(cubit.state.draft, const ChatComposerDraft(text: ''));
      await cubit.close();
    });

    test('in-flight save nie wskrzesza draftu po revoke', () async {
      final repository = _RaceDraftRepository();
      final cubit = _ComposerDraftFixture.cubit(
        repository,
        debounce: Duration.zero,
      );

      cubit.updatePlainText('Treść do usunięcia');
      await repository.saveStarted.future;
      final cleared = cubit.clearForAccessRevoked();
      repository.completeSave();
      await cleared;

      expect(repository.readSync('user-1', 'conversation-1'), isNull);
      await cubit.close();
    });

    test('opóźniony restore nie wskrzesza draftu po revoke', () async {
      final repository = _DelayedReadDraftRepository();
      final cubit = _ComposerDraftFixture.cubit(repository);

      final restoring = cubit.restore();
      await repository.readStarted.future;
      await cubit.clearForAccessRevoked();
      repository.completeRead(const ChatComposerDraft(text: 'Stary draft'));
      await restoring;

      expect(cubit.state.draft, const ChatComposerDraft(text: ''));
      await cubit.close();
    });
  });
}

final class _RaceDraftRepository extends _MemoryDraftRepository {
  final Completer<void> saveStarted = Completer<void>();
  final Completer<void> _saveGate = Completer<void>();

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {
    if (!saveStarted.isCompleted) saveStarted.complete();
    await _saveGate.future;
    await super.save(
      userId: userId,
      conversationId: conversationId,
      draft: draft,
    );
  }

  void completeSave() => _saveGate.complete();
}

final class _DelayedReadDraftRepository extends _MemoryDraftRepository {
  final Completer<void> readStarted = Completer<void>();
  final Completer<ChatComposerDraft?> _readGate =
      Completer<ChatComposerDraft?>();

  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) {
    if (!readStarted.isCompleted) readStarted.complete();
    return _readGate.future;
  }

  void completeRead(ChatComposerDraft draft) => _readGate.complete(draft);
}

class _MemoryDraftRepository implements ChatDraftRepository {
  final Map<String, ChatComposerDraft> _values = <String, ChatComposerDraft>{};
  int saveCalls = 0;

  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {
    _values.remove('$userId:$conversationId');
  }

  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async => readSync(userId, conversationId);

  ChatComposerDraft? readSync(String userId, String conversationId) =>
      _values['$userId:$conversationId'];

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {
    saveCalls++;
    _values['$userId:$conversationId'] = draft;
  }

  @override
  Future<void> deleteAllForUser({required String userId}) async {}
}

abstract final class _ComposerDraftFixture {
  static ChatComposerCubit cubit(
    ChatDraftRepository repository, {
    Duration debounce = const Duration(milliseconds: 200),
  }) => ChatComposerCubit(
    repository: repository,
    userId: 'user-1',
    conversationId: 'conversation-1',
    debounce: debounce,
  );
}
