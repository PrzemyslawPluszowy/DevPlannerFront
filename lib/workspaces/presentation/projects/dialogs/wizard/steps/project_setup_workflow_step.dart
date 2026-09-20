import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
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
          trailing: choice == ProjectSetupWorkflowChoice.catalogTemplate
              ? _CatalogPicker(selectedKey: draft.workflowTemplateKey)
              : null,
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
        ),
        if (choice == ProjectSetupWorkflowChoice.explicitStatuses) ...[
          Gaps.h12,
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final key in ProjectSetupCatalog.workflowTemplateKeys)
          ChoiceChip(
            label: Text(ProjectSetupWizardL10n.workflowTemplateName(l10n, key)),
            selected: key == selectedKey,
            onSelected: (_) => cubit.setWorkflowTemplateKey(key),
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.status.name);
    _wipController = TextEditingController(
      text: widget.status.wipLimit?.toString() ?? '',
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
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.projectSetupStatusNameLabel,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => cubit.updateCustomStatus(
                    widget.index,
                    status.copyWith(name: value),
                  ),
                ),
              ),
              Gaps.w8,
              _StatusColorPicker(
                colorHex: status.colorHex,
                onChanged: (hex) => cubit.updateCustomStatus(
                  widget.index,
                  status.copyWith(colorHex: hex),
                ),
              ),
              Gaps.w8,
              Expanded(
                child: DropdownButtonFormField<TaskStatusCategory>(
                  initialValue: status.category,
                  decoration: InputDecoration(
                    labelText: l10n.projectSetupStatusCategoryLabel,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in TaskStatusCategory.values)
                      DropdownMenuItem(
                        value: category,
                        child: Text(
                          ProjectSetupWizardL10n.statusCategory(l10n, category),
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
                width: 96,
                child: TextField(
                  controller: _wipController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.projectSetupStatusWipLabel,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value.trim());
                    cubit.updateCustomStatus(
                      widget.index,
                      parsed == null
                          ? status.copyWith(clearWipLimit: true)
                          : status.copyWith(wipLimit: parsed),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: status.isDefault,
                onChanged: (value) => cubit.updateCustomStatus(
                  widget.index,
                  status.copyWith(isDefault: value ?? false),
                ),
              ),
              Text(
                l10n.projectSetupStatusDefaultLabel,
                style: context.text.labelSmall,
              ),
              const Spacer(),
              IconButton(
                tooltip: l10n.projectSetupStatusRemoveButton,
                onPressed: () => cubit.removeCustomStatus(widget.index),
                icon: const Icon(Symbols.delete, size: 18),
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
