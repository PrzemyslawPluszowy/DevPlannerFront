import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wybór kryterium sortowania w pasku poleceń.
///
/// Menu należy do wspólnej powierzchni `AppContextMenu`, więc Pliki nie
/// renderują drugiego, lokalnego stylu menu obok Tasks/Kanban.
final class StorageSortMenu extends StatelessWidget {
  /// Tworzy kontrolkę sortowania.
  const StorageSortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StorageBrowserCubit>();
    final current = cubit.currentSort;
    final label = _labelFor(context, current);

    return StorageChromePill(
      key: const ValueKey('storage_sort_menu'),
      icon: AppIcons.sort,
      label: label,
      tooltip: context.l10n.storageSortTooltip,
      onTap: () => unawaited(_select(context, cubit)),
    );
  }

  Future<void> _select(
    BuildContext context,
    StorageBrowserCubit cubit,
  ) async {
    final selected = await AppContextMenu.select<StorageSortCriteria>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: context.l10n.storageSortTooltip,
      options: [
        for (final option in _options(context))
          AppContextMenuOption<StorageSortCriteria>(
            value: option.criteria,
            label: option.label,
            icon: AppIcons.sort,
            selected: cubit.currentSort == option.criteria,
          ),
      ],
    );
    if (selected == null) return;
    cubit.setSort(selected);
  }

  List<({String label, StorageSortCriteria criteria})> _options(
    BuildContext context,
  ) {
    final l10n = context.l10n;
    return [
      (
        label: l10n.storageSortNameAsc,
        criteria: const StorageSortCriteria(
          field: StorageSortField.name,
          direction: StorageSortDirection.ascending,
        ),
      ),
      (
        label: l10n.storageSortNameDesc,
        criteria: const StorageSortCriteria(field: StorageSortField.name),
      ),
      (
        label: l10n.storageSortDateDesc,
        criteria: const StorageSortCriteria(),
      ),
      (
        label: l10n.storageSortDateAsc,
        criteria: const StorageSortCriteria(
          direction: StorageSortDirection.ascending,
        ),
      ),
      (
        label: l10n.storageSortSizeDesc,
        criteria: const StorageSortCriteria(field: StorageSortField.size),
      ),
      (
        label: l10n.storageSortSizeAsc,
        criteria: const StorageSortCriteria(
          field: StorageSortField.size,
          direction: StorageSortDirection.ascending,
        ),
      ),
    ];
  }

  String _labelFor(BuildContext context, StorageSortCriteria criteria) {
    for (final option in _options(context)) {
      if (option.criteria == criteria) return option.label;
    }
    return context.l10n.storageSortTooltip;
  }
}
