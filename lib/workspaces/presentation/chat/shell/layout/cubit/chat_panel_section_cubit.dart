import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan nawigacji panelu: wybrana sekcja i to, co pokazuje tryb compact.
///
/// W trybie szerokim obie kolumny są widoczne razem, więc `showList` nic nie
/// zmienia. W compact jedna kolumna oznacza wybór: rail przełącza na listę
/// sekcji, a wybór rozmowy pokazuje rozmowę. Dzięki temu kliknięcie Plików czy
/// Kanałów z otwartą rozmową naprawdę pokazuje wybraną sekcję, a rozmowa
/// pozostaje zaznaczona i gotowa po powrocie.
@immutable
final class ChatPanelSectionState {
  /// Tworzy stan nawigacji panelu.
  const ChatPanelSectionState({
    this.section = ChatPanelSection.chats,
    this.showList = true,
  });

  final ChatPanelSection section;

  /// Czy compact ma pokazać listę (`true`) czy otwartą rozmowę (`false`).
  final bool showList;

  ChatPanelSectionState copyWith({ChatPanelSection? section, bool? showList}) =>
      ChatPanelSectionState(
        section: section ?? this.section,
        showList: showList ?? this.showList,
      );

  @override
  bool operator ==(Object other) =>
      other is ChatPanelSectionState &&
      other.section == section &&
      other.showList == showList;

  @override
  int get hashCode => Object.hash(section, showList);
}

/// Prowadzi wybraną sekcję panelu komunikatora.
///
/// Cubit zna wyłącznie nawigację i nie pobiera danych: filtrem skrzynki steruje
/// `ChatInboxCubit`, zakładkami `ChatMessageSecondaryActionsCubit`, a modale
/// otwiera widok. Dzięki temu przełączenie zakładki nie kasuje zaznaczonej
/// rozmowy ani szkicu w composerze.
final class ChatPanelSectionCubit extends Cubit<ChatPanelSectionState> {
  /// Tworzy cubit sekcji panelu.
  ChatPanelSectionCubit({ChatPanelSection initial = ChatPanelSection.chats})
    : super(ChatPanelSectionState(section: initial));

  /// Wybiera sekcję i pokazuje jej listę.
  ///
  /// Ponowne kliknięcie tej samej pozycji railu także wraca do listy: w compact
  /// to jedyny sposób, żeby wrócić z otwartej rozmowy do zakładki.
  void select(ChatPanelSection section) {
    if (isClosed) return;
    if (state.section == section && state.showList) return;
    emit(state.copyWith(section: section, showList: true));
  }

  /// Pokazuje otwartą rozmowę (tryb compact); w szerokim panelu bez zmian.
  void showConversation() {
    if (isClosed || !state.showList) return;
    emit(state.copyWith(showList: false));
  }
}
