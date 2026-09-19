import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_page.dart';

/// Kontrakt historii jednego wątku, oddzielony od snapshotu całej rozmowy.
// Kontrakt pozostaje punktem rozszerzenia dla mute i pagination wątku.
// ignore: one_member_abstracts
abstract interface class ChatThreadRepository {
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  });
}
