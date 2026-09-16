part of 'assign_user_issues_from_standard_modal.dart';

/// Wiersz wyboru pozycji standardu.
class _SelectionTile extends StatelessWidget {
  /// Tworzy wiersz pozycji standardu.
  const _SelectionTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.accentTone,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool enabled;
  final AppStatusBadgeTone accentTone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final backgroundColor = enabled
        ? colors.surfaceContainerLow
        : colors.surfaceContainerHighest.withValues(alpha: .5);

    return Padding(
      padding: const .only(bottom: Sizes.p8),
      child: Material(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        clipBehavior: .antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .7),
            ),
          ),
          child: CheckboxListTile(
            value: value,
            onChanged: onChanged,
            tileColor: backgroundColor,
            selectedTileColor: backgroundColor,
            dense: true,
            visualDensity: .compact,
            contentPadding: const .symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p4,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              label,
              style: text.bodyMedium?.copyWith(
                fontWeight: .w600,
                color: colors.onSurface,
              ),
            ),
            subtitle: Padding(
              padding: const .only(top: Sizes.p4),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  AppStatusBadge(
                    label: _badgeLabel(context),
                    tone: accentTone,
                    icon: _badgeIcon,
                  ),
                  if (subtitle.trim().isNotEmpty) ...[
                    Gaps.h8,
                    Text(
                      subtitle,
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _badgeLabel(BuildContext context) => switch (accentTone) {
    AppStatusBadgeTone.success =>
      context.l10n.bhpAssignFromStandardBadgeAddable,
    AppStatusBadgeTone.warning =>
      value
          ? context.l10n.bhpAssignFromStandardBadgeLocked
          : context.l10n.bhpAssignFromStandardBadgeInactive,
    AppStatusBadgeTone.neutral =>
      context.l10n.bhpAssignFromStandardBadgeInactive,
    AppStatusBadgeTone.info => context.l10n.bhpAssignFromStandardBadgeInfo,
    AppStatusBadgeTone.danger => context.l10n.bhpAssignFromStandardBadgeWarning,
  };

  IconData get _badgeIcon => switch (accentTone) {
    AppStatusBadgeTone.success => Icons.add_circle_outline_rounded,
    AppStatusBadgeTone.warning => Icons.lock_outline_rounded,
    AppStatusBadgeTone.neutral => Icons.remove_circle_outline_rounded,
    AppStatusBadgeTone.info => Icons.info_outline_rounded,
    AppStatusBadgeTone.danger => Icons.warning_amber_rounded,
  };
}

/// Nagłówek sekcji na liście pozycji standardu.
class _SectionTitle extends StatelessWidget {
  /// Tworzy nagłówek sekcji.
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.text.titleSmall?.copyWith(
        fontWeight: .w700,
        color: context.colors.onSurface,
      ),
    );
  }
}
