import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_status_category.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Modal tworzenia lub edycji własnego statusu / kolumny Kanban z kolorem, kategorią i limitem WIP.
class ProjectCustomStatusEditorDialog extends StatefulWidget {
  const ProjectCustomStatusEditorDialog({
    this.initialStatus,
    super.key,
  });

  /// Status do edycji lub null w przypadku tworzenia nowego statusu.
  final ProjectCustomStatusResponse? initialStatus;

  @override
  State<ProjectCustomStatusEditorDialog> createState() =>
      _ProjectCustomStatusEditorDialogState();
}

class _ProjectCustomStatusEditorDialogState
    extends State<ProjectCustomStatusEditorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _wipLimitController;
  late String _selectedColorHex;
  late TaskStatusCategory _selectedCategory;

  static const _statusColors = [
    '#64748B', // Slate
    '#3B82F6', // Blue
    '#06B6D4', // Cyan
    '#8B5CF6', // Purple
    '#F59E0B', // Amber
    '#EC4899', // Pink
    '#10B981', // Emerald
    '#EF4444', // Red
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialStatus?.name ?? '',
    );
    _wipLimitController = TextEditingController(
      text:
          widget.initialStatus?.wipLimit != null &&
              widget.initialStatus!.wipLimit! > 0
          ? widget.initialStatus!.wipLimit.toString()
          : '',
    );
    _selectedColorHex = widget.initialStatus?.colorHex ?? _statusColors.first;
    _selectedCategory =
        widget.initialStatus?.category ?? TaskStatusCategory.inProgress;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wipLimitController.dispose();
    super.dispose();
  }

  Color _parseHex(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isEditing = widget.initialStatus != null;

    return WorkspaceCreationModalWrapper(
      title: isEditing
          ? l10n.projectSettingsWorkflowEditStatus
          : l10n.projectSettingsWorkflowAddStatus,
      subtitle:
          'Skonfiguruj nazwę, kategorię etapu, limit WIP oraz kolor kolumny.',
      icon: Icons.view_column_rounded,
      accentColor: _parseHex(_selectedColorHex),
      submitLabel: l10n.tasksListSaveButton,
      cancelLabel: l10n.tasksListCancelButton,
      maxWidth: 460,
      onSubmit: _handleSubmit,
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.projectSettingsWorkflowStatusName,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          TextField(
            controller: _nameController,
            autofocus: true,
            style: context.text.bodySmall?.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'np. Code Review, W trakcie testów...',
              hintStyle: context.text.bodySmall?.copyWith(
                fontSize: 12.5,
                color: colors.onSurfaceVariant.withValues(alpha: .6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          Gaps.h16,
          Text(
            l10n.projectSettingsWorkflowStatusCategory,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TaskStatusCategory>(
                value: _selectedCategory,
                isExpanded: true,
                dropdownColor: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                elevation: 3,
                menuMaxHeight: 260,
                style: context.text.bodySmall?.copyWith(fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                items: const [
                  DropdownMenuItem(
                    value: TaskStatusCategory.todo,
                    child: Text(
                      'Do zrobienia (To Do)',
                      style: TextStyle(fontSize: 12.5),
                    ),
                  ),
                  DropdownMenuItem(
                    value: TaskStatusCategory.inProgress,
                    child: Text(
                      'W toku (In Progress)',
                      style: TextStyle(fontSize: 12.5),
                    ),
                  ),
                  DropdownMenuItem(
                    value: TaskStatusCategory.done,
                    child: Text(
                      'Zakończone (Done)',
                      style: TextStyle(fontSize: 12.5),
                    ),
                  ),
                  DropdownMenuItem(
                    value: TaskStatusCategory.cancelled,
                    child: Text(
                      'Anulowane (Cancelled)',
                      style: TextStyle(fontSize: 12.5),
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ),
          ),
          Gaps.h16,
          Text(
            l10n.projectSettingsWorkflowStatusColor,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          Wrap(
            spacing: 8,
            children: [
              for (final hex in _statusColors)
                InkWell(
                  onTap: () => setState(() => _selectedColorHex = hex),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: _parseHex(hex),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColorHex == hex
                            ? colors.onSurface
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: _selectedColorHex == hex
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
            ],
          ),
          Gaps.h16,
          Text(
            l10n.projectSettingsWorkflowWipLimit,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          TextField(
            controller: _wipLimitController,
            keyboardType: TextInputType.number,
            style: context.text.bodySmall?.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: l10n.projectSettingsWorkflowWipLimitHint,
              hintStyle: context.text.bodySmall?.copyWith(
                fontSize: 12.5,
                color: colors.onSurfaceVariant.withValues(alpha: .6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final wip = int.tryParse(_wipLimitController.text.trim());
    Navigator.of(context).pop((
      name: name,
      colorHex: _selectedColorHex,
      category: _selectedCategory,
      wipLimit: (wip != null && wip > 0) ? wip : null,
    ));
  }
}
