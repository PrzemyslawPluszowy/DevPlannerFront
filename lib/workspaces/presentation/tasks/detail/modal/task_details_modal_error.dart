import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TaskDetailsModalConflictField {
  const TaskDetailsModalConflictField({
    required this.label,
    required this.baseline,
    required this.current,
    this.draft,
  });

  final String label;
  final String baseline;
  final String current;
  final String? draft;
}

/// Persistent mutation feedback rendered inside the task workspace.
final class TaskDetailsModalError extends StatelessWidget {
  const TaskDetailsModalError({
    required this.error,
    this.conflictFields = const [],
    this.fallbackMessage,
    super.key,
  });

  final ApiError error;
  final String? fallbackMessage;
  final List<TaskDetailsModalConflictField> conflictFields;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final code = error.apiCode;
    final retryAfter = error.retryAfterUtc;
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tasks.commandBarSurface,
        border: Border(
          bottom: BorderSide(color: colors.error.withValues(alpha: .55)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Symbols.error_outline_rounded, color: colors.error),
                const SizedBox(width: 10),
                Expanded(
                  child: MergeSemantics(
                    child: Semantics(
                      container: true,
                      liveRegion: true,
                      child: SelectableText(
                        error.message.isEmpty
                            ? (fallbackMessage ?? error.message)
                            : error.message,
                        style: tasks.dataStrongText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (code != null ||
                error.contractCode != null ||
                error.backendCode != null ||
                error.statusCode != null ||
                error.traceId != null)
              Padding(
                padding: const EdgeInsets.only(left: 34, top: 5),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    if (code != null)
                      _TaskDetailsErrorMetadata(
                        label: context.l10n.taskDetailsErrorCode,
                        value: code,
                      ),
                    if (error.contractCode case final contractCode?)
                      _TaskDetailsErrorMetadata(
                        label: context.l10n.taskDetailsErrorContractCode,
                        value: contractCode,
                      ),
                    if (error.backendCode case final backendCode?)
                      _TaskDetailsErrorMetadata(
                        label: context.l10n.taskDetailsErrorBackendCode,
                        value: '$backendCode',
                      ),
                    if (error.statusCode case final statusCode?)
                      _TaskDetailsErrorMetadata(
                        label: context.l10n.taskDetailsErrorHttpStatus,
                        value: '$statusCode',
                      ),
                    if (error.traceId case final traceId?)
                      _TaskDetailsErrorMetadata(
                        label: context.l10n.taskDetailsErrorTraceId,
                        value: traceId,
                      ),
                  ],
                ),
              ),
            if (error.fields.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 34, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.taskDetailsErrorFields,
                      style: tasks.metaText.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    for (final entry in error.fields.entries)
                      _TaskDetailsErrorMetadata(
                        label: entry.key,
                        value: entry.value.join(' · '),
                      ),
                  ],
                ),
              ),
            if (retryAfter != null)
              Padding(
                padding: const EdgeInsets.only(left: 34, top: 4),
                child: Text(
                  context.l10n.taskDetailsErrorRetryAfter(
                    dateFormat.format(retryAfter.toLocal()),
                  ),
                  style: tasks.metaText.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            if (conflictFields.isNotEmpty) ...[
              const SizedBox(height: 9),
              for (final field in conflictFields)
                _TaskDetailsConflictFieldView(field: field),
            ],
          ],
        ),
      ),
    );
  }
}

final class _TaskDetailsErrorMetadata extends StatelessWidget {
  const _TaskDetailsErrorMetadata({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SelectableText.rich(
    TextSpan(
      style: context.tasksTheme.metaText.copyWith(
        color: context.colors.onSurfaceVariant,
      ),
      children: [
        TextSpan(text: '${label.trim()}: '),
        TextSpan(
          text: value,
          style: context.tasksTheme.metaText.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

final class _TaskDetailsConflictFieldView extends StatelessWidget {
  const _TaskDetailsConflictFieldView({required this.field});

  final TaskDetailsModalConflictField field;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 34, top: 3),
      child: Wrap(
        spacing: 12,
        runSpacing: 3,
        children: [
          Text(field.label, style: tasks.controlText),
          _ConflictValue(
            label: context.l10n.taskDetailsConflictBase,
            value: field.baseline,
          ),
          _ConflictValue(
            label: context.l10n.taskDetailsConflictCurrent,
            value: field.current,
          ),
          if (field.draft case final draft?)
            _ConflictValue(
              label: context.l10n.taskDetailsConflictDraft,
              value: draft,
            ),
        ],
      ),
    );
  }
}

final class _ConflictValue extends StatelessWidget {
  const _ConflictValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      style: context.tasksTheme.metaText,
      children: [
        TextSpan(
          text: '$label: ',
          style: TextStyle(color: context.colors.onSurfaceVariant),
        ),
        TextSpan(
          text: value.isEmpty ? '—' : value,
          style: TextStyle(color: context.colors.onSurface),
        ),
      ],
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}
