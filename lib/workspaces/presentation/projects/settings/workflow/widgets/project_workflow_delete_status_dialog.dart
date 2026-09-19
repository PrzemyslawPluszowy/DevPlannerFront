import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:flutter/material.dart';

/// Dialog wyboru statusu zastępczego przed usunięciem kolumny workflow.
///
/// Zwraca identyfikator wybranego statusu albo `null`, gdy użytkownik anuluje
/// operację. Wybór jest krótkotrwałym stanem widoku i nie trafia do Cubitu.
class ProjectWorkflowDeleteStatusDialog extends StatefulWidget {
  const ProjectWorkflowDeleteStatusDialog({
    required this.status,
    required this.fallbackCandidates,
    super.key,
  });

  final ProjectCustomStatusResponse status;
  final List<ProjectCustomStatusResponse> fallbackCandidates;

  @override
  State<ProjectWorkflowDeleteStatusDialog> createState() =>
      _ProjectWorkflowDeleteStatusDialogState();
}

class _ProjectWorkflowDeleteStatusDialogState
    extends State<ProjectWorkflowDeleteStatusDialog> {
  late final ValueNotifier<String> _fallbackId;

  @override
  void initState() {
    super.initState();
    _fallbackId = ValueNotifier(widget.fallbackCandidates.first.id);
  }

  @override
  void dispose() {
    _fallbackId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ValueListenableBuilder<String>(
      valueListenable: _fallbackId,
      builder: (context, fallbackId, _) => AlertDialog(
        title: Text(l10n.projectSettingsWorkflowDeleteStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Czy na pewno chcesz usunąć status "${widget.status.name}"? '
              'Zadania zostaną przeniesione do wybranego statusu zastępczego.',
            ),
            Gaps.h16,
            Text(
              'Status zastępczy:',
              style: context.text.labelMedium?.copyWith(fontWeight: .w700),
            ),
            Gaps.h6,
            DropdownButtonFormField<String>(
              initialValue: fallbackId,
              isExpanded: true,
              items: [
                for (final fallback in widget.fallbackCandidates)
                  DropdownMenuItem(
                    value: fallback.id,
                    child: Text(fallback.name),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _fallbackId.value = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.tasksListCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(fallbackId),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
            ),
            child: Text(l10n.projectSettingsWorkflowDeleteStatus),
          ),
        ],
      ),
    );
  }
}
