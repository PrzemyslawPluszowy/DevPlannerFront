import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/chat_creation_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/cubit/chat_directory_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Zakotwiczony popover „Nowy czat” z §2.4 planu korekty.
///
/// Popover powstaje w miejscu przycisku compose (nie jako `AlertDialog`),
/// mieści się w widoku dzięki wspólnej powierzchni `AppContextMenu` i nie jest
/// obcinany przez panel, bo należy do warstwy modali nad panelem. Osoba z
/// katalogu kończy rozmowę 1:1 od razu: backend rozwiązuje istniejący DM pary
/// albo tworzy nowy, a panel otwiera to, co wróciło.
abstract final class ChatComposePopover {
  /// Otwiera popover i zwraca utworzoną albo odnalezioną rozmowę.
  static Future<ChatConversation?> show(
    BuildContext context, {
    required Offset globalPosition,
    required ChatConversationManagementRepository repository,
    required ChatDirectoryRepository directoryRepository,
    List<ChatInboxItem> recent = const <ChatInboxItem>[],
    Set<String> existingDirectConversationIds = const <String>{},
  }) async {
    ChatConversation? created;
    final media = MediaQuery.of(context);
    await AppContextMenu.showCustom(
      context,
      globalPosition: globalPosition,
      maxWidth: 420,
      maxHeight: media.size.height * .7,
      headerTitle: context.l10n.chatComposeTitle,
      contentBuilder: (context, dismiss) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ChatCreationCubit(
              repository: repository,
              existingDirectConversationIds: existingDirectConversationIds,
            ),
          ),
          BlocProvider(
            create: (_) => ChatDirectorySearchCubit(
              repository: directoryRepository,
            ),
          ),
        ],
        child: _ChatComposePopoverContent(
          repository: repository,
          directoryRepository: directoryRepository,
          recent: recent,
          existingDirectConversationIds: existingDirectConversationIds,
          onCreated: (conversation) {
            created = conversation;
            dismiss();
          },
        ),
      ),
    );
    return created;
  }
}

class _ChatComposePopoverContent extends StatefulWidget {
  const _ChatComposePopoverContent({
    required this.repository,
    required this.directoryRepository,
    required this.recent,
    required this.existingDirectConversationIds,
    required this.onCreated,
  });

  final ChatConversationManagementRepository repository;
  final ChatDirectoryRepository directoryRepository;
  final List<ChatInboxItem> recent;
  final Set<String> existingDirectConversationIds;
  final ValueChanged<ChatConversation> onCreated;

  @override
  State<_ChatComposePopoverContent> createState() =>
      _ChatComposePopoverContentState();
}

class _ChatComposePopoverContentState
    extends State<_ChatComposePopoverContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<ChatCreationCubit, ChatCreationState>(
    listenWhen: (previous, current) =>
        current.created != null && previous.created != current.created,
    listener: (context, state) => widget.onCreated(state.created!),
    // Cały stan czytamy w builderze: `read` nie przebudowywał kontrolek, więc
    // użytkownik nie widział ani trwającej wysyłki, ani przyczyny porażki.
    child: BlocBuilder<ChatCreationCubit, ChatCreationState>(
      builder: (context, creation) {
        return Padding(
          padding: const EdgeInsets.all(Sizes.p12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const ValueKey('chat-compose-search'),
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Symbols.search, size: 18),
                  hintText: context.l10n.chatCreationSearchHint,
                ),
                onChanged: (value) =>
                    context.read<ChatDirectorySearchCubit>().updateQuery(value),
              ),
              Gaps.h8,
              if (creation.isSubmitting)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.p8),
                  child: LinearProgressIndicator(),
                ),
              _ChatComposeKindRow(
                icon: Symbols.group_add_rounded,
                label: context.l10n.chatComposeNewGroup,
                onTap: () => _openSheet(context, ChatConversationKind.group),
              ),
              _ChatComposeKindRow(
                icon: Symbols.campaign_rounded,
                label: context.l10n.chatComposeNewChannel,
                onTap: () => _openSheet(context, ChatConversationKind.channel),
              ),
              _ChatComposeKindRow(
                icon: Symbols.campaign_rounded,
                label: context.l10n.chatComposeNewBroadcast,
                onTap: () =>
                    _openSheet(context, ChatConversationKind.broadcast),
              ),
              const Divider(height: Sizes.p16),
              Flexible(
                child:
                    BlocBuilder<
                      ChatDirectorySearchCubit,
                      ChatDirectorySearchState
                    >(
                      builder: (context, state) {
                        // Stany rozstrzygamy po kolei: krótka fraza nie pyta
                        // backendu, a trwające wyszukiwanie nie udaje pustego
                        // wyniku ani gotowej listy.
                        if (state.query.trim().isEmpty) {
                          return _recentSection(context);
                        }
                        if (state.isQueryTooShort) {
                          return _hint(context.l10n.chatCreationSearchTooShort);
                        }
                        if (state.failureCode != null) {
                          return _hint(context.l10n.chatCreationFailureTitle);
                        }
                        if (state.isSearching && state.results.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(Sizes.p16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state.isEmpty) {
                          return _hint(context.l10n.chatCreationSearchEmpty);
                        }
                        return _results(
                          context,
                          context.read<ChatCreationCubit>(),
                          creation.isSubmitting,
                          state.results,
                        );
                      },
                    ),
              ),
              if (creation.failureCode case final failure?)
                Padding(
                  padding: const EdgeInsets.only(top: Sizes.p8),
                  child: Text(
                    // Kod domenowy zostaje widoczny dla diagnostyki; użytkownik
                    // dostaje tekst z ARB, a nie techniczny identyfikator.
                    '${context.l10n.chatCreationFailureTitle} ($failure)',
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );

  /// Otwiera kreator w wybranym trybie; popover zostaje otwarty pod spodem.
  void _openSheet(BuildContext context, ChatConversationKind kind) {
    unawaited(
      ChatCreationSheet.show(
        context,
        repository: widget.repository,
        directoryRepository: widget.directoryRepository,
        existingDirectConversationIds: widget.existingDirectConversationIds,
        initialKind: kind,
      ).then((conversation) {
        if (conversation != null && mounted) widget.onCreated(conversation);
      }),
    );
  }

  Widget _recentSection(BuildContext context) {
    final recent = widget.recent.take(6).toList(growable: false);
    if (recent.isEmpty) {
      return _hint(context.l10n.chatComposeSearchPrompt);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle(context, context.l10n.chatComposeRecentTitle),
        for (final item in recent)
          ListTile(
            dense: true,
            leading: const Icon(Symbols.forum_rounded, size: 20),
            title: Text(
              item.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => widget.onCreated(item.conversation),
          ),
      ],
    );
  }

  Widget _results(
    BuildContext context,
    ChatCreationCubit cubit,
    bool busy,
    List<ChatDirectoryEntry> entries,
  ) => ListView.builder(
    shrinkWrap: true,
    itemCount: entries.length,
    itemBuilder: (context, index) {
      final entry = entries[index];
      return ListTile(
        key: ValueKey<String>('chat-compose-entry-${entry.userId}'),
        dense: true,
        enabled: !busy,
        leading: CircleAvatar(
          radius: 18,
          child: Text(_initials(entry.label)),
        ),
        title: Text(entry.label, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: busy ? null : () => unawaited(cubit.startDirectWith(entry)),
      );
    },
  );

  Widget _hint(String message) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
    child: Text(
      message,
      style: context.text.bodySmall?.copyWith(
        color: context.colors.onSurfaceVariant,
      ),
    ),
  );

  Widget _sectionTitle(BuildContext context, String label) => Padding(
    padding: const EdgeInsets.fromLTRB(Sizes.p4, Sizes.p8, Sizes.p4, Sizes.p4),
    child: Text(
      label.toUpperCase(),
      style: context.text.labelSmall?.copyWith(
        color: context.colors.onSurfaceVariant,
        letterSpacing: .5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static String _initials(String label) {
    final words = label
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .toList(growable: false);
    if (words.isEmpty) return '?';
    return words.map((word) => word.characters.first.toUpperCase()).join();
  }
}

class _ChatComposeKindRow extends StatelessWidget {
  const _ChatComposeKindRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    leading: Icon(icon, size: 20, color: context.colors.primary),
    title: Text(label),
    onTap: onTap,
  );
}
