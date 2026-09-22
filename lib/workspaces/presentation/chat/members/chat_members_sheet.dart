import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_add_members_view.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista członków rozmowy z rolami, usuwaniem i opuszczeniem rozmowy.
///
/// Arkusz montuje się w rootowym hoście modali, więc porty dostaje jawnie.
/// Akcje są widoczne tylko dla ról, które mogą je wykonać, ale decyzję i tak
/// podejmuje backend — UI nie jest źródłem uprawnień.
abstract final class ChatMembersSheet {
  /// Otwiera listę członków wskazanej rozmowy.
  static Future<bool?> show(
    BuildContext context, {
    required ChatMembersRepository? membersRepository,
    required ChatConversation conversation,
    required String currentUserId,
    ChatConversationManagementRepository? conversationManagement,
    ChatPresenceRepository? presenceRepository,
    ChatDirectoryRepository? directoryRepository,
  }) {
    if (membersRepository == null) return Future<bool?>.value(false);
    return DevPlannerModalHost.showSideSheet<bool>(
      context,
      builder: (sheetContext) =>
          RepositoryProvider<ChatMembersRepository>.value(
            value: membersRepository,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) {
                    final cubit = ChatMembersCubit(
                      membersRepository: membersRepository,
                      conversationId: conversation.id,
                      currentUserId: currentUserId,
                      conversationManagement: conversationManagement,
                    );
                    unawaited(cubit.load());
                    return cubit;
                  },
                ),
              ],
              child: _ChatMembersSheetBody(
                conversationName:
                    conversation.name ??
                    sheetContext.l10n.chatMembersFallbackName,
                isDirect: conversation.type == 'direct',
                directoryRepository: directoryRepository,
                presenceRepository: presenceRepository,
                onClose: () => Navigator.of(sheetContext).pop(false),
              ),
            ),
          ),
    );
  }
}

class _ChatMembersSheetBody extends StatefulWidget {
  const _ChatMembersSheetBody({
    required this.conversationName,
    required this.isDirect,
    required this.onClose,
    this.directoryRepository,
    this.presenceRepository,
  });

  final String conversationName;

  /// Rozmowa 1:1 nie pozwala dopisywać osób; opcją jest nowa grupa.
  final bool isDirect;

  final VoidCallback onClose;

  /// Port lokalnego katalogu do dodawania osób; brak wyłącza ten podwidok.
  final ChatDirectoryRepository? directoryRepository;

  /// Port obecności; brak oznacza listę bez statusów.
  final ChatPresenceRepository? presenceRepository;

  @override
  State<_ChatMembersSheetBody> createState() => _ChatMembersSheetBodyState();
}

class _ChatMembersSheetBodyState extends State<_ChatMembersSheetBody> {
  bool _addingPeople = false;

  static const int _maxGroupMembers = 50;

  Future<void> _submitAdd(List<String> userIds) async {
    final cubit = context.read<ChatMembersCubit>();
    await cubit.addMembers(userIds);
    if (!mounted) return;
    final state = cubit.state;
    final failed = state is ChatMembersReady && state.failureCode != null;
    if (!failed) setState(() => _addingPeople = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<ChatMembersCubit>().state;
    final ready = state is ChatMembersReady ? state : null;
    final directoryRepository = widget.directoryRepository;
    final canAddPeople =
        ready != null &&
        ready.canManageMembers &&
        !widget.isDirect &&
        directoryRepository != null;
    final showAddView = _addingPeople && canAddPeople;
    return BlocListener<ChatMembersCubit, ChatMembersState>(
      listenWhen: (previous, current) => current is ChatMembersLeft,
      listener: (context, state) => Navigator.of(context).pop(true),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p12),
          child: showAddView
              ? ChatAddMembersView(
                  directoryRepository: directoryRepository,
                  existingUserIds: {
                    for (final member in ready.members) member.userId,
                  },
                  freeSlots: _maxGroupMembers - ready.members.length,
                  isMutating: ready.isMutating,
                  failureCode: ready.failureCode,
                  onCancel: () => setState(() => _addingPeople = false),
                  onSubmit: (userIds) => unawaited(_submitAdd(userIds)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Symbols.group, size: 20),
                        const SizedBox(width: Sizes.p8),
                        Expanded(
                          child: Text(
                            context.l10n.chatMembersTitle(
                              widget.conversationName,
                            ),
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          tooltip: context.l10n.frameworkClose,
                          onPressed: widget.onClose,
                          icon: const Icon(Symbols.close, size: 18),
                        ),
                      ],
                    ),
                    const Divider(height: Sizes.p16),
                    Expanded(
                      child: switch (state) {
                        ChatMembersLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        ChatMembersFailure(:final message) => _MembersMessage(
                          icon: Symbols.error_outline,
                          title: context.l10n.chatMembersLoadFailureTitle,
                          message: message,
                          onRetry: () => unawaited(
                            context.read<ChatMembersCubit>().load(),
                          ),
                        ),
                        ChatMembersLeft() => const SizedBox.shrink(),
                        ChatMembersReady() => _MembersList(
                          state: state,
                          presenceRepository: widget.presenceRepository,
                          onAddPeople: canAddPeople
                              ? () => setState(() => _addingPeople = true)
                              : null,
                        ),
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MembersList extends StatefulWidget {
  const _MembersList({
    required this.state,
    this.presenceRepository,
    this.onAddPeople,
  });

  final ChatMembersReady state;
  final ChatPresenceRepository? presenceRepository;

  /// Otwiera podwidok dodawania osób; `null` ukrywa akcję.
  final VoidCallback? onAddPeople;

  @override
  State<_MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<_MembersList> {
  final Map<String, ChatUserStatus?> _statuses = <String, ChatUserStatus?>{};

  @override
  void initState() {
    super.initState();
    unawaited(_loadStatuses());
  }

  /// Statusy są uzupełnieniem listy: brak portu albo błąd zostawia wiersz bez
  /// statusu, a lista członków pozostaje użyteczna.
  Future<void> _loadStatuses() async {
    final repository = widget.presenceRepository;
    if (repository == null) return;
    for (final member in widget.state.members) {
      final result = await repository.getUserStatus(member.userId);
      if (!mounted) return;
      result.fold(
        (_) {},
        (status) => setState(() => _statuses[member.userId] = status),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final theme = Theme.of(context);
    final cubit = context.read<ChatMembersCubit>();
    return Column(
      children: [
        if (state.failureCode != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Text(
              state.failureCode!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        if (widget.onAddPeople != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: state.isMutating ? null : widget.onAddPeople,
              icon: const Icon(Symbols.person_add, size: 18),
              label: Text(context.l10n.chatMembersAdd),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: state.members.length,
            itemBuilder: (context, index) {
              final member = state.members[index];
              final isCurrent = member.userId == state.currentUserId;
              return ListTile(
                dense: true,
                title: Text(
                  isCurrent
                      ? '${member.label} (${context.l10n.chatMembersYou})'
                      : member.label,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_roleLabel(context, member.role)),
                    if (_statuses[member.userId] != null)
                      ChatStatusLabel(
                        status: _statuses[member.userId],
                        style: theme.textTheme.labelSmall,
                      ),
                  ],
                ),
                trailing: state.canManageMembers && !isCurrent
                    ? PopupMenuButton<String>(
                        tooltip: context.l10n.chatMembersActions,
                        enabled: !state.isMutating,
                        onSelected: (value) => unawaited(
                          value == 'remove'
                              ? cubit.removeMember(member.userId)
                              : cubit.changeRole(
                                  targetUserId: member.userId,
                                  role: ChatMemberRole.fromWire(value),
                                ),
                        ),
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          for (final role in ChatMemberRole.values)
                            if (role != member.role)
                              PopupMenuItem<String>(
                                value: role.wireValue,
                                child: Text(_roleLabel(context, role)),
                              ),
                          PopupMenuItem<String>(
                            value: 'remove',
                            child: Row(
                              children: [
                                const Icon(Symbols.person_remove, size: 18),
                                const SizedBox(width: Sizes.p8),
                                Text(context.l10n.chatMembersRemove),
                              ],
                            ),
                          ),
                        ],
                      )
                    : null,
              );
            },
          ),
        ),
        const Divider(height: Sizes.p16),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: state.isMutating
                ? null
                : () => unawaited(context.read<ChatMembersCubit>().leave()),
            icon: const Icon(Symbols.logout, size: 18),
            label: Text(context.l10n.chatMembersLeave),
          ),
        ),
      ],
    );
  }

  static String _roleLabel(BuildContext context, ChatMemberRole role) =>
      switch (role) {
        ChatMemberRole.owner => context.l10n.chatMemberRoleOwner,
        ChatMemberRole.moderator => context.l10n.chatMemberRoleModerator,
        ChatMemberRole.member => context.l10n.chatMemberRoleMember,
        ChatMemberRole.observer => context.l10n.chatMemberRoleObserver,
      };
}

class _MembersMessage extends StatelessWidget {
  const _MembersMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: Sizes.p8),
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: Sizes.p4),
          Text(
            message,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: Sizes.p8),
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.chatInboxRetry),
            ),
          ],
        ],
      ),
    );
  }
}
