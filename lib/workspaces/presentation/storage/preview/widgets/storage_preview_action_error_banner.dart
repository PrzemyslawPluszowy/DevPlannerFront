import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Compact in-preview feedback for a failed download action.
final class StoragePreviewActionErrorBanner extends StatefulWidget {
  const StoragePreviewActionErrorBanner({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final ApiError error;
  final VoidCallback onRetry;

  @override
  State<StoragePreviewActionErrorBanner> createState() =>
      _StoragePreviewActionErrorBannerState();
}

final class _StoragePreviewActionErrorBannerState
    extends State<StoragePreviewActionErrorBanner> {
  final _retryAllowed = ValueNotifier<bool>(true);
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _scheduleRetry();
  }

  @override
  void didUpdateWidget(StoragePreviewActionErrorBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error.retryAfterUtc != widget.error.retryAfterUtc) {
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    final remaining = widget.error.retryAfterUtc?.difference(
      DateTime.now().toUtc(),
    );
    _retryAllowed.value = remaining == null || remaining <= Duration.zero;
    if (!_retryAllowed.value) {
      _retryTimer = Timer(remaining!, () => _retryAllowed.value = true);
    }
  }

  String _message(BuildContext context, ApiError error) =>
      switch (error.apiCode) {
        'storage.action_busy' => context.l10n.storageActionBusy,
        'storage.action_canceled' => context.l10n.storageActionCanceled,
        'storage.action_failed' => context.l10n.storageActionFailed,
        _ => error.message,
      };

  @override
  void dispose() {
    _retryTimer?.cancel();
    _retryAllowed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.error;
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final retryAfter = error.retryAfterUtc;
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: tasks.commandBarSurface,
        border: Border(
          bottom: BorderSide(color: colors.error.withValues(alpha: .55)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Symbols.error_outline_rounded, color: colors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  _message(context, error),
                  style: tasks.controlText,
                ),
                Wrap(
                  spacing: 14,
                  runSpacing: 3,
                  children: [
                    if (error.apiCode case final code?)
                      _StoragePreviewActionMetadata(
                        label: context.l10n.taskDetailsErrorCode,
                        value: code,
                      ),
                    if (error.contractCode case final code?)
                      _StoragePreviewActionMetadata(
                        label: context.l10n.taskDetailsErrorContractCode,
                        value: code,
                      ),
                    if (error.statusCode case final status?)
                      _StoragePreviewActionMetadata(
                        label: context.l10n.taskDetailsErrorHttpStatus,
                        value: '$status',
                      ),
                    if (error.traceId case final trace?)
                      _StoragePreviewActionMetadata(
                        label: context.l10n.taskDetailsErrorTraceId,
                        value: trace,
                      ),
                    for (final entry in error.fields.entries)
                      _StoragePreviewActionMetadata(
                        label: entry.key,
                        value: entry.value.join(' · '),
                      ),
                  ],
                ),
                if (retryAfter != null)
                  Text(
                    context.l10n.taskDetailsErrorRetryAfter(
                      dateFormat.format(retryAfter.toLocal()),
                    ),
                    style: tasks.metaText.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<bool>(
            valueListenable: _retryAllowed,
            builder: (context, allowed, _) => TextButton.icon(
              onPressed: allowed ? widget.onRetry : null,
              icon: const Icon(Symbols.refresh_rounded, size: 16),
              label: Text(context.l10n.retry),
            ),
          ),
        ],
      ),
    );
  }
}

final class _StoragePreviewActionMetadata extends StatelessWidget {
  const _StoragePreviewActionMetadata({
    required this.label,
    required this.value,
  });

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
        TextSpan(text: value),
      ],
    ),
  );
}
