import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/chat_creation_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/cubit/chat_directory_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_compose_directory_section.dart';
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
  /// Maksymalna szerokość popovera kontaktów na desktopie.
  ///
  /// Zachowuje proporcje kompaktowego panelu tworzenia znanego z komunikatorów
  /// i nie zasłania niepotrzebnie aktywnej rozmowy.
  static const double maxWidth = 320;

  /// Otwiera popover i zwraca utworzoną albo odnalezioną rozmowę.
  static Future<ChatConversation?> show(
    BuildContext context, {
    required Offset globalPosition,
    required ChatConversationManagementRepository repository,
    required ChatDirectoryRepository directoryRepository,
    List<ChatInboxItem> recent = const <ChatInboxItem>[],
    ChatInboxPresenceCubit? inboxPresenceCubit,
    Set<String> existingDirectConversationIds = const <String>{},
  }) async {
    ChatConversation? created;
    final media = MediaQuery.of(context);
    final popoverMaxHeight = media.size.height * .7;
    final contentHeight = (popoverMaxHeight - 56).clamp(
      0.0,
      popoverMaxHeight,
    );
    await AppContextMenu.showCustom(
      context,
      globalPosition: globalPosition,
      maxWidth: maxWidth,
      maxHeight: popoverMaxHeight,
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
          if (inboxPresenceCubit case final presence?)
            BlocProvider<ChatInboxPresenceCubit>.value(value: presence),
        ],
        child: _ChatComposePopoverContent(
          repository: repository,
          directoryRepository: directoryRepository,
          contentHeight: contentHeight,
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
    required this.contentHeight,
    required this.recent,
    required this.existingDirectConversationIds,
    required this.onCreated,
  });

  final ChatConversationManagementRepository repository;
  final ChatDirectoryRepository directoryRepository;
  final double contentHeight;
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
        final chat = context.chatTheme;
        final compactHeight = widget.contentHeight < 256;
        final kindRows = <Widget>[
          _ChatComposeKindRow(
            icon: Symbols.group_add_rounded,
            label: context.l10n.chatComposeNewGroup,
            compact: compactHeight,
            onTap: () => _openSheet(context, ChatConversationKind.group),
          ),
          _ChatComposeKindRow(
            icon: Symbols.campaign_rounded,
            label: context.l10n.chatComposeNewChannel,
            compact: compactHeight,
            onTap: () => _openSheet(context, ChatConversationKind.channel),
          ),
          _ChatComposeKindRow(
            icon: Symbols.campaign_rounded,
            label: context.l10n.chatComposeNewBroadcast,
            compact: compactHeight,
            onTap: () => _openSheet(context, ChatConversationKind.broadcast),
          ),
        ];
        return SizedBox(
          height: widget.contentHeight,
          child: Padding(
            padding: EdgeInsets.all(compactHeight ? Sizes.p8 : Sizes.p12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const ValueKey('chat-compose-search'),
                  controller: _controller,
                  autofocus: true,
                  style: chat.contentStyle.copyWith(color: chat.incomingText),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: chat.composerSurface,
                    prefixIcon: Icon(
                      Symbols.search,
                      size: 18,
                      color: chat.metadataText,
                    ),
                    hintText: context.l10n.chatCreationSearchHint,
                    hintStyle: chat.contentStyle.copyWith(
                      color: chat.metadataText,
                    ),
                    border: _searchBorder(chat.separator),
                    enabledBorder: _searchBorder(chat.separator),
                    focusedBorder: _searchBorder(chat.focusRing, width: 1.5),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: context.l10n.chatInboxSearchClear,
                            color: chat.metadataText,
                            onPressed: () {
                              _controller.clear();
                              context.read<ChatDirectorySearchCubit>().clear();
                              setState(() {});
                            },
                            icon: const Icon(Symbols.close, size: 16),
                          ),
                  ),
                  onChanged: (value) {
                    context.read<ChatDirectorySearchCubit>().updateQuery(value);
                    setState(() {});
                  },
                ),
                SizedBox(height: compactHeight ? Sizes.p4 : Sizes.p8),
                if (creation.isSubmitting)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.p8),
                    child: LinearProgressIndicator(),
                  ),
                if (compactHeight)
                  Row(
                    children: [
                      for (final row in kindRows) Expanded(child: row),
                    ],
                  )
                else
                  ...kindRows,
                Divider(height: compactHeight ? Sizes.p8 : Sizes.p16),
                Flexible(
                  child: ChatComposeDirectorySection(
                    recent: widget.recent,
                    onCreated: widget.onCreated,
                  ),
                ),
                if (creation.failureCode != null)
                  Padding(
                    padding: const EdgeInsets.only(top: Sizes.p8),
                    child: Text(
                      // Szczegóły techniczne zostają w logach; w komunikatorze
                      // pokazujemy zwięzły komunikat zamiast kodu API.
                      context.l10n.chatCreationFailureTitle,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                  ),
              ],
            ),
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
}

class _ChatComposeKindRow extends StatelessWidget {
  const _ChatComposeKindRow({
    required this.icon,
    required this.label,
    required this.compact,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p4),
      child: Material(
        color: chat.listSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: compact
                ? const EdgeInsets.symmetric(
                    horizontal: Sizes.p2,
                    vertical: Sizes.p4,
                  )
                : const EdgeInsets.all(Sizes.p8),
            child: compact
                ? Tooltip(
                    message: label,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 18, color: chat.linkText),
                        const SizedBox(height: Sizes.p2),
                        Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: chat.metadataStyle.copyWith(
                            color: chat.incomingText,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: chat.mentionSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 19, color: chat.linkText),
                      ),
                      const SizedBox(width: Sizes.p8),
                      Expanded(
                        child: Text(
                          label,
                          style: chat.contentStyle.copyWith(
                            color: chat.incomingText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Symbols.chevron_right,
                        size: 18,
                        color: chat.metadataText,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder _searchBorder(Color color, {double width = 1}) =>
    OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: color, width: width),
    );
