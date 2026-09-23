import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
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
    this.freeSlots,
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

  /// Liczba wolnych miejsc; limit 50 obowiązuje tylko dla grup.
  final int? freeSlots;

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

  bool get _capacityReached =>
      widget.freeSlots != null && widget.freeSlots! - _selected.length <= 0;

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
    final chat = context.chatTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Symbols.person_add, size: 20, color: chat.linkText),
            const SizedBox(width: Sizes.p8),
            Expanded(
              child: Text(
                context.l10n.chatMembersAdd,
                style: chat.contentStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: chat.incomingText,
                ),
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
        if (widget.freeSlots case final freeSlots?)
          Padding(
            padding: const EdgeInsets.only(top: Sizes.p4),
            child: Text(
              _capacityReached
                  ? context.l10n.chatMembersAddCapacityFull
                  : context.l10n.chatMembersAddFreeSlots(
                      freeSlots - _selected.length,
                    ),
              style: chat.metadataStyle.copyWith(color: chat.metadataText),
            ),
          ),
        const SizedBox(height: Sizes.p8),
        TextField(
          controller: _queryController,
          enabled: !_capacityReached && !widget.isMutating,
          onChanged: _search.updateQuery,
          style: chat.contentStyle.copyWith(color: chat.incomingText),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: chat.panelSurface,
            prefixIcon: Icon(
              Symbols.search,
              size: 18,
              color: chat.metadataText,
            ),
            hintText: context.l10n.chatMembersAddSearchHint,
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
        ),
        if (_selected.isNotEmpty) ...[
          const SizedBox(height: Sizes.p8),
          Text(
            context.l10n.chatMembersAddSelected,
            style: chat.metadataStyle.copyWith(
              color: chat.metadataText,
              fontWeight: FontWeight.w700,
            ),
          ),
          Wrap(
            spacing: Sizes.p4,
            children: [
              for (final entry in _selected.values)
                InputChip(
                  label: Text(entry.label),
                  onDeleted: widget.isMutating ? null : () => _toggle(entry),
                  backgroundColor: chat.mentionSurface,
                  selectedColor: chat.mentionSurface,
                  labelStyle: chat.metadataStyle.copyWith(
                    color: chat.mentionText,
                  ),
                  deleteIconColor: chat.mentionText,
                  side: BorderSide(color: chat.separator),
                  shape: const StadiumBorder(),
                ),
            ],
          ),
        ],
        const SizedBox(height: Sizes.p8),
        Expanded(
          child:
              BlocBuilder<ChatDirectorySearchCubit, ChatDirectorySearchState>(
                bloc: _search,
                builder: (context, state) {
                  if (state.query.trim().isEmpty) {
                    return _AddHint(
                      icon: Symbols.search,
                      message: context.l10n.chatComposeSearchPrompt,
                    );
                  }
                  if (state.isQueryTooShort) {
                    return _AddHint(
                      icon: Symbols.search,
                      message: context.l10n.chatCreationSearchTooShort,
                    );
                  }
                  if (state.isSearching) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.failureCode != null) {
                    return _AddHint(
                      icon: Symbols.error_outline,
                      message: context.l10n.chatCreationFailureTitle,
                      color: chat.error,
                      onRetry: () => unawaited(_search.retry()),
                    );
                  }
                  if (state.results.isEmpty) {
                    return _AddHint(
                      icon: Symbols.search_off,
                      message: context.l10n.chatMembersAddEmpty,
                    );
                  }
                  final results = state.results;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final entry = results[index];
                      final existing = widget.existingUserIds.contains(
                        entry.userId,
                      );
                      final selected = _selected.containsKey(entry.userId);
                      final enabled =
                          !existing && (!_capacityReached || selected);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Sizes.p4),
                        child: Material(
                          color: chat.listSurface,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: enabled ? () => _toggle(entry) : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.p8,
                                vertical: Sizes.p8,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: existing || selected,
                                    onChanged: enabled
                                        ? (_) => _toggle(entry)
                                        : null,
                                    fillColor: WidgetStateProperty.resolveWith(
                                      (states) =>
                                          states.contains(
                                            WidgetState.selected,
                                          )
                                          ? chat.linkText
                                          : chat.separator,
                                    ),
                                    checkColor: chat.incomingBubble,
                                  ),
                                  AppUserAvatar(
                                    userId: entry.userId,
                                    displayName: entry.label,
                                    avatarUrl: entry.avatarUrl,
                                    hasCustomAvatar:
                                        entry.avatarUrl?.trim().isNotEmpty ==
                                        true,
                                    radius: 18,
                                    singleInitial: true,
                                  ),
                                  const SizedBox(width: Sizes.p10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        const SizedBox(height: Sizes.p2),
                                        Text(
                                          existing
                                              ? context
                                                    .l10n
                                                    .chatMembersAddExisting
                                              : entry.login,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: chat.metadataStyle.copyWith(
                                            color: chat.metadataText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
        ),
        if (widget.failureCode != null)
          Padding(
            padding: const EdgeInsets.only(top: Sizes.p4),
            child: Text(
              context.l10n.chatCreationFailureTitle,
              style: chat.metadataStyle.copyWith(color: chat.error),
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
  const _AddHint({
    required this.icon,
    required this.message,
    this.color,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final Color? color;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final foreground = color ?? chat.metadataText;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: foreground),
          const SizedBox(height: Sizes.p8),
          Text(
            message,
            style: chat.metadataStyle.copyWith(color: foreground),
          ),
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
