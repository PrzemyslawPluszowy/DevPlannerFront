// Repository stays a port instead of a global function to keep dependency
// injection and error contracts explicit at the presentation boundary.
// ignore_for_file: one_member_abstracts

import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_reply_command.dart';

/// Port odpowiedzi z centrum powiadomień do autoryzowanej rozmowy Chat.
abstract interface class NotificationReplyRepository {
  /// Wysyła idempotentną odpowiedź i zwraca potwierdzoną wiadomość domenową.
  Future<Either<ApiError, ChatMessage>> reply(NotificationReplyCommand command);
}
