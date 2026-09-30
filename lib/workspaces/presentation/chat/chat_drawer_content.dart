import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_drawer_host_actions.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_section_filter_sync.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/search/components/chat_search_view.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_thread_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_compose_popover.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_list_pane.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_scaffold.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDrawerContent extends StatelessWidget {
  const ChatDrawerContent({
    required this.repository,
    this.onClose,
    this.onConversationSelected,
    this.resourceConversationId,
    this.resourceContext,
    this.onResourceContextDismissed,
    this.createRealtime,
    this.pinned = false,
    this.canPin = true,
    this.onTogglePin,
    super.key,
  });

  final ChatRepository repository;
  final VoidCallback? onClose;
  final ValueChanged<String>? onConversationSelected;
  final String? resourceConversationId;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceContextDismissed;
  final WorkspaceChatRealtimeLease Function(String conversationId)?
  createRealtime;
  final bool pinned;
  final bool canPin;
  final VoidCallback? onTogglePin;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatPanelSelectionCubit, ChatPanelSelection?>(
        builder: _buildSelection,
      );

  Widget _buildSelection(BuildContext context, ChatPanelSelection? selection) {
    final conversation = selection?.conversation;
    final conversationPane = conversation == null
        ? null
        : _buildConversationPane(context, selection!, conversation);
    return ChatPanelScaffold(
      listPane: _buildListPane(context, selection),
      conversationPane: conversationPane,
      pinned: pinned,
      canPin: canPin,
      profileAction: ChatDrawerHostActions.profile(context),
      onOpenSettings: ChatDrawerHostActions.settings(context),
      onTogglePin: onTogglePin,
    );
  }

  /// Kolumna listy: wyszukiwanie wiadomości albo lista sekcji.
  Widget _buildListPane(BuildContext context, ChatPanelSelection? selection) {
    final searchCubit = context.read<ChatSearchCubit?>();
    final inboxCubit = context.read<ChatInboxCubit?>();
    final items = switch (inboxCubit?.state) {
      ChatInboxReady(:final items) => items,
      _ => const <ChatInboxItem>[],
    };
    if (searchCubit != null) {
      final searchPane = BlocBuilder<ChatSearchCubit, ChatSearchState>(
        bloc: searchCubit,
        builder: (context, searchState) => searchState.isOpen
            ? ChatSearchView(
                conversations: items,
                onResultSelected: (hit) => _openSearchResult(
                  context,
                  hit,
                  searchCubit: searchCubit,
                  inboxItems: items,
                ),
              )
            : const SizedBox.shrink(),
      );
      return BlocBuilder<ChatSearchCubit, ChatSearchState>(
        bloc: searchCubit,
        builder: (context, searchState) =>
            searchState.isOpen ? searchPane : _inboxPane(context, selection),
      );
    }
    return _inboxPane(context, selection);
  }

  Widget _inboxPane(BuildContext context, ChatPanelSelection? selection) {
    final searchCubit = context.read<ChatSearchCubit?>();
    return ChatSectionFilterSync(
      child: ChatPanelListPane(
        selectedConversationId: selection?.conversation.id,
        onConversationSelected: (item) => _selectConversation(
          context,
          item.conversation,
          role: item.role,
        ),
        onConversationOpened: (item) =>
            context.read<ChatInboxCubit>().refreshUnreadTotal(),
        onCompose: (globalPosition) =>
            unawaited(_openCompose(context, globalPosition)),
        // Pole inboxa używa serwerowego query (nazwy rozmów i aktywnych
        // uczestników); wyszukiwanie treści wiadomości ma osobny widok i Cubit.
        onSearchMessages: searchCubit?.open,
        onOpenSavedMessage: (conversationId, messageId) =>
            unawaited(_openSavedMessage(context, conversationId, messageId)),
        onClose: onClose,
      ),
    );
  }

  /// Zaznacza rozmowę w panelu i pokazuje ją także w trybie compact.
  ///
  /// Każda droga wyboru (lista, wyszukiwanie, popover, zakładka) przechodzi
  /// przez to miejsce, żeby stan nawigacji panelu nie rozjechał się z widokiem.
  void _selectConversation(
    BuildContext context,
    ChatConversation conversation, {
    String? targetMessageId,
    String? role,
  }) {
    context.read<ChatPanelSectionCubit>().showConversation();
    context.read<ChatPanelSelectionCubit>().select(
      conversation,
      targetMessageId: targetMessageId,
      role: role,
    );
    onConversationSelected?.call(conversation.id);
  }

  /// Otwiera wynik wyszukiwania niezależnie od bieżącego filtra/strony inboxa.
  ///
  /// Jeśli wynik nie ma pozycji w skrzynce, szczegóły rozmowy pobieramy przez
  /// GET po ID — endpoint ponownie egzekwuje członkostwo i ACL. Nigdy nie
  /// konstruujemy rozmowy z danych samego wyniku wyszukiwania.
  Future<void> _openSearchResult(
    BuildContext context,
    ChatSearchHit hit, {
    required ChatSearchCubit searchCubit,
    required List<ChatInboxItem> inboxItems,
  }) async {
    final cached = inboxItems
        .where((item) => item.conversation.id == hit.conversationId)
        .firstOrNull;
    if (cached != null) {
      _selectConversation(
        context,
        cached.conversation,
        targetMessageId: hit.messageId,
        role: cached.role,
      );
      searchCubit.closeView();
      return;
    }

    if (repository is! ChatConversationRepository) {
      _showSearchConversationUnavailable(context);
      return;
    }
    final result = await (repository as ChatConversationRepository)
        .getConversation(
          hit.conversationId,
        );
    if (!context.mounted) return;
    var accessRevoked = false;
    final conversation = result.fold<ChatConversation?>(
      (error) {
        accessRevoked = switch (error.type) {
          ApiErrorType.unauthorized ||
          ApiErrorType.forbidden ||
          ApiErrorType.notFound => true,
          _ => false,
        };
        return null;
      },
      (value) => value,
    );
    if (conversation == null) {
      // Nie zostawiamy nieaktualnych fragmentów wiadomości po revoke/usunięciu.
      if (accessRevoked) searchCubit.clear();
      _showSearchConversationUnavailable(context);
      return;
    }

    String? role;
    final userId =
        context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '';
    final membersRepository = context.read<ChatMembersRepository?>();
    if (conversation.type != 'direct' &&
        userId.isNotEmpty &&
        membersRepository != null) {
      final membersResult = await membersRepository.listMembers(
        conversation.id,
      );
      if (!context.mounted) return;
      final ownMembership = membersResult.fold<ChatMember?>(
        (_) => null,
        (members) {
          for (final member in members) {
            if (member.userId == userId) {
              return member;
            }
          }
          return null;
        },
      );
      role = ownMembership?.role.wireValue;
    }
    _selectConversation(
      context,
      conversation,
      targetMessageId: hit.messageId,
      role: role,
    );
    searchCubit.closeView();
  }

  void _showSearchConversationUnavailable(BuildContext context) {
    AppToast.show(
      context,
      message: context.l10n.chatSearchConversationUnavailable,
      tone: AppToastTone.error,
    );
  }

  /// Otwiera zakotwiczony popover „Nowy czat” i wybiera utworzoną rozmowę.
  Future<void> _openCompose(
    BuildContext context,
    Offset globalPosition,
  ) async {
    final management = context.read<ChatConversationManagementRepository?>();
    final directory = context.read<ChatDirectoryRepository?>();
    if (management == null || directory == null) return;
    final inboxCubit = context.read<ChatInboxCubit?>();
    final recent = switch (inboxCubit?.state) {
      ChatInboxReady(:final items) => items,
      _ => const <ChatInboxItem>[],
    };
    final created = await ChatComposePopover.show(
      context,
      globalPosition: globalPosition,
      repository: management,
      directoryRepository: directory,
      recent: recent,
      existingDirectConversationIds:
          ChatDrawerHostActions.existingDirectConversationIds(context),
    );
    if (created == null || !context.mounted) return;
    // Backend zwraca istniejącą rozmowę pary, więc panel otwiera to, co wróciło,
    // i odświeża skrzynkę zamiast dopisywać pozycję lokalnie.
    _selectConversation(context, created);
    await context.read<ChatInboxCubit?>()?.refresh();
  }

  /// Otwiera rozmowę zapisanej wiadomości, żeby panel doszedł do jej pozycji.
  Future<void> _openSavedMessage(
    BuildContext context,
    String conversationId,
    String messageId,
  ) async {
    final current = context.read<ChatPanelSelectionCubit>().state;
    if (current?.conversation.id == conversationId) {
      _selectConversation(
        context,
        current!.conversation,
        targetMessageId: messageId,
      );
      return;
    }
    final conversation = await _resolveConversation(context, conversationId);
    if (!context.mounted) return;
    if (conversation == null) {
      AppToast.show(
        context,
        message: context.l10n.globalChatLoadFailureTitle,
        tone: AppToastTone.error,
      );
      return;
    }
    _selectConversation(context, conversation, targetMessageId: messageId);
  }

  /// Rozwiązuje rozmowę po ID przez endpoint szczegółów chroniony ACL.
  ///
  /// Zakładka może wskazywać dowolnie starą rozmowę. Nie skanujemy stron inboxa
  /// ani nie ograniczamy działania do arbitralnej liczby stron; backend
  /// ponownie sprawdza członkostwo i dostęp do zasobu.
  Future<ChatConversation?> _resolveConversation(
    BuildContext context,
    String conversationId,
  ) async {
    final repository = this.repository;
    if (repository is! ChatConversationRepository) return null;
    final result = await (repository as ChatConversationRepository)
        .getConversation(conversationId);
    if (!context.mounted) return null;
    return result.fold<ChatConversation?>(
      (_) => null,
      (conversation) => conversation,
    );
  }

  /// Buduje kolumnę rozmowy dla wybranej pozycji panelu.
  Widget _buildConversationPane(
    BuildContext context,
    ChatPanelSelection selection,
    ChatConversation conversation,
  ) {
    final inboxState = context.read<ChatInboxCubit?>()?.state;
    final forwardTargets = inboxState is ChatInboxReady
        ? inboxState.items
        : const <ChatInboxItem>[];
    return ChatPanelConversation(
      // Klucz tożsamości: bez niego Flutter zachowuje providery i Cubit
      // poprzedniej rozmowy, a nagłówek pokazuje już inną.
      key: ChatPanelConversation.keyFor(conversation.id),
      conversationRepository: repository is ChatConversationRepository
          ? repository as ChatConversationRepository
          : null,
      conversation: conversation,
      resourceContext: conversation.id == resourceConversationId
          ? resourceContext
          : null,
      onBack: () {
        onResourceContextDismissed?.call();
        context.read<ChatPanelSelectionCubit>().clear();
      },
      onResourceAccessRevoked: onResourceContextDismissed,
      createRealtime: createRealtime,
      messageActions: context.read<ChatMessageActionsRepository?>(),
      notificationSettings: context.read<ChatNotificationSettingsRepository?>(),
      targetMessageId: selection.targetMessageId,
      canModerateMessages: selection.canModerate,
      onOpenThread: (message) => unawaited(() async {
        final lease = createRealtime?.call(conversation.id);
        try {
          await ChatThreadSheet.showThread(
            context,
            repository: context.read<ChatThreadRepository?>(),
            deliveryRepository:
                context.read<ChatConversationRepository?>() ??
                (repository is ChatConversationRepository
                    ? repository as ChatConversationRepository
                    : null),
            draftRepository: context.read<ChatDraftRepository?>(),
            conversationId: conversation.id,
            rootMessage: message,
            conversationEvents: lease?.conversationEvents,
            messageActionsRepository: context
                .read<ChatMessageActionsRepository?>(),
            forwardTargets: forwardTargets,
            canModerate: selection.canModerate,
          );
        } finally {
          await lease?.dispose();
        }
      }()),
    );
  }
}
