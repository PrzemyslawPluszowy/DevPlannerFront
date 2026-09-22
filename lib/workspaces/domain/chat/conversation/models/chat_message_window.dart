import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:equatable/equatable.dart';

/// Okno historii wokół wskazanej wiadomości.
///
/// Pozwala otworzyć starą wiadomość z wyszukiwania, zapisanych albo przypiętych
/// bez przechodzenia kolejnych stron historii. Kursor kontynuuje starszą część
/// istniejącym stronicowaniem rozmowy.
final class ChatMessageWindow extends Equatable {
  /// Tworzy okno historii.
  const ChatMessageWindow({
    required this.anchorMessageId,
    required this.messages,
    required this.hasMoreBefore,
    required this.hasMoreAfter,
    this.beforeCursor,
  });

  final String anchorMessageId;
  final List<ChatMessage> messages;
  final bool hasMoreBefore;
  final bool hasMoreAfter;

  /// Kursor najstarszej wiadomości okna do doładowania starszej historii.
  final String? beforeCursor;

  @override
  List<Object?> get props => [
    anchorMessageId,
    messages,
    hasMoreBefore,
    hasMoreAfter,
    beforeCursor,
  ];
}
