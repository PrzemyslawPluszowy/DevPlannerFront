import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stosuje intencję otwarcia w lifecycle; rebuild nie wybiera ponownie rozmowy.
/// Resolver zasobu przekazuje już autoryzowany model, więc nie czeka na inbox.
final class ChatPanelOpenIntentSync extends StatefulWidget {
  const ChatPanelOpenIntentSync({
    required this.child,
    this.initialConversationId,
    this.initialSelection,
    this.intentToken,
    super.key,
  });
  final Widget child;
  final String? initialConversationId;
  final ChatPanelSelection? initialSelection;

  /// Nowy token oznacza akcję użytkownika, także dla tej samej rozmowy.
  final Object? intentToken;

  @override
  State<ChatPanelOpenIntentSync> createState() =>
      _ChatPanelOpenIntentSyncState();
}

final class _ChatPanelOpenIntentSyncState
    extends State<ChatPanelOpenIntentSync> {
  @override
  void initState() {
    super.initState();
    _applyIntent();
  }

  @override
  void didUpdateWidget(ChatPanelOpenIntentSync oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.intentToken != widget.intentToken ||
        oldWidget.initialConversationId != widget.initialConversationId ||
        oldWidget.initialSelection != widget.initialSelection) {
      _applyIntent();
    }
  }

  void _applyIntent() {
    final selection = context.read<ChatPanelSelectionCubit>();
    final initial = widget.initialSelection;
    if (initial != null) {
      selection.select(
        initial.conversation,
        role: initial.role,
        targetMessageId: initial.targetMessageId,
      );
      context.read<ChatPanelSectionCubit>().showConversation();
      return;
    }
    final id = widget.initialConversationId;
    if (id == null) return;
    if (selection.state?.conversation.id == id) {
      context.read<ChatPanelSectionCubit>().showConversation();
      return;
    }
    selection.requestConversation(id);
    final inbox = context.read<ChatInboxCubit?>();
    if (inbox != null) _restore(inbox.state);
  }

  void _restore(ChatInboxState state) {
    if (state is! ChatInboxReady) return;
    final selection = context.read<ChatPanelSelectionCubit>();
    final before = selection.state;
    selection.restoreFrom(
      state.items.map((item) => item.conversation).toList(),
      roles: {
        for (final item in state.items)
          if (item.role != null) item.conversation.id: item.role!,
      },
    );
    if (before == null && selection.state != null) {
      context.read<ChatPanelSectionCubit>().showConversation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inbox = context.read<ChatInboxCubit?>();
    return inbox == null
        ? widget.child
        : BlocListener<ChatInboxCubit, ChatInboxState>(
            bloc: inbox,
            listener: (_, state) => _restore(state),
            child: widget.child,
          );
  }
}
