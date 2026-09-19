import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Powód, dla którego workspace'owy route Files nie może zostać złożony.
enum StorageWorkspaceFilesRouteFailure {
  /// Parametr nie jest niepustym UUID backendu.
  invalidWorkspaceId,

  /// Brakuje sesyjnego repozytorium Storage w composition root.
  repositoryUnavailable,
}

/// Jawny stan niedostępności trasy, bez udawania pustego eksploratora.
final class StorageWorkspaceFilesUnavailablePage extends StatelessWidget {
  /// Tworzy widok błędu kompozycji/routingu Files.
  const StorageWorkspaceFilesUnavailablePage({
    required this.failure,
    super.key,
  });

  /// Typ błędu ustalony przez route boundary.
  final StorageWorkspaceFilesRouteFailure failure;

  @override
  Widget build(BuildContext context) {
    final message = switch (failure) {
      StorageWorkspaceFilesRouteFailure.invalidWorkspaceId =>
        context.l10n.storageRouteInvalidWorkspaceId,
      StorageWorkspaceFilesRouteFailure.repositoryUnavailable =>
        context.l10n.storageRouteNotConfigured,
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 40,
              color: context.colors.error,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.storageRouteUnavailableTitle,
              style: context.text.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
