import 'package:devplanner/workspaces/data/chat/repositories/secure_chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage storage;
  late SecureChatDraftRepository repository;

  setUp(() {
    storage = _MockSecureStorage();
    repository = SecureChatDraftRepository(storage: storage);
    when(() => storage.read(key: any(named: 'key'))).thenAnswer(
      (_) async => null,
    );
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
    ).thenAnswer((_) async {});
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer(
      (_) async {},
    );
  });

  group('SecureChatDraftRepository', () {
    test('zapisuje szkic wyłącznie w systemowym secure storage', () async {
      await repository.save(
        userId: 'user-1',
        conversationId: 'conversation-1',
        draft: const ChatComposerDraft(
          text: 'tresc',
          attachmentIds: ['file-1'],
        ),
      );

      final key =
          verify(
                () => storage.write(
                  key: captureAny(named: 'key'),
                  value: captureAny(named: 'value'),
                  iOptions: any(named: 'iOptions'),
                  aOptions: any(named: 'aOptions'),
                  lOptions: any(named: 'lOptions'),
                  wOptions: any(named: 'wOptions'),
                  webOptions: any(named: 'webOptions'),
                  mOptions: any(named: 'mOptions'),
                ),
              ).captured.first
              as String;
      expect(key, contains('user-1'));
      expect(key, contains('conversation-1'));
    });

    test('usuwa wyłącznie szkice zakończonej sesji', () async {
      when(storage.readAll).thenAnswer(
        (_) async => <String, String>{
          'devplanner.chat_draft.v1.user-1.conversation-1': '{}',
          'devplanner.chat_draft.v1.user-1.conversation-2': '{}',
          'devplanner.chat_draft.v1.user-2.conversation-1': '{}',
          'devplanner.other.secret': 'value',
        },
      );

      await repository.deleteAllForUser(userId: 'user-1');

      final deleted = verify(
        () => storage.delete(key: captureAny(named: 'key')),
      ).captured.cast<String>();
      expect(deleted, hasLength(2));
      expect(
        deleted.every(
          (key) => key.startsWith('devplanner.chat_draft.v1.user-1.'),
        ),
        isTrue,
        reason: 'kolejny użytkownik i inne sekrety nie mogą zostać usunięte',
      );
    });

    test('brak dostępu do keychaina nie blokuje wylogowania', () async {
      when(storage.readAll).thenThrow(Exception('brak keychaina'));

      await expectLater(
        repository.deleteAllForUser(userId: 'user-1'),
        completes,
      );
    });
  });
}
