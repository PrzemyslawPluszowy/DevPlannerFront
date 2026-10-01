import 'dart:async';

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
final class StorageErrorBanner extends StatefulWidget {
  /// Tworzy banner błędu.
  const StorageErrorBanner({
    required this.message,
    required this.onRefresh,
    this.code,
    this.traceId,
    this.retryAfterUtc,
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

  /// Termin przed którym jawne retry jest wyłączone.
  final DateTime? retryAfterUtc;

  /// Ukrycie komunikatu; brak akcji oznacza, że błąd wymaga naprawy.
  final VoidCallback? onDismiss;

  @override
  State<StorageErrorBanner> createState() => _StorageErrorBannerState();
}

final class _StorageErrorBannerState extends State<StorageErrorBanner> {
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _scheduleRetryEnablement();
  }

  @override
  void didUpdateWidget(covariant StorageErrorBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.retryAfterUtc != widget.retryAfterUtc) {
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
    _retryTimer = null;
    final deadline = widget.retryAfterUtc?.toUtc();
    if (deadline == null) return;
    final delay = deadline.difference(DateTime.now().toUtc());
    if (delay.isNegative || delay == Duration.zero) return;
    _retryTimer = Timer(delay, () {
      if (!mounted) return;
      setState(() => _retryTimer = null);
    });
  }

  bool get _retryBlocked {
    final deadline = widget.retryAfterUtc?.toUtc();
    return deadline != null && DateTime.now().toUtc().isBefore(deadline);
  }

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    final retryDeadline = widget.retryAfterUtc;
    final meta = [
      ?widget.code,
      if (widget.traceId case final traceId?)
        context.l10n.tasksViewErrorTraceId(traceId),
      if (_retryBlocked && retryDeadline != null)
        context.l10n.taskDetailsErrorRetryAfter(
          retryDeadline.toLocal().toString(),
        ),
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
      child: _StorageErrorBannerLayout(
        message: widget.message,
        metadata: meta,
        retryBlocked: _retryBlocked,
        onRetry: widget.onRetry,
        onRefresh: widget.onRefresh,
        onDismiss: widget.onDismiss,
      ),
    );
  }
}

final class _StorageErrorBannerLayout extends StatelessWidget {
  const _StorageErrorBannerLayout({
    required this.message,
    required this.metadata,
    required this.retryBlocked,
    required this.onRetry,
    required this.onRefresh,
    required this.onDismiss,
  });

  final String message;
  final String metadata;
  final bool retryBlocked;
  final VoidCallback? onRetry;
  final VoidCallback onRefresh;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final common = context.filesTheme.common;
      final content = _StorageErrorBannerMessage(
        message: message,
        metadata: metadata,
      );
      final actions = _StorageErrorBannerActions(
        retryBlocked: retryBlocked,
        onRetry: onRetry,
        onRefresh: onRefresh,
        onDismiss: onDismiss,
      );
      if (constraints.maxWidth < 680) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            SizedBox(height: common.tightGap),
            Align(alignment: Alignment.centerRight, child: actions),
          ],
        );
      }
      return Row(
        children: [
          Expanded(child: content),
          SizedBox(width: common.controlGap),
          actions,
        ],
      );
    },
  );
}

final class _StorageErrorBannerMessage extends StatelessWidget {
  const _StorageErrorBannerMessage({
    required this.message,
    required this.metadata,
  });

  final String message;
  final String metadata;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: common.tightGap),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: colors.error,
          ),
        ),
        SizedBox(width: common.controlGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                liveRegion: true,
                label: message,
                child: ExcludeSemantics(
                  child: Text(
                    message,
                    style: common.controlText.copyWith(color: colors.error),
                  ),
                ),
              ),
              if (metadata.isNotEmpty) ...[
                SizedBox(height: common.tightGap / 2),
                SelectableText(
                  metadata,
                  style: common.metaText.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

final class _StorageErrorBannerActions extends StatelessWidget {
  const _StorageErrorBannerActions({
    required this.retryBlocked,
    required this.onRetry,
    required this.onRefresh,
    required this.onDismiss,
  });

  final bool retryBlocked;
  final VoidCallback? onRetry;
  final VoidCallback onRefresh;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    final actionStyle = TextButton.styleFrom(
      foregroundColor: colors.primary,
      padding: EdgeInsets.symmetric(
        horizontal: common.controlGap,
        vertical: common.tightGap,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(common.controlRadius),
      ),
      textStyle: common.controlText,
    );
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: common.tightGap,
      runSpacing: common.tightGap,
      children: [
        if (onRetry case final retry?)
          TextButton(
            style: actionStyle,
            onPressed: retryBlocked ? null : retry,
            child: Text(context.l10n.tasksViewErrorRetry),
          ),
        TextButton(
          style: actionStyle,
          onPressed: onRefresh,
          child: Text(context.l10n.tasksViewErrorRefresh),
        ),
        if (onDismiss case final dismiss?)
          IconButton(
            onPressed: dismiss,
            iconSize: 16,
            visualDensity: VisualDensity.compact,
            tooltip: context.l10n.tasksViewErrorDismissTooltip,
            style: IconButton.styleFrom(
              foregroundColor: colors.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(common.controlRadius),
              ),
            ),
            icon: const Icon(Icons.close_rounded),
          ),
      ],
    );
  }
}
