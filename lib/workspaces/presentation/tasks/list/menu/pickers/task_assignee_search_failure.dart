import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Trwały błąd katalogu osób z akcją ponowienia bieżącego żądania.
final class TaskAssigneeSearchFailure extends StatelessWidget {
  const TaskAssigneeSearchFailure({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final ApiError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLow,
      border: Border.all(color: context.colors.error.withValues(alpha: .45)),
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Symbols.error_outline_rounded,
                size: 16,
                color: context.colors.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error.message,
                  style: context.tasksTheme.controlText.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          if (error.apiCode != null ||
              error.contractCode != null ||
              error.backendCode != null ||
              error.traceId != null)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 3),
              child: Wrap(
                spacing: 10,
                runSpacing: 2,
                children: [
                  if (error.apiCode case final code?)
                    SelectableText(
                      '${context.l10n.taskDetailsErrorCode}: $code',
                      style: context.tasksTheme.metaText,
                    ),
                  if (error.contractCode case final code?)
                    SelectableText(
                      '${context.l10n.taskDetailsErrorContractCode}: $code',
                      style: context.tasksTheme.metaText,
                    ),
                  if (error.backendCode case final code?)
                    SelectableText(
                      '${context.l10n.taskDetailsErrorBackendCode}: $code',
                      style: context.tasksTheme.metaText,
                    ),
                  if (error.traceId case final trace?)
                    SelectableText(
                      '${context.l10n.taskDetailsErrorTraceId}: $trace',
                      style: context.tasksTheme.metaText,
                    ),
                ],
              ),
            ),
          if (error.fields.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final field in error.fields.entries)
                    SelectableText(
                      '${field.key}: ${field.value.join(' · ')}',
                      style: context.tasksTheme.metaText,
                    ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh_rounded, size: 15),
              label: Text(context.l10n.retry),
            ),
          ),
        ],
      ),
    ),
  );
}
