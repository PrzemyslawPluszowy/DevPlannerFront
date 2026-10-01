import 'dart:math' as math;

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:flutter/material.dart';

/// Keeps the full task-scoped Chat panel mounted at one stable tree position.
/// The selected conversation tab expands that pane; the split layout places it
/// beside the current task work tab without creating a second Chat engine.
final class TaskDetailsWorkspaceLayout extends StatelessWidget {
  const TaskDetailsWorkspaceLayout({
    required this.selectedTab,
    required this.splitConversationRequested,
    required this.centerContent,
    required this.conversationContent,
    super.key,
  });

  final TaskDetailsModalTab selectedTab;
  final bool splitConversationRequested;
  final Widget centerContent;
  final Widget conversationContent;

  static bool supportsSplit({
    required double viewportWidth,
    required double textScale,
  }) => viewportWidth >= 1360 && textScale <= 1.5;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final splitAvailable =
          supportsSplit(
            viewportWidth: MediaQuery.sizeOf(context).width,
            textScale: MediaQuery.textScalerOf(context).scale(14) / 14,
          ) &&
          constraints.maxWidth >= 820 &&
          constraints.maxHeight >= 360;
      final isConversationTab = selectedTab == TaskDetailsModalTab.conversation;
      final splitVisible =
          splitConversationRequested && splitAvailable && !isConversationTab;
      final conversationVisible = splitVisible || isConversationTab;
      final conversationWidth = isConversationTab
          ? constraints.maxWidth
          : math.min(520.0, math.max(400.0, constraints.maxWidth * .45));

      return Row(
        children: [
          Expanded(
            child: Offstage(
              offstage: isConversationTab,
              child: TickerMode(
                enabled: !isConversationTab,
                child: centerContent,
              ),
            ),
          ),
          if (splitVisible)
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: context.tasksTheme.divider,
            ),
          SizedBox(
            key: const ValueKey<String>('task-detail-conversation-pane'),
            width: conversationVisible ? conversationWidth : 0,
            child: TaskDetailsConversationPaneVisibilityScope(
              isVisible: conversationVisible,
              child: Offstage(
                offstage: !conversationVisible,
                child: TickerMode(
                  enabled: conversationVisible,
                  child: conversationContent,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Communicates actual pane visibility to the task-scoped Chat lease owner.
final class TaskDetailsConversationPaneVisibilityScope extends InheritedWidget {
  const TaskDetailsConversationPaneVisibilityScope({
    required this.isVisible,
    required super.child,
    super.key,
  });

  final bool isVisible;

  static bool isVisibleOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<
            TaskDetailsConversationPaneVisibilityScope
          >()
          ?.isVisible ??
      true;

  @override
  bool updateShouldNotify(
    TaskDetailsConversationPaneVisibilityScope oldWidget,
  ) => isVisible != oldWidget.isVisible;
}
