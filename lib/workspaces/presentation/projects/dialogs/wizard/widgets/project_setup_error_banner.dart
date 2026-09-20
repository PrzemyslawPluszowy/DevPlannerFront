import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Trwały banner błędu kreatora projektu.
///
/// Błąd nigdy nie ginie w SnackBarze: zostaje przy podsumowaniu wraz z kodem
/// Backendu i `traceId`, a użytkownik może skopiować diagnostykę bez sekretów.
/// Banner nie zamyka kreatora i nie kasuje draftu.
class ProjectSetupErrorBanner extends StatelessWidget {
  /// Tworzy banner błędu.
  const ProjectSetupErrorBanner({
    required this.error,
    required this.onRetry,
    this.retryLabel,
    this.contextMessage,
    super.key,
  });

  /// Błąd zwrócony przez port kreatora.
  final ApiError error;

  /// Ponowienie operacji tym samym kluczem idempotencji.
  final Future<void> Function() onRetry;

  /// Etykieta akcji ponowienia.
  final String? retryLabel;

  /// Zdanie opisujące kontekst błędu, właściwe dla kodu Backendu.
  final String? contextMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final code = error.apiCode ?? error.backendCode?.toString();
    final traceId = error.traceId;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: colors.error.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Symbols.error, size: 18, color: colors.onErrorContainer),
              Gaps.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.projectSetupErrorTitle,
                      style: context.text.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onErrorContainer,
                      ),
                    ),
                    Gaps.h4,
                    Text(
                      contextMessage ?? error.message,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onErrorContainer,
                      ),
                    ),
                    if (code != null) ...[
                      Gaps.h6,
                      Text(
                        l10n.projectSetupErrorCodeLabel(code),
                        style: context.text.labelSmall?.copyWith(
                          color: colors.onErrorContainer,
                        ),
                      ),
                    ],
                    if (traceId != null && traceId.isNotEmpty) ...[
                      Gaps.h2,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.projectSetupErrorTraceIdLabel(traceId),
                              style: context.text.labelSmall?.copyWith(
                                color: colors.onErrorContainer,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.projectSetupErrorCodeLabel(
                              code ?? '-',
                            ),
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Symbols.content_copy, size: 15),
                            onPressed: () => unawaited(
                              copyProjectSetupDiagnostics(
                                'code=$code traceId=$traceId',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Gaps.h8,
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.tonal(
              onPressed: onRetry,
              child: Text(retryLabel ?? l10n.projectSetupRetryButton),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kopiuje diagnostykę błędu do schowka bez logowania jej treści.
Future<void> copyProjectSetupDiagnostics(String value) =>
    Clipboard.setData(ClipboardData(text: value));

/// Zdanie opisujące kontekst błędu na podstawie stabilnego kodu Backendu.
///
/// Nieznany kod zwraca `null`, żeby UI pokazał komunikat serwera zamiast
/// zgadywać przyczynę.
String? projectSetupErrorContext(BuildContext context, ApiError error) {
  final l10n = context.l10n;
  return switch (error.apiCode) {
    ProjectSetupWizardErrorCodes.idempotencyKeyConflict =>
      l10n.projectSetupErrorConflictIdempotency,
    ProjectSetupWizardErrorCodes.idempotencyInProgress =>
      l10n.projectSetupErrorConflictInProgress,
    ProjectSetupWizardErrorCodes.templateVersionConflict =>
      l10n.projectSetupErrorTemplateVersion,
    _ => switch (error.type) {
      ApiErrorType.forbidden => l10n.projectSetupErrorForbidden,
      ApiErrorType.notFound => l10n.projectSetupErrorNotFound,
      ApiErrorType.validation => l10n.projectSetupErrorValidation,
      ApiErrorType.canceled => l10n.projectSetupErrorCancelled,
      ApiErrorType.conflict => l10n.projectSetupErrorValidation,
      _ => null,
    },
  };
}
