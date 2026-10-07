import 'dart:async';
import 'dart:math' as math;

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_add_members_view.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_list.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_cubit.dart';
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
    final onOpenConversation = DevPlannerPanelsScope.openConversationOf(
      context,
    );
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
                      onOpenConversation: onOpenConversation,
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
    this.onOpenConversation,
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

  /// Callback przechwycony przed otwarciem rootowego sheeta; jego kontekst nie
  /// dziedziczy `DevPlannerPanelsScope` z treści aplikacji.
  final ValueChanged<String>? onOpenConversation;

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
                          message: state.accessRevoked
                              ? context
                                    .l10n
                                    .chatConversationAccessRevokedMessage
                              : context.l10n.chatMembersLoadFailureMessage,
                          onRetry: state.accessRevoked
                              ? null
                              : () => unawaited(
                                  context.read<ChatMembersCubit>().load(),
                                ),
                        ),
                        ChatMembersLeft() => const SizedBox.shrink(),
                        ChatMembersReady() => ChatMembersList(
                          state: state,
                          membersPresenceRepository:
                              context.read<ChatMembersRepository>()
                                  is ChatMembersPresenceRepository
                              ? context.read<ChatMembersRepository>()
                                    as ChatMembersPresenceRepository
                              : null,
                          presenceRepository: widget.presenceRepository,
                          conversationManagement: widget.conversationManagement,
                          onOpenConversation: widget.onOpenConversation,
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
