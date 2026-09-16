import 'package:equatable/equatable.dart';

/// Intencja odpowiedzi z centrum powiadomień do właściwej rozmowy Chat.
final class NotificationReplyCommand extends Equatable {
  /// Tworzy idempotentną odpowiedź powiązaną z powiadomieniem.
  const NotificationReplyCommand({
    required this.notificationId,
    required this.clientMessageId,
    required this.text,
    this.deltaJson,
  });

  final String notificationId;
  final String clientMessageId;
  final String text;
  final String? deltaJson;

  @override
  List<Object?> get props => [notificationId, clientMessageId, text, deltaJson];
}
