import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';
import 'package:equatable/equatable.dart';

/// Stan lokalnej dostawy wiadomości, niezależny od potwierdzenia backendu.
enum ChatMessageDeliveryState { sending, sent, failed }

/// Wiadomość rozmowy, również w stanie optymistycznym przed potwierdzeniem API.
final class ChatMessage extends Equatable {
  /// Tworzy wiadomość potwierdzoną przez backend albo lokalny wpis kolejki.
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.authorUserId,
    required this.clientMessageId,
    required this.text,
    required this.payloadHash,
    required this.version,
    required this.createdAtUtc,
    required this.isDeleted,
    required this.deliveryState,
    this.deltaJson,
    this.displayText,
    this.replyToMessageId,
    this.threadRootMessageId,
    this.isEdited = false,
    this.deletedAtUtc,
    this.deliveryError,
    this.attachments = const <ChatMessageAttachment>[],
    this.reactions = const <ChatReactionSummary>[],
    this.deliveredToCount = 0,
    this.readByCount = 0,
    this.links = const <ChatMessageLink>[],
  });

  final String id;
  final String conversationId;
  final String authorUserId;
  final String clientMessageId;
  final String text;
  final String? deltaJson;

  /// Lokalna etykieta treści dla optymistycznej wiadomości.
  ///
  /// `text` pozostaje kanonicznym tekstem transportowym (np. z tokenami @UUID),
  /// a pole to pozwala autorowi widzieć nazwy wybrane w pickerze po potwierdzeniu.
  final String? displayText;
  final String? replyToMessageId;
  final String payloadHash;
  final int version;
  final DateTime createdAtUtc;
  final bool isDeleted;
  final String? threadRootMessageId;
  final bool isEdited;
  final DateTime? deletedAtUtc;
  final ChatMessageDeliveryState deliveryState;
  final String? deliveryError;
  final List<ChatMessageAttachment> attachments;

  /// Zagregowane reakcje emoji widoczne dla członka rozmowy.
  final List<ChatReactionSummary> reactions;

  /// Liczba odbiorców potwierdzonych przez serwer jako dostarczeni albo czytający.
  final int deliveredToCount;

  /// Liczba odbiorców, którzy odczytali wiadomość według serwera.
  final int readByCount;

  /// Linki rozpoznane przez backend; używane do klikalnego tekstu i preview.
  final List<ChatMessageLink> links;

  /// Zwraca kopię wpisu z nowym wynikiem dostawy bez zmiany idempotency key.
  ChatMessage copyWithDelivery({
    required ChatMessageDeliveryState deliveryState,
    String? deliveryError,
    ChatMessage? confirmedMessage,
  }) {
    final source = confirmedMessage ?? this;
    return ChatMessage(
      id: source.id,
      conversationId: source.conversationId,
      authorUserId: source.authorUserId,
      clientMessageId: source.clientMessageId,
      text: source.text,
      deltaJson: source.deltaJson,
      displayText: displayText ?? source.displayText,
      replyToMessageId: source.replyToMessageId,
      payloadHash: source.payloadHash,
      version: source.version,
      createdAtUtc: source.createdAtUtc,
      isDeleted: source.isDeleted,
      threadRootMessageId: source.threadRootMessageId,
      isEdited: source.isEdited,
      deletedAtUtc: source.deletedAtUtc,
      deliveryState: deliveryState,
      deliveryError: deliveryError,
      attachments: source.attachments,
      deliveredToCount: source.deliveredToCount,
      readByCount: source.readByCount,
      links: source.links,
    );
  }

  /// Zwraca lokalnie zachowaną wiadomość oznaczoną przez event usunięcia.
  ChatMessage copyWithDeletion({required int version}) => ChatMessage(
    id: id,
    conversationId: conversationId,
    authorUserId: authorUserId,
    clientMessageId: clientMessageId,
    text: text,
    deltaJson: deltaJson,
    replyToMessageId: replyToMessageId,
    payloadHash: payloadHash,
    version: version,
    createdAtUtc: createdAtUtc,
    isDeleted: true,
    threadRootMessageId: threadRootMessageId,
    isEdited: isEdited,
    deletedAtUtc: deletedAtUtc,
    deliveryState: deliveryState,
    deliveryError: deliveryError,
    attachments: attachments,
    links: links,
  );

  @override
  List<Object?> get props => [
    id,
    conversationId,
    authorUserId,
    clientMessageId,
    text,
    deltaJson,
    displayText,
    replyToMessageId,
    payloadHash,
    version,
    createdAtUtc,
    isDeleted,
    threadRootMessageId,
    isEdited,
    deletedAtUtc,
    deliveryState,
    deliveryError,
    attachments,
    reactions,
    deliveredToCount,
    readByCount,
    links,
  ];
}
