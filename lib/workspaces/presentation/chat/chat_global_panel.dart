import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_drawer_content.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
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
    this.initialSelection,
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
  final ChatPanelSelection? initialSelection;

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
            create: (context) {
              final cubit = ChatPanelSelectionCubit(
                initialConversationId: initialConversationId,
              );
              final selection = initialSelection;
              if (selection != null) {
                cubit.select(
                  selection.conversation,
                  targetMessageId: selection.targetMessageId,
                  role: selection.role,
                );
              }
              return cubit;
            },
          ),
          // Sekcja panelu jest stanem prezentacji; filtr skrzynki ustawia
          // słuchacz w kolumnie listy, więc przełączenie zakładki nie kasuje
          // zaznaczonej rozmowy ani szkicu w composerze.
          BlocProvider(
            create: (context) {
              final cubit = ChatPanelSectionCubit();
              if (initialSelection != null) cubit.showConversation();
              return cubit;
            },
          ),
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
                  color: context.chatTheme.panelSurface,
                  border: context.workspaceGlassBorder,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  boxShadow: context.workspaceGlassShadow,
                ),
                clipBehavior: Clip.antiAlias,
                child: ChatDrawerContent(
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
