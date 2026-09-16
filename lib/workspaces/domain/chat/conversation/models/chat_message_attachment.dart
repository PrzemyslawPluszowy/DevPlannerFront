import 'package:equatable/equatable.dart';

/// Uporządkowana relacja bezpiecznego pliku Storage z wiadomością Chat.
final class ChatMessageAttachment extends Equatable {
  /// Tworzy attachment zwrócony przez backend po wysłaniu lub odczycie historii.
  const ChatMessageAttachment({
    required this.id,
    required this.messageId,
    required this.storageFileId,
    required this.attachedByCoreUserId,
    required this.position,
    required this.createdAtUtc,
  });

  final String id;
  final String messageId;
  final String storageFileId;
  final String attachedByCoreUserId;
  final int position;
  final DateTime createdAtUtc;

  @override
  List<Object?> get props => [
    id,
    messageId,
    storageFileId,
    attachedByCoreUserId,
    position,
    createdAtUtc,
  ];
}
