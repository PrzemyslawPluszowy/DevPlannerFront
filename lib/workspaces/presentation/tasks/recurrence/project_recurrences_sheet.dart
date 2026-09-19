import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_action_pill.dart';
import 'package:devplanner/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_empty_view.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_header.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_rule_card.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_run_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nowoczesny arkusz / widok zarządzania zadaniami cyklicznymi w projekcie.
class ProjectRecurrencesSheet extends StatefulWidget {
  /// Tworzy widok dla wskazanego projektu.
  const ProjectRecurrencesSheet({
    super.key,
    required this.workspaceId,
    required this.projectId,
  });

  final String workspaceId;
  final String projectId;

  @override
  State<ProjectRecurrencesSheet> createState() =>
      _ProjectRecurrencesSheetState();
}

class _ProjectRecurrencesSheetState extends State<ProjectRecurrencesSheet> {
  final _selectedTab = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.surface,
    child: BlocConsumer<ProjectRecurrencesCubit, ProjectRecurrencesState>(
      listener: (context, state) {
        if (state is ProjectRecurrencesError) {
          AppBubbleToast.show(
            context,
            message: state.message,
            tone: AppBubbleToastTone.error,
          );
        } else if (state is ProjectRecurrencesLoaded &&
            state.feedback != null) {
          switch (state.feedback!) {
            case ProjectRecurrenceFeedbackSuccess(:final message):
              AppBubbleToast.show(
                context,
                message: message,
                tone: AppBubbleToastTone.success,
              );
            case ProjectRecurrenceFeedbackError(:final message):
              AppBubbleToast.show(
                context,
                message: message,
                tone: AppBubbleToastTone.error,
              );
          }
        }
      },
      builder: (context, state) => Column(
        crossAxisAlignment: .stretch,
        children: [
          const ProjectRecurrencesHeader(),
          ValueListenableBuilder<int>(
            valueListenable: _selectedTab,
            builder: (context, selectedTab, _) => _buildSubNav(
              context,
              state,
              selectedTab,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: switch (state) {
              ProjectRecurrencesInitial() ||
              ProjectRecurrencesLoading(previousRules: null) ||
              ProjectRecurrencesLoading(
                previousRuns: null,
              ) => const Center(child: CircularProgressIndicator()),
              ProjectRecurrencesError(:final message) => Center(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      unawaited(context.read<ProjectRecurrencesCubit>().load()),
                  icon: const Icon(Symbols.refresh_rounded),
                  label: Text(message),
                ),
              ),
              ProjectRecurrencesLoaded(
                :final rules,
                :final runs,
                :final isActionInProgress,
              ) =>
                ValueListenableBuilder<int>(
                  valueListenable: _selectedTab,
                  builder: (context, selectedTab, _) => _buildTabContent(
                    context,
                    selectedTab,
                    rules,
                    runs,
                    isActionInProgress,
                  ),
                ),
              ProjectRecurrencesLoading(
                :final previousRules?,
                :final previousRuns?,
              ) =>
                ValueListenableBuilder<int>(
                  valueListenable: _selectedTab,
                  builder: (context, selectedTab, _) => _buildTabContent(
                    context,
                    selectedTab,
                    previousRules,
                    previousRuns,
                    true,
                  ),
                ),
            },
          ),
        ],
      ),
    ),
  );

  Widget _buildSubNav(
    BuildContext context,
    ProjectRecurrencesState state,
    int selectedTab,
  ) {
    final rulesCount = switch (state) {
      ProjectRecurrencesLoaded(:final rules) => rules.length,
      ProjectRecurrencesLoading(:final previousRules?) => previousRules.length,
      _ => 0,
    };
    final runsCount = switch (state) {
      ProjectRecurrencesLoaded(:final runs) => runs.length,
      ProjectRecurrencesLoading(:final previousRuns?) => previousRuns.length,
      _ => 0,
    };

    return Padding(
      padding: const .symmetric(
        horizontal: Sizes.p20,
        vertical: Sizes.p6,
      ),
      child: Row(
        children: [
          AppActionPill(
            label: '${context.l10n.tasksRecurrenceTabSchedule} ($rulesCount)',
            icon: Symbols.schedule_rounded,
            selected: selectedTab == 0,
            onPressed: () => _selectedTab.value = 0,
          ),
          Gaps.w8,
          AppActionPill(
            label: '${context.l10n.tasksRecurrenceTabRuns} ($runsCount)',
            icon: Symbols.history_rounded,
            selected: selectedTab == 1,
            onPressed: () => _selectedTab.value = 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    int selectedTab,
    List<ProjectTaskRecurrenceItemResponse> rules,
    List<ProjectTaskRecurrenceRunResponse> runs,
    bool isActionInProgress,
  ) {
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
          _buildTableHeader(
            context,
            columns: [
              (label: 'STATUS', flex: null, width: 100.0, align: null),
              (label: 'ZADANIE ŹRÓDŁOWE', flex: 4, width: null, align: null),
              (label: 'HARMONOGRAM', flex: 2, width: null, align: null),
              (label: 'NASTĘPNE WYKONANIE', flex: 3, width: null, align: null),
              (label: 'AKCJE', flex: null, width: 172.0, align: TextAlign.end),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rules.length,
              itemBuilder: (context, index) => ProjectRecurrencesRuleCard(
                rule: rules[index],
                isActionInProgress: isActionInProgress,
                workspaceId: widget.workspaceId,
                projectId: widget.projectId,
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
          _buildTableHeader(
            context,
            columns: [
              (label: 'WYNIK', flex: null, width: 110.0, align: null),
              (label: 'ZADANIE ŹRÓDŁOWE', flex: 3, width: null, align: null),
              (label: 'UTWORZONE ZADANIE', flex: 3, width: null, align: null),
              (label: 'DATA URUCHOMIENIA', flex: 2, width: null, align: null),
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

  Widget _buildTableHeader(
    BuildContext context, {
    required List<({String label, int? flex, double? width, TextAlign? align})>
    columns,
  }) => Container(
    height: 34,
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHighest.withValues(alpha: .3),
      border: Border(
        bottom: BorderSide(
          color: context.colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
    ),
    padding: const .symmetric(horizontal: Sizes.p16),
    child: Row(
      children: [
        for (final col in columns)
          if (col.width != null)
            SizedBox(
              width: col.width,
              child: Text(
                col.label,
                textAlign: col.align ?? TextAlign.start,
                style: context.text.labelSmall?.copyWith(
                  fontWeight: .w800,
                  letterSpacing: .3,
                  fontSize: context.tasksTheme.controlText.fontSize,
                  color: context.colors.onSurfaceVariant.withValues(alpha: .7),
                ),
              ),
            )
          else
            Expanded(
              flex: col.flex ?? 1,
              child: Text(
                col.label,
                textAlign: col.align ?? TextAlign.start,
                style: context.text.labelSmall?.copyWith(
                  fontWeight: .w800,
                  letterSpacing: .3,
                  fontSize: context.tasksTheme.controlText.fontSize,
                  color: context.colors.onSurfaceVariant.withValues(alpha: .7),
                ),
              ),
            ),
      ],
    ),
  );
}
