import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wybór rozmowy w panelu wraz z opcjonalnym celem skoku.
///
/// Skok pochodzi z wyszukiwania: wynik otwiera rozmowę i pozycję wiadomości.
/// Cel jest częścią stanu, bo powtórny wybór tej samej rozmowy musi nadal
/// przenieść widok do wskazanej wiadomości.
final class ChatPanelSelection extends Equatable {
  /// Tworzy wybór rozmowy.
  const ChatPanelSelection({
    required this.conversation,
    this.targetMessageId,
    this.role,
  });

  final ChatConversation conversation;

  /// Wiadomość, do której widok ma przewinąć, albo `null`.
  final String? targetMessageId;

  /// Rola bieżącego użytkownika z serwerowej skrzynki albo `null`, gdy nieznana.
  ///
  /// Panel używa jej wyłącznie do ukrycia akcji moderacji; backend i tak
  /// ponownie egzekwuje uprawnienia.
  final String? role;

  /// Czy rola pozwala moderować cudzą treść.
  bool get canModerate => role == 'Owner' || role == 'Moderator';

  @override
  List<Object?> get props => [conversation, targetMessageId, role];
}

/// Lokalny wybór rozmowy wyłącznie dla jednego egzemplarza panelu Chat.
///
/// Nie przechowuje historii ani nie wykonuje żądań. Dzięki temu persistent pane
/// i modalny side sheet mogą pokazać rozmowę bez zmiany bieżącej trasy. Wybór
/// trzyma model domenowy, więc panel nie zależy od kształtu transportu.
final class ChatPanelSelectionCubit extends Cubit<ChatPanelSelection?> {
  ChatPanelSelectionCubit({String? initialConversationId})
    : _pendingConversationId = initialConversationId,
      super(null);

  String? _pendingConversationId;

  /// Wiadomość, do której panel ma przewinąć po otwarciu rozmowy.
  String? get targetMessageId => state?.targetMessageId;

  /// Wybiera rozmowę do wyświetlenia w aktualnym panelu.
  ///
  /// `targetMessageId` pochodzi z wyszukiwania; powtórny wybór tej samej
  /// rozmowy z innym celem nadal przenosi widok do wskazanej wiadomości.
  void select(
    ChatConversation conversation, {
    String? targetMessageId,
    String? role,
  }) {
    if (state?.conversation.id == conversation.id &&
        state?.targetMessageId == targetMessageId &&
        state?.role == role) {
      return;
    }
    emit(
      ChatPanelSelection(
        conversation: conversation,
        targetMessageId: targetMessageId,
        role: role,
      ),
    );
  }

  /// Wraca z treści rozmowy do listy skrótów panelu.
  void clear() {
    if (state == null) return;
    emit(null);
  }

  /// Odtwarza zapamiętany wybór dopiero po załadowaniu listy rozmów.
  void restoreFrom(List<ChatConversation> conversations) {
    if (state != null) return;
    final conversationId = _pendingConversationId;
    if (conversationId == null) return;
    final match = conversations.cast<ChatConversation?>().firstWhere(
      (conversation) => conversation?.id == conversationId,
      orElse: () => null,
    );
    if (match == null) return;
    _pendingConversationId = null;
    emit(ChatPanelSelection(conversation: match));
  }
}
