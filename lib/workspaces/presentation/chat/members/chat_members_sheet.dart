import 'dart:async';
import 'dart:math' as math;

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_add_members_view.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_person_card.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_label.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
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
      builder: (sheetContext) {
        final media = MediaQuery.sizeOf(sheetContext);
        final chat = sheetContext.chatTheme;
        final width = math.min(
          440.0,
          math.max(0.0, media.width - Sizes.p24),
        );
        final height = math.min(
          760.0,
          math.max(0.0, media.height - Sizes.p24),
        );
        return Theme(
          data: chat.applyControls(Theme.of(sheetContext)),
          child: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.p12,
              right: Sizes.p12,
              bottom: Sizes.p12,
            ),
            child: SizedBox(
              width: width,
              height: height,
              child: Material(
                color: chat.panelSurface,
                elevation: 18,
                shadowColor: Colors.black.withValues(alpha: .28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: chat.separator),
                ),
                clipBehavior: Clip.antiAlias,
                child: RepositoryProvider<ChatMembersRepository>.value(
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
                      conversationType: conversation.type,
                      isDirect: conversation.type == 'direct',
                      directoryRepository: directoryRepository,
                      presenceRepository: presenceRepository,
                      conversationManagement: conversationManagement,
                      onClose: () => Navigator.of(sheetContext).pop(false),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChatMembersSheetBody extends StatefulWidget {
  const _ChatMembersSheetBody({
    required this.conversationName,
    required this.conversationType,
    required this.isDirect,
    required this.onClose,
    this.directoryRepository,
    this.presenceRepository,
    this.conversationManagement,
  });

  final String conversationName;
  final String conversationType;

  /// Rozmowa 1:1 nie pozwala dopisywać osób; opcją jest nowa grupa.
  final bool isDirect;

  final VoidCallback onClose;

  /// Port lokalnego katalogu do dodawania osób; brak wyłącza ten podwidok.
  final ChatDirectoryRepository? directoryRepository;

  /// Port obecności; brak oznacza listę bez statusów.
  final ChatPresenceRepository? presenceRepository;

  /// Port zarządzania rozmową; brak wyłącza akcję „Napisz” z karty osoby.
  final ChatConversationManagementRepository? conversationManagement;

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
    final chat = context.chatTheme;
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
                  freeSlots: widget.conversationType == 'group'
                      ? (_maxGroupMembers - ready.members.length).clamp(
                          0,
                          _maxGroupMembers,
                        )
                      : null,
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
                        Icon(Symbols.group, size: 20, color: chat.linkText),
                        const SizedBox(width: Sizes.p8),
                        Expanded(
                          child: Text(
                            context.l10n.chatMembersTitle(
                              widget.conversationName,
                            ),
                            style: chat.contentStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: chat.incomingText,
                            ),
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
                    Divider(height: Sizes.p16, color: chat.separator),
                    Expanded(
                      child: switch (state) {
                        ChatMembersLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        ChatMembersFailure() => _MembersMessage(
                          icon: Symbols.error_outline,
                          title: context.l10n.chatMembersLoadFailureTitle,
                          message: context.l10n.chatMembersLoadFailureMessage,
                          onRetry: () => unawaited(
                            context.read<ChatMembersCubit>().load(),
                          ),
                        ),
                        ChatMembersLeft() => const SizedBox.shrink(),
                        ChatMembersReady() => _MembersList(
                          state: state,
                          presenceRepository: widget.presenceRepository,
                          conversationManagement: widget.conversationManagement,
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
    this.conversationManagement,
    this.onAddPeople,
  });

  final ChatMembersReady state;
  final ChatPresenceRepository? presenceRepository;

  /// Port zarządzania rozmową dla akcji „Napisz” w karcie osoby.
  final ChatConversationManagementRepository? conversationManagement;

  /// Otwiera podwidok dodawania osób; `null` ukrywa akcję.
  final VoidCallback? onAddPeople;

  @override
  State<_MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<_MembersList> {
  final Map<String, ChatUserStatus?> _statuses = <String, ChatUserStatus?>{};
  int _statusRequestGeneration = 0;

  Future<bool> _confirmRemoval(ChatMember member) async {
    final result = await DevPlannerModalHost.showDialog<bool>(
      context,
      builder: (dialogContext) => ChatSurfaceDialog(
        title: dialogContext.l10n.chatMembersRemoveConfirmationTitle,
        maxWidth: 420,
        content: Text(
          dialogContext.l10n.chatMembersRemoveConfirmationBody(member.label),
          style: dialogContext.chatTheme.contentStyle.copyWith(
            color: dialogContext.chatTheme.incomingText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.chatMembersAddCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.chatMembersRemove),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadStatuses());
  }

  @override
  void didUpdateWidget(covariant _MembersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldUserIds = oldWidget.state.members
        .map((member) => member.userId)
        .toSet();
    final userIds = widget.state.members.map((member) => member.userId).toSet();
    final membersChanged =
        oldUserIds.length != userIds.length || !oldUserIds.containsAll(userIds);
    if (!membersChanged &&
        oldWidget.presenceRepository == widget.presenceRepository) {
      return;
    }
    _statusRequestGeneration++;
    _statuses.removeWhere((userId, _) => !userIds.contains(userId));
    if (oldWidget.presenceRepository != widget.presenceRepository) {
      _statuses.clear();
    }
    unawaited(_loadStatuses());
  }

  /// Statusy są uzupełnieniem listy: brak portu albo błąd zostawia wiersz bez
  /// statusu, a lista członków pozostaje użyteczna. Małe partie równoległych
  /// żądań zapobiegają sekwencyjnemu czekaniu na każdego członka oraz nagłemu
  /// wysłaniu dużej liczby requestów naraz.
  Future<void> _loadStatuses() async {
    final repository = widget.presenceRepository;
    if (repository == null) return;
    final generation = ++_statusRequestGeneration;
    final userIds = widget.state.members
        .map((member) => member.userId)
        .where((userId) => !_statuses.containsKey(userId))
        .toList(growable: false);
    for (var start = 0; start < userIds.length; start += 8) {
      final batch = userIds.skip(start).take(8);
      final updates = <String, ChatUserStatus?>{};
      await Future.wait(
        batch.map((userId) async {
          final result = await repository.getUserStatus(userId);
          result.fold<void>((_) {}, (status) => updates[userId] = status);
        }),
      );
      if (!mounted || generation != _statusRequestGeneration) return;
      if (updates.isNotEmpty) setState(() => _statuses.addAll(updates));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final chat = context.chatTheme;
    final cubit = context.read<ChatMembersCubit>();
    return Column(
      children: [
        if (state.failureCode != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Row(
              children: [
                Icon(Symbols.error_outline, size: 16, color: chat.error),
                const SizedBox(width: Sizes.p6),
                Expanded(
                  child: Text(
                    state.failureCode == 'chat.conversations.manage_failed' &&
                            state.isSoleOwner
                        ? context.l10n.chatMembersLastOwnerCannotLeave
                        : context.l10n.chatMembersMutationFailureMessage,
                    style: chat.metadataStyle.copyWith(color: chat.error),
                  ),
                ),
              ],
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
              return Padding(
                padding: const EdgeInsets.only(bottom: Sizes.p4),
                child: Material(
                  color: chat.listSurface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => unawaited(
                      ChatPersonCard.show(
                        context,
                        member: member,
                        isCurrentUser: isCurrent,
                        presenceRepository: widget.presenceRepository,
                        conversationManagement: widget.conversationManagement,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.p12,
                        vertical: Sizes.p10,
                      ),
                      child: Row(
                        children: [
                          AppUserAvatar(
                            userId: member.userId,
                            displayName: member.label,
                            avatarUrl: member.avatarUrl,
                            hasCustomAvatar:
                                member.avatarUrl?.trim().isNotEmpty == true,
                            radius: 20,
                            singleInitial: true,
                          ),
                          const SizedBox(width: Sizes.p12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCurrent
                                      ? '${member.label} (${context.l10n.chatMembersYou})'
                                      : member.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: chat.contentStyle.copyWith(
                                    color: chat.incomingText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: Sizes.p2),
                                Text(
                                  _roleLabel(context, member.role),
                                  style: chat.metadataStyle.copyWith(
                                    color: chat.metadataText,
                                  ),
                                ),
                                if (_statuses[member.userId] != null)
                                  ChatStatusLabel(
                                    status: _statuses[member.userId],
                                    style: chat.metadataStyle,
                                  ),
                              ],
                            ),
                          ),
                          if (state.canManageMembers &&
                              !isCurrent &&
                              member.role != ChatMemberRole.owner)
                            Builder(
                              builder: (anchorContext) => IconButton(
                                tooltip: context.l10n.chatMembersActions,
                                onPressed: state.isMutating
                                    ? null
                                    : () => unawaited(() async {
                                        final selected =
                                            await AppContextMenu.select<String>(
                                              anchorContext,
                                              globalPosition:
                                                  AppContextMenu.positionFor(
                                                    anchorContext,
                                                  ),
                                              options: [
                                                for (final role
                                                    in ChatMemberRole.values)
                                                  if (role != member.role &&
                                                      (role !=
                                                              ChatMemberRole
                                                                  .owner ||
                                                          state.currentRole ==
                                                              ChatMemberRole
                                                                  .owner))
                                                    AppContextMenuOption<
                                                      String
                                                    >(
                                                      value: role.wireValue,
                                                      label:
                                                          role ==
                                                              ChatMemberRole
                                                                  .owner
                                                          ? context
                                                                .l10n
                                                                .chatMembersTransferOwnership
                                                          : _roleLabel(
                                                              context,
                                                              role,
                                                            ),
                                                      selected:
                                                          role == member.role,
                                                    ),
                                                AppContextMenuOption<String>(
                                                  value: 'remove',
                                                  label: context
                                                      .l10n
                                                      .chatMembersRemove,
                                                  icon: Symbols.person_remove,
                                                  isDestructive: true,
                                                  separatorBefore: true,
                                                ),
                                              ],
                                            );
                                        if (selected == null ||
                                            !context.mounted) {
                                          return;
                                        }
                                        if (selected == 'remove') {
                                          final confirmed =
                                              await _confirmRemoval(member);
                                          if (!confirmed || !context.mounted) {
                                            return;
                                          }
                                          await cubit.removeMember(
                                            member.userId,
                                          );
                                        } else {
                                          await cubit.changeRole(
                                            targetUserId: member.userId,
                                            role: ChatMemberRole.fromWire(
                                              selected,
                                            ),
                                          );
                                        }
                                      }()),
                                icon: const Icon(Symbols.more_vert_rounded),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Divider(height: Sizes.p16, color: chat.separator),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.isSoleOwner)
                Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.p4),
                  child: Text(
                    context.l10n.chatMembersLastOwnerCannotLeave,
                    style: chat.metadataStyle.copyWith(
                      color: chat.metadataText,
                    ),
                  ),
                ),
              TextButton.icon(
                onPressed: state.isMutating || state.isSoleOwner
                    ? null
                    : () => unawaited(context.read<ChatMembersCubit>().leave()),
                icon: const Icon(Symbols.logout, size: 18),
                label: Text(context.l10n.chatMembersLeave),
              ),
            ],
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
    final chat = context.chatTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: chat.metadataText),
          const SizedBox(height: Sizes.p8),
          Text(
            title,
            style: chat.contentStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: chat.incomingText,
            ),
          ),
          const SizedBox(height: Sizes.p4),
          Text(
            message,
            style: chat.metadataStyle.copyWith(color: chat.metadataText),
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
