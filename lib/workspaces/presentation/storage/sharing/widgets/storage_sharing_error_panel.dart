import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Trwały błąd udostępniania z bezpiecznym odświeżeniem listy GET.
final class StorageSharingErrorPanel extends StatefulWidget {
  const StorageSharingErrorPanel({
    required this.error,
    this.onRefresh,
    this.isRefreshing = false,
    super.key,
  });

  final ApiError error;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  @override
  State<StorageSharingErrorPanel> createState() =>
      _StorageSharingErrorPanelState();
}

final class _StorageSharingErrorPanelState
    extends State<StorageSharingErrorPanel> {
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _scheduleRetryEnablement();
  }

  @override
  void didUpdateWidget(covariant StorageSharingErrorPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error.retryAfterUtc != widget.error.retryAfterUtc) {
      _scheduleRetryEnablement();
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  void _scheduleRetryEnablement() {
    _retryTimer?.cancel();
    final deadline = widget.error.retryAfterUtc?.toUtc();
    if (deadline == null) return;
    final delay = deadline.difference(DateTime.now().toUtc());
    if (delay <= Duration.zero) return;
    _retryTimer = Timer(delay, () {
      if (!mounted) return;
      setState(() => _retryTimer = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final common = context.filesTheme.common;
    final error = widget.error;
    final message = error.message.isEmpty
        ? context.l10n.storageActionFailed
        : error.message;
    final deadline = error.retryAfterUtc?.toUtc();
    final retryBlocked =
        deadline != null && DateTime.now().toUtc().isBefore(deadline);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(common.controlGap),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: .22),
        border: Border.all(color: colors.error.withValues(alpha: .48)),
        borderRadius: BorderRadius.circular(common.controlRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded, color: colors.error, size: 18),
              SizedBox(width: common.tightGap),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: SelectableText(
                    message,
                    style: common.dataStrongText.copyWith(color: colors.error),
                  ),
                ),
              ),
              if (widget.onRefresh != null)
                TextButton(
                  onPressed: widget.isRefreshing || retryBlocked
                      ? null
                      : widget.onRefresh,
                  child: Text(context.l10n.workspacesRefresh),
                ),
            ],
          ),
          if (_hasMetadata(error))
            Padding(
              padding: EdgeInsets.only(
                left: common.controlGap * 2,
                top: common.tightGap,
              ),
              child: _StorageSharingErrorMetadata(error: error),
            ),
        ],
      ),
    );
  }

  bool _hasMetadata(ApiError error) =>
      error.apiCode != null ||
      error.contractCode != null ||
      error.backendCode != null ||
      error.statusCode != null ||
      error.traceId != null ||
      error.fields.isNotEmpty ||
      error.retryAfterUtc != null;
}

final class _StorageSharingErrorMetadata extends StatelessWidget {
  const _StorageSharingErrorMetadata({required this.error});

  final ApiError error;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.onSurfaceVariant;
    final textStyle = context.filesTheme.common.metaText.copyWith(color: color);
    final date = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            if (error.statusCode case final status?)
              Text(
                '${context.l10n.taskDetailsErrorHttpStatus}: $status',
                style: textStyle,
              ),
            if (error.apiCode case final code?)
              Text(
                '${context.l10n.taskDetailsErrorCode}: $code',
                style: textStyle,
              ),
            if (error.contractCode case final code?)
              Text(
                '${context.l10n.taskDetailsErrorContractCode}: $code',
                style: textStyle,
              ),
            if (error.backendCode case final code?)
              Text(
                '${context.l10n.taskDetailsErrorBackendCode}: $code',
                style: textStyle,
              ),
            if (error.traceId case final trace?)
              SelectableText(
                '${context.l10n.taskDetailsErrorTraceId}: $trace',
                style: textStyle,
              ),
          ],
        ),
        if (error.fields.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(context.l10n.taskDetailsErrorFields, style: textStyle),
          for (final field in error.fields.entries)
            SelectableText(
              '${field.key}: ${field.value.join(' · ')}',
              style: textStyle,
            ),
        ],
        if (error.retryAfterUtc case final retryAfter?)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              context.l10n.taskDetailsErrorRetryAfter(
                date.format(retryAfter.toLocal()),
              ),
              style: textStyle,
            ),
          ),
      ],
    );
  }
}
