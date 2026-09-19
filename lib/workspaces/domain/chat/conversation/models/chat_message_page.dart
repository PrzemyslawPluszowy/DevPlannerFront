import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:equatable/equatable.dart';

/// Nieprzezroczysta strona historii rozmowy wraz z kursorem kolejnego odczytu.
final class ChatMessagePage extends Equatable {
  /// Tworzy stronę wiadomości zwróconą przez cursorowy endpoint backendu.
  const ChatMessagePage({required this.items, this.nextCursor});

  final List<ChatMessage> items;
  final String? nextCursor;

  @override
  List<Object?> get props => [items, nextCursor];
}
