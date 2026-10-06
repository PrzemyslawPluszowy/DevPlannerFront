import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
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
    this.isSaving = false,
    this.errorMessage,
    this.onRetry,
    super.key,
  });

  /// Liczba zaznaczonych zadań.
  final int selectedCount;

  /// Kontrolki akcji zależne od widoku.
  final List<Widget> controls;

  /// Czyści zaznaczenie i zamyka pasek.
  final VoidCallback onClearSelection;
  final bool isSaving;
  final String? errorMessage;
  final VoidCallback? onRetry;

  Future<void> _showError(BuildContext context) async {
    final message = errorMessage;
    if (message == null || isSaving) return;
    await DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => TasksBulkErrorDialog(message: message),
    );
  }

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
          SizedBox(width: tasksTheme.controlGap),
          SizedBox(
            width: 320,
            height: 36,
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 16,
                  child: isSaving
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : errorMessage == null
                      ? const SizedBox.shrink()
                      : Icon(
                          Symbols.error_outline_rounded,
                          size: 16,
                          color: colors.error,
                        ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: errorMessage != null && !isSaving
                      ? TextButton(
                          key: const ValueKey('bulk_error_details'),
                          onPressed: () => _showError(context),
                          child: Text(
                            errorMessage!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tasksTheme.metaText.copyWith(
                              color: colors.error,
                            ),
                          ),
                        )
                      : Text(
                          isSaving ? context.l10n.tasksBulkSaving : '',
                          style: tasksTheme.metaText,
                        ),
                ),
                if (errorMessage != null && onRetry != null)
                  TextButton(
                    onPressed: isSaving ? null : onRetry,
                    child: Text(context.l10n.retry),
                  ),
              ],
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
            label: context.l10n.tasksBulkClearSelection,
            onTap: isSaving ? null : onClearSelection,
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
    final foreground = onTap == null
        ? colors.onSurface.withValues(alpha: .38)
        : isDestructive
        ? colors.error
        : colors.onSurface;

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
            if (!context.mounted || selected == null) return;
            onSelected(selected);
          },
  );
}

/// Czytelny pełny komunikat bez zwiększania wysokości nagłówka.
class TasksBulkErrorDialog extends StatelessWidget {
  const TasksBulkErrorDialog({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
      side: BorderSide(color: context.colors.outlineVariant),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.tasksBulkErrorTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SelectableText(message, style: context.tasksTheme.controlText),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.close),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
