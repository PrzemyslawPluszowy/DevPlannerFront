import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Modal tworzenia lub edycji kamienia milowego projektu.
class ProjectMilestoneEditorDialog extends StatefulWidget {
  const ProjectMilestoneEditorDialog({
    this.initialMilestone,
    super.key,
  });

  /// Kamień milowy do edycji lub null przy tworzeniu nowego.
  final MilestoneResponse? initialMilestone;

  @override
  State<ProjectMilestoneEditorDialog> createState() =>
      _ProjectMilestoneEditorDialogState();
}

class _ProjectMilestoneEditorDialogState
    extends State<ProjectMilestoneEditorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final ValueNotifier<DateTime?> _dueDate;
  late final ValueNotifier<MilestoneStatus> _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialMilestone?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialMilestone?.description ?? '',
    );
    _dueDate = ValueNotifier(widget.initialMilestone?.dueAtUtc);
    _status = ValueNotifier(
      widget.initialMilestone?.status ?? MilestoneStatus.active,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dueDate.dispose();
    _status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isEditing = widget.initialMilestone != null;

    return ValueListenableBuilder<DateTime?>(
      valueListenable: _dueDate,
      builder: (context, dueDate, _) => ValueListenableBuilder<MilestoneStatus>(
        valueListenable: _status,
        builder: (context, status, _) => WorkspaceCreationModalWrapper(
          title: isEditing
              ? 'Edytuj kamień milowy'
              : l10n.projectSettingsAddMilestone,
          subtitle: 'Skonfiguruj nazwę, opis, termin docelowy oraz status kamienia milowego.',
          icon: Icons.flag_rounded,
          submitLabel: l10n.tasksListSaveButton,
          cancelLabel: l10n.tasksListCancelButton,
          maxWidth: 460,
          onSubmit: _handleSubmit,
          body: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                l10n.projectSettingsMilestoneName,
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
                  hintText: 'np. MVP v1.0, Wdrożenie produkcyjne...',
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
                'Opis',
                style: context.text.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h6,
              TextField(
                controller: _descriptionController,
                maxLines: 2,
                style: context.text.bodySmall?.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Opcjonalny opis etapu...',
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
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              Gaps.h16,
              Text(
                l10n.projectSettingsMilestoneDueDate,
                style: context.text.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h6,
              InkWell(
                onTap: _pickDueDate,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colors.surfaceContainerLowest,
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 15,
                        color: colors.onSurfaceVariant,
                      ),
                      Gaps.w8,
                      Expanded(
                        child: Text(
                          dueDate != null
                              ? DateFormat('dd.MM.yyyy').format(dueDate)
                              : 'Wybierz termin (opcjonalnie)',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: dueDate != null
                                ? colors.onSurface
                                : colors.onSurfaceVariant.withValues(alpha: .7),
                          ),
                        ),
                      ),
                      if (dueDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 14),
                          onPressed: () => _dueDate.value = null,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),
              Gaps.h16,
              Text(
                'Status etapu',
                style: context.text.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h6,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<MilestoneStatus>(
                    value: status,
                    isExpanded: true,
                    dropdownColor: colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                    elevation: 3,
                    menuMaxHeight: 260,
                    style: context.text.bodySmall?.copyWith(fontSize: 13),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: MilestoneStatus.active,
                        child: Text(
                          'Aktywny / W toku (Active)',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ),
                      DropdownMenuItem(
                        value: MilestoneStatus.completed,
                        child: Text(
                          'Zakończony (Completed)',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ),
                      DropdownMenuItem(
                        value: MilestoneStatus.cancelled,
                        child: Text(
                          'Anulowany (Cancelled)',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) _status.value = value;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await DevPlannerModalPickerHost.showDate(
      context,
      initialDate: _dueDate.value ?? now.add(const Duration(days: 14)),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
    );

    if (picked != null) {
      _dueDate.value = picked;
    }
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    Navigator.of(context).pop((
      name: name,
      description: _descriptionController.text.trim(),
      dueAtUtc: _dueDate.value,
      status: _status.value,
    ));
  }
}
