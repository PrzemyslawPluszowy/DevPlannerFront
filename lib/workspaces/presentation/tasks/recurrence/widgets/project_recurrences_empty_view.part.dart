part of '../project_recurrences_sheet.dart';

/// Pusty stan dla braku reguł lub historii wykonań.
class _ProjectRecurrencesEmptyView extends StatelessWidget {
  const _ProjectRecurrencesEmptyView({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const .all(Sizes.p32),
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(
            icon,
            size: 56,
            color: context.colors.onSurfaceVariant.withValues(alpha: .5),
          ),
          Gaps.h16,
          Text(
            title,
            textAlign: .center,
            style: context.text.titleMedium?.copyWith(
              fontWeight: .w600,
            ),
          ),
          Gaps.h6,
          Text(
            description,
            textAlign: .center,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
