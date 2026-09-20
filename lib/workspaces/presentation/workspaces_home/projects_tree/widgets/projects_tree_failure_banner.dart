import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/cubit/projects_tree_cubit.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Trwały komunikat nieudanej operacji na projekcie.
///
/// Błąd rollbacku nie znika w SnackBarze: banner pozostaje w drzewie do czasu
/// ponowienia albo jawnego ukrycia i pokazuje operację, przyczynę, kod backendu
/// oraz `traceId`. Nie zawiera sekretów ani treści żądań.
class ProjectsTreeFailureBanner extends StatelessWidget {
  const ProjectsTreeFailureBanner({
    required this.failure,
    required this.onRetry,
    required this.onDismiss,
    super.key,
  });

  /// Opis nieudanej operacji.
  final ProjectsTreeFailure failure;

  /// Ponowienie ostatniej intencji; `null`, gdy nie jest bezpieczne.
  final VoidCallback? onRetry;

  /// Ukrycie komunikatu bez zmiany stanu projektów.
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final details = <String>[
      if (failure.rolledBack) l10n.projectsFailureRolledBack,
      _kindMessage(l10n, failure.kind),
      if (failure.backendMessage case final message?
          when message.trim().isNotEmpty)
        l10n.projectsFailureBackendMessage(message.trim()),
      if (failure.code case final code? when code.trim().isNotEmpty)
        l10n.projectsFailureCode(code.trim()),
      if (failure.traceId case final traceId? when traceId.trim().isNotEmpty)
        l10n.projectsFailureTraceId(traceId.trim()),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.errorContainer.withValues(alpha: .35),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: colors.error.withValues(alpha: .5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Symbols.error_outline_rounded,
                  size: 15,
                  color: colors.error,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    l10n.projectsFailureTitle,
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.projectsFailureDismiss,
                  onPressed: onDismiss,
                  icon: const Icon(Symbols.close_rounded, size: 15),
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 24,
                    height: 24,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            Text(
              _operationMessage(l10n, failure.operation),
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurface,
              ),
            ),
            for (final detail in details)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  detail,
                  style: context.text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            if (onRetry case final retry?)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: retry,
                    icon: const Icon(Symbols.refresh_rounded, size: 14),
                    label: Text(l10n.projectsFailureRetry),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _operationMessage(
    AppLocalizations l10n,
    ProjectsTreeOperation operation,
  ) => switch (operation) {
    ProjectsTreeOperation.pin => l10n.projectsFailureOperationPin,
    ProjectsTreeOperation.hide => l10n.projectsFailureOperationHide,
    ProjectsTreeOperation.preference => l10n.projectsFailureOperationPreference,
    ProjectsTreeOperation.reorder => l10n.projectsFailureOperationReorder,
    ProjectsTreeOperation.archive => l10n.projectsFailureOperationArchive,
    ProjectsTreeOperation.restore => l10n.projectsFailureOperationRestore,
    ProjectsTreeOperation.deletePermanently =>
      l10n.projectsFailureOperationDelete,
    ProjectsTreeOperation.createTemplate =>
      l10n.projectsFailureOperationTemplate,
    ProjectsTreeOperation.leaveMembership => l10n.projectsFailureOperationLeave,
    ProjectsTreeOperation.loadSections => l10n.projectsFailureOperationSections,
  };

  static String _kindMessage(
    AppLocalizations l10n,
    ProjectsTreeFailureKind kind,
  ) => switch (kind) {
    ProjectsTreeFailureKind.unavailable => l10n.projectsFailureKindUnavailable,
    ProjectsTreeFailureKind.unauthorized =>
      l10n.projectsFailureKindUnauthorized,
    ProjectsTreeFailureKind.forbidden => l10n.projectsFailureKindForbidden,
    ProjectsTreeFailureKind.notFound => l10n.projectsFailureKindNotFound,
    ProjectsTreeFailureKind.conflict => l10n.projectsFailureKindConflict,
    ProjectsTreeFailureKind.validation => l10n.projectsFailureKindValidation,
    ProjectsTreeFailureKind.rateLimited => l10n.projectsFailureKindRateLimited,
    ProjectsTreeFailureKind.server => l10n.projectsFailureKindServer,
    ProjectsTreeFailureKind.transport => l10n.projectsFailureKindTransport,
    ProjectsTreeFailureKind.invalidIntent =>
      l10n.projectsFailureKindInvalidIntent,
    ProjectsTreeFailureKind.unknown => l10n.projectsFailureKindUnknown,
  };
}
