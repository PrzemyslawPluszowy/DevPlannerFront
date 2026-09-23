import 'package:devplanner/l10n/app_localizations_en.dart';
import 'package:devplanner/l10n/app_localizations_pl.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_filter.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_empty_copy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatInboxEmptyCopy', () {
    test('returns text that matches every Polish inbox filter', () {
      final l10n = AppLocalizationsPl();

      expect(
        ChatInboxEmptyCopy.forFilter(l10n, ChatInboxFilter.all),
        l10n.globalChatEmptyMessage,
      );
      expect(
        ChatInboxEmptyCopy.forFilter(l10n, ChatInboxFilter.unread),
        l10n.chatInboxEmptyUnread,
      );
      expect(
        ChatInboxEmptyCopy.forFilter(l10n, ChatInboxFilter.direct),
        l10n.chatInboxEmptyDirect,
      );
      expect(
        ChatInboxEmptyCopy.forFilter(l10n, ChatInboxFilter.groups),
        l10n.chatInboxEmptyGroups,
      );
      expect(
        ChatInboxEmptyCopy.forFilter(l10n, ChatInboxFilter.channels),
        l10n.chatInboxEmptyChannels,
      );
      expect(
        ChatInboxEmptyCopy.forFilter(l10n, ChatInboxFilter.mentions),
        l10n.chatInboxEmptyMentions,
      );
      expect(
        ChatInboxEmptyCopy.forFilter(l10n, ChatInboxFilter.archived),
        l10n.chatInboxEmptyArchived,
      );
    });

    test(
      'the Archive copy is translated and does not describe active chats',
      () {
        final polish = ChatInboxEmptyCopy.forFilter(
          AppLocalizationsPl(),
          ChatInboxFilter.archived,
        );
        final english = ChatInboxEmptyCopy.forFilter(
          AppLocalizationsEn(),
          ChatInboxFilter.archived,
        );

        expect(polish, 'Zarchiwizowane rozmowy pojawią się tutaj.');
        expect(english, 'Your archived conversations will appear here.');
        expect(polish, isNot(contains('aktywne')));
        expect(english, isNot(contains('active')));
      },
    );
  });
}
