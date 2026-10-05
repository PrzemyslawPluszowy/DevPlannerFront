import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_action_pill.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProjectRecurrencesSubNav extends StatelessWidget {
  const ProjectRecurrencesSubNav({
    super.key,
    required this.state,
    required this.selectedTab,
    required this.onSelected,
  });
  final ProjectRecurrencesState state;
  final int selectedTab;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) {
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
            onPressed: () => onSelected(0),
          ),
          Gaps.w8,
          AppActionPill(
            label: '${context.l10n.tasksRecurrenceTabRuns} ($runsCount)',
            icon: Symbols.history_rounded,
            selected: selectedTab == 1,
            onPressed: () => onSelected(1),
          ),
        ],
      ),
    );
  }
}
