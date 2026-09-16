part of '../task_recurrence_context_editor.dart';

/// Sekcja wyboru daty i godziny najbliższego wykonania cyklu.
class _TaskRecurrenceEditorScheduleSection extends StatelessWidget {
  const _TaskRecurrenceEditorScheduleSection({
    required this.scheduledDate,
    required this.scheduledTime,
    required this.onPickDate,
    required this.onPickTime,
  });

  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd('pl').add_EEEE();
    final formattedDate = dateFormat.format(scheduledDate);
    final formattedTime = scheduledTime.format(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          context.l10n.taskRecurrenceScheduleLabel,
          style: context.text.labelSmall?.copyWith(
            fontWeight: .w700,
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.h6,
        Row(
          children: [
            Expanded(
              flex: 3,
              child: OutlinedButton.icon(
                onPressed: onPickDate,
                icon: Icon(
                  Symbols.calendar_today_rounded,
                  size: Sizes.p16,
                  color: context.colors.onSurface,
                ),
                label: Text(
                  formattedDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: .w600,
                    color: context.colors.onSurface,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: .compact,
                  foregroundColor: context.colors.onSurface,
                  padding: const .symmetric(
                    horizontal: Sizes.p10,
                    vertical: Sizes.p8,
                  ),
                ),
              ),
            ),
            Gaps.w8,
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: onPickTime,
                icon: Icon(
                  Symbols.access_time_rounded,
                  size: Sizes.p16,
                  color: context.colors.onSurface,
                ),
                label: Text(
                  formattedTime,
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: .w600,
                    color: context.colors.onSurface,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: .compact,
                  foregroundColor: context.colors.onSurface,
                  padding: const .symmetric(
                    horizontal: Sizes.p10,
                    vertical: Sizes.p8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
