import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:flutter/material.dart';

/// Sekcja Strefy Niebezpiecznej (Danger Zone) — archiwizacja, przywracanie i trwałe usuwanie projektu.
class ProjectDangerZoneSection extends StatelessWidget {
  const ProjectDangerZoneSection({
    required this.project,
    required this.isArchiving,
    required this.isDeleting,
    required this.onArchive,
    required this.onRestore,
    required this.onDelete,
    this.enabled = true,
    super.key,
  });

  /// Dane projektu.
  final ProjectListItem project;

  /// Czy trwa proces archiwizacji / przywracania.
  final bool isArchiving;

  /// Czy trwa proces usuwania.
  final bool isDeleting;

  /// Callback archiwizacji.
  final VoidCallback onArchive;

  /// Callback przywrócenia.
  final VoidCallback onRestore;

  /// Callback trwałego usunięcia.
  final VoidCallback onDelete;

  /// Czy akcje są dozwolone (wymaga roli Owner/Admin).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isArchived = project.isArchived;

    return Container(
      padding: const .all(Sizes.p16),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: .1),
        borderRadius: .circular(Sizes.p12),
        border: Border.all(
          color: colors.error.withValues(alpha: .3),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colors.error,
                size: Sizes.p20,
              ),
              Gaps.w8,
              Text(
                l10n.projectSettingsDangerZoneTitle,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: .w700,
                  color: colors.error,
                ),
              ),
            ],
          ),
          Gaps.h12,
          // 1. Archiwizacja / Przywrócenie
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      isArchived
                          ? l10n.projectSettingsRestoreProject
                          : l10n.projectSettingsArchiveProject,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: .w600,
                        color: colors.onSurface,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      isArchived
                          ? 'Przywróć pełną aktywność i widoczność projektu.'
                          : 'Ukryj projekt przed użytkownikami, zachowując całą historię.',
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.w16,
              OutlinedButton(
                onPressed: enabled && !isArchiving && !isDeleting
                    ? () => _confirmArchiveOrRestore(context, isArchived)
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isArchived ? colors.primary : colors.error,
                  side: BorderSide(
                    color: isArchived ? colors.primary : colors.error,
                  ),
                ),
                child: isArchiving
                    ? const SizedBox(
                        width: Sizes.p16,
                        height: Sizes.p16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isArchived
                            ? l10n.projectSettingsRestoreProject
                            : l10n.projectSettingsArchiveProject,
                      ),
              ),
            ],
          ),
          Divider(
            height: Sizes.p24,
            color: colors.error.withValues(alpha: .2),
          ),
          // 2. Trwałe usunięcie
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      l10n.projectSettingsDeleteProject,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: .w600,
                        color: colors.error,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      l10n.projectSettingsDeleteProjectConfirm,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.w16,
              FilledButton(
                onPressed: enabled && !isArchiving && !isDeleting
                    ? () => _confirmDelete(context)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.error,
                  foregroundColor: colors.onError,
                ),
                child: isDeleting
                    ? const SizedBox(
                        width: Sizes.p16,
                        height: Sizes.p16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.projectSettingsDeleteProject),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmArchiveOrRestore(
    BuildContext context,
    bool isArchived,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isArchived
              ? l10n.projectSettingsRestoreProject
              : l10n.projectSettingsArchiveProject,
        ),
        content: Text(
          isArchived
              ? 'Czy na pewno chcesz przywrócić projekt "${project.name}"?'
              : l10n.projectSettingsArchiveProjectConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.tasksListCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              isArchived
                  ? l10n.projectSettingsRestoreProject
                  : l10n.projectSettingsArchiveProject,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (isArchived) {
        onRestore();
      } else {
        onArchive();
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.projectSettingsDeleteProject),
        content: Text(l10n.projectSettingsDeleteProjectConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.tasksListCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: ctx.colors.error,
              foregroundColor: ctx.colors.onError,
            ),
            child: Text(l10n.projectSettingsDeleteProject),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete();
    }
  }
}
