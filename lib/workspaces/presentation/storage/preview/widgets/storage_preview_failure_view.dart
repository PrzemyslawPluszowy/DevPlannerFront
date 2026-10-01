import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Trwały błąd odczytu z diagnostyką i ponowieniem respektującym Retry-After.
final class StoragePreviewFailureView extends StatefulWidget {
  const StoragePreviewFailureView({
    required this.message,
    required this.onRetry,
    this.error,
    this.title,
    super.key,
  });

  final String message;
  final ApiError? error;
  final String? title;
  final Future<void> Function() onRetry;

  @override
  State<StoragePreviewFailureView> createState() =>
      _StoragePreviewFailureViewState();
}

final class _StoragePreviewFailureViewState
    extends State<StoragePreviewFailureView> {
  final _retryAllowed = ValueNotifier<bool>(true);
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _scheduleRetry();
  }

  @override
  void didUpdateWidget(StoragePreviewFailureView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error?.retryAfterUtc != widget.error?.retryAfterUtc) {
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    final remaining = widget.error?.retryAfterUtc?.difference(
      DateTime.now().toUtc(),
    );
    _retryAllowed.value = remaining == null || remaining <= Duration.zero;
    if (!_retryAllowed.value) {
      _retryTimer = Timer(remaining!, () => _retryAllowed.value = true);
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _retryAllowed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.error;
    final retryAfter = error?.retryAfterUtc;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MergeSemantics(
                child: Semantics(
                  container: true,
                  liveRegion: widget.title == null,
                  child: SelectableText(
                    widget.title ??
                        context.l10n.storagePreviewError(widget.message),
                    style: context.tasksTheme.dataStrongText,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (widget.title != null)
                MergeSemantics(
                  child: Semantics(
                    container: true,
                    liveRegion: true,
                    child: SelectableText(
                      widget.message,
                      style: context.tasksTheme.controlText,
                    ),
                  ),
                ),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (error?.apiCode case final code?)
                    _Metadata(
                      label: context.l10n.taskDetailsErrorCode,
                      value: code,
                    ),
                  if (error?.contractCode case final code?)
                    _Metadata(
                      label: context.l10n.taskDetailsErrorContractCode,
                      value: code,
                    ),
                  if (error?.backendCode case final code?)
                    _Metadata(
                      label: context.l10n.taskDetailsErrorBackendCode,
                      value: '$code',
                    ),
                  if (error?.statusCode case final status?)
                    _Metadata(
                      label: context.l10n.taskDetailsErrorHttpStatus,
                      value: '$status',
                    ),
                  if (error?.traceId case final trace?)
                    _Metadata(
                      label: context.l10n.taskDetailsErrorTraceId,
                      value: trace,
                    ),
                ],
              ),
              if (error != null)
                for (final entry in error.fields.entries)
                  _Metadata(label: entry.key, value: entry.value.join(' · ')),
              if (retryAfter != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    context.l10n.taskDetailsErrorRetryAfter(
                      DateFormat.yMMMd(
                        Localizations.localeOf(context).toLanguageTag(),
                      ).add_Hm().format(retryAfter.toLocal()),
                    ),
                    style: context.tasksTheme.metaText,
                  ),
                ),
              const SizedBox(height: 12),
              ValueListenableBuilder<bool>(
                valueListenable: _retryAllowed,
                builder: (context, allowed, _) => OutlinedButton.icon(
                  onPressed: allowed ? () => unawaited(widget.onRetry()) : null,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(context.l10n.retry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _Metadata extends StatelessWidget {
  const _Metadata({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SelectableText(
    '${label.trim()}: $value',
    style: context.tasksTheme.metaText,
  );
}
