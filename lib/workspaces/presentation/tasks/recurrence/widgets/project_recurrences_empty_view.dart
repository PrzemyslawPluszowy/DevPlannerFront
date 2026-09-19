import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Pusty stan wspólny dla braku reguł lub historii wykonań.
final class ProjectRecurrencesEmptyView extends StatelessWidget {
  const ProjectRecurrencesEmptyView({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: context.colors.onSurfaceVariant.withValues(alpha: .5),
            ),
            Gaps.h16,
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.h6,
            Text(
              description,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
