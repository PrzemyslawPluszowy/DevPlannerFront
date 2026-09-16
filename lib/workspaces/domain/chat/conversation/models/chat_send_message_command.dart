import 'package:equatable/equatable.dart';

/// Intencja wysłania zachowująca stabilny klucz idempotencji przy retry.
final class ChatSendMessageCommand extends Equatable {
  /// Tworzy kompletną intencję wysyłki jednej wiadomości tekstowej.
  const ChatSendMessageCommand({
    required this.conversationId,
    required this.clientMessageId,
    required this.text,
    required this.payloadHash,
    this.deltaJson,
    this.replyToMessageId,
    this.attachmentFileIds = const <String>[],
  });

  final String conversationId;
  final String clientMessageId;
  final String text;
  final String payloadHash;
  final String? deltaJson;
  final String? replyToMessageId;
  final List<String> attachmentFileIds;

  @override
  List<Object?> get props => [
    conversationId,
    clientMessageId,
    text,
    payloadHash,
    deltaJson,
    replyToMessageId,
    attachmentFileIds,
  ];
}
