import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:flutter/material.dart';

/// Pusty stan bieżącego katalogu.
///
/// Widok celowo nie powtarza akcji: CTA tworzenia i wysyłania należą do
/// chrome'u, który stoi bezpośrednio nad ciałem. Dwa wejścia do tej samej
/// operacji na jednym ekranie to zaproszenie do rozjazdu ich bramkowania.
final class StorageEmptyView extends StatelessWidget {
  /// Tworzy widok pustego katalogu.
  const StorageEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(common.blockGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.folder,
              size: 48,
              color: colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            SizedBox(height: common.rowGutter),
            Text(
              context.l10n.storageEmptyTitle,
              textAlign: TextAlign.center,
              style: common.projectTitleText.copyWith(color: colors.onSurface),
            ),
            SizedBox(height: common.tightGap),
            Text(
              context.l10n.storageEmptySubtitle,
              textAlign: TextAlign.center,
              style: common.dataText.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Jawny stan braku dostępu do zakresu Storage.
///
/// Odmowa dostępu nie jest błędem przejściowym: nie ma tu ponowienia, bo
/// ponowienie nie zmieni wyniku, a stan trwa do zmiany zakresu.
final class StorageForbiddenView extends StatelessWidget {
  /// Tworzy widok braku dostępu.
  const StorageForbiddenView({required this.message, super.key});

  /// Komunikat o odmowie dostępu.
  final String message;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(common.blockGap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.lock, size: 48, color: colors.error),
            SizedBox(height: common.rowGutter),
            Text(
              context.l10n.storageForbiddenTitle,
              textAlign: TextAlign.center,
              style: common.projectTitleText.copyWith(color: colors.onSurface),
            ),
            SizedBox(height: common.tightGap),
            Text(
              message,
              textAlign: TextAlign.center,
              style: common.dataText.copyWith(color: colors.error),
            ),
          ],
        ),
      ),
    );
  }
}
