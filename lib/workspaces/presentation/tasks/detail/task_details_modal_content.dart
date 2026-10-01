import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_conversation_slot.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_layout.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_visited_tab_stack.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_header.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_modal_sections.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:flutter/foundation.dart' show ValueListenable;

class TaskDetailsOverlay extends StatelessWidget {
  const TaskDetailsOverlay({
    this.onClose,
    this.conversationSlot,
    this.tabIntent,
    this.onTabSelected,
    super.key,
  });

  final VoidCallback? onClose;
  final Widget? conversationSlot;
  final ValueListenable<TaskDetailsModalTab?>? tabIntent;
  final ValueChanged<TaskDetailsModalTab>? onTabSelected;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) => switch (state) {
          TaskDetailsInitial() || TaskDetailsLoading() => TaskDetailsModalShell(
            header: TaskDetailsPendingHeader(onClose: onClose),
            tabs: const SizedBox.shrink(),
            mainContent: const TaskDetailsModalLoadingView(),
            propertyRail: const SizedBox.shrink(),
          ),
          TaskDetailsFailure() => TaskDetailsModalShell(
            header: TaskDetailsPendingHeader(onClose: onClose),
            tabs: const SizedBox.shrink(),
            mainContent: TaskDetailsFailureView(failure: state),
            propertyRail: const SizedBox.shrink(),
          ),
          TaskDetailsReady() => TaskDetailsContent(
            state: state,
            onClose: onClose,
            conversationSlot: conversationSlot,
            tabIntent: tabIntent,
            onTabSelected: onTabSelected,
          ),
        },
      );
}

class TaskDetailsContent extends StatefulWidget {
  const TaskDetailsContent({
    required this.state,
    this.onClose,
    this.conversationSlot,
    this.tabIntent,
    this.onTabSelected,
    super.key,
  });

  final TaskDetailsReady state;
  final VoidCallback? onClose;
  final Widget? conversationSlot;
  final ValueListenable<TaskDetailsModalTab?>? tabIntent;
  final ValueChanged<TaskDetailsModalTab>? onTabSelected;

  @override
  State<TaskDetailsContent> createState() => TaskDetailsContentState();
}

class TaskDetailsContentState extends State<TaskDetailsContent> {
  late TaskDetailsModalTab _selectedTab =
      widget.tabIntent?.value ?? TaskDetailsModalTab.work;
  bool _splitConversationRequested = false;

  @override
  void initState() {
    super.initState();
    widget.tabIntent?.addListener(_onTabIntent);
  }

  @override
  void didUpdateWidget(covariant TaskDetailsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.tabIntent, widget.tabIntent)) return;
    oldWidget.tabIntent?.removeListener(_onTabIntent);
    widget.tabIntent?.addListener(_onTabIntent);
    _applyTabIntent();
  }

  @override
  void dispose() {
    widget.tabIntent?.removeListener(_onTabIntent);
    super.dispose();
  }

  void _onTabIntent() => _applyTabIntent();

  void _applyTabIntent() {
    final requested = widget.tabIntent?.value;
    if (!mounted || requested == null || requested == _selectedTab) return;
    setState(() {
      _selectedTab = requested;
      if (requested == TaskDetailsModalTab.conversation) {
        _splitConversationRequested = false;
      }
    });
  }

  void _selectTab(TaskDetailsModalTab tab) {
    setState(() {
      _selectedTab = tab;
      if (tab == TaskDetailsModalTab.conversation) {
        _splitConversationRequested = false;
      }
    });
    widget.onTabSelected?.call(tab);
  }

  void _toggleConversationSplit() {
    final enableSplit = !_splitConversationRequested;
    final tabChanged =
        enableSplit && _selectedTab == TaskDetailsModalTab.conversation;
    setState(() {
      _splitConversationRequested = enableSplit;
      if (tabChanged) _selectedTab = TaskDetailsModalTab.work;
    });
    if (tabChanged) widget.onTabSelected?.call(TaskDetailsModalTab.work);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final details = state.details;
    final conflictBase = state.conflictBase;
    final failure = state.mutationFailure;
    final conflictFields =
        failure?.type == ApiErrorType.conflict && conflictBase != null
        ? <TaskDetailsModalConflictField>[
            TaskDetailsModalConflictField(
              label: context.l10n.taskDetailsTitleField,
              baseline: conflictBase.task.title,
              current: details.task.title,
            ),
            TaskDetailsModalConflictField(
              label: context.l10n.taskDetailsStatusField,
              baseline: TaskDetailsLabeler.status(
                context,
                conflictBase.task.status,
              ),
              current: TaskDetailsLabeler.status(context, details.task.status),
            ),
            TaskDetailsModalConflictField(
              label: context.l10n.taskDetailsPriorityField,
              baseline: TaskDetailsLabeler.priority(
                context,
                conflictBase.task.priority,
              ),
              current: TaskDetailsLabeler.priority(
                context,
                details.task.priority,
              ),
            ),
          ]
        : const <TaskDetailsModalConflictField>[];
    final splitAvailable = TaskDetailsWorkspaceLayout.supportsSplit(
      viewportWidth: MediaQuery.sizeOf(context).width,
      textScale: MediaQuery.textScalerOf(context).scale(14) / 14,
    );
    return TaskDetailsModalShell(
      header: DetailHeader(
        details: details,
        isSaving: state.isSaving,
        canEdit: state.canEdit,
        canToggleArchive: state.canToggleArchive,
        onClose: widget.onClose,
      ),
      tabs: TaskDetailsModalTabs(
        selected: _selectedTab,
        onSelected: _selectTab,
        splitConversationSelected: _splitConversationRequested,
        splitConversationAvailable:
            splitAvailable && widget.conversationSlot != null,
        onSplitConversationChanged: _toggleConversationSplit,
      ),
      mainContent: TaskDetailsWorkspaceLayout(
        selectedTab: _selectedTab,
        splitConversationRequested: _splitConversationRequested,
        centerContent: TaskDetailsVisitedTabStack(
          selected: _selectedTab,
          children: {
            for (final tab in TaskDetailsModalTab.values)
              tab: TaskDetailsSelectedTabContent(
                selected: tab,
                details: details,
                isSaving: state.isSaving,
                canEdit: state.canEdit,
              ),
          },
        ),
        conversationContent:
            widget.conversationSlot ?? const TaskDetailsConversationSlot(),
      ),
      propertyRail: TaskDetailsPropertyRail(
        details: details,
        isSaving: state.isSaving,
        canEdit: state.canEdit,
      ),
      statusBanner: failure == null
          ? null
          : TaskDetailsModalError(
              error: failure,
              conflictFields: conflictFields,
            ),
    );
  }
}

class TaskDetailsSelectedTabContent extends StatelessWidget {
  const TaskDetailsSelectedTabContent({
    required this.selected,
    required this.details,
    required this.isSaving,
    required this.canEdit,
    super.key,
  });

  final TaskDetailsModalTab selected;
  final ProjectTaskDetailsResponse details;
  final bool isSaving;
  final bool canEdit;

  @override
  Widget build(BuildContext context) => switch (selected) {
    TaskDetailsModalTab.work => TaskDetailsWorkTab(
      details: details,
      isSaving: isSaving,
      canEdit: canEdit,
    ),
    TaskDetailsModalTab.conversation => const SizedBox.shrink(),
    TaskDetailsModalTab.files => TaskDetailsFilesTab(
      taskId: details.task.id,
      isEditable: canEdit,
    ),
    TaskDetailsModalTab.planAndTime => TaskDetailsPlanTab(
      task: details.task,
      isEditable: canEdit,
    ),
    TaskDetailsModalTab.history => const TaskDetailsHistoryTab(),
  };
}
