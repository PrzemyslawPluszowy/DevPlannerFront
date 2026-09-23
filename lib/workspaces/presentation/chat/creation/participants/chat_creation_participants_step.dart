import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/cubit/chat_directory_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/validation/chat_creation_validation_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Krok wyboru uczestników: katalog, wybrane osoby, reguły typu rozmowy.
class ChatCreationParticipantsStep extends StatefulWidget {
  /// Tworzy krok wyboru uczestników.
  const ChatCreationParticipantsStep({super.key});

  @override
  State<ChatCreationParticipantsStep> createState() =>
      _ChatCreationParticipantsStepState();
}

class _ChatCreationParticipantsStepState
    extends State<ChatCreationParticipantsStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatCreationCubit>().state;
    final chat = context.chatTheme;
    final isDirect = state.kind == ChatConversationKind.direct;
    final search = context.read<ChatDirectorySearchCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isDirect
              ? context.l10n.chatCreationKindDirectHint
              : context.l10n.chatCreationKindGroupHint,
          style: chat.metadataStyle.copyWith(color: chat.metadataText),
        ),
        const SizedBox(height: Sizes.p8),
        TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
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
            hintStyle: chat.contentStyle.copyWith(color: chat.metadataText),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: chat.separator),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: chat.separator),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: chat.focusRing),
            ),
          ),
          style: chat.contentStyle.copyWith(color: chat.incomingText),
          onChanged: search.updateQuery,
        ),
        const SizedBox(height: Sizes.p8),
        BlocBuilder<ChatDirectorySearchCubit, ChatDirectorySearchState>(
          bloc: search,
          builder: (context, searchState) => _CatalogResults(
            state: searchState,
            selected: state.participants.map((entry) => entry.userId).toSet(),
            existingDirect: state.existingDirectConversationIds,
            isDirect: isDirect,
            busy: state.isSubmitting,
            onToggle: context.read<ChatCreationCubit>().toggleParticipant,
            onStartDirect: (entry) => unawaited(
              context.read<ChatCreationCubit>().startDirectWith(entry),
            ),
            onRetry: search.retry,
          ),
        ),
        const SizedBox(height: Sizes.p12),
        _SelectedParticipants(
          participants: state.participants,
          existingDirect: state.existingDirectConversationIds,
          isDirect: isDirect,
          onRemove: context.read<ChatCreationCubit>().toggleParticipant,
        ),
        if (state.validationErrors.isNotEmpty) ...[
          const SizedBox(height: Sizes.p8),
          for (final error in state.validationErrors)
            ChatCreationValidationText(
              validation: error,
              style: chat.metadataStyle.copyWith(color: chat.error),
            ),
        ],
      ],
    );
  }
}

class _CatalogResults extends StatelessWidget {
  const _CatalogResults({
    required this.state,
    required this.selected,
    required this.existingDirect,
    required this.isDirect,
    required this.busy,
    required this.onToggle,
    required this.onStartDirect,
    required this.onRetry,
  });

  final ChatDirectorySearchState state;
  final Set<String> selected;
  final Set<String> existingDirect;
  final bool isDirect;

  /// Czy trwa wysyłanie; wtedy wybór osoby jest zablokowany.
  final bool busy;
  final ValueChanged<ChatDirectoryEntry> onToggle;
  final ValueChanged<ChatDirectoryEntry> onStartDirect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    if (state.query.trim().isEmpty) return const SizedBox.shrink();
    if (state.isQueryTooShort) {
      return Text(
        context.l10n.chatCreationSearchTooShort,
        style: chat.metadataStyle.copyWith(color: chat.metadataText),
      );
    }
    if (state.isSearching) {
      return const Padding(
        padding: EdgeInsets.all(Sizes.p8),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (state.failureCode != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.chatCreationFailureTitle,
              style: chat.metadataStyle.copyWith(color: chat.error),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.chatCreationRetry),
          ),
        ],
      );
    }
    if (state.results.isEmpty) {
      return Text(
        context.l10n.chatCreationSearchEmpty,
        style: chat.metadataStyle.copyWith(color: chat.metadataText),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final entry = state.results[index];
          final isSelected = selected.contains(entry.userId);
          final hasDirect = isDirect && existingDirect.contains(entry.userId);
          final subtitle = hasDirect
              ? '${entry.login} · ${context.l10n.chatCreationExistingDirect}'
              : entry.login;
          final enabled = !busy;
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p4),
            child: Material(
              color: isSelected ? chat.selectedSurface : chat.listSurface,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: !enabled
                    ? null
                    : isDirect
                    ? () => onStartDirect(entry)
                    : () => onToggle(entry),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Row(
                    children: [
                      AppUserAvatar(
                        userId: entry.userId,
                        displayName: entry.label,
                        avatarUrl: entry.avatarUrl,
                        hasCustomAvatar:
                            entry.avatarUrl?.trim().isNotEmpty == true,
                        radius: 18,
                        singleInitial: true,
                      ),
                      const SizedBox(width: Sizes.p8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: chat.contentStyle.copyWith(
                                color: chat.incomingText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: chat.metadataStyle.copyWith(
                                color: hasDirect
                                    ? chat.linkText
                                    : chat.metadataText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Sizes.p8),
                      Icon(
                        isDirect
                            ? Symbols.chat_bubble_outline
                            : isSelected
                            ? Symbols.check_circle
                            : Symbols.circle,
                        size: 20,
                        color: isSelected ? chat.linkText : chat.metadataText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SelectedParticipants extends StatelessWidget {
  const _SelectedParticipants({
    required this.participants,
    required this.existingDirect,
    required this.isDirect,
    required this.onRemove,
  });

  final List<ChatDirectoryEntry> participants;
  final Set<String> existingDirect;
  final bool isDirect;
  final ValueChanged<ChatDirectoryEntry> onRemove;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.chatCreationSelectedTitle,
          style: chat.contentStyle.copyWith(
            color: chat.incomingText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Sizes.p4),
        if (participants.isEmpty)
          Text(
            context.l10n.chatCreationSelectedNone,
            style: chat.metadataStyle.copyWith(color: chat.metadataText),
          )
        else
          Wrap(
            spacing: Sizes.p6,
            runSpacing: Sizes.p6,
            children: [
              for (final entry in participants)
                InputChip(
                  label: Text(entry.label),
                  deleteButtonTooltipMessage:
                      context.l10n.chatCreationRemoveParticipant,
                  onDeleted: () => onRemove(entry),
                  backgroundColor: chat.mentionSurface,
                  labelStyle: chat.metadataStyle.copyWith(
                    color: chat.mentionText,
                  ),
                  deleteIconColor: chat.mentionText,
                  side: BorderSide(color: chat.separator),
                  shape: const StadiumBorder(),
                ),
            ],
          ),
        if (isDirect &&
            participants.any(
              (entry) => existingDirect.contains(entry.userId),
            )) ...[
          const SizedBox(height: Sizes.p6),
          Text(
            context.l10n.chatCreationExistingReused,
            style: chat.metadataStyle.copyWith(color: chat.metadataText),
          ),
        ],
      ],
    );
  }
}
