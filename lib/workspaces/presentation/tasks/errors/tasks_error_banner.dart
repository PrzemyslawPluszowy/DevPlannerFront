import 'package:devplanner/foundation/error/api_error.dart';
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
    this.apiError,
    this.onRetry,
    this.onDismiss,
    super.key,
  });

  /// Gotowy komunikat dla użytkownika.
  final String message;

  /// Identyfikator korelacji z Backendu, jeśli błąd go przyniósł.
  final String? traceId;

  /// Ustrukturyzowane szczegóły API, gdy operacja ma diagnostykę kontraktu.
  final ApiError? apiError;

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
    final effectiveTraceId = traceId ?? apiError?.traceId;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Symbols.warning_rounded,
                  size: 18,
                  color: colors.error,
                ),
              ),
              SizedBox(width: tasksTheme.controlGap),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 112),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SelectableText(
                          message,
                          style: tasksTheme.controlText.copyWith(
                            color: colors.error,
                          ),
                        ),
                        if (effectiveTraceId case final trace?) ...[
                          const SizedBox(height: 2),
                          SelectableText(
                            context.l10n.tasksViewErrorTraceId(trace),
                            style: tasksTheme.metaText.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (apiError case final apiError?)
                          TasksErrorDiagnostics(error: apiError),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: tasksTheme.tightGap,
            runSpacing: 2,
            children: [
              if (onRetry case final onRetry?)
                TextButton(
                  onPressed: onRetry,
                  child: Text(context.l10n.tasksViewErrorRetry),
                ),
              TextButton(
                onPressed: onRefresh,
                child: Text(context.l10n.tasksViewErrorRefresh),
              ),
              if (onDismiss case final onDismiss?)
                IconButton(
                  onPressed: onDismiss,
                  iconSize: 16,
                  visualDensity: VisualDensity.compact,
                  tooltip: context.l10n.tasksViewErrorDismissTooltip,
                  icon: const Icon(Symbols.close_rounded),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pokazuje kontraktowe szczegóły bez zastępowania nimi czytelnego błędu.
class TasksErrorDiagnostics extends StatelessWidget {
  const TasksErrorDiagnostics({
    required this.error,
    this.messageOverride,
    super.key,
  });

  final ApiError error;
  final String? messageOverride;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final details = [
      if ((messageOverride ?? error.message).isNotEmpty)
        messageOverride ?? error.message,
      if (error.apiCode case final code?) l10n.tasksViewErrorApiCode(code),
      if (error.contractCode case final code?)
        l10n.tasksViewErrorContractCode(code),
      if (error.statusCode case final status?)
        l10n.tasksViewErrorHttpStatus(status),
      if (error.backendCode case final code?)
        l10n.tasksViewErrorBackendCode(code),
      if (error.retryAfterUtc case final retryAfter?)
        l10n.tasksViewErrorRetryAfter(
          retryAfter.toUtc().toIso8601String(),
        ),
      if (error.fields.isNotEmpty)
        l10n.tasksViewErrorValidationFields(
          error.fields.entries
              .map((entry) => '${entry.key}: ${entry.value.join(', ')}')
              .join('; '),
        ),
    ];
    if (details.isEmpty) return const SizedBox.shrink();
    final style = context.tasksTheme.metaText.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: SelectableText(
        '${l10n.tasksViewErrorDiagnostics}: ${details.join(' · ')}',
        style: style,
      ),
    );
  }
}
