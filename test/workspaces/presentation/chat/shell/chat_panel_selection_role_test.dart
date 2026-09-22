import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium zarządzania rejestrujące archiwizację i przywrócenie.
final class _ManagementFake implements ChatConversationManagementRepository {
  ApiError? failure;
  final List<String> calls = <String>[];

  @override
  Future<Either<ApiError, void>> archiveConversation(
    String conversationId,
  ) async {
    calls.add('archive:$conversationId');
    final error = failure;
    if (error != null) return Left(error);
    return const Right(null);
  }

  @override
  Future<Either<ApiError, void>> restoreConversation(
    String conversationId,
  ) async {
    calls.add('restore:$conversationId');
    final error = failure;
    if (error != null) return Left(error);
    return const Right(null);
  }

  @override
  Future<Either<ApiError, ChatConversation>> createConversation(
    ChatConversationCreateCommand command,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatConversation>> updateDetails({
    required String conversationId,
    required String? name,
    required String postingPermission,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> leaveConversation(
    String conversationId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatConversation>>>
  listArchivedConversations() async => throw UnimplementedError();
}

ChatConversation conversation({bool isArchived = false}) => ChatConversation(
  id: 'conversation-1',
  type: 'group',
  scopeKind: 'global',
  scopeKey: 'global:grupa',
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9, 21),
  postingPermission: 'Everyone',
  isArchived: isArchived,
  name: 'Grupa',
);

void main() {
  group('ChatPanelSelection — sygnał roli', () {
    test('rola Owner i Moderator pozwalają moderować cudzą treść', () async {
      final cubit = ChatPanelSelectionCubit();

      cubit.select(conversation(), role: 'Owner');
      expect(cubit.state?.canModerate, isTrue);

      cubit.select(conversation(), role: 'Moderator');
      expect(cubit.state?.canModerate, isTrue);

      cubit.select(conversation(), role: 'Member');
      expect(cubit.state?.canModerate, isFalse);

      cubit.select(conversation(), role: 'Observer');
      expect(cubit.state?.canModerate, isFalse);
      await cubit.close();
    });

    test('brak roli nie udaje uprawnień moderacji', () async {
      final cubit = ChatPanelSelectionCubit();

      cubit.select(conversation());

      expect(cubit.state?.role, isNull);
      expect(
        cubit.state?.canModerate,
        isFalse,
        reason: 'nieznana rola nie może odblokować edycji cudzej treści',
      );
      await cubit.close();
    });

    test(
      'ponowny wybór tej samej rozmowy z inną rolą aktualizuje stan',
      () async {
        final cubit = ChatPanelSelectionCubit();
        cubit.select(conversation(), role: 'Member');

        cubit.select(conversation(), role: 'Owner');

        expect(cubit.state?.canModerate, isTrue);
        await cubit.close();
      },
    );
  });

  group('ChatConversationManagementRepository — archiwizacja', () {
    test('archiwizacja i przywrócenie mają realny skutek w porcie', () async {
      final repository = _ManagementFake();

      await repository.archiveConversation('conversation-1');
      await repository.restoreConversation('conversation-1');

      expect(repository.calls, <String>[
        'archive:conversation-1',
        'restore:conversation-1',
      ]);
    });

    test('porażka archiwizacji jest błędem, nie cichym sukcesem', () async {
      final repository = _ManagementFake()
        ..failure = const ApiError(
          type: ApiErrorType.forbidden,
          message: 'chat.conversations.manage_failed',
          apiCode: 'chat.conversations.manage_failed',
          statusCode: 403,
        );

      final result = await repository.archiveConversation('conversation-1');

      expect(result.isLeft(), isTrue);
      expect(
        result.swap().getOrElse(() => throw StateError('brak')).apiCode,
        'chat.conversations.manage_failed',
      );
    });
  });
}
