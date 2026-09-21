import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_dropdown.dart';
import 'package:devplanner/shared/presentation/widgets/app_text_field.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_atoms.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_models.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_help_button.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Krok 4 kreatora: standardowy workflow, katalogowy szablon albo jawne statusy.
class ProjectSetupWorkflowStep extends StatelessWidget {
  /// Tworzy krok workflow.
  const ProjectSetupWorkflowStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final draft = state.draft;
    // Projekt z szablonu używa workflow zapisanego w szablonie — Backend
    // odrzuca każdy inny wybór, więc kreator pokazuje sam snapshot.
    if (draft.usesTemplate) {
      return ProjectSetupChoiceCard(
        title: l10n.projectSetupWorkflowFromTemplateTitle,
        description: l10n.projectSetupWorkflowFromTemplateDescription,
        icon: Symbols.auto_awesome_motion,
        selected: true,
        onSelected: () {},
      );
    }
    final choice = draft.workflowChoice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupChoiceCard(
          title: l10n.projectSetupWorkflowDefaultTitle,
          description: l10n.projectSetupWorkflowDefaultDescription,
          icon: Symbols.checklist,
          selected: choice == ProjectSetupWorkflowChoice.systemDefault,
          onSelected: () =>
              cubit.setWorkflowChoice(ProjectSetupWorkflowChoice.systemDefault),
          trailing: _WorkflowColumnsPreview(
            snapshot: _snapshotFor(
              context,
              draft,
              ProjectSetupWorkflowChoice.systemDefault,
            ),
            hint: l10n.projectSetupWorkflowSystemPreviewHint,
          ),
        ),
        Gaps.h8,
        ProjectSetupChoiceCard(
          title: l10n.projectSetupWorkflowCatalogTitle,
          description: l10n.projectSetupWorkflowCatalogDescription,
          icon: Symbols.category,
          selected: choice == ProjectSetupWorkflowChoice.catalogTemplate,
          onSelected: () => cubit.setWorkflowChoice(
            ProjectSetupWorkflowChoice.catalogTemplate,
          ),
          trailing: _WorkflowColumnsPreview(
            snapshot: _snapshotFor(
              context,
              draft,
              ProjectSetupWorkflowChoice.catalogTemplate,
            ),
            hint: l10n.projectSetupWorkflowCatalogPreviewHint,
            child: choice == ProjectSetupWorkflowChoice.catalogTemplate
                ? _CatalogPicker(selectedKey: draft.workflowTemplateKey)
                : null,
          ),
        ),
        Gaps.h8,
        ProjectSetupChoiceCard(
          title: l10n.projectSetupWorkflowExplicitTitle,
          description: l10n.projectSetupWorkflowExplicitDescription,
          icon: Symbols.edit_note,
          selected: choice == ProjectSetupWorkflowChoice.explicitStatuses,
          onSelected: () => cubit.setWorkflowChoice(
            ProjectSetupWorkflowChoice.explicitStatuses,
          ),
          trailing: _WorkflowColumnsPreview(
            snapshot: _snapshotFor(
              context,
              draft,
              ProjectSetupWorkflowChoice.explicitStatuses,
            ),
            hint: l10n.projectSetupWorkflowExplicitPreviewHint,
          ),
        ),
        if (choice == ProjectSetupWorkflowChoice.explicitStatuses) ...[
          Gaps.h16,
          ProjectSetupSectionLabel(
            l10n.projectSetupStatusesLegend,
            hint: l10n.projectSetupStatusesHint,
          ),
          Gaps.h8,
          Row(
            children: [
              Text(
                l10n.projectSetupStatusCategoryLabel,
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              ProjectSetupHelpButton(
                title: l10n.projectSetupHelpStatusCategoryTitle,
                body: l10n.projectSetupHelpStatusCategoryBody,
                size: 16,
              ),
              Gaps.w4,
              Text(
                l10n.projectSetupStatusWipLabel,
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              ProjectSetupHelpButton(
                title: l10n.projectSetupHelpWipTitle,
                body: l10n.projectSetupHelpWipBody,
                size: 16,
              ),
            ],
          ),
          Gaps.h8,
          _ExplicitStatusEditor(statuses: draft.customStatuses),
        ],
        ProjectSetupFieldError(
          error: state.fieldErrors[ProjectSetupField.customStatuses],
        ),
      ],
    );
  }
}

class _CatalogPicker extends StatelessWidget {
  const _CatalogPicker({required this.selectedKey});

  final String selectedKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.projectSetupWorkflowCatalogLegend,
              style: context.text.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            ProjectSetupHelpButton(
              title: l10n.projectSetupHelpCatalogWorkflowTitle,
              body: l10n.projectSetupHelpCatalogWorkflowBody,
              size: 16,
            ),
          ],
        ),
        Gaps.h4,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final key in ProjectSetupCatalog.workflowTemplateKeys)
              ChoiceChip(
                label: Text(
                  ProjectSetupWizardL10n.workflowTemplateName(l10n, key),
                ),
                selected: key == selectedKey,
                onSelected: (_) => cubit.setWorkflowTemplateKey(key),
              ),
          ],
        ),
      ],
    );
  }
}

class _ExplicitStatusEditor extends StatelessWidget {
  const _ExplicitStatusEditor({required this.statuses});

  final List<ProjectSetupCustomStatusDraft> statuses;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < statuses.length; index++)
          _StatusRow(
            key: ValueKey('project-setup-status-$index'),
            index: index,
            status: statuses[index],
          ),
        Gaps.h4,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed:
                statuses.length >= ProjectSetupCatalog.maxExplicitStatuses
                ? null
                : cubit.addCustomStatus,
            icon: const Icon(Symbols.add, size: 16),
            label: Text(l10n.projectSetupStatusAddButton),
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatefulWidget {
  const _StatusRow({required this.index, required this.status, super.key});

  final int index;
  final ProjectSetupCustomStatusDraft status;

  @override
  State<_StatusRow> createState() => _StatusRowState();
}

class _StatusRowState extends State<_StatusRow> {
  late final TextEditingController _nameController;
  late final TextEditingController _wipController;

  /// Wartości, które ten wiersz sam wysłał do draftu.
  ///
  /// Lista statusów nie ma stabilnych identyfikatorów, więc po usunięciu
  /// wiersza Flutter potrafi oddać stan jednego wiersza drugiemu statusowi.
  /// Porównanie „co przyszło z draftu” z „co sami wysłaliśmy” pozwala odróżnić
  /// taką podmianę od zwykłego pisania i przesynchronizować kontrolery.
  late String _emittedName;
  late String _emittedWip;

  @override
  void initState() {
    super.initState();
    _emittedName = widget.status.name;
    _emittedWip = widget.status.wipLimit?.toString() ?? '';
    _nameController = TextEditingController(text: widget.status.name);
    _wipController = TextEditingController(text: _emittedWip);
  }

  @override
  void didUpdateWidget(_StatusRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status.name != _emittedName) {
      _emittedName = widget.status.name;
      _nameController.text = widget.status.name;
    }
    final wip = widget.status.wipLimit?.toString() ?? '';
    if (wip != _emittedWip) {
      _emittedWip = wip;
      _wipController.text = wip;
    }
  }

  void _emitName(String value) {
    _emittedName = value;
    context.read<ProjectSetupWizardCubit>().updateCustomStatus(
      widget.index,
      widget.status.copyWith(name: value),
    );
  }

  void _emitWip(String value) {
    _emittedWip = value;
    final parsed = int.tryParse(value.trim());
    context.read<ProjectSetupWizardCubit>().updateCustomStatus(
      widget.index,
      parsed == null
          ? widget.status.copyWith(clearWipLimit: true)
          : widget.status.copyWith(wipLimit: parsed),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final status = widget.status;
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      padding: const EdgeInsets.all(Sizes.p10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: status.isDefault ? colors.primary : colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusColorPicker(
                colorHex: status.colorHex,
                onChanged: (hex) => cubit.updateCustomStatus(
                  widget.index,
                  status.copyWith(colorHex: hex),
                ),
              ),
              Gaps.w8,
              Expanded(
                child: AppTextField(
                  controller: _nameController,
                  labelText: l10n.projectSetupStatusNameLabel,
                  onChanged: _emitName,
                ),
              ),
              Gaps.w4,
              IconButton(
                tooltip: l10n.projectSetupStatusRemoveButton,
                visualDensity: VisualDensity.compact,
                onPressed: () => cubit.removeCustomStatus(widget.index),
                icon: const Icon(Symbols.delete, size: 18),
              ),
            ],
          ),
          Gaps.h8,
          Row(
            children: [
              Expanded(
                child: AppDropdown<TaskStatusCategory>(
                  value: status.category,
                  labelText: l10n.projectSetupStatusCategoryLabel,
                  options: [
                    for (final category in TaskStatusCategory.values)
                      AppDropdownOption(
                        value: category,
                        label: ProjectSetupWizardL10n.statusCategory(
                          l10n,
                          category,
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      cubit.updateCustomStatus(
                        widget.index,
                        status.copyWith(category: value),
                      );
                    }
                  },
                ),
              ),
              Gaps.w8,
              SizedBox(
                width: 116,
                child: AppTextField(
                  controller: _wipController,
                  labelText: l10n.projectSetupStatusWipLabel,
                  keyboardType: TextInputType.number,
                  onChanged: _emitWip,
                ),
              ),
            ],
          ),
          Gaps.h4,
          Row(
            children: [
              Checkbox(
                value: status.isDefault,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) => cubit.updateCustomStatus(
                  widget.index,
                  status.copyWith(isDefault: value ?? false),
                ),
              ),
              Gaps.w8,
              Expanded(
                child: Text(
                  l10n.projectSetupStatusDefaultLabel,
                  style: context.text.labelSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusColorPicker extends StatelessWidget {
  const _StatusColorPicker({required this.colorHex, required this.onChanged});

  final String colorHex;
  final ValueChanged<String> onChanged;

  static const List<String> _palette = [
    '#64748B',
    '#0284C7',
    '#8B5CF6',
    '#EC4899',
    '#D97706',
    '#16A34A',
    '#EF4444',
    '#94A3B8',
  ];

  @override
  Widget build(BuildContext context) {
    final selected = ProjectDialogColorHexCodec.toColor(colorHex);
    return PopupMenuButton<String>(
      tooltip: context.l10n.projectSetupStatusColorLabel,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final hex in _palette)
          PopupMenuItem(
            value: hex,
            child: Row(
              children: [
                _Swatch(color: ProjectDialogColorHexCodec.toColor(hex)),
                Gaps.w8,
                Text(hex),
              ],
            ),
          ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selected ?? context.colors.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: context.colors.outlineVariant),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    width: 16,
    height: 16,
    decoration: BoxDecoration(
      color: color ?? context.colors.surfaceContainerHighest,
      shape: BoxShape.circle,
    ),
  );
}

/// Kolumny, które powstają przy danym wyborze workflow.
///
/// Miniatura korzysta z tego samego źródła co panel podglądu, więc karta nie
/// obiecuje kolumn, których projekt nie dostanie.
ProjectPreviewSnapshot _snapshotFor(
  BuildContext context,
  ProjectSetupDraft draft,
  ProjectSetupWorkflowChoice choice,
) => buildProjectPreviewSnapshot(
  l10n: context.l10n,
  draft: draft.copyWith(workflowChoice: choice),
);

/// Miniatura kolumn widoczna na karcie wyboru workflow.
class _WorkflowColumnsPreview extends StatelessWidget {
  const _WorkflowColumnsPreview({
    required this.snapshot,
    required this.hint,
    this.child,
  });

  /// Liczba kolumn pokazywanych w miniaturze.
  static const int visibleColumns = 4;

  final ProjectPreviewSnapshot snapshot;
  final String hint;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final columns = snapshot.columns;
    final visible = columns.length <= visibleColumns
        ? columns
        : columns.sublist(0, visibleColumns);
    final hidden = columns.length - visible.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.projectSetupWorkflowOptionColumnsLegend,
          style: context.text.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gaps.h4,
        if (columns.isEmpty)
          // Układ katalogowy nie zdradza nazw kolumn przed wyborem, więc
          // miniatura pokazuje sam kształt tablicy, bez wymyślania nazw.
          Row(
            children: [
              for (var index = 0; index < 3; index++) ...[
                _ColumnShape(color: colors.outlineVariant),
                Gaps.w4,
              ],
            ],
          )
        else
          Row(
            children: [
              for (final column in visible) ...[
                _ColumnShape(
                  color: projectPreviewColor(column.colorHex, colors.primary),
                  name: column.name,
                ),
                Gaps.w4,
              ],
              if (hidden > 0)
                Text(
                  l10n.projectSetupPreviewMoreColumns(hidden),
                  style: context.text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        Gaps.h6,
        Text(
          hint,
          style: context.text.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        if (child case final value?) ...[Gaps.h8, value],
      ],
    );
  }
}

/// Kształt jednej kolumny tablicy w miniaturze.
class _ColumnShape extends StatelessWidget {
  const _ColumnShape({required this.color, this.name});

  final Color color;
  final String? name;

  @override
  Widget build(BuildContext context) => Container(
    width: 54,
    padding: const EdgeInsets.symmetric(
      horizontal: Sizes.p4,
      vertical: Sizes.p4,
    ),
    decoration: BoxDecoration(
      color: context.surfaceRoles.raisedBackground,
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.p6)),
      border: Border(top: BorderSide(color: color, width: 3)),
    ),
    child: Text(
      name ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.text.labelSmall,
    ),
  );
}
