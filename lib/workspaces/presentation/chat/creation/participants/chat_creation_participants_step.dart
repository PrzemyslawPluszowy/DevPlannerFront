import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
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
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: Sizes.p8),
        TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: const Icon(Symbols.search, size: 18),
            hintText: context.l10n.chatCreationSearchHint,
          ),
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
          onRemove: context.read<ChatCreationCubit>().toggleParticipant,
        ),
        if (state.validationErrors.isNotEmpty) ...[
          const SizedBox(height: Sizes.p8),
          for (final error in state.validationErrors)
            ChatCreationValidationText(
              validation: error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
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
    final theme = Theme.of(context);
    if (state.query.trim().isEmpty) return const SizedBox.shrink();
    if (state.isQueryTooShort) {
      return Text(
        context.l10n.chatCreationSearchTooShort,
        style: theme.textTheme.bodySmall,
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
              state.failureCode!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(context.l10n.chatCreationRetry)),
        ],
      );
    }
    if (state.results.isEmpty) {
      return Text(
        context.l10n.chatCreationSearchEmpty,
        style: theme.textTheme.bodySmall,
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
          final subtitle = Text(
            hasDirect
                ? '${entry.login} · ${context.l10n.chatCreationExistingDirect}'
                : entry.login,
          );
          return isDirect
              // 1:1 kończy się na wyborze osoby: nie ma osobnego kroku szczegółów.
              ? ListTile(
                  title: Text(entry.label),
                  subtitle: subtitle,
                  dense: true,
                  enabled: !busy,
                  onTap: busy ? null : () => onStartDirect(entry),
                )
              : CheckboxListTile(
                  value: isSelected,
                  onChanged: (_) => onToggle(entry),
                  title: Text(entry.label),
                  subtitle: subtitle,
                  dense: true,
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
    required this.onRemove,
  });

  final List<ChatDirectoryEntry> participants;
  final Set<String> existingDirect;
  final ValueChanged<ChatDirectoryEntry> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.chatCreationSelectedTitle,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: Sizes.p4),
        if (participants.isEmpty)
          Text(
            context.l10n.chatCreationSelectedNone,
            style: theme.textTheme.bodySmall,
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
                ),
            ],
          ),
        if (participants.any(
          (entry) => existingDirect.contains(entry.userId),
        )) ...[
          const SizedBox(height: Sizes.p6),
          Text(
            context.l10n.chatCreationExistingReused,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
