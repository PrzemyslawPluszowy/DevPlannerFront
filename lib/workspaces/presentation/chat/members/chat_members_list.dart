import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_member_display_label.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_person_card.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_label.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_inbox_presence_label.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChatMembersList extends StatefulWidget {
  const ChatMembersList({
    required this.state,
    this.presenceRepository,
    this.membersPresenceRepository,
    this.conversationManagement,
    this.onOpenConversation,
    this.onAddPeople,
    super.key,
  });

  final ChatMembersReady state;
  final ChatPresenceRepository? presenceRepository;
  final ChatMembersPresenceRepository? membersPresenceRepository;

  /// Port zarządzania rozmową dla akcji „Napisz” w karcie osoby.
  final ChatConversationManagementRepository? conversationManagement;

  /// Jawny callback przechwycony przez host przed otwarciem rootowego sheeta.
  final ValueChanged<String>? onOpenConversation;

  /// Otwiera podwidok dodawania osób; `null` ukrywa akcję.
  final VoidCallback? onAddPeople;

  @override
  State<ChatMembersList> createState() => _ChatMembersListState();
}

class _ChatMembersListState extends State<ChatMembersList> {
  ChatMembersPresenceCubit? _presence;
  AppLifecycleListener? _lifecycle;
  StreamSubscription<ChatMembersPresenceState>? _presenceSubscription;
  final Map<String, ChatUserStatus?> _statuses = <String, ChatUserStatus?>{};
  int _statusRequestGeneration = 0;

  Future<bool> _confirmRemoval(ChatMember member) async {
    final result = await DevPlannerModalHost.showDialog<bool>(
      context,
      builder: (dialogContext) => ChatSurfaceDialog(
        title: dialogContext.l10n.chatMembersRemoveConfirmationTitle,
        maxWidth: 420,
        content: Text(
          dialogContext.l10n.chatMembersRemoveConfirmationBody(
            member.displayLabel(dialogContext),
          ),
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
    _createPresence();
    unawaited(_loadStatuses());
  }

  void _createPresence() {
    final repository = widget.membersPresenceRepository;
    if (repository == null) return;
    final cubit = ChatMembersPresenceCubit(
      repository: repository,
      conversationId: context.read<ChatMembersCubit>().conversationId,
    );
    _presence = cubit;
    final members = context.read<ChatMembersCubit>();
    _presenceSubscription = cubit.stream.listen((snapshot) {
      final error = snapshot.failure;
      if (error != null &&
          (error.statusCode == 401 ||
              error.statusCode == 403 ||
              error.statusCode == 404)) {
        members.invalidateAccess(error);
      }
    });
    _lifecycle = AppLifecycleListener(
      onHide: () => cubit.setActive(false),
      onPause: () => cubit.setActive(false),
      onResume: () => cubit.setActive(true),
    );
    unawaited(cubit.refresh());
  }

  @override
  void dispose() {
    _lifecycle?.dispose();
    unawaited(_presenceSubscription?.cancel());
    final presence = _presence;
    if (presence != null) unawaited(presence.close());
    _statusRequestGeneration++;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatMembersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membersPresenceRepository !=
        widget.membersPresenceRepository) {
      _lifecycle?.dispose();
      unawaited(_presenceSubscription?.cancel());
      final oldPresence = _presence;
      if (oldPresence != null) unawaited(oldPresence.close());
      _presence = null;
      _createPresence();
    }
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
    if (membersChanged) unawaited(_presence?.refresh());
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
        if (_presence case final presence?)
          BlocBuilder<ChatMembersPresenceCubit, ChatMembersPresenceState>(
            bloc: presence,
            builder: (context, presenceState) => presenceState.failure == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          presenceState.failure?.retryAfterUtc == null
                              ? context.l10n.projectPeoplePresenceUnknown
                              : context.l10n.tasksViewErrorRetryAfter(
                                  MaterialLocalizations.of(context)
                                      .formatTimeOfDay(
                                        TimeOfDay.fromDateTime(
                                          presenceState.failure!.retryAfterUtc!
                                              .toLocal(),
                                        ),
                                      ),
                                ),
                          style: chat.metadataStyle.copyWith(color: chat.error),
                        ),
                      ),
                      TextButton(
                        onPressed:
                            presenceState.isLoading ||
                                (presenceState.failure?.retryAfterUtc?.isAfter(
                                      DateTime.now().toUtc(),
                                    ) ??
                                    false)
                            ? null
                            : () => unawaited(presence.refresh()),
                        child: Text(context.l10n.frameworkRetry),
                      ),
                    ],
                  ),
          ),
        if (state.failureCode != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Row(
              children: [
                Icon(Symbols.error_outline, size: 16, color: chat.error),
                const SizedBox(width: Sizes.p6),
                Expanded(
                  child: Text(
                    _failureMessage(context, state),
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
                        onOpenConversation: widget.onOpenConversation,
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
                            displayName: member.displayLabel(context),
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
                                      ? '${member.displayLabel(context)} (${context.l10n.chatMembersYou})'
                                      : member.displayLabel(context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: chat.contentStyle.copyWith(
                                    color: chat.incomingText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: Sizes.p2),
                                if (_presence case final presence?)
                                  BlocSelector<
                                    ChatMembersPresenceCubit,
                                    ChatMembersPresenceState,
                                    bool?
                                  >(
                                    bloc: presence,
                                    selector: (snapshot) =>
                                        snapshot.users[member.userId],
                                    builder: (context, online) =>
                                        ChatInboxPresenceLabel(
                                          isOnline: online,
                                        ),
                                  ),
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

  String _failureMessage(BuildContext context, ChatMembersReady state) {
    if (state.failureCode == 'chat.conversations.manage_failed' &&
        state.isSoleOwner) {
      return context.l10n.chatMembersLastOwnerCannotLeave;
    }
    return switch (state.failureType) {
      ApiErrorType.forbidden => context.l10n.chatMembersMutationForbidden,
      ApiErrorType.conflict => context.l10n.chatMembersMutationConflict,
      ApiErrorType.validation || ApiErrorType.badResponse
          when state.failureStatusCode == null ||
              state.failureStatusCode == 400 ||
              state.failureStatusCode == 422 =>
        context.l10n.chatMembersMutationValidation,
      ApiErrorType.connection ||
      ApiErrorType.connectionTimeout ||
      ApiErrorType.sendTimeout ||
      ApiErrorType.receiveTimeout => context.l10n.chatMembersMutationConnection,
      _ => context.l10n.chatMembersMutationFailureMessage,
    };
  }

  static String _roleLabel(BuildContext context, ChatMemberRole role) =>
      switch (role) {
        ChatMemberRole.owner => context.l10n.chatMemberRoleOwner,
        ChatMemberRole.moderator => context.l10n.chatMemberRoleModerator,
        ChatMemberRole.member => context.l10n.chatMemberRoleMember,
        ChatMemberRole.observer => context.l10n.chatMemberRoleObserver,
      };
}
