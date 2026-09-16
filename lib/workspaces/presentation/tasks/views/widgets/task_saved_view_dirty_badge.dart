import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Drobny wskaźnik informujący o lokalnej modyfikacji aktywnego widoku.
class TaskSavedViewDirtyBadge extends StatelessWidget {
  const TaskSavedViewDirtyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: .circular(4),
      ),
      child: Text(
        context.l10n.tasksSavedViewsModified,
        style: context.text.labelSmall?.copyWith(
          color: colors.onTertiaryContainer,
          fontWeight: .w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
