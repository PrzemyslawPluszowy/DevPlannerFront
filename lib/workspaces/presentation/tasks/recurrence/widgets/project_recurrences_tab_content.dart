import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_empty_view.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_rule_card.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_run_card.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_table_header.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProjectRecurrencesTabContent extends StatelessWidget {
  const ProjectRecurrencesTabContent({
    super.key,
    required this.selectedTab,
    required this.rules,
    required this.runs,
    required this.isActionInProgress,
    required this.workspaceId,
    required this.projectId,
  });
  final int selectedTab;
  final List<ProjectTaskRecurrenceItemResponse> rules;
  final List<ProjectTaskRecurrenceRunResponse> runs;
  final bool isActionInProgress;
  final String workspaceId;
  final String projectId;
  @override
  Widget build(BuildContext context) {
    if (selectedTab == 0) {
      if (rules.isEmpty) {
        return ProjectRecurrencesEmptyView(
          icon: Symbols.repeat_on,
          title: context.l10n.tasksRecurrenceEmptyTitle,
          description: context.l10n.tasksRecurrenceEmptyDescription,
        );
      }
      return Column(
        children: [
          ProjectRecurrencesTableHeader(
            columns: [
              (
                label: context.l10n.tasksRecurrenceColumnStatus,
                flex: null,
                width: 100.0,
                align: null,
              ),
              (
                label: context.l10n.tasksRecurrenceColumnSourceTask,
                flex: 4,
                width: null,
                align: null,
              ),
              (
                label: context.l10n.tasksRecurrenceColumnSchedule,
                flex: 2,
                width: null,
                align: null,
              ),
              (
                label: context.l10n.tasksRecurrenceColumnNextRun,
                flex: 3,
                width: null,
                align: null,
              ),
              (
                label: context.l10n.tasksRecurrenceColumnActions,
                flex: null,
                width: 172.0,
                align: TextAlign.end,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rules.length,
              itemBuilder: (context, index) => ProjectRecurrencesRuleCard(
                rule: rules[index],
                isActionInProgress: isActionInProgress,
                workspaceId: workspaceId,
                projectId: projectId,
              ),
            ),
          ),
        ],
      );
    } else {
      if (runs.isEmpty) {
        return ProjectRecurrencesEmptyView(
          icon: Symbols.history_rounded,
          title: context.l10n.tasksRecurrenceRunsEmptyTitle,
          description: context.l10n.tasksRecurrenceRunsEmptyDescription,
        );
      }
      return Column(
        children: [
          ProjectRecurrencesTableHeader(
            columns: [
              (
                label: context.l10n.tasksRecurrenceColumnOutcome,
                flex: null,
                width: 110.0,
                align: null,
              ),
              (
                label: context.l10n.tasksRecurrenceColumnSourceTask,
                flex: 3,
                width: null,
                align: null,
              ),
              (
                label: context.l10n.tasksRecurrenceColumnCreatedTask,
                flex: 3,
                width: null,
                align: null,
              ),
              (
                label: context.l10n.tasksRecurrenceColumnExecutedAt,
                flex: 2,
                width: null,
                align: null,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: runs.length,
              itemBuilder: (context, index) => ProjectRecurrencesRunCard(
                run: runs[index],
              ),
            ),
          ),
        ],
      );
    }
  }
}
