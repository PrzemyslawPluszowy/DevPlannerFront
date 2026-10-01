import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_controller.dart';
import 'package:flutter/material.dart';

final class StorageOnlyOfficeHostSurface extends StatelessWidget {
  const StorageOnlyOfficeHostSurface({
    required this.state,
    required this.onRetry,
    super.key,
  });
  final StorageOnlyOfficeHostViewState state;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.initializationError case final error?) {
      return StorageOnlyOfficeHostError(
        error: error,
        onRetry: onRetry,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        if (state.controller case final controller?) controller.buildWidget(),
        if (state.isLoading) const StorageOnlyOfficeHostLoading(),
        if (state.documentTimedOut)
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AppIcons.alertCircle, color: context.colors.error),
                    const SizedBox(width: 8),
                    Text(context.l10n.storageOfficeHostFailure),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onRetry,
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

final class StorageOnlyOfficeHostViewState {
  const StorageOnlyOfficeHostViewState({
    this.controller,
    this.initializationError,
    this.isLoading = true,
    this.documentTimedOut = false,
  });

  final StorageOnlyOfficeController? controller;
  final Object? initializationError;
  final bool isLoading;
  final bool documentTimedOut;

  StorageOnlyOfficeHostViewState copyWith({
    StorageOnlyOfficeController? controller,
    Object? initializationError,
    bool? isLoading,
    bool? documentTimedOut,
    bool clearInitializationError = false,
  }) => StorageOnlyOfficeHostViewState(
    controller: controller ?? this.controller,
    initializationError: clearInitializationError
        ? null
        : initializationError ?? this.initializationError,
    isLoading: isLoading ?? this.isLoading,
    documentTimedOut: documentTimedOut ?? this.documentTimedOut,
  );
}

final class StorageOnlyOfficeHostError extends StatelessWidget {
  const StorageOnlyOfficeHostError({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.alertCircle, size: 48, color: context.colors.error),
          const SizedBox(height: 12),
          Text(
            context.l10n.storageOfficeHostFailure,
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SelectableText(error.toString(), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(AppIcons.refresh, size: 16),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    ),
  );
}

final class StorageOnlyOfficeHostLoading extends StatelessWidget {
  const StorageOnlyOfficeHostLoading({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.surface,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 12),
          Text(context.l10n.storageOfficeHostLoading),
        ],
      ),
    ),
  );
}
