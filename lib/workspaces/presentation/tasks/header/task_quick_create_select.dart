import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';

/// Form field using the same menu surface and keyboard navigation as Tasks.
final class TaskQuickCreateSelect extends StatelessWidget {
  const TaskQuickCreateSelect({
    required this.label,
    required this.options,
    required this.onSelected,
    this.leading,
    super.key,
  });

  final String label;
  final Widget? leading;
  final List<AppContextMenuOption<int>> options;
  final ValueChanged<int>? onSelected;

  Future<void> _open(BuildContext context) async {
    final route = ModalRoute.of(context);
    final callback = onSelected;
    if (callback == null || route?.isCurrent != true) return;
    final index = await AppContextMenu.select<int>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      options: options,
    );
    if (!context.mounted || route?.isCurrent != true || index == null) return;
    callback(index);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: onSelected == null ? null : () => unawaited(_open(context)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 32),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        foregroundColor: colors.onSurface,
        side: BorderSide(color: tasks.cardBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tasks.controlRadius),
        ),
        textStyle: tasks.controlText,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        children: [
          if (leading case final icon?) ...[
            icon,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_drop_down, size: 18, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}
