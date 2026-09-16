import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/chat/message_actions/models/chat_message_revision.dart';

/// Jawny stan krótkiego lifecycle akcji wykonanej na jednej wiadomości.
sealed class ChatMessageActionsState {
  const ChatMessageActionsState();
}

/// Żadna akcja nie trwa.
final class ChatMessageActionsIdle extends ChatMessageActionsState {
  const ChatMessageActionsIdle();
}

/// Backend przetwarza mutację albo odczyt rewizji wskazanej wiadomości.
final class ChatMessageActionsInProgress extends ChatMessageActionsState {
  const ChatMessageActionsInProgress(this.messageId);

  final String messageId;
}

/// Edycja zwróciła autoryzowany, aktualny snapshot wiadomości.
final class ChatMessageActionsUpdated extends ChatMessageActionsState {
  const ChatMessageActionsUpdated(this.message);

  final ChatMessage message;
}

/// Soft delete został zaakceptowany; snapshot zachowuje tylko bezpieczny stan.
final class ChatMessageActionsDeleted extends ChatMessageActionsState {
  const ChatMessageActionsDeleted(this.message);

  final ChatMessage message;
}

/// Historia poprzednich wersji została odczytana przez backend.
final class ChatMessageActionsRevisions extends ChatMessageActionsState {
  const ChatMessageActionsRevisions({
    required this.messageId,
    required this.revisions,
  });

  final String messageId;
  final List<ChatMessageRevision> revisions;
}

/// Backend odrzucił mutację, ponieważ wersja wiadomości nie jest już aktualna.
final class ChatMessageActionsConflict extends ChatMessageActionsState {
  const ChatMessageActionsConflict({
    required this.messageId,
    required this.message,
  });

  final String messageId;
  final String message;
}

/// Backend odebrał dostęp; rodzic rozmowy musi natychmiast odrzucić cache.
final class ChatMessageActionsAccessRevoked extends ChatMessageActionsState {
  const ChatMessageActionsAccessRevoked(this.message);

  final String message;
}

/// Inny błąd kontraktu, pokazany bez udawania sukcesu.
final class ChatMessageActionsFailure extends ChatMessageActionsState {
  const ChatMessageActionsFailure({
    required this.messageId,
    required this.message,
  });

  final String messageId;
  final String message;
}
