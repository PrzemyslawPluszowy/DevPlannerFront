import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_filter.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Synchronizuje wybraną sekcję panelu z filtrem serwerowej skrzynki.
///
/// Widget pamięta filtr wybrany w każdej sekcji, więc powrót na Czaty wraca do
/// „Nieprzeczytane”, jeśli użytkownik tak je zostawił, a przejście na Pliki czy
/// Zapisane nie zmienia skrzynki w tle.
class ChatSectionFilterSync extends StatefulWidget {
  const ChatSectionFilterSync({required this.child, super.key});

  final Widget child;

  @override
  State<ChatSectionFilterSync> createState() => ChatSectionFilterSyncState();
}

class ChatSectionFilterSyncState extends State<ChatSectionFilterSync> {
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
