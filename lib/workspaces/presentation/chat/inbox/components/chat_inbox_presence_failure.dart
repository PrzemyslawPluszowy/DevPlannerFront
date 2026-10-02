import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wspólny komunikat błędu batchowego presence nad wierszami inboxa.
final class ChatInboxPresenceFailure extends StatelessWidget {
  const ChatInboxPresenceFailure({
    required this.error,
    required this.retryCountdownSeconds,
    required this.onRetry,
    super.key,
  });

  final ApiError error;
  final int retryCountdownSeconds;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final diagnostics = <String>[
      if (error.apiCode case final code? when code.isNotEmpty) code,
      if (error.statusCode case final status?) 'HTTP $status',
      if (error.traceId case final trace? when trace.isNotEmpty)
        'traceId: $trace',
    ];
    final coolingDown = retryCountdownSeconds > 0;
    return Material(
      color: chat.selectedSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p12,
          vertical: Sizes.p8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Symbols.error_outline, size: 16, color: chat.metadataText),
            const SizedBox(width: Sizes.p8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.chatInboxPresenceFailure,
                    style: chat.metadataStyle.copyWith(
                      color: chat.incomingText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (diagnostics.isNotEmpty)
                    Text(
                      diagnostics.join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: chat.metadataStyle.copyWith(
                        color: chat.metadataText,
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: coolingDown ? null : onRetry,
              child: Text(
                coolingDown
                    ? context.l10n.tasksGlobalSearchRetryAfter(
                        retryCountdownSeconds,
                      )
                    : context.l10n.chatInboxRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
