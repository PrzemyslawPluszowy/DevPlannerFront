import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Komunikat błędu ładowania pól niestandardowych z możliwością ponowienia.
class ProjectCustomFieldsFailureState extends StatelessWidget {
  const ProjectCustomFieldsFailureState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: Sizes.p40,
            color: colors.error,
          ),
          Gaps.h12,
          Text(
            message,
            style: context.text.bodyMedium?.copyWith(color: colors.error),
            textAlign: TextAlign.center,
          ),
          Gaps.h16,
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
}
