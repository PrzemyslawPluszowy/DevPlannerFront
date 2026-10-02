import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_forward_target_picker_components.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_forward_targets_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wyszukiwalna lista rozmów docelowych osadzona w menu kontekstowym.
class ChatForwardTargetPicker extends StatefulWidget {
  const ChatForwardTargetPicker({
    required this.targets,
    required this.onSelected,
    required this.sourceConversationId,
    this.repository,
    super.key,
  });

  /// Snapshot używany wyłącznie jako zgodnościowy fallback bez repozytorium.
  final List<ChatInboxItem> targets;
  final ValueChanged<ChatInboxItem> onSelected;
  final String sourceConversationId;
  final ChatInboxRepository? repository;

  @override
  State<ChatForwardTargetPicker> createState() =>
      _ChatForwardTargetPickerState();
}

class _ChatForwardTargetPickerState extends State<ChatForwardTargetPicker> {
  ChatForwardTargetsCubit? _cubit;
  late List<ChatInboxItem> _fallbackMatches;
  String _fallbackQuery = '';

  @override
  void initState() {
    super.initState();
    _cubit = _createCubit(widget);
    final cubit = _cubit;
    _fallbackMatches = _filterTargets(_fallbackQuery);
    if (cubit != null) _loadCubit(cubit);
  }

  @override
  void didUpdateWidget(covariant ChatForwardTargetPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targets != widget.targets ||
        oldWidget.sourceConversationId != widget.sourceConversationId) {
      _fallbackMatches = _filterTargets(_fallbackQuery);
    }
    if (oldWidget.repository != widget.repository ||
        oldWidget.sourceConversationId != widget.sourceConversationId) {
      final previous = _cubit;
      if (previous != null) unawaited(previous.close());
      _cubit = _createCubit(widget);
      final cubit = _cubit;
      if (cubit != null) _loadCubit(cubit);
    }
  }

  ChatForwardTargetsCubit? _createCubit(ChatForwardTargetPicker widget) {
    final repository = widget.repository;
    return repository == null
        ? null
        : ChatForwardTargetsCubit(
            repository: repository,
            excludedConversationId: widget.sourceConversationId,
          );
  }

  void _loadCubit(ChatForwardTargetsCubit cubit) {
    if (_fallbackQuery.trim().length >= 2) {
      unawaited(cubit.setQuery(_fallbackQuery));
    } else {
      unawaited(cubit.load());
    }
  }

  @override
  void dispose() {
    final cubit = _cubit;
    if (cubit != null) unawaited(cubit.close());
    super.dispose();
  }

  List<ChatInboxItem> _filterTargets(String query) {
    final normalized = query.trim().toLowerCase();
    return widget.targets
        .where((item) {
          if (item.conversation.id == widget.sourceConversationId) return false;
          return normalized.isEmpty ||
              item.displayName.toLowerCase().contains(normalized) ||
              (item.lastMessage?.text ?? '').toLowerCase().contains(normalized);
        })
        .toList(growable: false);
  }

  void _onQueryChanged(String value) {
    _fallbackQuery = value;
    final cubit = _cubit;
    if (cubit != null) {
      unawaited(cubit.setQuery(value));
      return;
    }
    setState(() {
      _fallbackQuery = value;
      _fallbackMatches = _filterTargets(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final cubit = _cubit;
    return Theme(
      data: chat.applyControls(Theme.of(context)),
      child: SizedBox(
        width: 340,
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                key: const ValueKey('chat-forward-target-search'),
                autofocus: true,
                onChanged: _onQueryChanged,
                style: chat.contentStyle.copyWith(color: chat.incomingText),
                decoration: InputDecoration(
                  hintText: context.l10n.chatInboxSearchHint,
                  prefixIcon: Icon(Symbols.search, color: chat.metadataText),
                  isDense: true,
                  filled: true,
                  fillColor: chat.composerSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: chat.separator),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: cubit == null
                    ? ChatForwardTargetFallbackResults(
                        items: _fallbackMatches,
                        onSelected: widget.onSelected,
                      )
                    : BlocProvider<ChatForwardTargetsCubit>.value(
                        value: cubit,
                        child: ChatForwardTargetRemoteResults(
                          onSelected: widget.onSelected,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
