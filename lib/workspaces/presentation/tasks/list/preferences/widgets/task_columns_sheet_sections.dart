import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/components/task_column_header_preview_strip.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kompaktowy komunikat o błędzie automatycznego zapisu preferencji.
///
/// Arkusz jest modalny, więc trwały banner nad treścią zostaje pod jego
/// nakładką — komunikat o nieudanym zapisie musi być widoczny także tutaj.
class SheetSaveError extends StatelessWidget {
  const SheetSaveError({required this.state, required this.onRetry, super.key});

  final TaskListPreferencesReady state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final failure = state.saveFailure;
    if (failure == null) return const SizedBox.shrink();
    final colors = context.colors;
    final message =
        tasksViewErrorText(context.l10n, failure.code) ?? failure.code;
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 8),
      margin: const .only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.error.withValues(alpha: .5)),
      ),
      child: Row(
        children: [
          Icon(Symbols.warning_rounded, size: 16, color: colors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: context.text.bodySmall?.copyWith(
                color: colors.error,
                fontSize: 11.5,
              ),
            ),
          ),
          if (failure.canRetry)
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.tasksViewErrorRetry),
            ),
        ],
      ),
    );
  }
}

/// Informuje administratora, że edytuje politykę domyślną projektu.
class ProjectPolicyBanner extends StatelessWidget {
  const ProjectPolicyBanner({required this.isLoading, super.key});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: .25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.primary.withValues(alpha: .3),
          width: .8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.admin_panel_settings_rounded,
            size: 18,
            color: colors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Konfigurujesz bazowy układ kolumn dla każdego członka tego projektu.',
              style: context.text.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isLoading) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
    );
  }
}

/// Podgląd kolejności widocznych kolumn z operacjami drag-and-drop.
class ColumnsSheetPreview extends StatelessWidget {
  const ColumnsSheetPreview({
    required this.visible,
    required this.state,
    required this.cubit,
    required this.customFields,
    required this.isProjectTab,
    super.key,
  });

  final List<TaskColumnReference> visible;
  final TaskListPreferencesReady state;
  final TaskListPreferencesCubit cubit;
  final List<TaskCustomFieldResponse> customFields;
  final bool isProjectTab;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    children: [
      Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Kolejność w nagłówku tabeli (${visible.length})',
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            'Przeciągaj w lewo/prawo',
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontSize: context.tasksTheme.metaText.fontSize,
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      TaskColumnHeaderPreviewStrip(
        columns: visible,
        state: state,
        cubit: cubit,
        customFields: customFields,
        onReorder: isProjectTab
            ? cubit.reorderProjectDefaultColumns
            : cubit.reorderColumns,
        onRemove: isProjectTab
            ? cubit.toggleProjectDefaultColumn
            : cubit.toggleColumn,
      ),
    ],
  );
}

/// Dolny pasek operacji arkusza.
class ColumnsSheetActions extends StatelessWidget {
  const ColumnsSheetActions({
    required this.isProjectTab,
    required this.isSavingProjectPolicy,
    required this.onReset,
    required this.onDone,
    required this.onSaveProjectPolicy,
    super.key,
  });

  final bool isProjectTab;
  final bool isSavingProjectPolicy;
  final Future<void> Function() onReset;
  final VoidCallback onDone;
  final Future<void> Function() onSaveProjectPolicy;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      TextButton.icon(
        icon: const Icon(Symbols.restore_rounded, size: 16),
        label: Text(context.l10n.tasksListColumnsResetButton),
        onPressed: onReset,
      ),
      const Spacer(),
      if (!isProjectTab)
        FilledButton(
          onPressed: onDone,
          child: Text(context.l10n.tasksListColumnsDoneButton),
        )
      else
        FilledButton.icon(
          icon: isSavingProjectPolicy
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.tasksTheme.onAccent,
                  ),
                )
              : const Icon(Symbols.save_rounded, size: 16),
          label: Text(context.l10n.tasksListSaveProjectDefaults),
          onPressed: isSavingProjectPolicy ? null : onSaveProjectPolicy,
        ),
    ],
  );
}
