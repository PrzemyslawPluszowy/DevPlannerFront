import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Jedna kontekstowa powierzchnia akcji masowych dla Listy i Kanbanu.
///
/// Miejsce paska to drugi wiersz wspólnego nagłówka, więc po zaznaczeniu zadań
/// nad treścią nie pojawia się drugi pasek. Kontrolki przewijają się poziomo i
/// korzystają z tokenów gęstości oraz wspólnego menu kontekstowego; zestaw akcji
/// zależy od widoku i ACL, ale wygląd oraz obsługa pozostają identyczne.
class TasksContextualBulkBar extends StatelessWidget {
  const TasksContextualBulkBar({
    required this.selectedCount,
    required this.controls,
    required this.onClearSelection,
    super.key,
  });

  /// Liczba zaznaczonych zadań.
  final int selectedCount;

  /// Kontrolki akcji zależne od widoku.
  final List<Widget> controls;

  /// Czyści zaznaczenie i zamyka pasek.
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    final tasksTheme = context.tasksTheme;
    final colors = context.colors;

    return SingleChildScrollView(
      key: const ValueKey('contextual_bulk_bar'),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: tasksTheme.controlGap,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: tasksTheme.rowSelected,
              borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
            ),
            child: Text(
              context.l10n.tasksBulkSelected(selectedCount),
              style: tasksTheme.controlText.copyWith(color: colors.primary),
            ),
          ),
          for (final control in controls) ...[
            SizedBox(width: tasksTheme.controlGap),
            control,
          ],
          SizedBox(width: tasksTheme.controlGap),
          TasksBulkButton(
            key: const ValueKey('bulk_clear_selection'),
            icon: Symbols.close_rounded,
            label: 'Wyczyść',
            onTap: onClearSelection,
          ),
        ],
      ),
    );
  }
}

/// Klawisz akcji masowej w kontekstowym pasku.
class TasksBulkButton extends StatelessWidget {
  const TasksBulkButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final tasksTheme = context.tasksTheme;
    final colors = context.colors;
    final foreground = isDestructive ? colors.error : colors.onSurface;

    return Tooltip(
      message: label,
      child: Material(
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: .6)),
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
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: tasksTheme.controlText.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Menu akcji masowej otwierane wspólnym komponentem menu.
class TasksBulkMenu<T> extends StatelessWidget {
  const TasksBulkMenu({
    required this.icon,
    required this.label,
    required this.options,
    required this.onSelected,
    this.isLoading = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final List<AppContextMenuOption<T>> options;
  final ValueChanged<T> onSelected;

  /// Blokuje kontrolkę w trakcie zapisu akcji masowej.
  final bool isLoading;

  @override
  Widget build(BuildContext context) => TasksBulkButton(
    icon: icon,
    label: label,
    onTap: isLoading
        ? null
        : () async {
            final selected = await AppContextMenu.select<T>(
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
