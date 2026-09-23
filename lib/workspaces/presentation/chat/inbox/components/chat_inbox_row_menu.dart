import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Menu kontekstowe rozmowy na liście skrzynki.
///
/// Jedno menu dla prawego kliku, długiego przytrzymania i klawiatury: pokazuje
/// wyłącznie akcje, które mają realny skutek w portach (otwarcie, wyciszenie,
/// archiwum/przywrócenie, informacje). Akcja bez portu nie pojawia się wcale,
/// więc menu nie udaje funkcji, której nie da się wykonać. Przypięcie rozmowy
/// celowo tu nie występuje: to nie jest to samo co przypięcie wiadomości.
abstract final class ChatInboxRowMenu {
  /// Buduje akcje menu dla wiersza rozmowy w bieżącym kontekście.
  static List<AppContextMenuAction> actions(
    BuildContext context, {
    required ChatInboxItem item,
    required bool archived,
    required VoidCallback onOpen,
    VoidCallback? onInfo,
  }) {
    final notificationSettings = context
        .read<ChatNotificationSettingsRepository?>();
    final management = context.read<ChatConversationManagementRepository?>();
    final cubit = context.read<ChatInboxCubit?>();
    return <AppContextMenuAction>[
      AppContextMenuAction(
        label: context.l10n.chatInboxOpen,
        icon: Symbols.forum,
        onTap: (_) => onOpen(),
      ),
      if (notificationSettings != null)
        AppContextMenuAction(
          label: item.isMuted
              ? context.l10n.chatInboxUnmute
              : context.l10n.chatInboxMute,
          icon: item.isMuted
              ? Symbols.notifications_active
              : Symbols.notifications_off,
          onTap: (menuContext) => unawaited(
            _setMuted(
              menuContext,
              repository: notificationSettings,
              cubit: cubit,
              item: item,
              muted: !item.isMuted,
            ),
          ),
        ),
      if (management != null)
        AppContextMenuAction(
          label: archived
              ? context.l10n.chatInboxRestore
              : context.l10n.chatInboxArchive,
          icon: archived ? Symbols.unarchive : Symbols.archive,
          onTap: (menuContext) => unawaited(
            _setArchived(
              menuContext,
              repository: management,
              cubit: cubit,
              item: item,
              archived: !archived,
            ),
          ),
        ),
      if (onInfo != null)
        AppContextMenuAction(
          label: context.l10n.chatInboxInfo,
          icon: Symbols.info,
          onTap: (_) => onInfo(),
        ),
    ];
  }

  /// Zmienia wyciszenie rozmowy i odświeża skrzynkę.
  static Future<void> _setMuted(
    BuildContext context, {
    required ChatNotificationSettingsRepository repository,
    required ChatInboxCubit? cubit,
    required ChatInboxItem item,
    required bool muted,
  }) async {
    // Zdjęcie wyciszenia przywraca pełne powiadomienia; inny tryb użytkownik
    // ustawia w ustawieniach rozmowy, a nie przypadkiem z menu.
    final result = await repository.updateConversationSetting(
      conversationId: item.conversation.id,
      mode: muted
          ? ChatConversationNotificationMode.muted
          : ChatConversationNotificationMode.all,
    );
    if (result.isLeft()) {
      if (!context.mounted) return;
      AppToast.show(
        context,
        message: context.l10n.chatInboxActionFailureMessage,
        tone: AppToastTone.error,
      );
      return;
    }
    unawaited(cubit?.refresh());
  }

  /// Archiwizuje albo przywraca rozmowę i odświeża skrzynkę.
  static Future<void> _setArchived(
    BuildContext context, {
    required ChatConversationManagementRepository repository,
    required ChatInboxCubit? cubit,
    required ChatInboxItem item,
    required bool archived,
  }) async {
    final result = archived
        ? await repository.archiveConversation(item.conversation.id)
        : await repository.restoreConversation(item.conversation.id);
    if (result.isLeft()) {
      if (!context.mounted) return;
      AppToast.show(
        context,
        message: context.l10n.chatInboxActionFailureMessage,
        tone: AppToastTone.error,
      );
      return;
    }
    unawaited(cubit?.refresh());
  }
}
