import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/resource/cubit/resource_chat_cubit.dart';

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
