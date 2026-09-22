import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Sekcja panelu wybierana na railu.
///
/// Czaty, Grupy, Kanały i Archiwum to filtry tej samej serwerowej skrzynki, więc
/// nie mają własnych danych. Pliki i Zadania / Kanban są przygotowane pod
/// rozmowy kontekstowe i do czasu integracji pokazują uczciwy stan. Zapisane,
/// Profil i Ustawienia mają własne źródło albo modal.
///
/// Kolejność wartości jest kolejnością pozycji na railu z §2.2 planu korekty.
enum ChatPanelSection {
  /// Wszystkie aktywne rozmowy globalne.
  chats,

  /// Grupy.
  groups,

  /// Kanały i ogłoszenia.
  channels,

  /// Rozmowy plików — zakładka przygotowana, integracja późniejsza.
  files,

  /// Rozmowy zadań i Kanbanu — zakładka przygotowana, integracja późniejsza.
  tasks,

  /// Archiwum rozmów.
  archived,

  /// Zapisane wiadomości.
  saved,

  /// Własny status i obecność.
  profile,

  /// Ustawienia komunikatora.
  settings;

  /// Filtr skrzynki stojący za sekcją; `null` dla sekcji spoza skrzynki.
  ChatInboxFilter? get inboxFilter => switch (this) {
    chats => ChatInboxFilter.all,
    groups => ChatInboxFilter.groups,
    channels => ChatInboxFilter.channels,
    archived => ChatInboxFilter.archived,
    files || tasks || saved || profile || settings => null,
  };

  /// Czy sekcja ma własną listę rozmów (skrzynka, zakładki, rozmowy kontekstowe).
  bool get hasConversationList =>
      inboxFilter != null || this == saved || this == files || this == tasks;
}

/// Etykiety, ikony i opisy sekcji panelu.
extension ChatPanelSectionPresentation on ChatPanelSection {
  /// Nazwa pozycji railu i nagłówka kolumny listy.
  String label(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      ChatPanelSection.chats => l10n.chatPanelSectionChats,
      ChatPanelSection.groups => l10n.chatInboxFilterGroups,
      ChatPanelSection.channels => l10n.chatInboxFilterChannels,
      ChatPanelSection.files => l10n.chatPanelSectionFiles,
      ChatPanelSection.tasks => l10n.chatPanelSectionTasks,
      ChatPanelSection.archived => l10n.chatInboxFilterArchived,
      ChatPanelSection.saved => l10n.chatPanelSectionSaved,
      ChatPanelSection.profile => l10n.chatPanelSectionProfile,
      ChatPanelSection.settings => l10n.chatPanelSectionSettings,
    };
  }

  /// Ikona pozycji railu.
  IconData get icon => switch (this) {
    ChatPanelSection.chats => Symbols.forum_rounded,
    ChatPanelSection.groups => Symbols.group_rounded,
    ChatPanelSection.channels => Symbols.campaign_rounded,
    ChatPanelSection.files => Symbols.folder_rounded,
    ChatPanelSection.tasks => Symbols.view_kanban_rounded,
    ChatPanelSection.archived => Symbols.archive_rounded,
    ChatPanelSection.saved => Symbols.bookmark_rounded,
    ChatPanelSection.profile => Symbols.account_circle_rounded,
    ChatPanelSection.settings => Symbols.settings_rounded,
  };

  /// Filtry widoczne w kolumnie listy dla sekcji; pusta lista oznacza brak filtrów.
  List<ChatInboxFilter> get visibleFilters => switch (this) {
    ChatPanelSection.chats => const <ChatInboxFilter>[
      ChatInboxFilter.all,
      ChatInboxFilter.unread,
      ChatInboxFilter.direct,
    ],
    ChatPanelSection.groups => const <ChatInboxFilter>[ChatInboxFilter.groups],
    ChatPanelSection.channels => const <ChatInboxFilter>[
      ChatInboxFilter.channels,
    ],
    ChatPanelSection.archived => const <ChatInboxFilter>[
      ChatInboxFilter.archived,
    ],
    ChatPanelSection.files ||
    ChatPanelSection.tasks ||
    ChatPanelSection.saved ||
    ChatPanelSection.profile ||
    ChatPanelSection.settings => const <ChatInboxFilter>[],
  };

  /// Etykieta filtra skrzynki w kolumnie listy.
  static String filterLabel(BuildContext context, ChatInboxFilter filter) {
    final l10n = context.l10n;
    return switch (filter) {
      ChatInboxFilter.all => l10n.chatInboxFilterAll,
      ChatInboxFilter.unread => l10n.chatInboxFilterUnread,
      ChatInboxFilter.direct => l10n.chatInboxFilterDirect,
      ChatInboxFilter.groups => l10n.chatInboxFilterGroups,
      ChatInboxFilter.channels => l10n.chatInboxFilterChannels,
      ChatInboxFilter.archived => l10n.chatInboxFilterArchived,
    };
  }
}
