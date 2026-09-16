import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Modal tworzenia lub edycji etykiety zadania z paletą kolorów.
class ProjectLabelEditorDialog extends StatefulWidget {
  const ProjectLabelEditorDialog({
    this.initialLabel,
    super.key,
  });

  /// Etykieta do edycji lub null przy tworzeniu nowej.
  final TaskLabelResponse? initialLabel;

  @override
  State<ProjectLabelEditorDialog> createState() =>
      _ProjectLabelEditorDialogState();
}

class _ProjectLabelEditorDialogState extends State<ProjectLabelEditorDialog> {
  late final TextEditingController _nameController;
  late String _selectedColor;

  static const _labelColors = [
    '#EF4444', // Red
    '#F59E0B', // Amber
    '#10B981', // Emerald
    '#06B6D4', // Cyan
    '#3B82F6', // Blue
    '#6366F1', // Indigo
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#64748B', // Slate
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialLabel?.name ?? '',
    );
    _selectedColor = widget.initialLabel?.color ?? _labelColors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
    final isEditing = widget.initialLabel != null;

    return WorkspaceCreationModalWrapper(
      title: isEditing ? 'Edytuj etykietę' : l10n.projectSettingsAddLabel,
      subtitle: 'Skonfiguruj nazwę i kolor etykiety dla zadań projektu.',
      icon: Icons.label_rounded,
      accentColor: _parseHex(_selectedColor),
      submitLabel: l10n.tasksListSaveButton,
      cancelLabel: l10n.tasksListCancelButton,
      maxWidth: 420,
      onSubmit: _handleSubmit,
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.projectSettingsLabelName,
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
              hintText: 'np. Backend, Pilne, Frontend, UX...',
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
            l10n.projectSettingsLabelColor,
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
              for (final hex in _labelColors)
                InkWell(
                  onTap: () => setState(() => _selectedColor = hex),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: _parseHex(hex),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == hex
                            ? colors.onSurface
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: _selectedColor == hex
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
        ],
      ),
    );
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    Navigator.of(context).pop((
      name: name,
      color: _selectedColor,
    ));
  }
}
