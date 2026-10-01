import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_action_pill.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_pick_fields.dart';
import 'package:flutter/material.dart';

/// Zwarte presety częstotliwości w edytorze kontekstowym.
final class TaskRecurrenceEditorPresets extends StatelessWidget {
  const TaskRecurrenceEditorPresets({
    required this.selectedPreset,
    required this.enabled,
    required this.interval,
    required this.frequency,
    required this.onPresetSelected,
    required this.onIntervalChanged,
    required this.onFrequencyChanged,
    super.key,
  });

  final TaskRecurrencePreset selectedPreset;
  final bool enabled;
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
            onPressed: enabled
                ? () => onPresetSelected(TaskRecurrencePreset.daily)
                : null,
          ),
          AppActionPill(
            label: context.l10n.taskRecurrencePresetWorkdays,
            selected: selectedPreset == TaskRecurrencePreset.workdays,
            onPressed: enabled
                ? () => onPresetSelected(TaskRecurrencePreset.workdays)
                : null,
          ),
          AppActionPill(
            label: context.l10n.taskRecurrenceIntervalWeekly,
            selected: selectedPreset == TaskRecurrencePreset.weekly,
            onPressed: enabled
                ? () => onPresetSelected(TaskRecurrencePreset.weekly)
                : null,
          ),
          AppActionPill(
            label: context.l10n.taskRecurrenceIntervalMonthly,
            selected: selectedPreset == TaskRecurrencePreset.monthly,
            onPressed: enabled
                ? () => onPresetSelected(TaskRecurrencePreset.monthly)
                : null,
          ),
          AppActionPill(
            label: context.l10n.taskRecurrencePresetCustom,
            selected: selectedPreset == TaskRecurrencePreset.custom,
            onPressed: enabled
                ? () => onPresetSelected(TaskRecurrencePreset.custom)
                : null,
          ),
        ],
      ),
      if (selectedPreset == TaskRecurrencePreset.custom) ...[
        Gaps.h8,
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: interval.toString(),
                decoration: InputDecoration(
                  labelText: context.l10n.taskRecurrenceRepeatEvery,
                  filled: true,
                  fillColor: context.colors.surfaceContainerHighest.withValues(
                    alpha: .5,
                  ),
                ),
                keyboardType: TextInputType.number,
                enabled: enabled,
                onChanged: (val) {
                  final num = int.tryParse(val);
                  if (num != null && num > 0) onIntervalChanged(num);
                },
              ),
            ),
            Gaps.w8,
            Expanded(
              flex: 4,
              child: TaskRecurrenceFrequencyPicker(
                frequency: frequency,
                enabled: enabled,
                onChanged: onFrequencyChanged,
              ),
            ),
          ],
        ),
      ],
    ],
  );
}
