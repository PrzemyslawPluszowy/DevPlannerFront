import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/presentation/chat/conversation_delivery/chat_client_message_id_factory.dart';
import 'package:ready_next/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';

void main() {
  test(
    'kolejka przekazuje Delta i reply pod jednym UUID także przy retry',
    () async {
      final repository = _ComposerDeliveryRepository();
      final queue = ChatMessageDeliveryQueue(
        repository,
        idFactory: ChatClientMessageIdFactory(random: _FixedRandom()),
      );
      final changes = <ChatMessage>[];
      final confirmations = <ChatMessageDeliveryConfirmation>[];
      final subscription = queue.changes.listen(changes.add);
      final confirmationSubscription = queue.confirmations.listen(
        confirmations.add,
      );

      final local = queue.enqueue(
        conversationId: 'conversation-1',
        draft: const ChatComposerDraft(
          text: 'Formatowana odpowiedź',
          deltaJson:
              '[{"insert":"Formatowana odpowiedź","attributes":{"bold":true}}]',
          replyToMessageId: 'message-1',
          attachmentIds: ['file-2', 'file-1'],
        ),
      );
      await _ComposerDeliveryFixture.flush();
      expect(confirmations, isEmpty);
      queue.retry(local.clientMessageId);
      await _ComposerDeliveryFixture.flush();

      expect(repository.commands, hasLength(2));
      expect(
        repository.commands.map((command) => command.clientMessageId),
        everyElement(local.clientMessageId),
      );
      expect(
        repository.commands.map((command) => command.deltaJson),
        everyElement(
          '[{"insert":"Formatowana odpowiedź","attributes":{"bold":true}}]',
        ),
      );
      expect(
        repository.commands.map((command) => command.replyToMessageId),
        everyElement('message-1'),
      );
      expect(
        repository.commands.map((command) => command.attachmentFileIds),
        everyElement(['file-2', 'file-1']),
      );
      expect(confirmations, [
        isA<ChatMessageDeliveryConfirmation>()
            .having(
              (value) => value.clientMessageId,
              'client id',
              local.clientMessageId,
            )
            .having(
              (value) => value.attachmentFileIds,
              'ordered attachment ids',
              ['file-2', 'file-1'],
            ),
      ]);
      expect(changes.last.deliveryState, ChatMessageDeliveryState.sent);
      await subscription.cancel();
      await confirmationSubscription.cancel();
      await queue.dispose();
    },
  );
}

final class _ComposerDeliveryRepository implements ChatConversationRepository {
  final List<ChatSendMessageCommand> commands = <ChatSendMessageCommand>[];
  var _attempt = 0;

  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async {
    commands.add(command);
    _attempt++;
    if (_attempt == 1) {
      return const Left(
        ApiError(type: ApiErrorType.connection, message: 'Offline.'),
      );
    }
    return Right(
      ChatMessage(
        id: 'message-1',
        conversationId: command.conversationId,
        authorCoreUserId: 'user-1',
        clientMessageId: command.clientMessageId,
        text: command.text,
        deltaJson: command.deltaJson,
        replyToMessageId: command.replyToMessageId,
        payloadHash: command.payloadHash,
        version: 1,
        createdAtUtc: DateTime.utc(2026),
        isDeleted: false,
        deliveryState: ChatMessageDeliveryState.sent,
      ),
    );
  }
}

final class _FixedRandom implements Random {
  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) => 0;
}

abstract final class _ComposerDeliveryFixture {
  static Future<void> flush() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }
}
