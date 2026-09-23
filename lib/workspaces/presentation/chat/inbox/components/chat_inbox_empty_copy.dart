import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_filter.dart';

/// Lokalizowany opis pustej skrzynki zgodny z aktywnym filtrem.
abstract final class ChatInboxEmptyCopy {
  /// Zwraca komunikat, który opisuje pustą sekcję zamiast każdej nazywać aktywną.
  static String forFilter(AppLocalizations l10n, ChatInboxFilter filter) =>
      switch (filter) {
        ChatInboxFilter.all => l10n.globalChatEmptyMessage,
        ChatInboxFilter.unread => l10n.chatInboxEmptyUnread,
        ChatInboxFilter.direct => l10n.chatInboxEmptyDirect,
        ChatInboxFilter.groups => l10n.chatInboxEmptyGroups,
        ChatInboxFilter.channels => l10n.chatInboxEmptyChannels,
        ChatInboxFilter.mentions => l10n.chatInboxEmptyMentions,
        ChatInboxFilter.archived => l10n.chatInboxEmptyArchived,
      };
}
