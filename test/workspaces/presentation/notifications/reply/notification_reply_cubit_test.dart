import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_reply_command.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_reply_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/conversation_delivery/chat_client_message_id_factory.dart';
import 'package:ready_next/workspaces/presentation/notifications/reply/cubit/notification_reply_cubit.dart';

class _FakeNotificationReplyRepository implements NotificationReplyRepository {
  final List<NotificationReplyCommand> commands = <NotificationReplyCommand>[];
  final List<Either<ApiError, ChatMessage>> results =
      <Either<ApiError, ChatMessage>>[];

  @override
  Future<Either<ApiError, ChatMessage>> reply(
    NotificationReplyCommand command,
  ) async {
    commands.add(command);
    return results.removeAt(0);
  }
}

abstract final class _ReplyFixture {
  static ChatMessage message({String clientMessageId = 'client-id'}) =>
      ChatMessage(
        id: 'message-id',
        conversationId: 'conversation-id',
        authorCoreUserId: 'author-id',
        clientMessageId: clientMessageId,
        text: 'Potwierdzona odpowiedź',
        payloadHash: 'payload-hash',
        version: 1,
        createdAtUtc: DateTime.utc(2026),
        isDeleted: false,
        deliveryState: ChatMessageDeliveryState.sent,
      );
}

void main() {
  group('NotificationReplyCubit', () {
    test(
      'wysyła potwierdzoną odpowiedź Chat przez wyłączny port reply',
      () async {
        final repository = _FakeNotificationReplyRepository()
          ..results.add(Right(_ReplyFixture.message()));
        final cubit = NotificationReplyCubit(
          repository: repository,
          notificationId: 'notification-id',
          clientMessageIdFactory: ChatClientMessageIdFactory(random: Random(4)),
        );
        addTearDown(cubit.close);

        cubit.updateRichText(
          text: 'Odpowiedź',
          deltaJson: '[{"insert":"Odpowiedź\\n"}]',
        );
        await cubit.send();

        expect(cubit.state, isA<NotificationReplySucceeded>());
        expect(repository.commands, hasLength(1));
        expect(repository.commands.single.notificationId, 'notification-id');
        expect(repository.commands.single.text, 'Odpowiedź');
        expect(
          repository.commands.single.deltaJson,
          '[{"insert":"Odpowiedź\\n"}]',
        );
        expect(
          repository.commands.single.clientMessageId,
          matches(RegExp(r'^[0-9a-f-]{36}$')),
        );
      },
    );

    for (final errorType in <ApiErrorType>[
      ApiErrorType.unauthorized,
      ApiErrorType.forbidden,
    ]) {
      test('${errorType.name} po revoke usuwa tekst, Delta i UUID', () async {
        final repository = _FakeNotificationReplyRepository()
          ..results.add(
            Left(ApiError(type: errorType, message: 'Dostęp odebrany.')),
          );
        final cubit = NotificationReplyCubit(
          repository: repository,
          notificationId: 'notification-id',
          clientMessageIdFactory: ChatClientMessageIdFactory(random: Random(9)),
        );
        addTearDown(cubit.close);

        cubit.updateRichText(
          text: 'Prywatna odpowiedź',
          deltaJson: '[{"insert":"Prywatna odpowiedź\\n"}]',
        );
        await cubit.send();

        final revoked = cubit.state as NotificationReplyAccessRevoked;
        expect(revoked.error.type, errorType);
        expect(repository.commands.single.clientMessageId, isNotEmpty);

        // Stan po revoke nie zawiera draftu ani UUID i nie daje go edytować.
        cubit.updatePlainText('Nie wolno przywrócić szkicu');
        expect(cubit.state, same(revoked));
      });
    }

    test('retry po błędzie przejściowym zachowuje jeden client UUID', () async {
      final repository = _FakeNotificationReplyRepository()
        ..results.addAll([
          const Left(
            ApiError(type: ApiErrorType.connection, message: 'Offline'),
          ),
          Right(_ReplyFixture.message()),
        ]);
      final cubit = NotificationReplyCubit(
        repository: repository,
        notificationId: 'notification-id',
        clientMessageIdFactory: ChatClientMessageIdFactory(random: Random(7)),
      );
      addTearDown(cubit.close);

      cubit.updatePlainText('Spróbuj ponownie');
      await cubit.send();
      final failed = cubit.state as NotificationReplyEditing;
      expect(failed.error?.type, ApiErrorType.connection);
      expect(failed.clientMessageId, isNotNull);

      await cubit.send();

      expect(cubit.state, isA<NotificationReplySucceeded>());
      expect(repository.commands, hasLength(2));
      expect(
        repository.commands.first.clientMessageId,
        repository.commands.last.clientMessageId,
      );
    });
  });
}
