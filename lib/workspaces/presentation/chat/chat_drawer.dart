import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_conversation_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_drawer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_drawer_state.dart';
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
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_theme_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wejście do istniejącego drawera Chat przez wspólny host modalny.
///
/// Nie rozwija funkcji Chat; zachowuje aktualny panel do czasu etapu 4.
abstract final class AppGlobalChatDrawer {
  /// Otwiera panel bez opuszczania bieżącego kontekstu aplikacji.
  static Future<void> show(
    BuildContext context, {
    required ChatRepository repository,
    ValueChanged<String>? onConversationSelected,
    String? initialConversationId,
    String? resourceConversationId,
    ResourceChatFileContext? resourceContext,
    VoidCallback? onResourceContextDismissed,
  }) async {
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (context) => Align(
        alignment: Alignment.centerRight,
        child: AppGlobalChatPanel(
          repository: repository,
          onConversationSelected: onConversationSelected,
          initialConversationId: initialConversationId,
          resourceConversationId: resourceConversationId,
          resourceContext: resourceContext,
          onResourceContextDismissed: onResourceContextDismissed,
        ),
      ),
    );
  }
}

/// Wielokrotnego użycia zawartość globalnego panelu Chat.
///
/// Shell używa jej jako przypiętego pane, a istniejący drawer jako modalnego
/// side sheeta. Nie zarządza stanem globalnego panelu.
class AppGlobalChatPanel extends StatelessWidget {
  const AppGlobalChatPanel({
    required this.repository,
    this.onClose,
    this.onConversationSelected,
    this.onOpenFullView,
    this.initialConversationId,
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
  final ValueChanged<String>? onOpenFullView;
  final String? initialConversationId;
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = ChatDrawerCubit(repository);
            unawaited(cubit.load());
            return cubit;
          },
        ),
        if (inboxRepository != null)
          BlocProvider(
            create: (context) {
              final cubit = ChatInboxCubit(repository: inboxRepository);
              unawaited(cubit.load());
              return cubit;
            },
          ),
        if (searchRepository != null)
          BlocProvider(
            create: (context) => ChatSearchCubit(repository: searchRepository),
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
                onOpenFullView: onOpenFullView,
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
    );
  }
}

class _ChatDrawerContent extends StatelessWidget {
  const _ChatDrawerContent({
    required this.repository,
    this.onClose,
    this.onConversationSelected,
    this.onOpenFullView,
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
  final ValueChanged<String>? onOpenFullView;
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
                onResultSelected: (item, messageId) {
                  _selectConversation(
                    context,
                    item.conversation,
                    targetMessageId: messageId,
                    role: item.role,
                  );
                  searchCubit.closeView();
                },
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
    final inboxCubit = context.read<ChatInboxCubit?>();
    if (inboxCubit == null) {
      // Kolumna listy musi mieć własną szerokość, bo układ panelu wkłada ją do
      // wiersza; lista bazowa nie zna rozmiarów panelu.
      return SizedBox(
        width: ChatPanelSizeController.listMaxWidth,
        child: _LegacyConversationList(
          onConversationSelected: onConversationSelected,
        ),
      );
    }
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
        // Wyszukiwanie w treści wiadomości ma własny widok i Cubit; pole w
        // kolumnie listy filtruje wyłącznie nazwy już pobranych rozmów.
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
    if (conversation == null || !context.mounted) return;
    _selectConversation(context, conversation, targetMessageId: messageId);
  }

  /// Rozwiązuje rozmowę po identyfikatorze z serwerowej skrzynki.
  ///
  /// Zakładka może wskazywać rozmowę spoza bieżącej strony listy, więc panel
  /// pobiera strony kursorem, aż znajdzie rozmowę, i nie udaje sukcesu, gdy
  /// backend jej nie zwraca (brak dostępu).
  Future<ChatConversation?> _resolveConversation(
    BuildContext context,
    String conversationId,
  ) async {
    final cubit = context.read<ChatInboxCubit?>();
    if (cubit == null) return null;
    var state = cubit.state;
    if (state is! ChatInboxReady) {
      await cubit.refresh();
      state = cubit.state;
    }
    var attempts = 0;
    while (state is ChatInboxReady && attempts < 10) {
      for (final item in state.items) {
        if (item.conversation.id == conversationId) return item.conversation;
      }
      if (!state.hasMore || state.isLoadingMore) break;
      await cubit.loadMore();
      attempts++;
      state = cubit.state;
    }
    return null;
  }

  /// Buduje kolumnę rozmowy dla wybranej pozycji panelu.
  Widget _buildConversationPane(
    BuildContext context,
    ChatPanelSelection selection,
    ChatConversation conversation,
  ) => ChatPanelConversation(
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
        conversationId: conversation.id,
        rootMessage: message,
      ),
    ),
    onOpenFullView: onOpenFullView == null
        ? null
        : () => onOpenFullView!(conversation.id),
  );

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

  void _apply(BuildContext context, ChatPanelSection section) {
    final cubit = context.read<ChatInboxCubit?>();
    if (cubit == null) return;
    final previous = _current;
    if (previous != null && previous.inboxFilter != null) {
      _lastFilter[previous] = cubit.filter;
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

/// Lista rozmów z kontraktu bazowego, używana tylko bez portu skrzynki.
///
/// Panel w produkcji zawsze dostaje `ChatInboxRepository`, więc ta ścieżka jest
/// wyłącznie zabezpieczeniem kompozycji, która nie ma jeszcze skrzynki.
class _LegacyConversationList extends StatelessWidget {
  const _LegacyConversationList({this.onConversationSelected});

  final ValueChanged<String>? onConversationSelected;

  @override
  Widget build(BuildContext context) =>
      BlocListener<ChatDrawerCubit, ChatDrawerState>(
        listener: (context, state) {
          if (state case ChatDrawerReady(:final conversations)) {
            context.read<ChatPanelSelectionCubit>().restoreFrom(
              conversations
                  .map(ChatConversationMapper.toDomain)
                  .toList(
                    growable: false,
                  ),
            );
          }
        },
        child: BlocBuilder<ChatDrawerCubit, ChatDrawerState>(
          builder: (context, state) => switch (state) {
            ChatDrawerInitial() || ChatDrawerLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ChatDrawerEmpty() => _ChatMessage(
              icon: WorkspaceIcons.chat,
              title: context.l10n.globalChatEmptyTitle,
              message: context.l10n.globalChatEmptyMessage,
            ),
            ChatDrawerFailure(:final message) => _ChatMessage(
              icon: Symbols.error_outline,
              title: context.l10n.globalChatLoadFailureTitle,
              message: message,
            ),
            ChatDrawerReady(:final conversations) => _ConversationList(
              conversations: conversations,
              onTap: (conversation) {
                onConversationSelected?.call(conversation.id);
                context.read<ChatPanelSelectionCubit>().select(
                  ChatConversationMapper.toDomain(conversation),
                );
              },
            ),
          },
        ),
      );
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({required this.conversations, required this.onTap});

  final List<ChatConversationResponse> conversations;
  final ValueChanged<ChatConversationResponse> onTap;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<ChatConversationResponse>>{};
    for (final conversation in conversations) {
      grouped
          .putIfAbsent(_groupLabel(context, conversation), () => [])
          .add(conversation);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(Sizes.p12, 0, Sizes.p12, Sizes.p16),
      children: [
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p4,
              Sizes.p8,
              Sizes.p4,
              Sizes.p4,
            ),
            child: Text(
              entry.key.toUpperCase(),
              style: context.text.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                letterSpacing: .5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final conversation in entry.value)
            _ConversationTile(conversation: conversation, onTap: onTap),
        ],
      ],
    );
  }

  String _groupLabel(
    BuildContext context,
    ChatConversationResponse conversation,
  ) {
    if (conversation.workspaceId != null && conversation.projectId != null) {
      return context.l10n.globalChatGroupProject;
    }
    if (conversation.workspaceId != null) {
      return context.l10n.globalChatGroupWorkspace;
    }
    return context.l10n.globalChatGroupPrivate;
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.onTap});

  final ChatConversationResponse conversation;
  final ValueChanged<ChatConversationResponse> onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(9)),
    ),
    leading: Icon(
      conversation.projectId == null
          ? WorkspaceIcons.chat
          : WorkspaceIcons.workflow,
      size: 19,
      color: context.colors.primary,
    ),
    title: Text(
      conversation.name?.trim().isNotEmpty == true
          ? conversation.name!
          : context.l10n.globalChatConversationFallback(
              conversation.id.substring(0, 8),
            ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      conversation.scopeKey,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: () => onTap(conversation),
  );
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42),
          Gaps.h12,
          Text(
            title,
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          Gaps.h8,
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
