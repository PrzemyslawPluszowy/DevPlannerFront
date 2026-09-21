import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Przełącznik widoku Lista/Siatka.
///
/// Dwa segmenty z osobnym stanem zaznaczenia zamiast jednej ikony przełączającej:
/// użytkownik widzi, który widok jest aktywny, a nie tylko co się stanie po
/// kliknięciu.
final class StorageViewModeToggle extends StatelessWidget {
  /// Tworzy przełącznik widoku.
  const StorageViewModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StorageBrowserCubit>();
    final l10n = context.l10n;

    return BlocSelector<
      StorageBrowserCubit,
      StorageBrowserState,
      StorageViewMode
    >(
      selector: (_) => cubit.currentViewMode,
      builder: (context, mode) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StorageChromePill(
            key: const ValueKey('storage_view_mode_list'),
            icon: AppIcons.list,
            tooltip: l10n.storageListViewTooltip,
            isActive: mode == StorageViewMode.list,
            onTap: () => cubit.setViewMode(StorageViewMode.list),
          ),
          const SizedBox(width: 4),
          StorageChromePill(
            key: const ValueKey('storage_view_mode_grid'),
            icon: AppIcons.grid,
            tooltip: l10n.storageGridViewTooltip,
            isActive: mode == StorageViewMode.grid,
            onTap: () => cubit.setViewMode(StorageViewMode.grid),
          ),
        ],
      ),
    );
  }
}
