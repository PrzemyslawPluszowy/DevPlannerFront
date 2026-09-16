part of '../task_recurrence_context_editor.dart';

/// Nowoczesna sekcja trybów i opcji cyklu z AppToggleSwitch.
class _TaskRecurrenceEditorOptionsSection extends StatelessWidget {
  const _TaskRecurrenceEditorOptionsSection({
    required this.mode,
    required this.occurrenceStatus,
    required this.skipIfPreviousOpen,
    required this.isSourceTask,
    required this.hasRecurrence,
    required this.isActive,
    required this.isSubmitting,
    required this.onModeChanged,
    required this.onOccurrenceStatusChanged,
    required this.onSkipIfPreviousOpenChanged,
    required this.onSave,
    required this.onTogglePause,
    required this.onDelete,
  });

  final TaskRecurrenceMode mode;
  final ProjectTaskStatus occurrenceStatus;
  final bool skipIfPreviousOpen;
  final bool isSourceTask;
  final bool hasRecurrence;
  final bool isActive;
  final bool isSubmitting;
  final ValueChanged<TaskRecurrenceMode> onModeChanged;
  final ValueChanged<ProjectTaskStatus> onOccurrenceStatusChanged;
  final ValueChanged<bool> onSkipIfPreviousOpenChanged;
  final VoidCallback onSave;
  final VoidCallback onTogglePause;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    children: [
      Text(
        context.l10n.taskRecurrenceModeLabel,
        style: context.text.labelSmall?.copyWith(
          fontWeight: .w700,
          color: context.colors.onSurfaceVariant,
        ),
      ),
      Gaps.h6,
      Row(
        children: [
          Expanded(
            child: AppActionPill(
              label: context.l10n.tasksRecurrenceModeScheduled,
              selected: mode == TaskRecurrenceMode.scheduled,
              onPressed: () => onModeChanged(TaskRecurrenceMode.scheduled),
            ),
          ),
          Gaps.w6,
          Expanded(
            child: AppActionPill(
              label: context.l10n.tasksRecurrenceModeAfterCompletion,
              selected: mode == TaskRecurrenceMode.afterCompletion,
              onPressed: () =>
                  onModeChanged(TaskRecurrenceMode.afterCompletion),
            ),
          ),
        ],
      ),
      Gaps.h8,
      Text(
        context.l10n.taskRecurrenceOccurrenceStatus,
        style: context.text.labelSmall?.copyWith(
          fontWeight: .w700,
          color: context.colors.onSurfaceVariant,
        ),
      ),
      Gaps.h4,
      DropdownButtonFormField<ProjectTaskStatus>(
        initialValue: occurrenceStatus,
        decoration: InputDecoration(
          filled: true,
          fillColor: context.colors.surfaceContainerHighest.withValues(
            alpha: .5,
          ),
          contentPadding: const .symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p8,
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
            borderSide: BorderSide(color: context.colors.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
            borderSide: BorderSide(color: context.colors.outlineVariant),
          ),
        ),
        items: [
          DropdownMenuItem(
            value: ProjectTaskStatus.todo,
            child: Text(
              context.l10n.tasksListStatusTodo,
              style: context.text.bodySmall?.copyWith(fontWeight: .w600),
            ),
          ),
          DropdownMenuItem(
            value: ProjectTaskStatus.inProgress,
            child: Text(
              context.l10n.tasksListStatusInProgress,
              style: context.text.bodySmall?.copyWith(fontWeight: .w600),
            ),
          ),
        ],
        onChanged: (val) {
          if (val != null) onOccurrenceStatusChanged(val);
        },
      ),
      Gaps.h8,
      AppToggleSwitch(
        value: skipIfPreviousOpen,
        onChanged: onSkipIfPreviousOpenChanged,
        label: context.l10n.taskRecurrenceSkipIfPreviousOpen,
      ),
      Gaps.h12,
      Row(
        children: [
          if (hasRecurrence && isSourceTask) ...[
            Tooltip(
              message: context.l10n.tasksRecurrenceDelete,
              child: IconButton.outlined(
                onPressed: isSubmitting ? null : onDelete,
                style: IconButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: context.colors.error,
                  side: BorderSide(
                    color: context.colors.error.withValues(alpha: .5),
                  ),
                ),
                icon: const Icon(
                  Symbols.delete_outline_rounded,
                  size: Sizes.p16,
                ),
              ),
            ),
            Gaps.w8,
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isSubmitting ? null : onTogglePause,
                icon: Icon(
                  isActive ? Symbols.pause_rounded : Symbols.play_arrow_rounded,
                  size: Sizes.p16,
                  color: context.colors.onSurface,
                ),
                label: Text(
                  isActive
                      ? context.l10n.taskRecurrencePauseSeries
                      : context.l10n.taskRecurrenceResumeSeries,
                  style: context.text.labelSmall?.copyWith(
                    fontWeight: .w700,
                    color: context.colors.onSurface,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: .compact,
                  foregroundColor: context.colors.onSurface,
                  padding: const .symmetric(horizontal: Sizes.p8),
                ),
              ),
            ),
            Gaps.w8,
          ],
          Expanded(
            child: FilledButton.icon(
              onPressed: isSubmitting ? null : onSave,
              icon: isSubmitting
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.onPrimary,
                      ),
                    )
                  : Icon(
                      Symbols.check_rounded,
                      size: Sizes.p16,
                      color: context.colors.onPrimary,
                    ),
              label: Text(
                isSubmitting
                    ? context.l10n.taskRecurrenceSaving
                    : context.l10n.taskRecurrenceSave,
                style: context.text.labelSmall?.copyWith(
                  fontWeight: .w800,
                  letterSpacing: -.1,
                  color: context.colors.onPrimary,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
                visualDensity: .compact,
                padding: const .symmetric(horizontal: Sizes.p12),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
