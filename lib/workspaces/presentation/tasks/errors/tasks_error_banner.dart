import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Trwały pasek błędu modułu Tasks.
///
/// Błędy zapisu ustawień widoku i synchronizacji meldują się tutaj, nad treścią
/// Listy albo Kanbana, i zostają na ekranie do naprawy albo zamknięcia. SnackBar
/// pozostaje dla krótkich, niekrytycznych informacji.
class TasksErrorBanner extends StatelessWidget {
  const TasksErrorBanner({
    required this.message,
    required this.onRefresh,
    this.traceId,
    this.onRetry,
    this.onDismiss,
    super.key,
  });

  /// Gotowy komunikat dla użytkownika.
  final String message;

  /// Identyfikator korelacji z Backendu, jeśli błąd go przyniósł.
  final String? traceId;

  /// Ponowienie operacji, która się nie powiodła; `null`, gdy nie ma czego
  /// ponawiać bez zmiany danych.
  final VoidCallback? onRetry;

  /// Ponowny odczyt stanu z Backendu.
  final VoidCallback onRefresh;

  /// Zamknięcie komunikatu; `null` dla błędów, których nie wolno ukryć bez
  /// naprawy (np. nieudany odczyt ustawień widoku).
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tasksTheme = context.tasksTheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        tasksTheme.sectionGap,
        tasksTheme.tightGap,
        tasksTheme.sectionGap,
        0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: tasksTheme.controlGap,
        vertical: tasksTheme.tightGap,
      ),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
        border: Border.all(color: colors.error.withValues(alpha: .5)),
      ),
      child: Row(
        children: [
          Icon(Symbols.warning_rounded, size: 18, color: colors.error),
          SizedBox(width: tasksTheme.controlGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: tasksTheme.controlText.copyWith(color: colors.error),
                ),
                if (traceId case final traceId?) ...[
                  const SizedBox(height: 2),
                  SelectableText(
                    context.l10n.tasksViewErrorTraceId(traceId),
                    style: tasksTheme.metaText.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRetry case final onRetry?) ...[
            SizedBox(width: tasksTheme.tightGap),
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.tasksViewErrorRetry),
            ),
          ],
          SizedBox(width: tasksTheme.tightGap),
          TextButton(
            onPressed: onRefresh,
            child: Text(context.l10n.tasksViewErrorRefresh),
          ),
          if (onDismiss case final onDismiss?) ...[
            const SizedBox(width: 2),
            IconButton(
              onPressed: onDismiss,
              iconSize: 16,
              visualDensity: VisualDensity.compact,
              tooltip: context.l10n.tasksViewErrorDismissTooltip,
              icon: const Icon(Symbols.close_rounded),
            ),
          ],
        ],
      ),
    );
  }
}
