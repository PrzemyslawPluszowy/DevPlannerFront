import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/cubit/chat_directory_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Podwidok dodawania osób do istniejącej rozmowy.
///
/// Widok jest lokalny dla arkusza członków: nie otwiera pełnoekranowego modala.
/// Wybór trzyma etykiety kandydatów, więc po błędzie backendu użytkownik nie
/// traci zaznaczenia; nowy stan potwierdza dopiero odświeżenie listy członków.
class ChatAddMembersView extends StatefulWidget {
  /// Tworzy podwidok dodawania osób.
  const ChatAddMembersView({
    required this.directoryRepository,
    required this.existingUserIds,
    required this.freeSlots,
    required this.isMutating,
    required this.onCancel,
    required this.onSubmit,
    this.failureCode,
    super.key,
  });

  /// Port lokalnego katalogu kont do wyszukiwania kandydatów.
  final ChatDirectoryRepository directoryRepository;

  /// Członkowie, których nie wolno dodać ponownie.
  final Set<String> existingUserIds;

  /// Liczba wolnych miejsc w grupie; zero blokuje dodawanie.
  final int freeSlots;

  /// Czy trwa mutacja na serwerze.
  final bool isMutating;

  /// Zamyka podwidok bez zmiany listy.
  final VoidCallback onCancel;

  /// Wysyła wybrane identyfikatory; widok czeka na wynik mutacji.
  final ValueChanged<List<String>> onSubmit;

  /// Kod domenowy ostatniej porażki; pokazywany bez zamykania widoku.
  final String? failureCode;

  @override
  State<ChatAddMembersView> createState() => _ChatAddMembersViewState();
}

class _ChatAddMembersViewState extends State<ChatAddMembersView> {
  late final ChatDirectorySearchCubit _search;
  final TextEditingController _queryController = TextEditingController();
  final Map<String, ChatDirectoryEntry> _selected =
      <String, ChatDirectoryEntry>{};

  bool get _capacityReached => widget.freeSlots - _selected.length <= 0;

  @override
  void initState() {
    super.initState();
    _search = ChatDirectorySearchCubit(repository: widget.directoryRepository);
  }

  @override
  void dispose() {
    _queryController.dispose();
    unawaited(_search.close());
    super.dispose();
  }

  void _toggle(ChatDirectoryEntry entry) {
    setState(() {
      if (_selected.containsKey(entry.userId)) {
        _selected.remove(entry.userId);
        return;
      }
      if (_capacityReached) return;
      _selected[entry.userId] = entry;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Symbols.person_add, size: 20),
            const SizedBox(width: Sizes.p8),
            Expanded(
              child: Text(
                context.l10n.chatMembersAdd,
                style: theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: context.l10n.chatMembersAddCancel,
              onPressed: widget.isMutating ? null : widget.onCancel,
              icon: const Icon(Symbols.close, size: 18),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: Sizes.p4),
          child: Text(
            _capacityReached
                ? context.l10n.chatMembersAddCapacityFull
                : context.l10n.chatMembersAddFreeSlots(
                    widget.freeSlots - _selected.length,
                  ),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: Sizes.p8),
        TextField(
          controller: _queryController,
          enabled: !_capacityReached && !widget.isMutating,
          onChanged: _search.updateQuery,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: const Icon(Symbols.search, size: 18),
            hintText: context.l10n.chatMembersAddSearchHint,
          ),
        ),
        if (_selected.isNotEmpty) ...[
          const SizedBox(height: Sizes.p8),
          Text(
            context.l10n.chatMembersAddSelected,
            style: theme.textTheme.labelSmall,
          ),
          Wrap(
            spacing: Sizes.p4,
            children: [
              for (final entry in _selected.values)
                InputChip(
                  label: Text(entry.label),
                  onDeleted: widget.isMutating ? null : () => _toggle(entry),
                ),
            ],
          ),
        ],
        const SizedBox(height: Sizes.p8),
        Expanded(
          child:
              BlocBuilder<ChatDirectorySearchCubit, ChatDirectorySearchState>(
                bloc: _search,
                builder: (context, state) => switch (state) {
                  ChatDirectorySearchState(isSearching: true) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ChatDirectorySearchState(failureCode: final code?) =>
                    _AddHint(
                      icon: Symbols.error_outline,
                      message: code,
                      onRetry: () => unawaited(_search.retry()),
                    ),
                  ChatDirectorySearchState(isEmpty: true) => _AddHint(
                    icon: Symbols.search_off,
                    message: context.l10n.chatMembersAddEmpty,
                  ),
                  ChatDirectorySearchState(:final results) => ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final entry = results[index];
                      final existing = widget.existingUserIds.contains(
                        entry.userId,
                      );
                      final selected = _selected.containsKey(entry.userId);
                      return CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: existing || selected,
                        onChanged: existing || _capacityReached && !selected
                            ? null
                            : (_) => _toggle(entry),
                        title: Text(entry.label),
                        subtitle: Text(
                          existing
                              ? context.l10n.chatMembersAddExisting
                              : entry.login,
                        ),
                      );
                    },
                  ),
                },
              ),
        ),
        if (widget.failureCode != null)
          Padding(
            padding: const EdgeInsets.only(top: Sizes.p4),
            child: Text(
              widget.failureCode!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        const Divider(height: Sizes.p16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: widget.isMutating ? null : widget.onCancel,
              child: Text(context.l10n.chatMembersAddCancel),
            ),
            const SizedBox(width: Sizes.p8),
            FilledButton(
              onPressed: _selected.isEmpty || widget.isMutating
                  ? null
                  : () =>
                        widget.onSubmit(_selected.keys.toList(growable: false)),
              child: Text(context.l10n.chatMembersAddConfirm),
            ),
          ],
        ),
      ],
    );
  }
}

class _AddHint extends StatelessWidget {
  const _AddHint({required this.icon, required this.message, this.onRetry});

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: Sizes.p8),
          Text(message, style: theme.textTheme.bodySmall),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.chatInboxRetry),
            ),
        ],
      ),
    );
  }
}
