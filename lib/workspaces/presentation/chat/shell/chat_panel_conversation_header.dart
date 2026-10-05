import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_conversation_actions_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nagłówek panelu rozmowy oraz kontekst udostępnionego pliku.
final class ChatPanelConversationHeader extends StatelessWidget {
  const ChatPanelConversationHeader({
    required this.conversation,
    required this.onBack,
    this.title,
    this.avatarUserId,
    this.avatarUrl,
    this.avatarLabel,
    this.subtitle,
    this.subtitleWidget,
    this.onOpenMembers,
    this.onOpenFullView,
    this.resourceContext,
    this.messageActions,
    this.conversationRepository,
    this.canManageConversation = false,
    this.showBackButton = true,
    super.key,
  });

  final ChatConversation conversation;
  final VoidCallback onBack;

  /// Nagłówek podany przez właściciela, np. etykieta rozmówcy w DM.
  final String? title;

  /// UUID rozmówcy w DM; brak oznacza awatar grupy z inicjałów nazwy.
  final String? avatarUserId;

  /// URL zdjęcia z profilu rozmówcy; brak oznacza awatar z inicjałami.
  final String? avatarUrl;

  /// Etykieta awatara; w DM rozmówca, w grupie nazwa rozmowy.
  final String? avatarLabel;

  /// Jedna linia kontekstu pod nazwą, np. liczba uczestników; brak ją ukrywa.
  final String? subtitle;

  /// Linia kontekstu jako widget (np. status rozmówcy); ma pierwszeństwo
  /// przed [subtitle], bo niesie treść z serwera.
  final Widget? subtitleWidget;

  /// Otwiera uczestników i, zależnie od roli, akcję dodawania osób.
  final VoidCallback? onOpenMembers;

  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  /// Port akcji wiadomości; brak oznacza brak list przypiętych i zakładek.
  final ChatMessageActionsRepository? messageActions;

  /// ACL-owane pobieranie rozmowy dla skoku z zakładki do innej konwersacji.
  final ChatConversationRepository? conversationRepository;

  /// Uprawnienie z roli zwróconej przez inbox; serwer ponownie sprawdza ACL.
  final bool canManageConversation;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, Sizes.p4),
    child: Column(
      children: [
        if (resourceContext case final current?)
          _ResourceChatHeader(context: current),
        Row(
          children: [
            if (showBackButton)
              IconButton(
                tooltip: context.l10n.globalChatBackToConversations,
                onPressed: onBack,
                icon: const Icon(Symbols.arrow_back_rounded, size: 19),
              ),
            AppUserAvatar(
              userId: avatarUserId,
              displayName: avatarLabel ?? _headerTitle(context),
              avatarUrl: avatarUrl,
              hasCustomAvatar: avatarUrl?.trim().isNotEmpty == true,
              radius: context.chatTheme.avatarHeader / 2,
            ),
            const SizedBox(width: Sizes.p8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _headerTitle(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.chatTheme.contentStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.chatTheme.incomingText,
                    ),
                  ),
                  if (subtitleWidget != null)
                    subtitleWidget!
                  else if (subtitle?.trim().isNotEmpty ?? false)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.chatTheme.metadataStyle.copyWith(
                        color: context.chatTheme.metadataText,
                      ),
                    ),
                ],
              ),
            ),
            if (onOpenMembers case final openMembers?)
              IconButton(
                tooltip: context.l10n.chatMembersOpen,
                onPressed: openMembers,
                icon: const Icon(Symbols.group_add, size: 19),
              ),
            Builder(
              builder: (context) {
                final presence = context.read<ChatPresenceRepository?>();
                final userId =
                    context.read<AuthSessionPort?>()?.snapshot.user?.userId ??
                    '';
                if (presence == null || userId.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ChatStatusMenuButton(
                  repository: presence,
                  currentUserId: userId,
                  icon: const Icon(Symbols.mood, size: 18),
                );
              },
            ),
            ChatConversationActionsMenu(
              conversation: conversation,
              messageActions: messageActions,
              conversationRepository: conversationRepository,
              canRename:
                  canManageConversation &&
                  conversation.type != 'direct' &&
                  conversation.discussionRootMessageId == null &&
                  resourceContext == null &&
                  context.read<ChatConversationManagementRepository?>() != null,
              onOpenFullView: onOpenFullView,
            ),
          ],
        ),
      ],
    ),
  );
}

/// Nazwa w nagłówku: etykieta właściciela, nazwa rozmowy albo neutralny fallback.
extension on ChatPanelConversationHeader {
  /// Zwraca etykietę tytułu bez powtarzania reguły w kilku miejscach.
  String _headerTitle(BuildContext context) => title?.trim().isNotEmpty == true
      ? title!.trim()
      : conversation.name?.trim().isNotEmpty == true
      ? conversation.name!.trim()
      : context.l10n.chatMembersFallbackName;
}

/// Zwięzły, świeży kontekst pliku nad rozmową Resource Chat.
final class _ResourceChatHeader extends StatelessWidget {
  const _ResourceChatHeader({required this.context});

  final ResourceChatFileContext context;

  @override
  Widget build(BuildContext buildContext) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p8,
        Sizes.p4,
        Sizes.p8,
        Sizes.p8,
      ),
      child: Text(
        buildContext.l10n.resourceChatFileHeader(
          context.fileName,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: buildContext.text.labelSmall?.copyWith(
          color: buildContext.colors.onSurfaceVariant,
        ),
      ),
    ),
  );
}
