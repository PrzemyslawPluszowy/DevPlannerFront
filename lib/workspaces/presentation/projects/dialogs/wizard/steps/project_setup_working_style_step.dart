import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Krok 5 kreatora: harmonogram, domyślny widok, ustawienia listy i Kanbanu.
class ProjectSetupWorkingStyleStep extends StatelessWidget {
  /// Tworzy krok sposobu pracy.
  const ProjectSetupWorkingStyleStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final draft = state.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupSectionLabel(l10n.projectSetupDefaultViewLegend),
        Gaps.h6,
        SegmentedButton<ProjectSetupTaskViewKind>(
          segments: [
            ButtonSegment(
              value: ProjectSetupTaskViewKind.list,
              label: Text(l10n.projectSetupViewList),
            ),
            ButtonSegment(
              value: ProjectSetupTaskViewKind.board,
              label: Text(l10n.projectSetupViewBoard),
            ),
          ],
          selected: {draft.defaultView},
          showSelectedIcon: false,
          onSelectionChanged: (values) => cubit.setDefaultView(values.first),
        ),
        Gaps.h20,
        ProjectSetupSectionLabel(l10n.projectSetupScheduleLegend),
        Gaps.h6,
        RadioGroup<AutoScheduleMode>(
          groupValue: draft.scheduleMode,
          onChanged: (value) {
            if (value != null) cubit.setScheduleMode(value);
          },
          child: Column(
            children: [
              for (final mode in AutoScheduleMode.values)
                RadioListTile<AutoScheduleMode>(
                  value: mode,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    ProjectSetupWizardL10n.scheduleMode(l10n, mode),
                    style: context.text.bodySmall,
                  ),
                ),
            ],
          ),
        ),
        Gaps.h16,
        _CapacityField(state: state),
        Gaps.h20,
        ProjectSetupSectionLabel(l10n.projectSetupListLegend),
        Gaps.h8,
        _DropdownRow<TaskSavedViewSortField>(
          label: l10n.projectSetupListSortFieldLegend,
          value: draft.listSortField,
          values: TaskSavedViewSortField.values,
          labelOf: (value) => ProjectSetupWizardL10n.listSortField(l10n, value),
          onChanged: cubit.setListSortField,
        ),
        _DropdownRow<TaskSavedViewSortDirection>(
          label: l10n.projectSetupListSortDirectionLegend,
          value: draft.listSortDirection,
          values: TaskSavedViewSortDirection.values,
          labelOf: (value) =>
              ProjectSetupWizardL10n.listSortDirection(l10n, value),
          onChanged: cubit.setListSortDirection,
        ),
        _DropdownRow<TaskSavedViewGroupBy>(
          label: l10n.projectSetupListGroupByLegend,
          value: draft.listGroupBy,
          values: TaskSavedViewGroupBy.values,
          labelOf: (value) => ProjectSetupWizardL10n.listGroupBy(l10n, value),
          onChanged: cubit.setListGroupBy,
        ),
        Gaps.h20,
        ProjectSetupSectionLabel(l10n.projectSetupBoardLegend),
        Gaps.h8,
        _DropdownRow<KanbanCardDensity>(
          label: l10n.projectSetupBoardDensityLegend,
          value: draft.boardDensity,
          values: KanbanCardDensity.values,
          labelOf: (value) => ProjectSetupWizardL10n.cardDensity(l10n, value),
          onChanged: cubit.setBoardDensity,
        ),
        _DropdownRow<KanbanSwimlaneMode>(
          label: l10n.projectSetupBoardSwimlaneLegend,
          value: draft.boardSwimlaneMode,
          values: KanbanSwimlaneMode.values,
          labelOf: (value) => ProjectSetupWizardL10n.swimlaneMode(l10n, value),
          onChanged: cubit.setBoardSwimlaneMode,
        ),
        Gaps.h12,
        ProjectSetupSectionLabel(l10n.projectSetupBoardFieldsLegend),
        Gaps.h6,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final field in KanbanCardField.values)
              FilterChip(
                label: Text(ProjectSetupWizardL10n.cardField(l10n, field)),
                selected: draft.boardVisibleFields.contains(field),
                onSelected: (_) => cubit.toggleBoardField(field),
              ),
          ],
        ),
        ProjectSetupFieldError(
          error: state.fieldErrors[ProjectSetupField.boardFields],
        ),
      ],
    );
  }
}

/// Pojemność workspace jest widoczna tylko dla ról, które mogą ją zapisać.
class _CapacityField extends StatefulWidget {
  const _CapacityField({required this.state});

  final ProjectSetupWizardState state;

  @override
  State<_CapacityField> createState() => _CapacityFieldState();
}

class _CapacityFieldState extends State<_CapacityField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.state.draft.capacityMinutes?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<ProjectSetupWizardCubit>();
    if (!widget.state.canManageWorkspaceCapacity) {
      return ProjectSetupSectionLabel(
        l10n.projectSetupCapacityLegend,
        hint: l10n.projectSetupCapacityAdminOnly,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupSectionLabel(
          l10n.projectSetupCapacityLegend,
          hint: l10n.projectSetupCapacityDescription,
        ),
        Gaps.h6,
        SizedBox(
          width: 180,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.projectSetupCapacityFieldLabel,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              final parsed = int.tryParse(value.trim());
              cubit.setCapacityMinutes(parsed);
            },
          ),
        ),
        ProjectSetupFieldError(
          error: widget.state.fieldErrors[ProjectSetupField.capacity],
        ),
        Gaps.h4,
        Text(
          l10n.projectSetupCapacityDescription,
          style: context.text.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  const _DropdownRow({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Sizes.p8),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: context.text.bodySmall),
        ),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<T>(
            initialValue: value,
            // Wybrana wartość zajmuje dostępną szerokość i skraca się wielokropkiem:
            // bez tego najdłuższe etykiety (np. „Według własnego statusu”)
            // przepełniają wiersz w wąskim oknie.
            isExpanded: true,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
            items: [
              for (final item in values)
                DropdownMenuItem(
                  value: item,
                  child: Text(labelOf(item), overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (next) {
              if (next != null) onChanged(next);
            },
          ),
        ),
      ],
    ),
  );
}
