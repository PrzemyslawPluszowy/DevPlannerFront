import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

class ProjectRecurrencesTableHeader extends StatelessWidget {
  const ProjectRecurrencesTableHeader({super.key, required this.columns});
  final List<({String label, int? flex, double? width, TextAlign? align})>
  columns;
  @override
  Widget build(BuildContext context) => Container(
    height: 34,
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHighest.withValues(alpha: .3),
      border: Border(
        bottom: BorderSide(
          color: context.colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
    ),
    padding: const .symmetric(horizontal: Sizes.p16),
    child: Row(
      children: [
        for (final col in columns)
          if (col.width != null)
            SizedBox(
              width: col.width,
              child: Text(
                col.label,
                textAlign: col.align ?? TextAlign.start,
                style: context.text.labelSmall?.copyWith(
                  fontWeight: .w800,
                  letterSpacing: .3,
                  fontSize: context.tasksTheme.controlText.fontSize,
                  color: context.colors.onSurfaceVariant.withValues(alpha: .7),
                ),
              ),
            )
          else
            Expanded(
              flex: col.flex ?? 1,
              child: Text(
                col.label,
                textAlign: col.align ?? TextAlign.start,
                style: context.text.labelSmall?.copyWith(
                  fontWeight: .w800,
                  letterSpacing: .3,
                  fontSize: context.tasksTheme.controlText.fontSize,
                  color: context.colors.onSurfaceVariant.withValues(alpha: .7),
                ),
              ),
            ),
      ],
    ),
  );
}
