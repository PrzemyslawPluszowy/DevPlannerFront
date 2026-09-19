import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_drawer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_drawer_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeChatRepository implements ChatRepository {
  const _FakeChatRepository(this.result);

  final Either<ApiError, List<ChatConversationResponse>> result;

  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() async => result;

  @override
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  ) async => const Right([]);

  @override
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  }) async => const Left(
    ApiError(
      type: ApiErrorType.server,
      message: 'Nie testujemy wysyłki.',
    ),
  );
}

void main() {
  final conversation = ChatConversationResponse(
    id: '11111111-1111-4111-8111-111111111111',
    type: ChatConversationType.channel,
    scopeKind: ChatScopeKind.workspace,
    scopeKey: 'workspace:demo',
    version: 1,
    createdAtUtc: DateTime(2026),
  );

  test('emituje gotową listę rozmów', () async {
    final cubit = ChatDrawerCubit(
      _FakeChatRepository(Right([conversation])),
    );

    await cubit.load();

    expect(cubit.state, isA<ChatDrawerReady>());
    expect((cubit.state as ChatDrawerReady).conversations, [conversation]);
    await cubit.close();
  });

  test('nie ukrywa błędu backendu', () async {
    final cubit = ChatDrawerCubit(
      const _FakeChatRepository(
        Left(ApiError(type: ApiErrorType.forbidden, message: 'Brak dostępu.')),
      ),
    );

    await cubit.load();

    expect(cubit.state, isA<ChatDrawerFailure>());
    expect((cubit.state as ChatDrawerFailure).message, 'Brak dostępu.');
    await cubit.close();
  });
}
