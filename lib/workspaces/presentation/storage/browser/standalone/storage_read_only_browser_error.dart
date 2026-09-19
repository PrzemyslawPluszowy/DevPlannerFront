import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Typed error/forbidden boundary for the standalone Files browser.
final class StorageReadOnlyBrowserError extends StatelessWidget {
  /// Creates an error state with a retry action.
  const StorageReadOnlyBrowserError({
    required this.message,
    required this.forbidden,
    super.key,
  });

  /// Backend-safe detail already supplied by the browser Cubit.
  final String message;

  /// Whether the error is an ACL denial rather than a transport failure.
  final bool forbidden;

  @override
  Widget build(BuildContext context) {
    final browser = context.read<StorageBrowserCubit>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              forbidden ? AppIcons.lock : AppIcons.alertCircle,
              color: context.colors.error,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              forbidden
                  ? context.l10n.storageForbiddenTitle
                  : context.l10n.storageErrorTitle,
              style: context.text.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(context.l10n.storagePreviewError(message)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: browser.load,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
