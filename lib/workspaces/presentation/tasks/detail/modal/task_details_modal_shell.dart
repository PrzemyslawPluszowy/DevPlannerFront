import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:flutter/material.dart';

/// Centered desktop frame for task details. The root modal host owns the barrier.
final class TaskDetailsModalShell extends StatelessWidget {
  const TaskDetailsModalShell({
    required this.header,
    required this.tabs,
    required this.mainContent,
    required this.propertyRail,
    this.statusBanner,
    this.showPropertyRail = true,
    super.key,
  });

  final Widget header;
  final Widget tabs;
  final Widget mainContent;
  final Widget propertyRail;
  final Widget? statusBanner;
  final bool showPropertyRail;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final tasks = context.tasksTheme;
      final preferredWidth = constraints.maxWidth >= 1600 ? 1400.0 : 1240.0;
      final availableWidth = constraints.maxWidth > 40
          ? constraints.maxWidth - 40
          : 0.0;
      final availableHeight = constraints.maxHeight > 40
          ? constraints.maxHeight - 40
          : 0.0;
      final width = availableWidth < preferredWidth
          ? availableWidth
          : preferredWidth;
      final height = availableHeight < 840 ? availableHeight : 840.0;
      final showRail = showPropertyRail && width >= 980;

      return Center(
        child: SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tasks.canvas,
              borderRadius: BorderRadius.circular(tasks.panelRadius),
              border: Border.all(color: tasks.canvasBorder),
              boxShadow: [
                BoxShadow(
                  color: tasks.shadow.withValues(alpha: .16),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: TaskDetailsModalTheme(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(tasks.panelRadius),
                child: Material(
                  color: tasks.canvas,
                  child: Column(
                    children: [
                      header,
                      ?statusBanner,
                      tabs,
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: mainContent),
                            if (showRail) ...[
                              VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: tasks.divider,
                              ),
                              SizedBox(width: 324, child: propertyRail),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
