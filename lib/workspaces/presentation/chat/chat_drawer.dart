import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/search/components/chat_search_view.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_global_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_thread_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_compose_popover.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_list_pane.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_scaffold.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_theme_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wielokrotnego użycia zawartość globalnego panelu Chat.
///
/// Shell używa jej jako przypiętego pane. Nie zarządza stanem globalnego panelu.
class AppGlobalChatPanel extends StatelessWidget {
  const AppGlobalChatPanel({
    required this.repository,
    this.onClose,
    this.onConversationSelected,
    this.initialConversationId,
    this.inboxCubit,
    this.resourceConversationId,
    this.resourceContext,
    this.onResourceContextDismissed,
    this.fillAvailableWidth = false,
    this.pinned = false,
    this.canPin = true,
    this.onTogglePin,
    super.key,
  });

  final ChatRepository repository;
  final VoidCallback? onClose;
  final ValueChanged<String>? onConversationSelected;
  final String? initialConversationId;

  /// Host sesji może współdzielić inbox pomiędzy otwartym panelem i hubem.
  final ChatInboxCubit? inboxCubit;
  final String? resourceConversationId;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceContextDismissed;
  final bool fillAvailableWidth;

  /// Czy panel rezerwuje szerokość w layoucie.
  final bool pinned;

  /// Czy w oknie jest miejsce na przypięty panel obok treści aplikacji.
  final bool canPin;

  /// Przełącza przypięcie panelu.
  final VoidCallback? onTogglePin;

  @override
  Widget build(BuildContext context) {
    final realtimeFactory = context.read<WorkspaceChatRealtimeFactory?>();
    final inboxRepository = context.read<ChatInboxRepository?>();
    final searchRepository = context.read<ChatSearchRepository?>();
    final chatPanelTheme = context.chatTheme.applyControls(Theme.of(context));
    return Theme(
      data: chatPanelTheme,
      child: MultiBlocProvider(
        providers: [
          if (inboxCubit case final inboxCubit?)
            BlocProvider<ChatInboxCubit>.value(value: inboxCubit)
          else if (inboxRepository != null)
            BlocProvider(
              create: (context) {
                final cubit = ChatInboxCubit(repository: inboxRepository);
                unawaited(cubit.load());
                return cubit;
              },
            ),
          if (searchRepository != null)
            BlocProvider(
              create: (context) =>
                  ChatSearchCubit(repository: searchRepository),
            ),
          BlocProvider(
            create: (context) => ChatPanelSelectionCubit(
              initialConversationId: initialConversationId,
            ),
          ),
          // Sekcja panelu jest stanem prezentacji; filtr skrzynki ustawia
          // słuchacz w kolumnie listy, więc przełączenie zakładki nie kasuje
          // zaznaczonej rozmowy ani szkicu w composerze.
          BlocProvider(create: (context) => ChatPanelSectionCubit()),
        ],
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: fillAvailableWidth ? double.infinity : 384,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: context.workspaceGlassGradient,
                  border: context.workspaceGlassBorder,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  boxShadow: context.workspaceGlassShadow,
                ),
                clipBehavior: Clip.antiAlias,
                child: _ChatDrawerContent(
                  repository: repository,
                  onClose: onClose,
                  onConversationSelected: onConversationSelected,
                  resourceConversationId: resourceConversationId,
                  resourceContext: resourceContext,
                  onResourceContextDismissed: onResourceContextDismissed,
                  createRealtime: realtimeFactory?.open,
                  pinned: pinned,
                  canPin: canPin,
                  onTogglePin: onTogglePin,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatDrawerContent extends StatelessWidget {
  const _ChatDrawerContent({
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

  static Set<String> _existingDirectConversationIds(BuildContext context) {
    final state = context.read<ChatInboxCubit?>()?.state;
    if (state is! ChatInboxReady) return const <String>{};
    return <String>{
      for (final item in state.items)
        if (item.conversation.type == 'direct')
          ...item.otherParticipants.map((participant) => participant.userId),
    };
  }

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
      profileAction: _profileAction(context),
      onOpenSettings: _settingsAction(context),
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
    return _ChatSectionFilterSync(
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
        onSearchMessages: () => context.read<ChatSearchCubit?>()?.open(),
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
      existingDirectConversationIds: _existingDirectConversationIds(context),
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
      onOpenThread: (message) => unawaited(
        ChatThreadSheet.showThread(
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
          messageActionsRepository: context
              .read<ChatMessageActionsRepository?>(),
          forwardTargets: forwardTargets,
          canModerate: selection.canModerate,
        ),
      ),
    );
  }

  /// Powierzchnia własnego profilu i statusu; brak portu albo sesji oznacza brak akcji.
  Widget? _profileAction(BuildContext context) {
    final presence = context.read<ChatPresenceRepository?>();
    final user = context.read<AuthSessionPort?>()?.snapshot.user;
    final userId = user?.userId.trim() ?? '';
    if (presence == null || userId.isEmpty) return null;
    return ChatStatusMenuButton(
      repository: presence,
      currentUserId: userId,
      displayName: user?.displayName,
      login: user?.login,
    );
  }

  /// Otwiera ustawienia komunikatora; brak portu oznacza brak akcji.
  VoidCallback? _settingsAction(BuildContext context) {
    final repository = context.read<ChatNotificationSettingsRepository?>();
    if (repository == null) return null;
    return () => unawaited(
      ChatGlobalSettingsModal.show(context, repository: repository),
    );
  }
}

/// Synchronizuje wybraną sekcję panelu z filtrem serwerowej skrzynki.
///
/// Widget pamięta filtr wybrany w każdej sekcji, więc powrót na Czaty wraca do
/// „Nieprzeczytane”, jeśli użytkownik tak je zostawił, a przejście na Pliki czy
/// Zapisane nie zmienia skrzynki w tle.
class _ChatSectionFilterSync extends StatefulWidget {
  const _ChatSectionFilterSync({required this.child});

  final Widget child;

  @override
  State<_ChatSectionFilterSync> createState() => _ChatSectionFilterSyncState();
}

class _ChatSectionFilterSyncState extends State<_ChatSectionFilterSync> {
  final Map<ChatPanelSection, ChatInboxFilter> _lastFilter =
      <ChatPanelSection, ChatInboxFilter>{};
  ChatPanelSection? _current;

  @override
  void initState() {
    super.initState();
    // Section changes can happen after restoring an initial/deep-linked chat;
    // seed the previous section before the first listener event arrives.
    _current = context.read<ChatPanelSectionCubit>().state.section;
  }

  void _apply(BuildContext context, ChatPanelSection section) {
    final cubit = context.read<ChatInboxCubit?>();
    if (cubit == null) return;
    final previous = _current;
    if (previous != null && previous.inboxFilter != null) {
      _lastFilter[previous] = cubit.filter;
    }
    // A conversation selected in Chats/Groups must not remain rendered while
    // another rail section is active (especially an empty Channels list).
    // Selection is panel-local, so leaving the section returns to its list
    // instead of presenting a stale conversation under a different heading.
    if (previous != null && previous != section) {
      context.read<ChatPanelSelectionCubit>().clear();
    }
    _current = section;
    final next = _lastFilter[section] ?? section.inboxFilter;
    if (next != null && next != cubit.filter) {
      unawaited(cubit.setFilter(next));
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<ChatPanelSectionCubit, ChatPanelSectionState>(
        listenWhen: (previous, current) => previous.section != current.section,
        listener: (context, state) => _apply(context, state.section),
        child: widget.child,
      );
}
