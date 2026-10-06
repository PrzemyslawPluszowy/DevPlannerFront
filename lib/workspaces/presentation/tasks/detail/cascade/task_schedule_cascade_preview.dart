import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

class CascadePreview extends StatelessWidget {
  const CascadePreview({
    required this.preview,
    required this.format,
    super.key,
  });

  final ScheduleCascadeResponse preview;
  final DateFormat format;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.colors.outlineVariant),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.taskDetailsCascadeChanges,
            style: context.text.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.taskDetailsCascadePreviewDescription,
            style: context.text.bodySmall,
          ),
          const SizedBox(height: 8),
          if (preview.dateShifts.isEmpty)
            Text(context.l10n.taskDetailsCascadeNoChanges)
          else
            ...preview.dateShifts.map(
              (shift) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      shift.isOnCriticalPath
                          ? Symbols.warning_amber_rounded
                          : Symbols.calendar_month,
                      size: 18,
                      color: shift.isOnCriticalPath
                          ? context.colors.error
                          : context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: '${shift.title}\n',
                          style: context.text.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${context.l10n.taskDetailsCascadeBefore}: '
                                  '${shift.currentStartAtUtc == null ? context.l10n.taskDetailsCascadeDateUnset : format.format(shift.currentStartAtUtc!.toLocal())} – '
                                  '${shift.currentDueAtUtc == null ? context.l10n.taskDetailsCascadeDateUnset : format.format(shift.currentDueAtUtc!.toLocal())}\n'
                                  '${context.l10n.taskDetailsCascadeAfter}: '
                                  '${format.format(shift.proposedStartAtUtc.toLocal())} – ${format.format(shift.proposedDueAtUtc.toLocal())}',
                              style: context.text.bodySmall?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (shift.isOnCriticalPath)
                              TextSpan(
                                text:
                                    ' · ${context.l10n.taskDetailsCascadeCritical}',
                                style: context.text.bodySmall?.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
