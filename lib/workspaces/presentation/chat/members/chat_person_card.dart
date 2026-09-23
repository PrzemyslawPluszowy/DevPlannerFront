import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_label.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Karta osoby otwierana z listy członków.
///
/// Pokazuje tylko potwierdzone dane: nazwę, awatar, rolę w rozmowie i status,
/// jeśli port obecności go zwrócił. „Napisz” rozwiązuje rozmowę 1:1 przez ten
/// sam kontrakt co kreator (`POST /conversations/resolve`) i otwiera ją w panelu;
/// brak portu albo błąd nie udaje wysłania wiadomości.
abstract final class ChatPersonCard {
  /// Otwiera kartę wybranej osoby.
  static Future<void> show(
    BuildContext context, {
    required ChatMember member,
    required bool isCurrentUser,
    ChatPresenceRepository? presenceRepository,
    ChatConversationManagementRepository? conversationManagement,
  }) => DevPlannerModalHost.showDialog<void>(
    context,
    builder: (_) => _ChatPersonCardDialog(
      member: member,
      isCurrentUser: isCurrentUser,
      presenceRepository: presenceRepository,
      conversationManagement: conversationManagement,
    ),
  );
}

class _ChatPersonCardDialog extends StatefulWidget {
  const _ChatPersonCardDialog({
    required this.member,
    required this.isCurrentUser,
    this.presenceRepository,
    this.conversationManagement,
  });

  final ChatMember member;
  final bool isCurrentUser;
  final ChatPresenceRepository? presenceRepository;
  final ChatConversationManagementRepository? conversationManagement;

  @override
  State<_ChatPersonCardDialog> createState() => _ChatPersonCardDialogState();
}

class _ChatPersonCardDialogState extends State<_ChatPersonCardDialog> {
  ChatUserStatus? _status;
  bool _writing = false;
  String? _failureCode;

  @override
  void initState() {
    super.initState();
    unawaited(_loadStatus());
  }

  /// Status jest uzupełnieniem karty: brak portu albo błąd nie psuje widoku.
  Future<void> _loadStatus() async {
    final repository = widget.presenceRepository;
    if (repository == null) return;
    final result = await repository.getUserStatus(widget.member.userId);
    if (!mounted) return;
    result.fold((_) {}, (status) => setState(() => _status = status));
  }

  /// Rozwiązuje rozmowę 1:1 i otwiera ją w panelu.
  Future<void> _write() async {
    final repository = widget.conversationManagement;
    if (repository == null || _writing) return;
    setState(() {
      _writing = true;
      _failureCode = null;
    });
    final cubit = ChatCreationCubit(repository: repository);
    try {
      await cubit.startDirectWith(
        ChatDirectoryEntry(
          userId: widget.member.userId,
          login: widget.member.login?.trim().isNotEmpty == true
              ? widget.member.login!.trim()
              : widget.member.label,
          displayName: widget.member.label,
          avatarUrl: widget.member.avatarUrl,
        ),
      );
      final created = cubit.state.created;
      if (!mounted) return;
      if (created == null) {
        setState(() {
          _writing = false;
          _failureCode = context.l10n.chatPersonWriteFailed;
        });
        return;
      }
      DevPlannerPanelsScope.openConversationOf(context)?.call(created.id);
      Navigator.of(context).maybePop();
    } finally {
      await cubit.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final member = widget.member;
    final canWrite =
        !widget.isCurrentUser && widget.conversationManagement != null;
    return ChatSurfaceDialog(
      title: member.label,
      subtitle: _roleLabel(context, member.role),
      leading: AppUserAvatar(
        userId: member.userId,
        displayName: member.label,
        avatarUrl: member.avatarUrl,
        hasCustomAvatar: member.avatarUrl?.trim().isNotEmpty == true,
        radius: chat.avatarInbox / 2,
        singleInitial: true,
      ),
      maxWidth: 420,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_status != null)
            ChatStatusLabel(
              status: _status,
              style: chat.contentStyle.copyWith(color: chat.metadataText),
            ),
          if (_failureCode != null) ...[
            const SizedBox(height: Sizes.p8),
            Text(
              _failureCode!,
              style: chat.metadataStyle.copyWith(color: chat.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(MaterialLocalizations.of(context).closeButtonTooltip),
        ),
        if (canWrite)
          FilledButton.icon(
            key: const ValueKey('chat-person-write'),
            onPressed: _writing ? null : () => unawaited(_write()),
            icon: const Icon(Symbols.chat_bubble, size: 18),
            label: Text(context.l10n.chatPersonWrite),
          ),
      ],
    );
  }
}

String _roleLabel(BuildContext context, ChatMemberRole role) => switch (role) {
  ChatMemberRole.owner => context.l10n.chatMemberRoleOwner,
  ChatMemberRole.moderator => context.l10n.chatMemberRoleModerator,
  ChatMemberRole.member => context.l10n.chatMemberRoleMember,
  ChatMemberRole.observer => context.l10n.chatMemberRoleObserver,
};
