import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';

/// Status zawartosci ekranu/modalu opartego o asynchroniczne ladowanie danych.
enum AppAsyncViewStatus { initial, loading, loaded, error }

/// Uniwersalny renderer stanów `initial/loading/loaded/error`.
///
/// Widget nie zna BLoC-a i moze byc karmiony dowolnym source of truth.
/// Dzieki temu w feature'ach mapujemy stan BLoC-a na [AppAsyncViewStatus],
/// a wyglad pozostaje wspolny i powtarzalny.
class AppAsyncStateBody extends StatelessWidget {
  const AppAsyncStateBody({
    required this.status,
    required this.loadedBuilder,
    super.key,
    this.initialBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.errorMessage,
    this.onRetry,
  });

  final AppAsyncViewStatus status;
  final WidgetBuilder loadedBuilder;
  final WidgetBuilder? initialBuilder;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext context, String? errorMessage)?
  errorBuilder;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      AppAsyncViewStatus.initial =>
        initialBuilder?.call(context) ?? const SizedBox.shrink(),
      AppAsyncViewStatus.loading =>
        loadingBuilder?.call(context) ?? const _DefaultLoadingBody(),
      AppAsyncViewStatus.loaded => loadedBuilder(context),
      AppAsyncViewStatus.error =>
        errorBuilder?.call(context, errorMessage) ??
            _DefaultErrorBody(
              message:
                  errorMessage ?? 'Wystapil blad podczas pobierania danych.',
              onRetry: onRetry,
            ),
    };
  }
}

class _DefaultLoadingBody extends StatelessWidget {
  /// Tworzy domyslny widok ladowania.
  const _DefaultLoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppSpinner());
  }
}

class _DefaultErrorBody extends StatelessWidget {
  const _DefaultErrorBody({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p16),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: .34),
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(color: colors.error.withValues(alpha: .28)),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline_rounded, color: colors.error),
              Gaps.w8,
              Text(
                'Nie udalo sie zaladowac danych',
                style: context.text.titleSmall?.copyWith(
                  fontWeight: .w700,
                  color: colors.error,
                ),
              ),
            ],
          ),
          Gaps.h8,
          Text(
            message,
            style: context.text.bodyMedium?.copyWith(
              color: colors.onSurface,
            ),
          ),
          if (onRetry case final retry) ...[
            Gaps.h12,
            FilledButton.icon(
              onPressed: retry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Ponow probe'),
            ),
          ],
        ],
      ),
    );
  }
}
