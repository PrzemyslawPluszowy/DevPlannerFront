part of '../project_recurrences_sheet.dart';

/// Zwarty pasek nagłówka sekcji zadań cyklicznych w projekcie.
class _ProjectRecurrencesHeader extends StatelessWidget {
  const _ProjectRecurrencesHeader();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectRecurrencesCubit>();

    return Padding(
      padding: const .symmetric(horizontal: Sizes.p20, vertical: Sizes.p12),
      child: Row(
        children: [
          Container(
            width: Sizes.p36,
            height: Sizes.p36,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
            ),
            child: Icon(
              Symbols.repeat_rounded,
              color: context.colors.onPrimaryContainer,
              size: Sizes.p20,
            ),
          ),
          Gaps.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  context.l10n.tasksRecurrenceTitle,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: .w800,
                    letterSpacing: -.2,
                  ),
                ),
                Gaps.h2,
                Text(
                  context.l10n.tasksRecurrenceDescription,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: context.l10n.workspacesRefresh,
            onPressed: () => unawaited(cubit.load()),
            icon: const Icon(Symbols.refresh_rounded, size: Sizes.p18),
            visualDensity: .compact,
          ),
        ],
      ),
    );
  }
}
