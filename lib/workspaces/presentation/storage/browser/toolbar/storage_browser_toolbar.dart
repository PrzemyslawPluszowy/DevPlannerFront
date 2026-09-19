import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/toolbar/storage_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pasek narzędziowy eksploratora plików: okruszki, pole wyszukiwania, sortowanie i przełącznik siatka/lista.
class StorageBrowserToolbar extends StatelessWidget {
  /// Tworzy pasek narzędziowy.
  const StorageBrowserToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<StorageBrowserCubit>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: StorageBreadcrumbs(),
          ),
          const SizedBox(width: 16),
          // Pole wyszukiwania
          SizedBox(
            width: 220,
            height: 36,
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.storageSearchHint,
                prefixIcon: const Icon(AppIcons.search, size: 16),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: context.colors.outlineVariant,
                  ),
                ),
              ),
              onChanged: cubit.search,
            ),
          ),
          const SizedBox(width: 8),
          // Menu sortowania
          PopupMenuButton<StorageSortCriteria>(
            icon: const Icon(AppIcons.sort, size: 18),
            tooltip: l10n.storageSortTooltip,
            onSelected: cubit.setSort,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const StorageSortCriteria(
                  field: StorageSortField.name,
                  direction: StorageSortDirection.ascending,
                ),
                child: Text(l10n.storageSortNameAsc),
              ),
              PopupMenuItem(
                value: const StorageSortCriteria(
                  field: StorageSortField.name,
                ),
                child: Text(l10n.storageSortNameDesc),
              ),
              PopupMenuItem(
                value: const StorageSortCriteria(),
                child: Text(l10n.storageSortDateDesc),
              ),
              PopupMenuItem(
                value: const StorageSortCriteria(
                  direction: StorageSortDirection.ascending,
                ),
                child: Text(l10n.storageSortDateAsc),
              ),
              PopupMenuItem(
                value: const StorageSortCriteria(
                  field: StorageSortField.size,
                ),
                child: Text(l10n.storageSortSizeDesc),
              ),
              PopupMenuItem(
                value: const StorageSortCriteria(
                  field: StorageSortField.size,
                  direction: StorageSortDirection.ascending,
                ),
                child: Text(l10n.storageSortSizeAsc),
              ),
            ],
          ),
          const SizedBox(width: 4),
          // Przełącznik widoku Grid / List
          BlocSelector<
            StorageBrowserCubit,
            StorageBrowserState,
            StorageViewMode
          >(
            selector: (state) => cubit.currentViewMode,
            builder: (context, viewMode) => IconButton(
              icon: Icon(
                viewMode == StorageViewMode.grid
                    ? AppIcons.list
                    : AppIcons.grid,
                size: 18,
              ),
              tooltip: viewMode == StorageViewMode.grid
                  ? l10n.storageListViewTooltip
                  : l10n.storageGridViewTooltip,
              onPressed: cubit.toggleViewMode,
            ),
          ),
        ],
      ),
    );
  }
}
