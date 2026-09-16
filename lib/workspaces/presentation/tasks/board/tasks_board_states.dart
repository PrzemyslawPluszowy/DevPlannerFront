part of 'tasks_board_page.dart';

class _BoardSkeleton extends StatelessWidget {
  const _BoardSkeleton();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < 3; index++) ...[
          Expanded(
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          if (index < 2) const SizedBox(width: 14),
        ],
      ],
    ),
  );
}

class _BoardFailure extends StatelessWidget {
  const _BoardFailure({required this.message, required this.kind});

  final String message;
  final TasksBoardFailureKind kind;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 42, color: context.colors.error),
          const SizedBox(height: 12),
          Text(
            _title(context),
            style: context.text.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          if (kind != TasksBoardFailureKind.forbidden)
            FilledButton.icon(
              onPressed: () => unawaited(
                context.read<TasksBoardCubit>().start(),
              ),
              icon: const Icon(Symbols.refresh_rounded),
              label: Text(context.l10n.workspacesRetry),
            ),
        ],
      ),
    ),
  );

  IconData get _icon => switch (kind) {
    TasksBoardFailureKind.forbidden => Symbols.lock_outline_rounded,
    TasksBoardFailureKind.notFound => Symbols.search_off_rounded,
    TasksBoardFailureKind.offline => Symbols.cloud_off_rounded,
    TasksBoardFailureKind.other => Symbols.error_outline_rounded,
  };

  String _title(BuildContext context) => switch (kind) {
    TasksBoardFailureKind.forbidden => context.l10n.tasksBoardForbiddenTitle,
    TasksBoardFailureKind.notFound => context.l10n.tasksBoardNotFoundTitle,
    TasksBoardFailureKind.offline => context.l10n.tasksBoardOfflineTitle,
    TasksBoardFailureKind.other => context.l10n.tasksBoardErrorTitle,
  };
}

class _BoardEmpty extends StatelessWidget {
  const _BoardEmpty();

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      context.l10n.tasksBoardEmpty,
      style: context.text.titleMedium,
    ),
  );
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.column});

  final KanbanColumnResponse column;

  @override
  Widget build(BuildContext context) {
    final exceeded = column.isWipLimitExceeded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: exceeded
            ? context.colors.errorContainer
            : context.colors.surfaceContainerHighest.withValues(alpha: .6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        column.wipLimit == null
            ? '${column.totalTaskCount}'
            : '${column.totalTaskCount}/${column.wipLimit}',
        style: context.text.labelSmall?.copyWith(
          color: exceeded
              ? context.colors.onErrorContainer
              : context.colors.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Color _parseColor(String value) {
  final normalized = value.replaceFirst('#', '');
  final parsed = int.tryParse(normalized, radix: 16);
  return parsed == null ? const Color(0xFF6C5CE7) : Color(0xFF000000 | parsed);
}
