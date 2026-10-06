import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Pokazuje komunikat oraz komplet diagnostyki, zachowując ograniczony viewport.
final class StorageFolderMutationErrorView extends StatelessWidget {
  const StorageFolderMutationErrorView({
    required this.error,
    this.isRestoring = false,
    super.key,
  });

  final ApiError error;
  final bool isRestoring;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMd(locale).add_Hm();
    return Container(
      padding: EdgeInsets.all(common.controlGap),
      decoration: BoxDecoration(
        color: context.colors.errorContainer.withValues(alpha: .22),
        border: Border.all(color: context.colors.error.withValues(alpha: .48)),
        borderRadius: BorderRadius.circular(common.controlRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 260),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                liveRegion: true,
                child: SelectableText(
                  switch (isRestoring
                      ? (error.contractCode ?? error.apiCode)
                      : null) {
                    'storage.folder_name_conflict' =>
                      context.l10n.storageRestoreFolderNameConflict,
                    'storage.folder_parent_deleted' =>
                      context.l10n.storageRestoreFolderParentDeleted,
                    'storage.folder_version_conflict' =>
                      context.l10n.storageRestoreFolderVersionConflict,
                    _ =>
                      error.message.isEmpty
                          ? context.l10n.storageActionFailed
                          : error.message,
                  },
                  style: common.dataStrongText.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ),
              SizedBox(height: common.tightGap),
              Wrap(
                spacing: common.tightGap,
                runSpacing: common.tightGap,
                children: [
                  if (error.statusCode case final status?)
                    Text(
                      '${context.l10n.taskDetailsErrorHttpStatus}: $status',
                      style: common.metaText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  if (error.apiCode case final apiCode?)
                    SelectableText(
                      '${context.l10n.taskDetailsErrorCode}: $apiCode',
                      style: common.metaText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  if (error.contractCode case final contractCode?)
                    SelectableText(
                      '${context.l10n.taskDetailsErrorContractCode}: $contractCode',
                      style: common.metaText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  if (error.backendCode case final backend?)
                    Text(
                      '${context.l10n.taskDetailsErrorBackendCode}: $backend',
                      style: common.metaText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  if (error.traceId case final trace?)
                    SelectableText(
                      '${context.l10n.taskDetailsErrorTraceId}: $trace',
                      style: common.metaText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  for (final field in error.fields.entries)
                    SelectableText(
                      '${field.key}: ${field.value.join(' · ')}',
                      style: common.metaText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  if (error.retryAfterUtc case final retryAfter?)
                    Text(
                      context.l10n.taskDetailsErrorRetryAfter(
                        date.format(retryAfter.toLocal()),
                      ),
                      style: common.metaText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
