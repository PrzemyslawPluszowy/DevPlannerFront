import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_thread_sheet.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_chat_theme_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_conversation_feedback.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Task-scoped resolver and full shared Chat surface for the detail modal.
final class TaskDetailResourceConversationSlot extends StatefulWidget {
  const TaskDetailResourceConversationSlot({
    required this.taskId,
    required this.workspaceId,
    required this.projectId,
    required this.composition,
    super.key,
  });

  final String taskId;
  final String workspaceId;
  final String projectId;
  final DevPlannerGlobalChatComposition? composition;

  @override
  State<TaskDetailResourceConversationSlot> createState() =>
      _TaskDetailResourceConversationSlotState();
}

final class _TaskDetailResourceConversationSlotState
    extends State<TaskDetailResourceConversationSlot> {
  late TaskDetailConversationCubit _cubit;
  bool _revoked = false;
  bool? _paneVisibility;
  bool _resolutionStarted = false;
  int _scopeGeneration = 0;

  bool get _paneVisible => _paneVisibility ?? true;

  @override
  void initState() {
    super.initState();
    _cubit = TaskDetailConversationCubit(
      _resourceRepository(widget.composition),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isVisible = TaskDetailsConversationPaneVisibilityScope.isVisibleOf(
      context,
    );
    if (isVisible == _paneVisibility) return;
    _paneVisibility = isVisible;
    if (isVisible) _resolveOnce();
  }

  @override
  void didUpdateWidget(covariant TaskDetailResourceConversationSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    final repositoryChanged = !identical(
      _resourceRepository(oldWidget.composition),
      _resourceRepository(widget.composition),
    );
    if (repositoryChanged) {
      final oldCubit = _cubit;
      _cubit = TaskDetailConversationCubit(
        _resourceRepository(widget.composition),
      );
      unawaited(oldCubit.close());
      _resolutionStarted = false;
    }
    if (oldWidget.taskId != widget.taskId ||
        oldWidget.workspaceId != widget.workspaceId ||
        oldWidget.projectId != widget.projectId ||
        !identical(oldWidget.composition, widget.composition) ||
        repositoryChanged) {
      _scopeGeneration++;
      _revoked = false;
      _resolutionStarted = false;
      if (_paneVisible) _resolveOnce();
    }
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  void _resolveOnce() {
    if (_resolutionStarted) return;
    _resolutionStarted = true;
    _cubit.resolve(
      taskId: widget.taskId,
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
    );
  }

  static ResourceChatRepository? _resourceRepository(
    DevPlannerGlobalChatComposition? composition,
  ) => switch (composition?.repository) {
    final ResourceChatRepository repository => repository,
    _ => null,
  };

  void _markRevoked(int generation) {
    if (!mounted || generation != _scopeGeneration || _revoked) return;
    setState(() => _revoked = true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child:
          BlocBuilder<TaskDetailConversationCubit, TaskDetailConversationState>(
            builder: (context, state) {
              final generation = _scopeGeneration;
              if (_revoked || state is TaskDetailConversationDenied) {
                return _ConversationNotice(
                  icon: Icons.lock_outline,
                  message: context.l10n.chatConversationAccessRevokedMessage,
                );
              }
              return switch (state) {
                TaskDetailConversationLoading() => const _ConversationLoading(),
                TaskDetailConversationFailure(:final error) =>
                  TaskDetailConversationFeedback(
                    error: error,
                    onRetry: _cubit.canRetry ? _cubit.retry : null,
                  ),
                TaskDetailConversationReady(:final conversation) =>
                  _TaskConversationPanel(
                    key: ValueKey<String>(
                      '${widget.workspaceId}/${widget.projectId}/'
                      '${widget.taskId}/${conversation.id}',
                    ),
                    conversation: conversation,
                    composition: widget.composition,
                    onAccessRevoked: () => _markRevoked(generation),
                  ),
                TaskDetailConversationDenied() => const SizedBox.shrink(),
              };
            },
          ),
    );
  }
}

final class _TaskConversationPanel extends StatelessWidget {
  const _TaskConversationPanel({
    required this.conversation,
    required this.composition,
    required this.onAccessRevoked,
    super.key,
  });

  final ChatConversation conversation;
  final DevPlannerGlobalChatComposition? composition;
  final VoidCallback onAccessRevoked;

  @override
  Widget build(BuildContext context) {
    final chat = composition;
    final repository = chat?.conversationRepository;
    return TaskDetailChatThemeScope(
      child: ChatPanelConversation(
        key: ChatPanelConversation.keyFor(conversation.id),
        conversationRepository: repository,
        conversation: conversation,
        onBack: onAccessRevoked,
        showBackButton: false,
        desktopWebComposer: true,
        createRealtime: chat?.realtimeFactory?.open,
        messageActions: chat?.messageActionsRepository,
        notificationSettings: chat?.notificationSettingsRepository,
        onResourceAccessRevoked: onAccessRevoked,
        onOpenThread: (threadContext, message) =>
            _openThread(threadContext, chat, message),
      ),
    );
  }

  void _openThread(
    BuildContext context,
    DevPlannerGlobalChatComposition? chat,
    ChatMessage message,
  ) {
    final threadRepository = context.read<ChatThreadRepository?>();
    final draftRepository = chat?.draftRepository;
    final deliveryRepository = chat?.conversationRepository;
    if (threadRepository == null ||
        draftRepository == null ||
        deliveryRepository == null) {
      return;
    }
    final lease = chat?.realtimeFactory?.open(conversation.id);
    final inbox = context.read<ChatInboxCubit?>()?.state;
    unawaited(
      ChatThreadSheet.showThread(
        context,
        repository: threadRepository,
        deliveryRepository: deliveryRepository,
        draftRepository: draftRepository,
        conversationId: conversation.id,
        rootMessage: message,
        conversationEvents: lease?.conversationEvents,
        messageActionsRepository: chat?.messageActionsRepository,
        forwardTargets: inbox is ChatInboxReady ? inbox.items : const [],
      ).whenComplete(() async => lease?.dispose()),
    );
  }
}

final class _ConversationLoading extends StatelessWidget {
  const _ConversationLoading();

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: LinearProgressIndicator(
        color: context.tasksTheme.selectionAccent,
      ),
    ),
  );
}

final class _ConversationNotice extends StatelessWidget {
  const _ConversationNotice({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: context.tasksTheme.divider),
          const SizedBox(height: Sizes.p8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
