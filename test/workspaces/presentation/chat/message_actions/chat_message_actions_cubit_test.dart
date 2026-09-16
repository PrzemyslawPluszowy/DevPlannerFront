import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:ready_next/workspaces/presentation/chat/message_actions/message_actions_export.dart';

void main() {
  test(
    'edycja przekazuje Version i emituje wyłącznie snapshot potwierdzony API',
    () async {
      final repository = _MessageActionsRepository();
      final cubit = ChatMessageActionsCubit(repository: repository);
      final message = _Fixture.message();

      await cubit.edit(message: message, text: ' Zmieniona treść ');

      expect(repository.editVersion, 4);
      expect(repository.editText, 'Zmieniona treść');
      expect(cubit.state, isA<ChatMessageActionsUpdated>());
      expect((cubit.state as ChatMessageActionsUpdated).message.version, 5);
      await cubit.close();
    },
  );

  test(
    '409 pozostawia lokalny snapshot bez optymistycznego nadpisania',
    () async {
      final repository = _MessageActionsRepository(
        editResult: const Left(
          ApiError(
            type: ApiErrorType.conflict,
            message: 'Wersja jest nieaktualna.',
          ),
        ),
      );
      final cubit = ChatMessageActionsCubit(repository: repository);

      await cubit.edit(message: _Fixture.message(), text: 'Nowa treść');

      expect(cubit.state, isA<ChatMessageActionsConflict>());
      expect(
        (cubit.state as ChatMessageActionsConflict).messageId,
        'message-1',
      );
      await cubit.close();
    },
  );

  test('soft delete używa Version i dopiero po ACK oznacza wiadomość jako usuniętą', () async {
    final repository = _MessageActionsRepository();
    final cubit = ChatMessageActionsCubit(repository: repository);

    await cubit.delete(_Fixture.message());

    expect(repository.deleteVersion, 4);
    expect(cubit.state, isA<ChatMessageActionsDeleted>());
    final deleted = (cubit.state as ChatMessageActionsDeleted).message;
    expect(deleted.isDeleted, isTrue);
    expect(deleted.version, 5);
    await cubit.close();
  });

  test(
    '401 rewizji kończy lifecycle fail-closed bez ujawnienia historii',
    () async {
      final repository = _MessageActionsRepository(
        revisionsResult: const Left(
          ApiError(type: ApiErrorType.forbidden, message: 'Brak dostępu.'),
        ),
      );
      final cubit = ChatMessageActionsCubit(repository: repository);

      await cubit.loadRevisions('message-1');

      expect(cubit.state, isA<ChatMessageActionsAccessRevoked>());
      await cubit.close();
    },
  );
}

final class _MessageActionsRepository implements ChatMessageActionsRepository {
  _MessageActionsRepository({this.editResult, this.revisionsResult});

  Either<ApiError, ChatMessage>? editResult;
  Either<ApiError, List<ChatMessageRevision>>? revisionsResult;
  int? editVersion;
  int? deleteVersion;
  String? editText;

  @override
  Future<Either<ApiError, ChatMessage>> editMessage({
    required String messageId,
    required String text,
    required String? deltaJson,
    required int version,
  }) async {
    editVersion = version;
    editText = text;
    return editResult ??
        Right(_Fixture.message(text: text, version: version + 1));
  }

  @override
  Future<Either<ApiError, void>> deleteMessage({
    required String messageId,
    required int version,
  }) async {
    deleteVersion = version;
    return const Right(null);
  }

  @override
  Future<Either<ApiError, List<ChatMessageRevision>>> listRevisions(
    String messageId,
  ) async => revisionsResult ?? const Right(<ChatMessageRevision>[]);
}

abstract final class _Fixture {
  static ChatMessage message({String text = 'Treść', int version = 4}) =>
      ChatMessage(
        id: 'message-1',
        conversationId: 'conversation-1',
        authorCoreUserId: 'user-1',
        clientMessageId: 'client-1',
        text: text,
        payloadHash: 'hash',
        version: version,
        createdAtUtc: DateTime.utc(2026),
        isDeleted: false,
        deliveryState: ChatMessageDeliveryState.sent,
      );
}
