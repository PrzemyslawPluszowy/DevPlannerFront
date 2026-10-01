import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Pełna, przewijana przyczyna błędu; nie usuwa wybranych plików ani szkicu.
final class ChatAttachmentUploadError extends StatelessWidget {
  const ChatAttachmentUploadError({required this.error, super.key});

  final ApiError? error;

  @override
  Widget build(BuildContext context) {
    final failure = error;
    final retryAfter = failure?.retryAfterUtc?.toLocal();
    final material = MaterialLocalizations.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 120),
      child: SingleChildScrollView(
        child: Semantics(
          liveRegion: true,
          child: DefaultTextStyle(
            style: context.text.labelMedium!.copyWith(
              color: context.chatTheme.error,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  failure?.message.isNotEmpty == true
                      ? failure!.message
                      : context.l10n.chatAttachmentUploadFailed,
                ),
                if (failure?.apiCode case final code?)
                  SelectableText(context.l10n.tasksViewErrorApiCode(code)),
                if (failure?.contractCode case final code?)
                  SelectableText(context.l10n.tasksViewErrorContractCode(code)),
                if (failure?.backendCode case final code?)
                  SelectableText(context.l10n.tasksViewErrorBackendCode(code)),
                if (failure?.statusCode case final status?)
                  SelectableText(context.l10n.tasksViewErrorHttpStatus(status)),
                if (failure?.traceId case final trace?)
                  SelectableText(context.l10n.tasksViewErrorTraceId(trace)),
                for (final entry
                    in failure?.fields.entries ??
                        const <MapEntry<String, List<String>>>[])
                  SelectableText('${entry.key}: ${entry.value.join('\n')}'),
                if (retryAfter != null)
                  SelectableText(
                    context.l10n.tasksViewErrorRetryAfter(
                      '${material.formatShortDate(retryAfter)} '
                      '${material.formatTimeOfDay(TimeOfDay.fromDateTime(retryAfter))}',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
