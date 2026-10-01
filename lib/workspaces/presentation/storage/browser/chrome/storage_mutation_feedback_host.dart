import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Trwałe podsumowanie mutacji i pełna diagnostyka wyników zbiorczych.
final class StorageMutationFeedbackHost extends StatelessWidget {
  const StorageMutationFeedbackHost({
    required this.errorListenable,
    required this.onRefresh,
    required this.onDismiss,
    super.key,
  });

  final ValueListenable<StorageMutationError?> errorListenable;
  final VoidCallback onRefresh;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: errorListenable,
    builder: (context, error, _) => error == null
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StorageErrorBanner(
                message: error.message,
                code: error.code,
                traceId: error.traceId,
                retryAfterUtc: error.apiError?.retryAfterUtc,
                onRetry: error.onRetry,
                onRefresh: onRefresh,
                onDismiss: onDismiss,
              ),
              if (error.apiError case final apiError?)
                _StorageApiErrorDetails(error: apiError),
              if (error.apiErrorsById.isNotEmpty)
                _StorageBulkErrorDetails(
                  errors: error.apiErrorsById,
                  itemLabels: error.itemLabels,
                ),
              if (error.notAttemptedIds.isNotEmpty)
                _StorageNotAttemptedDetails(
                  ids: error.notAttemptedIds,
                  itemLabels: error.itemLabels,
                ),
            ],
          ),
  );
}

final class _StorageApiErrorDetails extends StatelessWidget {
  const _StorageApiErrorDetails({required this.error});

  final ApiError error;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final details = <String>[
      if (error.apiCode case final code?)
        '${context.l10n.taskDetailsErrorCode}: $code',
      if (error.contractCode case final code?)
        '${context.l10n.taskDetailsErrorContractCode}: $code',
      if (error.backendCode case final code?)
        '${context.l10n.taskDetailsErrorBackendCode}: $code',
      if (error.statusCode case final status?)
        '${context.l10n.taskDetailsErrorHttpStatus}: $status',
      if (error.traceId case final trace?)
        context.l10n.tasksViewErrorTraceId(trace),
      for (final field in error.fields.entries)
        '${field.key}: ${field.value.join(', ')}',
    ];
    if (details.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: common.sectionGap),
      child: ExpansionTile(
        dense: true,
        tilePadding: EdgeInsets.symmetric(horizontal: common.controlGap),
        iconColor: context.colors.onSurfaceVariant,
        collapsedIconColor: context.colors.onSurfaceVariant,
        textColor: context.colors.onSurface,
        collapsedTextColor: context.colors.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(common.controlRadius),
          side: BorderSide(color: context.colors.outlineVariant),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(common.controlRadius),
          side: BorderSide(color: context.colors.outlineVariant),
        ),
        title: Text(
          context.l10n.tasksGlobalSearchShowDiagnostics,
          style: common.controlText,
        ),
        children: [
          SizedBox(
            height: 120,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(common.controlGap),
              child: SelectableText(
                details.join('\n'),
                style: common.metaText.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _StorageBulkErrorDetails extends StatefulWidget {
  const _StorageBulkErrorDetails({
    required this.errors,
    required this.itemLabels,
  });

  final Map<String, ApiError> errors;
  final Map<String, String> itemLabels;

  @override
  State<_StorageBulkErrorDetails> createState() =>
      _StorageBulkErrorDetailsState();
}

final class _StorageBulkErrorDetailsState
    extends State<_StorageBulkErrorDetails> {
  late List<MapEntry<String, ApiError>> _entries;

  @override
  void initState() {
    super.initState();
    _prepareEntries();
  }

  @override
  void didUpdateWidget(covariant _StorageBulkErrorDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.errors, widget.errors) ||
        !identical(oldWidget.itemLabels, widget.itemLabels)) {
      _prepareEntries();
    }
  }

  void _prepareEntries() {
    _entries = List<MapEntry<String, ApiError>>.unmodifiable(
      widget.errors.entries,
    );
  }

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: common.sectionGap),
      child: ExpansionTile(
        dense: true,
        tilePadding: EdgeInsets.symmetric(horizontal: common.controlGap),
        title: Text(context.l10n.storageBulkItemFailures(_entries.length)),
        children: [
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return _StorageBulkErrorRow(
                  fileId: entry.key,
                  label: widget.itemLabels[entry.key],
                  error: entry.value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final class _StorageBulkErrorRow extends StatelessWidget {
  const _StorageBulkErrorRow({
    required this.fileId,
    required this.label,
    required this.error,
  });

  final String fileId;
  final String? label;
  final ApiError error;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final diagnostics = <String>[
      if (error.apiCode case final code?)
        '${context.l10n.taskDetailsErrorCode}: $code',
      if (error.contractCode case final code?)
        '${context.l10n.taskDetailsErrorContractCode}: $code',
      if (error.backendCode case final code?)
        '${context.l10n.taskDetailsErrorBackendCode}: $code',
      if (error.statusCode case final status?)
        '${context.l10n.taskDetailsErrorHttpStatus}: $status',
      if (error.traceId case final trace?)
        context.l10n.tasksViewErrorTraceId(trace),
      for (final field in error.fields.entries)
        '${field.key}: ${field.value.join(', ')}',
    ];
    return Padding(
      padding: EdgeInsets.fromLTRB(
        common.controlGap,
        common.tightGap,
        common.controlGap,
        common.tightGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label case final value?) Text(value, style: common.controlText),
          SelectableText(fileId, style: common.metaText),
          Text(error.message, style: common.controlText),
          if (diagnostics.isNotEmpty)
            SelectableText(
              diagnostics.join('\n'),
              style: common.metaText,
            ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

final class _StorageNotAttemptedDetails extends StatefulWidget {
  const _StorageNotAttemptedDetails({
    required this.ids,
    required this.itemLabels,
  });

  final List<String> ids;
  final Map<String, String> itemLabels;

  @override
  State<_StorageNotAttemptedDetails> createState() =>
      _StorageNotAttemptedDetailsState();
}

final class _StorageNotAttemptedDetailsState
    extends State<_StorageNotAttemptedDetails> {
  late String _details;

  @override
  void initState() {
    super.initState();
    _prepareDetails();
  }

  @override
  void didUpdateWidget(covariant _StorageNotAttemptedDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.ids, widget.ids) ||
        !identical(oldWidget.itemLabels, widget.itemLabels)) {
      _prepareDetails();
    }
  }

  void _prepareDetails() {
    _details = widget.ids
        .map((id) {
          final label = widget.itemLabels[id];
          return label == null ? id : '$label — $id';
        })
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: common.sectionGap),
      child: ExpansionTile(
        dense: true,
        tilePadding: EdgeInsets.symmetric(horizontal: common.controlGap),
        title: Text(context.l10n.storageBulkNotAttempted(widget.ids.length)),
        children: [
          SizedBox(
            height: 120,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(common.controlGap),
              child: SelectableText(_details, style: common.metaText),
            ),
          ),
        ],
      ),
    );
  }
}
