import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_state.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/task_recurrence_context_editor.dart';

part 'widgets/project_recurrences_empty_view.part.dart';
part 'widgets/project_recurrences_header.part.dart';
part 'widgets/project_recurrences_rule_card.part.dart';
part 'widgets/project_recurrences_run_card.part.dart';

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
  int _selectedTab = 0; // 0 = harmonogram reguł, 1 = historia wykonań

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
          const _ProjectRecurrencesHeader(),
          _buildSubNav(context, state),
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
                _buildTabContent(context, rules, runs, isActionInProgress),
              ProjectRecurrencesLoading(
                :final previousRules?,
                :final previousRuns?,
              ) =>
                _buildTabContent(context, previousRules, previousRuns, true),
            },
          ),
        ],
      ),
    ),
  );

  Widget _buildSubNav(BuildContext context, ProjectRecurrencesState state) {
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
            selected: _selectedTab == 0,
            onPressed: () => setState(() => _selectedTab = 0),
          ),
          Gaps.w8,
          AppActionPill(
            label: '${context.l10n.tasksRecurrenceTabRuns} ($runsCount)',
            icon: Symbols.history_rounded,
            selected: _selectedTab == 1,
            onPressed: () => setState(() => _selectedTab = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    List<ProjectTaskRecurrenceItemResponse> rules,
    List<ProjectTaskRecurrenceRunResponse> runs,
    bool isActionInProgress,
  ) {
    if (_selectedTab == 0) {
      if (rules.isEmpty) {
        return _ProjectRecurrencesEmptyView(
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
              itemBuilder: (context, index) => _ProjectRecurrencesRuleCard(
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
        return _ProjectRecurrencesEmptyView(
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
              itemBuilder: (context, index) => _ProjectRecurrencesRunCard(
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
                  fontSize: 10,
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
                  fontSize: 10,
                  color: context.colors.onSurfaceVariant.withValues(alpha: .7),
                ),
              ),
            ),
      ],
    ),
  );
}

/// Rozszerzenia ułatwiające formatowanie opisów cykliczności w kontekście lokalizacji.
extension TaskRecurrenceDisplayX on BuildContext {
  /// Zwraca zlokalizowaną etykietę interwału powtarzania.
  String recurrenceIntervalLabel(
    TaskRecurrenceFrequency frequency,
    int interval,
  ) => switch (frequency) {
    TaskRecurrenceFrequency.daily =>
      interval == 1
          ? l10n.taskRecurrenceIntervalDaily
          : l10n.taskRecurrenceIntervalDays(interval),
    TaskRecurrenceFrequency.weekly =>
      interval == 1
          ? l10n.taskRecurrenceIntervalWeekly
          : l10n.taskRecurrenceIntervalWeeks(interval),
    TaskRecurrenceFrequency.monthly =>
      interval == 1
          ? l10n.taskRecurrenceIntervalMonthly
          : l10n.taskRecurrenceIntervalMonths(interval),
  };

  /// Zwraca zlokalizowaną etykietę trybu serii.
  String recurrenceModeLabel(TaskRecurrenceMode mode) => switch (mode) {
    TaskRecurrenceMode.scheduled => l10n.tasksRecurrenceModeScheduled,
    TaskRecurrenceMode.afterCompletion =>
      l10n.tasksRecurrenceModeAfterCompletion,
  };
}
