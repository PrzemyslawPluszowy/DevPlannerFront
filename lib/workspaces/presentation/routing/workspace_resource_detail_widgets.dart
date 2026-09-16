part of 'workspace_resource_detail_pages.dart';

class _ResourceDetails extends StatelessWidget {
  const _ResourceDetails({
    required this.item,
    required this.workspaceId,
    required this.projectId,
  });

  final ProjectResourceListItem item;
  final String workspaceId;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resourceColor = WorkspaceVisualHelpers.resourceColor(
      context,
      item.kind,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(Sizes.p24),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: .04)
            : colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .08)
              : colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              WorkspaceVisualHelpers.resourceIconBadge(
                context,
                icon: WorkspaceVisualHelpers.iconFor(item.kind.name),
                color: resourceColor,
                size: 36,
                iconSize: 20,
              ),
              Gaps.w12,
              Expanded(
                child: Text(
                  item.title,
                  style: context.text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (item.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: .12),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.check_circle_rounded,
                        size: 14,
                        color: colors.primary,
                      ),
                      Gaps.w4,
                      Text(
                        'Zweryfikowano',
                        style: context.text.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Gaps.h20,
          Divider(
            color: isDark
                ? Colors.white.withValues(alpha: .06)
                : colors.outlineVariant.withValues(alpha: .3),
          ),
          Gaps.h16,
          _DetailRow(label: 'Typ zasobu', value: item.kind.name.toUpperCase()),
          Gaps.h8,
          _DetailRow(label: 'Projekt', value: projectId),
          Gaps.h8,
          _DetailRow(label: 'Workspace', value: workspaceId),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 120,
        child: Text(
          label,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: context.text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

class _ResourceMessage extends StatelessWidget {
  const _ResourceMessage({
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Symbols.info, size: 44),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('Spróbuj ponownie'),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
