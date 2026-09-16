import 'package:equatable/equatable.dart';

/// Serwerowo wydana sesja tymczasowych załączników przypisana do rozmowy.
final class ChatAttachmentSession extends Equatable {
  /// Tworzy bezpieczny snapshot sesji bez ticketów, URL-i ani tokenów Storage.
  const ChatAttachmentSession({
    required this.id,
    required this.conversationId,
    required this.expiresAtUtc,
  });

  final String id;
  final String conversationId;
  final DateTime expiresAtUtc;

  @override
  List<Object?> get props => [id, conversationId, expiresAtUtc];
}
