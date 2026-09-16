part of '../task_recurrence_context_editor.dart';

/// Zwarte presety częstotliwości w edytorze kontekstowym.
class _TaskRecurrenceEditorPresets extends StatelessWidget {
  const _TaskRecurrenceEditorPresets({
    required this.selectedPreset,
    required this.interval,
    required this.frequency,
    required this.onPresetSelected,
    required this.onIntervalChanged,
    required this.onFrequencyChanged,
  });

  final TaskRecurrencePreset selectedPreset;
  final int interval;
  final TaskRecurrenceFrequency frequency;
  final ValueChanged<TaskRecurrencePreset> onPresetSelected;
  final ValueChanged<int> onIntervalChanged;
  final ValueChanged<TaskRecurrenceFrequency> onFrequencyChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    children: [
      Text(
        context.l10n.taskRecurrenceFrequencyLabel,
        style: context.text.labelSmall?.copyWith(
          fontWeight: .w700,
          color: context.colors.onSurfaceVariant,
        ),
      ),
      Gaps.h8,
      Wrap(
        spacing: Sizes.p6,
        runSpacing: Sizes.p6,
        children: [
          AppActionPill(
            label: context.l10n.taskRecurrenceIntervalDaily,
            selected: selectedPreset == TaskRecurrencePreset.daily,
            onPressed: () => onPresetSelected(TaskRecurrencePreset.daily),
          ),
          AppActionPill(
            label: context.l10n.taskRecurrencePresetWorkdays,
            selected: selectedPreset == TaskRecurrencePreset.workdays,
            onPressed: () => onPresetSelected(TaskRecurrencePreset.workdays),
          ),
          AppActionPill(
            label: context.l10n.taskRecurrenceIntervalWeekly,
            selected: selectedPreset == TaskRecurrencePreset.weekly,
            onPressed: () => onPresetSelected(TaskRecurrencePreset.weekly),
          ),
          AppActionPill(
            label: context.l10n.taskRecurrenceIntervalMonthly,
            selected: selectedPreset == TaskRecurrencePreset.monthly,
            onPressed: () => onPresetSelected(TaskRecurrencePreset.monthly),
          ),
          AppActionPill(
            label: context.l10n.taskRecurrencePresetCustom,
            selected: selectedPreset == TaskRecurrencePreset.custom,
            onPressed: () => onPresetSelected(TaskRecurrencePreset.custom),
          ),
        ],
      ),
      if (selectedPreset == TaskRecurrencePreset.custom) ...[
        Gaps.h8,
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AppTextField(
                variant: AppTextFieldVariant.filled,
                labelText: context.l10n.taskRecurrenceRepeatEvery,
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: interval.toString()),
                onChanged: (val) {
                  final num = int.tryParse(val);
                  if (num != null && num > 0) onIntervalChanged(num);
                },
              ),
            ),
            Gaps.w8,
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Jednostka',
                    style: context.text.labelSmall?.copyWith(
                      fontWeight: .w600,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  Gaps.h4,
                  DropdownButtonFormField<TaskRecurrenceFrequency>(
                    initialValue: frequency,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.colors.surfaceContainerHighest
                          .withValues(alpha: .5),
                      contentPadding: const .symmetric(
                        horizontal: Sizes.p8,
                        vertical: Sizes.p8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          .circular(Sizes.p8),
                        ),
                        borderSide: BorderSide(
                          color: context.colors.outlineVariant,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          .circular(Sizes.p8),
                        ),
                        borderSide: BorderSide(
                          color: context.colors.outlineVariant,
                        ),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: TaskRecurrenceFrequency.daily,
                        child: Text(
                          context.l10n.taskRecurrenceUnitDays,
                          style: context.text.bodySmall?.copyWith(
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: TaskRecurrenceFrequency.weekly,
                        child: Text(
                          context.l10n.taskRecurrenceUnitWeeks,
                          style: context.text.bodySmall?.copyWith(
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: TaskRecurrenceFrequency.monthly,
                        child: Text(
                          context.l10n.taskRecurrenceUnitMonths,
                          style: context.text.bodySmall?.copyWith(
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) onFrequencyChanged(val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ],
  );
}
