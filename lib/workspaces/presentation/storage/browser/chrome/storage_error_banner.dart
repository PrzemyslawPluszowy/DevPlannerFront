import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Trwały banner błędu modułu Pliki.
///
/// Zastępuje `SnackBar`, który znikał razem z komunikatem, kodem i możliwością
/// ponowienia. Banner zostaje na ekranie do czasu naprawy stanu, pokazuje
/// stabilny kod kontraktu i `traceId`, a akcje `Ponów`/`Odśwież` są jawnie
/// rozdzielone: pierwsza ponawia nieudaną operację, druga wczytuje zakres od
/// nowa. Gdy nie ma czego ponowić, `onRetry` jest `null` i przycisk nie istnieje
/// — zamiast obiecywać akcję, której nie ma.
final class StorageErrorBanner extends StatelessWidget {
  /// Tworzy banner błędu.
  const StorageErrorBanner({
    required this.message,
    required this.onRefresh,
    this.code,
    this.traceId,
    this.onRetry,
    this.onDismiss,
    super.key,
  });

  /// Czytelny komunikat błędu dla użytkownika.
  final String message;

  /// Ponowienie nieudanej operacji; brak akcji oznacza brak przycisku.
  final VoidCallback? onRetry;

  /// Ponowne wczytanie bieżącego zakresu.
  final VoidCallback onRefresh;

  /// Stabilny kod kontraktu, np. `storage.version_conflict`.
  final String? code;

  /// Identyfikator śledzenia żądania.
  final String? traceId;

  /// Ukrycie komunikatu; brak akcji oznacza, że błąd wymaga naprawy.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    final meta = [
      ?code,
      if (traceId case final traceId?)
        context.l10n.tasksViewErrorTraceId(traceId),
    ].join(' • ');

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        common.sectionGap,
        common.tightGap,
        common.sectionGap,
        0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: common.controlGap,
        vertical: common.tightGap,
      ),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(common.controlRadius),
        border: Border.all(color: colors.error.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: colors.error),
          SizedBox(width: common.controlGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: common.controlText.copyWith(color: colors.error),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  SelectableText(
                    meta,
                    style: common.metaText.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRetry case final onRetry?) ...[
            SizedBox(width: common.tightGap),
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.tasksViewErrorRetry),
            ),
          ],
          SizedBox(width: common.tightGap),
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
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ],
      ),
    );
  }
}
