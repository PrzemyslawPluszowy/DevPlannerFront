import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

/// Local wall-clock controls. The recurrence request still carries a UTC instant.
final class TaskRecurrenceTimeFields extends StatelessWidget {
  const TaskRecurrenceTimeFields({
    required this.value,
    required this.enabled,
    required this.onChanged,
    required this.selectionScope,
    super.key,
  });

  final DateTime? value;
  final bool enabled;
  final ValueChanged<DateTime?> onChanged;
  final Object selectionScope;

  void _changeHour(int hour) => _changeTime(hour: hour);
  void _changeMinute(int minute) => _changeTime(minute: minute);

  void _changeTime({int? hour, int? minute}) {
    final local = value?.toLocal();
    if (!enabled || local == null) return;
    final nextHour = hour ?? local.hour;
    final nextMinute = minute ?? local.minute;
    if (nextHour == local.hour && nextMinute == local.minute) return;
    onChanged(
      DateTime(
        local.year,
        local.month,
        local.day,
        nextHour,
        nextMinute,
      ).toUtc(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = value?.toLocal();
    return Row(
      children: [
        Expanded(
          child: TaskDetailsSelectField<int>(
            label: context.l10n.taskRecurrenceHour,
            value: local?.hour ?? 0,
            selectionScope: (selectionScope, value),
            enabled: enabled && local != null,
            options: [
              for (var hour = 0; hour < 24; hour++)
                TaskDetailsSelectOption(
                  value: hour,
                  label: hour.toString().padLeft(2, '0'),
                ),
            ],
            onChanged: _changeHour,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TaskDetailsSelectField<int>(
            label: context.l10n.taskRecurrenceMinute,
            value: local?.minute ?? 0,
            selectionScope: (selectionScope, value),
            enabled: enabled && local != null,
            options: [
              for (var minute = 0; minute < 60; minute++)
                TaskDetailsSelectOption(
                  value: minute,
                  label: minute.toString().padLeft(2, '0'),
                ),
            ],
            onChanged: _changeMinute,
          ),
        ),
      ],
    );
  }
}
