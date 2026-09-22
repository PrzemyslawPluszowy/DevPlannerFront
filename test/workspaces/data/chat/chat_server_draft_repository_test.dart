import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_server_draft_repository_impl.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockChatApi extends Mock implements ChatApi {}

final class _LocalDraftFake implements ChatDraftRepository {
  final Map<String, ChatComposerDraft> drafts = <String, ChatComposerDraft>{};

  /// Liczba zapisów lokalnych; potwierdza, że lokalna kopia nadal działa.
  int saves = 0;

  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async => drafts['$userId:$conversationId'];

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {
    saves++;
    drafts['$userId:$conversationId'] = draft;
  }

  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {
    drafts.remove('$userId:$conversationId');
  }

  @override
  Future<void> deleteAllForUser({required String userId}) async {
    drafts.removeWhere((key, value) => key.startsWith('$userId:'));
  }
}

final class _ServerDraftFake implements ChatServerDraftRepository {
  ChatComposerDraft? stored;
  final List<int> savedVersions = <int>[];
  ApiError? saveFailure;
  int deletes = 0;

  @override
  Future<Either<ApiError, ChatComposerDraft?>> readDraft(
    String conversationId,
  ) async => Right(stored);

  @override
  Future<Either<ApiError, ChatComposerDraft>> saveDraft({
    required String conversationId,
    required ChatComposerDraft draft,
    required int version,
  }) async {
    final error = saveFailure;
    if (error != null) return Left(error);
    savedVersions.add(version);
    stored = draft;
    return Right(draft);
  }

  @override
  Future<Either<ApiError, void>> deleteDraft(String conversationId) async {
    deletes++;
    stored = null;
    return const Right(null);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(const UpsertChatDraftPayload());
  });

  group('ChatServerDraftRepositoryImpl', () {
    test('mapuje szkic i kolejność załączników z kontraktu', () async {
      final api = _MockChatApi();
      when(() => api.getDraft(any())).thenAnswer(
        (_) async => ChatDraftResponse(
          id: 'draft-1',
          conversationId: 'conversation-1',
          text: 'Treść szkicu',
          replyToMessageId: 'message-1',
          version: 3,
          updatedAtUtc: DateTime.utc(2026, 9, 21),
          attachments: <ChatDraftAttachmentResponse>[
            ChatDraftAttachmentResponse(
              id: 'attachment-1',
              storageFileId: 'file-1',
              position: 0,
              createdAtUtc: DateTime.utc(2026, 9, 21),
            ),
          ],
        ),
      );

      final result = await ChatServerDraftRepositoryImpl(
        api,
      ).readDraft('conversation-1');

      final draft = result.getOrElse(() => null);
      expect(draft?.text, 'Treść szkicu');
      expect(draft?.replyToMessageId, 'message-1');
      expect(draft?.attachmentIds, <String>['file-1']);
    });

    test('brak szkicu jest poprawną odpowiedzią, nie błędem', () async {
      final api = _MockChatApi();
      when(() => api.getDraft(any())).thenAnswer((_) async => null);

      final result = await ChatServerDraftRepositoryImpl(
        api,
      ).readDraft('conversation-1');

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => null), isNull);
    });

    test('błąd zapisu ma stabilny kod domenowy', () async {
      final api = _MockChatApi();
      when(() => api.upsertDraft(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/chat/draft'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await ChatServerDraftRepositoryImpl(api).saveDraft(
        conversationId: 'conversation-1',
        draft: const ChatComposerDraft(text: 'Treść'),
        version: 0,
      );

      expect(
        result.swap().getOrElse(() => throw StateError('brak')).apiCode,
        'chat.drafts.save_failed',
      );
    });
  });

  group('ChatComposerCubit — szkic serwerowy', () {
    test('restore preferuje szkic serwerowy nad lokalną kopią', () async {
      final local = _LocalDraftFake()
        ..drafts['user-1:conversation-1'] = const ChatComposerDraft(
          text: 'Kopia lokalna',
        );
      final server = _ServerDraftFake()
        ..stored = const ChatComposerDraft(text: 'Wersja z serwera');
      final cubit = ChatComposerCubit(
        repository: local,
        serverRepository: server,
        userId: 'user-1',
        conversationId: 'conversation-1',
      );

      await cubit.restore();

      expect(cubit.state.draft.text, 'Wersja z serwera');
      await cubit.close();
    });

    test(
      'zapis trafia lokalnie i na serwer, a pusty szkic usuwa oba',
      () async {
        final local = _LocalDraftFake();
        final server = _ServerDraftFake();
        final cubit = ChatComposerCubit(
          repository: local,
          serverRepository: server,
          userId: 'user-1',
          conversationId: 'conversation-1',
        );

        cubit.updatePlainText('Nowa treść');
        await cubit.flush();

        expect(local.saves, 1);
        expect(server.stored?.text, 'Nowa treść');
        expect(server.savedVersions, <int>[0]);

        cubit.updatePlainText('');
        await cubit.flush();

        expect(server.deletes, 1);
        expect(server.stored, isNull);
        await cubit.close();
      },
    );

    test('konflikt wersji jest rozwiązywany jednym ponowieniem', () async {
      final server = _ServerDraftFake()
        ..saveFailure = const ApiError(
          type: ApiErrorType.conflict,
          message: 'Szkic Chat został zmieniony przez innego użytkownika.',
          statusCode: 400,
        );
      final cubit = ChatComposerCubit(
        repository: _LocalDraftFake(),
        serverRepository: server,
        userId: 'user-1',
        conversationId: 'conversation-1',
      );

      cubit.updatePlainText('Treść po konflikcie');
      await cubit.flush();
      // Pierwsza próba kończy się konfliktem, druga po odświeżeniu udaje się.
      server.saveFailure = null;
      await cubit.flush();

      expect(server.stored?.text, 'Treść po konflikcie');
      await cubit.close();
    });

    test('brak sieci nie gubi szkicu lokalnego', () async {
      final local = _LocalDraftFake();
      final server = _ServerDraftFake()
        ..saveFailure = const ApiError(
          type: ApiErrorType.connection,
          message: 'Offline.',
        );
      final cubit = ChatComposerCubit(
        repository: local,
        serverRepository: server,
        userId: 'user-1',
        conversationId: 'conversation-1',
      );

      cubit.updatePlainText('Treść offline');
      await cubit.flush();

      expect(local.saves, 1, reason: 'lokalna kopia chroni treść offline');
      expect(cubit.state.draft.text, 'Treść offline');
      await cubit.close();
    });
  });
}
