import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_atoms.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_models.dart';
import 'package:flutter/material.dart';

/// Podgląd listy zadań zbudowany z zadań szablonu.
///
/// Lista pokazuje tytuł, status, priorytet i etykiety, a gdy w szablonie jest
/// więcej zadań, niż mieści się w wycinku, mówi o tym liczbą „+N więcej”.
class TemplateListPreview extends StatelessWidget {
  /// Tworzy podgląd listy.
  const TemplateListPreview({
    required this.snapshot,
    super.key,
  });

  /// Klucz podglądu listy używany w testach.
  static const Key previewKey = ValueKey('project-preview-list');

  /// Dane podglądu.
  final ProjectPreviewSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final tasks = snapshot.tasks;
    if (tasks.isEmpty) return const SizedBox.shrink();
    // Kolor bierzemy po nazwie statusu z kolumn snapshotu: klucz normalizujemy,
    // bo różnica spacji albo wielkości liter nie może odebrać koloru wierszowi.
    final colorByStatus = <String, String?>{
      for (final column in snapshot.columns)
        projectPreviewStatusKey(column.name): column.colorHex,
    };
    return Container(
      key: previewKey,
      decoration: BoxDecoration(
        color: context.surfaceRoles.raisedBackground,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
        border: Border.all(color: context.surfaceRoles.raisedBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p12,
              Sizes.p10,
              Sizes.p12,
              Sizes.p6,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    l10n.projectSetupPreviewColumnTask,
                    style: _headerStyle(context),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.projectSetupPreviewColumnStatus,
                    style: _headerStyle(context),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.projectSetupPreviewColumnPriority,
                    style: _headerStyle(context),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.outlineVariant),
          for (final task in tasks)
            _ListRow(
              task: task,
              statusColor: projectPreviewColor(
                colorByStatus[projectPreviewStatusKey(task.statusName)],
                colors.primary,
              ),
            ),
          if (snapshot.hiddenTaskTotal > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p12,
                Sizes.p8,
                Sizes.p12,
                Sizes.p10,
              ),
              child: Text(
                l10n.projectSetupPreviewMoreTasks(snapshot.hiddenTaskTotal),
                style: context.text.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static TextStyle? _headerStyle(BuildContext context) =>
      context.text.labelSmall?.copyWith(
        color: context.colors.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      );
}

class _ListRow extends StatelessWidget {
  const _ListRow({required this.task, required this.statusColor});

  final ProjectPreviewTask task;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Sizes.p4),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                  ),
                ),
                Gaps.w6,
                Expanded(
                  child: Text(
                    task.title,
                    style: context.text.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: Sizes.p8),
              child: Text(
                task.statusName,
                style: context.text.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              task.priorityLabel ?? '—',
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
