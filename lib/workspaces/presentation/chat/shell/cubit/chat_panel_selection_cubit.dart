import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';

/// Lokalny wybór rozmowy wyłącznie dla jednego egzemplarza panelu Chat.
///
/// Nie przechowuje historii ani nie wykonuje żądań. Dzięki temu persistent pane
/// i modalny side sheet mogą pokazać rozmowę bez zmiany bieżącej trasy.
final class ChatPanelSelectionCubit extends Cubit<ChatConversationResponse?> {
  ChatPanelSelectionCubit({String? initialConversationId})
    : _pendingConversationId = initialConversationId,
      super(null);

  String? _pendingConversationId;

  /// Wybiera rozmowę do wyświetlenia w aktualnym panelu.
  void select(ChatConversationResponse conversation) {
    if (state?.id == conversation.id) return;
    emit(conversation);
  }

  /// Wraca z treści rozmowy do listy skrótów panelu.
  void clear() {
    if (state == null) return;
    emit(null);
  }

  /// Odtwarza zapamiętany wybór dopiero po załadowaniu listy rozmów.
  void restoreFrom(List<ChatConversationResponse> conversations) {
    if (state != null) return;
    final conversationId = _pendingConversationId;
    if (conversationId == null) return;
    final match = conversations.cast<ChatConversationResponse?>().firstWhere(
      (conversation) => conversation?.id == conversationId,
      orElse: () => null,
    );
    if (match == null) return;
    _pendingConversationId = null;
    emit(match);
  }
}
