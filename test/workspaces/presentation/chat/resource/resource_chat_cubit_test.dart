import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/resource/cubit/resource_chat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'resolver przekazuje autoryzowaną rozmowę bez danych Storage do UI',
    () async {
      final cubit = ResourceChatCubit(const _ResourceChatRepository());
      addTearDown(cubit.close);

      await cubit.resolveFile(ResourceChatCubitFixture.request());

      expect(cubit.state, isA<ResourceChatResolved>());
      final resolved = cubit.state as ResourceChatResolved;
      expect(resolved.conversation.id, 'chat-1');
      expect(
        resolved.openRequest.fileContext,
        ResourceChatCubitFixture.context,
      );
    },
  );

  test('równoległe aktywacje nie wysyłają drugiego resolvera', () async {
    final repository = _PendingResourceChatRepository();
    final cubit = ResourceChatCubit(repository);
    addTearDown(cubit.close);
    final first = cubit.resolveFile(ResourceChatCubitFixture.request());
    await cubit.resolveFile(ResourceChatCubitFixture.request());
    expect(repository.calls, 1);
    repository.result.complete(
      const Left(
        ApiError(
          type: ApiErrorType.connection,
          message: 'Offline',
        ),
      ),
    );
    await first;
    expect(cubit.state, isA<ResourceChatFailure>());
  });

  test('Retry-After blokuje ponowne żądanie także poza widgetem', () async {
    final repository = _PendingResourceChatRepository();
    final cubit = ResourceChatCubit(repository);
    addTearDown(cubit.close);
    final first = cubit.resolveFile(ResourceChatCubitFixture.request());
    repository.result.complete(
      Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Spróbuj później.',
          retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 1)),
        ),
      ),
    );
    await first;
    await cubit.resolveFile(ResourceChatCubitFixture.request());
    expect(repository.calls, 1);
    expect(cubit.state, isA<ResourceChatFailure>());
  });

  test('odpowiedź po zamknięciu nie emituje ani nie otwiera panelu', () async {
    final repository = _PendingResourceChatRepository();
    final cubit = ResourceChatCubit(repository);
    final first = cubit.resolveFile(ResourceChatCubitFixture.request());
    await cubit.close();
    repository.result.complete(
      const Left(
        ApiError(
          type: ApiErrorType.connection,
          message: 'Offline',
        ),
      ),
    );
    await first;
    expect(cubit.isClosed, isTrue);
    expect(cubit.state, isA<ResourceChatResolving>());
  });

  test('retry po upływie Retry-After znów wywołuje resolver', () async {
    final repository = _ExpiredRetryResourceChatRepository();
    final cubit = ResourceChatCubit(repository);
    addTearDown(cubit.close);
    await cubit.resolveFile(ResourceChatCubitFixture.request());
    await cubit.resolveFile(ResourceChatCubitFixture.request());
    expect(repository.calls, 2);
  });

  test('401 i 403 nie emitują identyfikatora rozmowy', () async {
    for (final error in const <ApiError>[
      ApiError(type: ApiErrorType.unauthorized, message: 'Sesja wygasła.'),
      ApiError(type: ApiErrorType.forbidden, message: 'Dostęp cofnięty.'),
    ]) {
      final cubit = ResourceChatCubit(_ResourceChatRepository(error: error));
      addTearDown(cubit.close);

      await cubit.resolveFile(ResourceChatCubitFixture.request());

      expect(cubit.state, isA<ResourceChatDenied>());
    }
  });
}

/// Repozytorium pozwala odseparować politykę backendowego dostępu od widgetu.
final class _ResourceChatRepository implements ResourceChatRepository {
  const _ResourceChatRepository({this.error});

  final ApiError? error;

  @override
  Future<Either<ApiError, ChatConversation>> resolveTaskConversation({
    required String taskId,
    required String workspaceId,
    required String projectId,
  }) async => Left(
    error ??
        const ApiError(
          type: ApiErrorType.unknown,
          message: 'Task resolution is not configured in this file-only test.',
          apiCode: 'test.task_resolution_unconfigured',
        ),
  );

  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) async => error == null
      ? Right(
          ChatConversation(
            id: 'chat-1',
            type: 'Channel',
            scopeKind: 'Resource',
            scopeKey: request.canonicalScopeKey,
            version: 1,
            createdAtUtc: DateTime.utc(2026),
            postingPermission: 'Everyone',
            isArchived: false,
          ),
        )
      : Left(error!);
}

/// Tworzy minimalny, workspace-bound kontekst wymagany przez provider files.
abstract final class ResourceChatCubitFixture {
  static const context = ResourceChatFileContext(
    fileId: '11111111-1111-4111-8111-111111111111',
    fileName: 'Dokument współdzielony.pdf',
    ownerUserId: 'owner-1',
    accessLevel: 'reader',
  );

  static ResourceChatFileRequest request() => const ResourceChatFileRequest(
    fileId: '11111111-1111-4111-8111-111111111111',
    workspaceId: '22222222-2222-4222-8222-222222222222',
    projectId: null,
    fileContext: ResourceChatCubitFixture.context,
  );
}

final class _PendingResourceChatRepository extends _ResourceChatRepository {
  final result = Completer<Either<ApiError, ChatConversation>>();
  int calls = 0;
  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) {
    calls++;
    return result.future;
  }
}

final class _ExpiredRetryResourceChatRepository
    extends _ResourceChatRepository {
  int calls = 0;
  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) async {
    calls++;
    return Left(
      ApiError(
        type: ApiErrorType.server,
        message: 'Spróbuj ponownie.',
        retryAfterUtc: DateTime.now().toUtc().subtract(
          const Duration(seconds: 1),
        ),
      ),
    );
  }
}
