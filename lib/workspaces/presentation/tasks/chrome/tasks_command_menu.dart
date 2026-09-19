import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';

/// Menu kontrolki wiersza poleceń.
///
/// Lista i Kanban mają jeden rząd poleceń, więc przycisk kontrolki, jego stan
/// aktywny i sposób otwierania wspólnego menu żyją w jednym miejscu, a nie w
/// każdym widoku osobno.
class TasksCommandMenu extends StatelessWidget {
  const TasksCommandMenu({
    required this.icon,
    required this.label,
    required this.options,
    required this.onSelected,
    this.activeLabel,
    this.leading,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? activeLabel;
  final List<AppContextMenuOption<String>> options;
  final ValueChanged<String> onSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) => TasksCommandButton(
    icon: icon,
    label: activeLabel ?? label,
    isActive: activeLabel != null,
    leading: leading,
    onTap: () async {
      final selected = await AppContextMenu.select<String>(
        context,
        globalPosition: AppContextMenu.positionFor(context),
        options: options,
        headerTitle: label,
      );
      if (selected == null) return;
      onSelected(selected);
    },
  );
}

/// Klawisz kontrolki wiersza poleceń.
class TasksCommandButton extends StatelessWidget {
  const TasksCommandButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.leading,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final tasksTheme = context.tasksTheme;
    final colors = context.colors;
    final foreground = isActive ? colors.primary : colors.onSurface;

    return Tooltip(
      message: label,
      child: Material(
        color: isActive ? tasksTheme.rowSelected : colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
          side: BorderSide(
            color: isActive
                ? tasksTheme.selectionAccent.withValues(alpha: .45)
                : colors.outlineVariant.withValues(alpha: .6),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
          onTap: onTap,
          child: Container(
            height: 28,
            padding: EdgeInsets.symmetric(horizontal: tasksTheme.controlGap),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading case final leading?)
                  leading
                else
                  Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 190),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tasksTheme.controlText.copyWith(color: foreground),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(icon, size: 12, color: colors.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
