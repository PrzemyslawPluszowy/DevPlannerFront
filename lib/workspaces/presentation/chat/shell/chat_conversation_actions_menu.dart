import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/management/chat_rename_conversation_dialog.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_list_sheets.dart';
import 'package:devplanner/workspaces/presentation/chat/search/components/chat_conversation_search_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Menu rozmowy: wyciszenie, przypięte, zakładki i preferencje powiadomień.
///
/// Każda pozycja ma realny skutek: wyciszenie zapisuje politykę serwera,
/// listy czytają porty akcji, a preferencje otwierają istniejący modal.
class ChatConversationActionsMenu extends StatelessWidget {
  const ChatConversationActionsMenu({
    required this.conversation,
    required this.messageActions,
    required this.conversationRepository,
    required this.canRename,
    this.onOpenFullView,
    super.key,
  });

  final ChatConversation conversation;
  final ChatMessageActionsRepository? messageActions;
  final ChatConversationRepository? conversationRepository;
  final bool canRename;

  /// Otwiera pełny widok rozmowy; brak oznacza brak pozycji w menu.
  final VoidCallback? onOpenFullView;

  @override
  Widget build(BuildContext context) {
    final muteCubit = context.watch<ChatConversationMuteCubit?>();
    final isMuted = muteCubit?.state.isMuted ?? false;
    return Builder(
      builder: (anchorContext) => IconButton(
        tooltip: context.l10n.chatMembersActions,
        onPressed: () => unawaited(
          AppContextMenu.show(
            anchorContext,
            globalPosition: AppContextMenu.positionFor(anchorContext),
            actions: [
              if (canRename)
                AppContextMenuAction(
                  label: context.l10n.chatConversationRenameAction,
                  icon: Symbols.edit,
                  onTap: (_) => _rename(context),
                ),
              AppContextMenuAction(
                label: isMuted
                    ? context.l10n.chatMuteUnmute
                    : context.l10n.chatMuteMute,
                icon: isMuted ? Symbols.volume_up : Symbols.volume_off,
                enabled: muteCubit != null && !muteCubit.state.isBusy,
                onTap: (_) => _handle(context, 'mute'),
              ),
              AppContextMenuAction(
                label: context.l10n.chatPinnedOpen,
                icon: Symbols.push_pin,
                enabled: messageActions != null,
                onTap: (_) => _handle(context, 'pinned'),
              ),
              AppContextMenuAction(
                label: context.l10n.chatBookmarksOpen,
                icon: Symbols.bookmarks,
                enabled: messageActions != null,
                onTap: (_) => _handle(context, 'bookmarks'),
              ),
              AppContextMenuAction(
                label: conversation.isArchived
                    ? context.l10n.chatRestoreAction
                    : context.l10n.chatArchiveAction,
                icon: conversation.isArchived
                    ? Symbols.unarchive
                    : Symbols.archive,
                onTap: (_) => _handle(
                  context,
                  conversation.isArchived ? 'restore' : 'archive',
                ),
              ),
              AppContextMenuAction(
                label: context.l10n.chatSearchOpen,
                icon: Symbols.search,
                enabled:
                    context.read<ChatSearchCubit?>() != null ||
                    context.read<ChatSearchRepository?>() != null,
                onTap: (_) => _handle(context, 'search'),
              ),
              AppContextMenuAction(
                label: context.l10n.chatMembersActions,
                icon: Symbols.group,
                enabled: context.read<ChatMembersRepository?>() != null,
                onTap: (_) => _handle(context, 'members'),
              ),
              if (onOpenFullView != null)
                AppContextMenuAction(
                  label: context.l10n.globalChatOpenFullView,
                  icon: Symbols.open_in_new_rounded,
                  onTap: (_) => _handle(context, 'fullView'),
                ),
              AppContextMenuAction(
                label: context.l10n.chatConversationNotificationSettingsOpen,
                icon: Symbols.notifications_rounded,
                onTap: (_) => _handle(context, 'preferences'),
              ),
            ],
          ),
        ),
        icon: const Icon(Symbols.more_vert, size: 18),
      ),
    );
  }

  Future<void> _rename(BuildContext context) async {
    final management = context.read<ChatConversationManagementRepository?>();
    if (management == null) return;
    final initialName = conversation.name?.trim() ?? '';
    final name = await DevPlannerModalHost.showDialog<String>(
      context,
      builder: (_) => ChatRenameConversationDialog(initialName: initialName),
    );
    final normalized = name?.trim();
    if (normalized == null || normalized.isEmpty || !context.mounted) return;
    if (normalized == initialName) return;

    final result = await management.updateDetails(
      conversationId: conversation.id,
      name: normalized,
      postingPermission: conversation.postingPermission,
    );
    if (!context.mounted) return;
    result.fold(
      (_) => AppToast.show(
        context,
        message: context.l10n.chatConversationRenameFailure,
        tone: AppToastTone.error,
      ),
      (updated) {
        final selection = context.read<ChatPanelSelectionCubit>();
        final current = selection.state;
        selection.select(
          updated,
          role: current?.role,
          targetMessageId: current?.targetMessageId,
        );
        unawaited(context.read<ChatInboxCubit?>()?.refresh());
        AppToast.show(
          context,
          message: context.l10n.chatConversationRenameSuccess,
          tone: AppToastTone.success,
        );
      },
    );
  }

  /// Archiwizuje albo przywraca rozmowę i zamyka widok po sukcesie.
  ///
  /// Archiwizacja wymaga potwierdzenia, bo zmienia listę rozmów; przywrócenie
  /// nie, bo jest odwracalne i nie ukrywa niczego.
  Future<void> _setArchived(
    BuildContext context, {
    required bool archived,
  }) async {
    final management = context.read<ChatConversationManagementRepository?>();
    if (management == null) return;
    if (archived) {
      final confirmed = await DevPlannerModalHost.showDialog<bool>(
        context,
        builder: (dialogContext) => ChatSurfaceDialog(
          title: dialogContext.l10n.chatArchiveConfirmTitle,
          content: Text(dialogContext.l10n.chatArchiveConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.l10n.chatCreationCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(dialogContext.l10n.chatArchiveAction),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
    }
    final result = archived
        ? await management.archiveConversation(conversation.id)
        : await management.restoreConversation(conversation.id);
    if (!context.mounted) return;
    result.fold((_) {}, (_) {
      // Rozmowa wyszła z bieżącego widoku, więc panel wraca do listy.
      context.read<ChatPanelSelectionCubit>().clear();
      unawaited(context.read<ChatInboxCubit?>()?.refresh());
    });
  }

  Future<void> _handle(BuildContext context, String value) async {
    switch (value) {
      case 'search':
        final search = context.read<ChatSearchCubit?>();
        if (search != null) {
          search.open();
        } else if (context.read<ChatSearchRepository?>()
            case final repository?) {
          await ChatConversationSearchSheet.show(
            context,
            repository: repository,
            conversationId: conversation.id,
          );
        }
      case 'members':
        await ChatMembersSheet.show(
          context,
          membersRepository: context.read<ChatMembersRepository?>(),
          conversation: conversation,
          currentUserId:
              context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
          conversationManagement: context
              .read<ChatConversationManagementRepository?>(),
          presenceRepository: context.read<ChatPresenceRepository?>(),
          directoryRepository: context.read<ChatDirectoryRepository?>(),
        );
      case 'fullView':
        onOpenFullView?.call();
      case 'mute':
        await context.read<ChatConversationMuteCubit?>()?.toggleMute();
      case 'pinned':
        await ChatPinnedMessagesSheet.show(
          context,
          repository: messageActions,
          conversationId: conversation.id,
          onOpenMessage: (messageId) => unawaited(
            context.read<ChatConversationCubit>().ensureTargetLoaded(messageId),
          ),
        );
      case 'bookmarks':
        await ChatBookmarksSheet.show(
          context,
          repository: messageActions,
          onOpenMessage: (conversationId, messageId) => unawaited(
            _openSavedMessage(context, conversationId, messageId),
          ),
        );
      case 'archive':
        await _setArchived(context, archived: true);
      case 'restore':
        await _setArchived(context, archived: false);
      case 'preferences':
        if (!context.mounted) return;
        await ChatConversationNotificationSettingsModal.show(
          context,
          conversationId: conversation.id,
        );
    }
  }

  Future<void> _openSavedMessage(
    BuildContext context,
    String conversationId,
    String messageId,
  ) async {
    if (conversationId == conversation.id) {
      await context.read<ChatConversationCubit>().ensureTargetLoaded(messageId);
      return;
    }
    final selection = context.read<ChatPanelSelectionCubit?>();
    if (selection == null) return;
    final inbox = context.read<ChatInboxCubit?>()?.state;
    if (inbox case ChatInboxReady(:final items)) {
      for (final item in items) {
        if (item.conversation.id == conversationId) {
          selection.select(
            item.conversation,
            role: item.role,
            targetMessageId: messageId,
          );
          return;
        }
      }
    }
    final repository = conversationRepository;
    if (repository == null) return;
    final result = await repository.getConversation(conversationId);
    if (!context.mounted) return;
    result.fold(
      (_) => AppToast.show(
        context,
        message: context.l10n.globalChatLoadFailureTitle,
        tone: AppToastTone.error,
      ),
      (conversation) => selection.select(
        conversation,
        targetMessageId: messageId,
      ),
    );
  }
}
