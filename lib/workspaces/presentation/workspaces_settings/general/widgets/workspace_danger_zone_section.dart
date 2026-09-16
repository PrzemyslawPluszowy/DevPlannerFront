import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';

/// Sekcja Strefy Niebezpiecznej (Danger Zone) — archiwizacja i przywracanie przestrzeni roboczej.
class WorkspaceDangerZoneSection extends StatelessWidget {
  const WorkspaceDangerZoneSection({
    required this.workspace,
    required this.isArchiving,
    required this.onArchive,
    required this.onRestore,
    this.enabled = true,
    super.key,
  });

  /// Dane przestrzeni roboczej.
  final WorkspaceListItem workspace;

  /// Czy trwa proces archiwizacji / przywracania.
  final bool isArchiving;

  /// Callback archiwizacji.
  final VoidCallback onArchive;

  /// Callback przywrócenia.
  final VoidCallback onRestore;

  /// Czy akcje są dozwolone (wymaga roli Owner/Admin).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isArchived = workspace.isArchived;

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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      isArchived
                          ? l10n.workspaceSettingsRestoreWorkspace
                          : l10n.workspaceSettingsArchiveWorkspace,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: .w600,
                        color: colors.onSurface,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      isArchived
                          ? 'Przywróć pełną aktywność przestrzeni roboczej i powiązanych projektów.'
                          : l10n.workspaceSettingsArchiveConfirm,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.w16,
              OutlinedButton(
                onPressed: enabled && !isArchiving
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
                            ? l10n.workspaceSettingsRestoreWorkspace
                            : l10n.workspaceSettingsArchiveWorkspace,
                      ),
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
              ? l10n.workspaceSettingsRestoreWorkspace
              : l10n.workspaceSettingsArchiveWorkspace,
        ),
        content: Text(
          isArchived
              ? 'Czy na pewno chcesz przywrócić przestrzeń roboczą "${workspace.name}"?'
              : l10n.workspaceSettingsArchiveConfirm,
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
                  ? l10n.workspaceSettingsRestoreWorkspace
                  : l10n.workspaceSettingsArchiveWorkspace,
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
}
