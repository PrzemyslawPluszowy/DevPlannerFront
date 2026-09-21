import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_dropdown.dart';
import 'package:devplanner/shared/presentation/widgets/app_text_field.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Krok 5 kreatora: harmonogram, domyślny widok, ustawienia listy i Kanbanu.
///
/// Ustawienia pokazywane są dla widoku, który użytkownik naprawdę wybrał jako
/// domyślny; drugi widok wchodzi jednym kliknięciem „Dostosuj także…”, a jego
/// wartości i tak trafiają do planu, więc krok mówi o tym wprost.
class ProjectSetupWorkingStyleStep extends StatefulWidget {
  /// Tworzy krok sposobu pracy.
  const ProjectSetupWorkingStyleStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  State<ProjectSetupWorkingStyleStep> createState() =>
      _ProjectSetupWorkingStyleStepState();
}

class _ProjectSetupWorkingStyleStepState
    extends State<ProjectSetupWorkingStyleStep> {
  bool _showOtherView = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final draft = widget.state.draft;
    final isListView = draft.defaultView == ProjectSetupTaskViewKind.list;
    // Błąd pola tablicy pokazuje jej ustawienia nawet wtedy, gdy domyślnym
    // widokiem jest lista: użytkownik musi zobaczyć, co blokuje „Dalej”.
    final boardFieldsError =
        widget.state.fieldErrors[ProjectSetupField.boardFields] != null;
    final showBoard = !isListView || _showOtherView || boardFieldsError;
    final showList = isListView || _showOtherView;
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
          onSelectionChanged: (values) {
            setState(() => _showOtherView = false);
            cubit.setDefaultView(values.first);
          },
        ),
        Gaps.h20,
        ProjectSetupSectionLabel(
          l10n.projectSetupScheduleLegend,
          helpTitle: l10n.projectSetupHelpCascadeTitle,
          helpBody: l10n.projectSetupHelpCascadeBody,
        ),
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
        _CapacityField(state: widget.state),
        if (showList) ...[
          Gaps.h20,
          _ListSettingsGroup(
            draft: draft,
            fieldErrors: widget.state.fieldErrors,
          ),
        ],
        if (showBoard) ...[
          Gaps.h20,
          _BoardSettingsGroup(
            draft: draft,
            fieldErrors: widget.state.fieldErrors,
          ),
        ],
        if (!_showOtherView && !boardFieldsError) ...[
          Gaps.h12,
          TextButton.icon(
            onPressed: () => setState(() => _showOtherView = true),
            icon: const Icon(Symbols.tune, size: 16),
            label: Text(
              isListView
                  ? l10n.projectSetupWorkingStyleAdjustBoard
                  : l10n.projectSetupWorkingStyleAdjustList,
            ),
          ),
          Gaps.h2,
          Text(
            l10n.projectSetupWorkingStyleHiddenDefaults,
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Ustawienia listy zadań.
class _ListSettingsGroup extends StatelessWidget {
  const _ListSettingsGroup({required this.draft, required this.fieldErrors});

  final ProjectSetupDraft draft;
  final Map<ProjectSetupField, ProjectSetupValidationError> fieldErrors;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

/// Ustawienia tablicy Kanban.
class _BoardSettingsGroup extends StatelessWidget {
  const _BoardSettingsGroup({required this.draft, required this.fieldErrors});

  final ProjectSetupDraft draft;
  final Map<ProjectSetupField, ProjectSetupValidationError> fieldErrors;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupSectionLabel(l10n.projectSetupBoardLegend),
        Gaps.h8,
        _DropdownRow<KanbanCardDensity>(
          label: l10n.projectSetupBoardDensityLegend,
          value: draft.boardDensity,
          values: KanbanCardDensity.values,
          labelOf: (value) => ProjectSetupWizardL10n.cardDensity(l10n, value),
          helpTitle: l10n.projectSetupHelpDensityTitle,
          helpBody: l10n.projectSetupHelpDensityBody,
          onChanged: cubit.setBoardDensity,
        ),
        _DropdownRow<KanbanSwimlaneMode>(
          label: l10n.projectSetupBoardSwimlaneLegend,
          value: draft.boardSwimlaneMode,
          values: KanbanSwimlaneMode.values,
          labelOf: (value) => ProjectSetupWizardL10n.swimlaneMode(l10n, value),
          helpTitle: l10n.projectSetupHelpSwimlanesTitle,
          helpBody: l10n.projectSetupHelpSwimlanesBody,
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
          error: fieldErrors[ProjectSetupField.boardFields],
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
    final cubit = context.read<ProjectSetupWizardCubit>();
    if (!widget.state.canManageWorkspaceCapacity) {
      return ProjectSetupSectionLabel(
        l10n.projectSetupCapacityLegend,
        hint: l10n.projectSetupCapacityAdminOnly,
        helpTitle: l10n.projectSetupHelpCapacityTitle,
        helpBody: l10n.projectSetupHelpCapacityBody,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupSectionLabel(
          l10n.projectSetupCapacityLegend,
          hint: l10n.projectSetupCapacityDescription,
          helpTitle: l10n.projectSetupHelpCapacityTitle,
          helpBody: l10n.projectSetupHelpCapacityBody,
        ),
        Gaps.h6,
        SizedBox(
          width: 200,
          child: AppTextField(
            controller: _controller,
            labelText: l10n.projectSetupCapacityFieldLabel,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final parsed = int.tryParse(value.trim());
              cubit.setCapacityMinutes(parsed);
            },
          ),
        ),
        ProjectSetupFieldError(
          error: widget.state.fieldErrors[ProjectSetupField.capacity],
        ),
      ],
    );
  }
}

/// Wiersz ustawienia: etykieta z opcjonalną pomocą i wspólny dropdown.
class _DropdownRow<T> extends StatelessWidget {
  const _DropdownRow({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    this.helpTitle,
    this.helpBody,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;
  final String? helpTitle;
  final String? helpBody;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Sizes.p12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupSectionLabel(
          label,
          helpTitle: helpTitle,
          helpBody: helpBody,
        ),
        Gaps.h6,
        AppDropdown<T>(
          value: value,
          options: [
            for (final item in values)
              AppDropdownOption(value: item, label: labelOf(item)),
          ],
          onChanged: (next) {
            if (next != null) onChanged(next);
          },
        ),
      ],
    ),
  );
}
