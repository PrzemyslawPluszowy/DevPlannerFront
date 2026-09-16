import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/locations_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/locations_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';
import 'package:ready_next/features/inventory/presentation/widgets/inventory_section_placeholder_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_tree.dart';

/// Ekran sekcji "Miejsca".
class InventoryStockPage extends StatelessWidget {
  /// Tworzy ekran sekcji "Miejsca".
  const InventoryStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationsCubit(
        repository: context.read<LocationsRepository>(),
        filterService: context.read<StockFilterService>(),
      )..load().ignore(),
      child: const _InventoryStockContent(),
    );
  }
}

enum _LocationsViewMode { table, tree }

/// Treść sekcji Miejsca z przełącznikiem tabela/drzewo.
class _InventoryStockContent extends StatefulWidget {
  const _InventoryStockContent();

  @override
  State<_InventoryStockContent> createState() => _InventoryStockContentState();
}

/// Stan lokalny widoku sekcji Miejsca.
class _InventoryStockContentState extends State<_InventoryStockContent> {
  _LocationsViewMode _viewMode = _LocationsViewMode.table;
  var _companiesRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_companiesRequested) {
      return;
    }

    _companiesRequested = true;
    unawaited(_ensureCompaniesLoaded());
  }

  Future<void> _ensureCompaniesLoaded() async {
    final filterService = context.read<StockFilterService>();
    if (filterService.companies.isNotEmpty) {
      return;
    }

    final result = await context.read<StockRepository>().fetchCompanies();
    if (!mounted) {
      return;
    }

    result.fold((_) => null, filterService.setCompanies);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsCubit, LocationsState>(
      builder: (context, state) {
        final cubit = context.read<LocationsCubit>();
        final intl = context.l10n;

        return InventorySectionPlaceholderCard(
          title: intl.inventoryLocationsTitle,
          subtitle: intl.inventoryLocationsSubtitle,
          headerPadding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p10,
          ),
          chips: [
            AppActionChip(
              label: intl.inventoryTable,
              icon: Icons.table_rows_outlined,
              selected: _viewMode == _LocationsViewMode.table,
              tone: AppActionChipTone.primary,
              onPressed: () {
                if (_viewMode == _LocationsViewMode.table) return;
                setState(() => _viewMode = _LocationsViewMode.table);
              },
            ),
            AppActionChip(
              label: intl.inventoryTree,
              icon: Icons.account_tree_outlined,
              selected: _viewMode == _LocationsViewMode.tree,
              tone: AppActionChipTone.primary,
              onPressed: () {
                if (_viewMode == _LocationsViewMode.tree) return;
                setState(() => _viewMode = _LocationsViewMode.tree);
              },
            ),
          ],
          actions: [
            const _FirmaFilterWrapper(),
            AppActionPill(
              label: intl.inventoryRefresh,
              icon: Icons.refresh_rounded,
              tone: AppActionPillTone.contrast,
              selected: true,
              onPressed: () => cubit.refresh().ignore(),
            ),
          ],
          child: switch (state) {
            LocationsInitial() ||
            LocationsLoading() => const Center(child: AppSpinner()),
            LocationsSuccess(:final data) => switch (_viewMode) {
              _LocationsViewMode.table => _LocationsTable(data: data),
              _LocationsViewMode.tree => _LocationsTree(data: data),
            },
            LocationsError(:final message) => Center(
              child: AppEmptyState.error(
                title: intl.inventoryLoadingErrorTitle,
                message: message,
              ),
            ),
          },
        );
      },
    );
  }
}

class _FirmaFilterWrapper extends StatelessWidget {
  const _FirmaFilterWrapper();

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final filterService = context.watch<StockFilterService>();
    final currentFirmaId = filterService.currentFirma;

    return StreamBuilder<List<GetFirmyItem>>(
      stream: filterService.companiesStream,
      initialData: filterService.companies,
      builder: (context, snapshot) {
        final companies = snapshot.data ?? [];
        if (companies.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          width: 220,
          child: AppDropdown<int?>(
            key: ValueKey(currentFirmaId),
            variant: AppDropdownVariant.filled,
            value: currentFirmaId,
            inlineLabel: intl.inventoryCompany,
            hintText: intl.inventoryAll,
            options: [
              AppDropdownOption<int?>(
                value: null,
                label: intl.inventoryAllCompanies,
              ),
              ...companies.map(
                (c) =>
                    AppDropdownOption<int?>(value: c.idFirmy, label: c.nazwa),
              ),
            ],
            onChanged: filterService.setFirma,
          ),
        );
      },
    );
  }
}

class _LocationsTable extends StatelessWidget {
  const _LocationsTable({required this.data});

  final GetMiejscaResponseData data;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    if (data.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: Sizes.p16),
        child: Center(child: AppEmptyState.noResults()),
      );
    }

    return AppSimpleTable<GetMiejscaItem>(
      height: null,
      rows: data.items,
      showSearch: true,
      searchInlineLabel: intl.inventorySearch,
      searchHintText: intl.inventoryLocationsSearchHint,
      searchMatcher: (row, query) {
        final normalizedQuery = query.toLowerCase();
        final code = row.baza?.toLowerCase() ?? '';
        final name = row.nazwa?.toLowerCase() ?? '';
        final level = row.lvl?.toLowerCase() ?? '';

        return code.contains(normalizedQuery) ||
            name.contains(normalizedQuery) ||
            level.contains(normalizedQuery);
      },
      columns: [
        AppSimpleTableColumn<GetMiejscaItem>(
          label: intl.inventoryCode,
          width: 180,
          sortValue: (row) => row.baza ?? '',
          cellBuilder: (context, row) => AppText(row.baza ?? '-'),
        ),
        AppSimpleTableColumn<GetMiejscaItem>(
          label: intl.inventoryName,
          width: 420,
          sortValue: (row) => row.nazwa ?? '',
          cellBuilder: (context, row) => AppText(row.nazwa ?? '-'),
        ),
        AppSimpleTableColumn<GetMiejscaItem>(
          label: intl.inventoryLevel,
          width: 160,
          sortValue: (row) => row.lvl ?? '',
          cellBuilder: (context, row) => AppText(row.lvl ?? '-'),
        ),
      ],
      onRowTap: (context, row, index) {
        _showLocationDetailsModal(context, row, data.items).ignore();
      },
    );
  }
}

/// Widok drzewa miejsc pogrupowanych według firm.
class _LocationsTree extends StatefulWidget {
  /// Tworzy widok drzewa miejsc.
  const _LocationsTree({required this.data});

  /// Dane źródłowe listy miejsc.
  final GetMiejscaResponseData data;

  @override
  State<_LocationsTree> createState() => _LocationsTreeState();
}

/// Stan widoku drzewa miejsc z lokalnym filtrowaniem gałęzi.
class _LocationsTreeState extends State<_LocationsTree> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    if (widget.data.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: Sizes.p16),
        child: Center(child: AppEmptyState.noResults()),
      );
    }

    final companies = context.watch<StockFilterService>().companies;
    final companyNames = {
      for (final company in companies) company.idFirmy: company.nazwa,
    };
    final normalizedQuery = _query.trim().toLowerCase();
    final nodes = _buildCompanyNodes(companyNames, normalizedQuery);

    return Column(
      children: [
        AppSearchTextField(
          inlineLabel: intl.inventorySearch,
          hintText: intl.inventoryLocationsTreeSearchHint,
          onChanged: (value) {
            setState(() => _query = value);
          },
        ),
        Gaps.h12,
        Expanded(
          child: nodes.isEmpty
              ? Center(
                  child: AppEmptyState.noResults(
                    title: intl.inventoryNoResultsTitle,
                    message: intl.inventoryLocationsNoResultsMessage,
                  ),
                )
              : AppTree<GetMiejscaItem>(
                  key: ValueKey(normalizedQuery),
                  padding: const EdgeInsets.only(bottom: Sizes.p12),
                  nodes: nodes,
                ),
        ),
      ],
    );
  }

  List<AppTreeNode<GetMiejscaItem>> _buildCompanyNodes(
    Map<int, String> companyNames,
    String normalizedQuery,
  ) {
    final groupedByCompany = <int, List<GetMiejscaItem>>{};
    for (final item in widget.data.items) {
      groupedByCompany.putIfAbsent(item.idFirmy, () => []).add(item);
    }

    final companyIds = groupedByCompany.keys.toList()..sort();
    final nodes = <AppTreeNode<GetMiejscaItem>>[];

    for (final companyId in companyIds) {
      final companyItems = groupedByCompany[companyId];
      if (companyItems == null) {
        continue;
      }

      final companyTitle =
          companyNames[companyId] ??
          context.l10n.inventoryCompanyWithId(companyId);
      final companyMatches =
          normalizedQuery.isNotEmpty &&
          companyTitle.toLowerCase().contains(normalizedQuery);
      final children = companyMatches
          ? _buildLocationNodes(companyItems)
          : _buildFilteredLocationNodes(companyItems, normalizedQuery);

      if (!companyMatches && normalizedQuery.isNotEmpty && children.isEmpty) {
        continue;
      }

      nodes.add(
        AppTreeNode<GetMiejscaItem>(
          title: companyTitle,
          subtitle: context.l10n.inventoryLocationsCount(companyItems.length),
          leading: const Icon(Icons.business_outlined, size: Sizes.p18),
          initiallyExpanded:
              companyIds.length == 1 || normalizedQuery.isNotEmpty,
          children: children,
        ),
      );
    }

    return nodes;
  }

  List<AppTreeNode<GetMiejscaItem>> _buildLocationNodes(
    List<GetMiejscaItem> items,
  ) {
    final parentUsesRecordId = _parentUsesRecordId(items);
    final itemsByTreeKey = {
      for (final item in items) _treeKey(item, parentUsesRecordId): item,
    };
    final childrenByParent = <int, List<GetMiejscaItem>>{};

    for (final item in items) {
      final parentId = item.idparent ?? 0;
      childrenByParent.putIfAbsent(parentId, () => []).add(item);
    }

    final roots =
        items
            .where((item) {
              final parentId = item.idparent ?? 0;
              return parentId == 0 || !itemsByTreeKey.containsKey(parentId);
            })
            .toList(growable: false)
          ..sort(_compareLocations);

    return roots
        .map(
          (item) => _buildLocationNode(
            item,
            childrenByParent,
            parentUsesRecordId,
          ),
        )
        .toList(growable: false);
  }

  List<AppTreeNode<GetMiejscaItem>> _buildFilteredLocationNodes(
    List<GetMiejscaItem> items,
    String normalizedQuery,
  ) {
    if (normalizedQuery.isEmpty) {
      return _buildLocationNodes(items);
    }

    final parentUsesRecordId = _parentUsesRecordId(items);
    final itemsByTreeKey = {
      for (final item in items) _treeKey(item, parentUsesRecordId): item,
    };
    final childrenByParent = <int, List<GetMiejscaItem>>{};

    for (final item in items) {
      final parentId = item.idparent ?? 0;
      childrenByParent.putIfAbsent(parentId, () => []).add(item);
    }

    final roots =
        items
            .where((item) {
              final parentId = item.idparent ?? 0;
              return parentId == 0 || !itemsByTreeKey.containsKey(parentId);
            })
            .toList(growable: false)
          ..sort(_compareLocations);

    final result = <AppTreeNode<GetMiejscaItem>>[];
    for (final root in roots) {
      final filteredNode = _buildFilteredLocationNode(
        root,
        childrenByParent,
        parentUsesRecordId,
        normalizedQuery,
      );
      if (filteredNode != null) {
        result.add(filteredNode);
      }
    }
    return result;
  }

  AppTreeNode<GetMiejscaItem> _buildLocationNode(
    GetMiejscaItem item,
    Map<int, List<GetMiejscaItem>> childrenByParent,
    bool parentUsesRecordId,
  ) {
    final children = List<GetMiejscaItem>.from(
      childrenByParent[_treeKey(item, parentUsesRecordId)] ??
          const <GetMiejscaItem>[],
    )..sort(_compareLocations);

    return AppTreeNode<GetMiejscaItem>(
      value: item,
      title: item.nazwa?.trim().isNotEmpty == true
          ? item.nazwa!.trim()
          : context.l10n.inventoryNoName,
      subtitle: _buildLocationSubtitle(item),
      leading: Icon(
        children.isEmpty ? Icons.place_outlined : Icons.keyboard_arrow_right,
        size: Sizes.p18,
      ),
      onTap: (value) {
        if (value case final location?) {
          _showLocationDetailsModal(
            context,
            location,
            widget.data.items,
          ).ignore();
        }
      },
      children: [
        for (final child in children)
          _buildLocationNode(child, childrenByParent, parentUsesRecordId),
      ],
    );
  }

  AppTreeNode<GetMiejscaItem>? _buildFilteredLocationNode(
    GetMiejscaItem item,
    Map<int, List<GetMiejscaItem>> childrenByParent,
    bool parentUsesRecordId,
    String normalizedQuery,
  ) {
    final childItems = List<GetMiejscaItem>.from(
      childrenByParent[_treeKey(item, parentUsesRecordId)] ??
          const <GetMiejscaItem>[],
    )..sort(_compareLocations);

    final matchesCurrent = _matchesLocation(item, normalizedQuery);

    if (matchesCurrent) {
      return _buildExpandedLocationNode(
        item,
        childrenByParent,
        parentUsesRecordId,
      );
    }

    final filteredChildren = <AppTreeNode<GetMiejscaItem>>[];
    for (final child in childItems) {
      final filteredChild = _buildFilteredLocationNode(
        child,
        childrenByParent,
        parentUsesRecordId,
        normalizedQuery,
      );
      if (filteredChild != null) {
        filteredChildren.add(filteredChild);
      }
    }

    if (filteredChildren.isEmpty) {
      return null;
    }

    return AppTreeNode<GetMiejscaItem>(
      value: item,
      title: item.nazwa?.trim().isNotEmpty == true
          ? item.nazwa!.trim()
          : context.l10n.inventoryNoName,
      subtitle: _buildLocationSubtitle(item),
      leading: const Icon(Icons.keyboard_arrow_right, size: Sizes.p18),
      initiallyExpanded: true,
      onTap: (value) {
        if (value case final location?) {
          _showLocationDetailsModal(
            context,
            location,
            widget.data.items,
          ).ignore();
        }
      },
      children: filteredChildren,
    );
  }

  AppTreeNode<GetMiejscaItem> _buildExpandedLocationNode(
    GetMiejscaItem item,
    Map<int, List<GetMiejscaItem>> childrenByParent,
    bool parentUsesRecordId,
  ) {
    final childItems = List<GetMiejscaItem>.from(
      childrenByParent[_treeKey(item, parentUsesRecordId)] ??
          const <GetMiejscaItem>[],
    )..sort(_compareLocations);

    return AppTreeNode<GetMiejscaItem>(
      value: item,
      title: item.nazwa?.trim().isNotEmpty == true
          ? item.nazwa!.trim()
          : context.l10n.inventoryNoName,
      subtitle: _buildLocationSubtitle(item),
      leading: Icon(
        childItems.isEmpty ? Icons.place_outlined : Icons.keyboard_arrow_right,
        size: Sizes.p18,
      ),
      initiallyExpanded: childItems.isNotEmpty,
      onTap: (value) {
        if (value case final location?) {
          _showLocationDetailsModal(
            context,
            location,
            widget.data.items,
          ).ignore();
        }
      },
      children: [
        for (final child in childItems)
          _buildExpandedLocationNode(
            child,
            childrenByParent,
            parentUsesRecordId,
          ),
      ],
    );
  }

  bool _matchesLocation(GetMiejscaItem item, String normalizedQuery) {
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final name = item.nazwa?.toLowerCase() ?? '';
    final code = item.baza?.toLowerCase() ?? '';
    final level = item.lvl?.toLowerCase() ?? '';

    return name.contains(normalizedQuery) ||
        code.contains(normalizedQuery) ||
        level.contains(normalizedQuery);
  }

  String _buildLocationSubtitle(GetMiejscaItem item) {
    final parts = <String>[];
    if (item.baza case final code? when code.trim().isNotEmpty) {
      parts.add(code.trim());
    }
    if (item.lvl case final level? when level.trim().isNotEmpty) {
      parts.add(level.trim());
    }
    return parts.isEmpty ? '-' : parts.join(' • ');
  }

  int _compareLocations(GetMiejscaItem left, GetMiejscaItem right) {
    final leftName = left.nazwa?.trim().toLowerCase() ?? '';
    final rightName = right.nazwa?.trim().toLowerCase() ?? '';
    return leftName.compareTo(rightName);
  }

  bool _parentUsesRecordId(List<GetMiejscaItem> items) {
    final recordIds = {for (final item in items) item.id};
    final placeIds = {for (final item in items) item.idMiejsca};
    final parentIds = items
        .map((item) => item.idparent)
        .whereType<int>()
        .where((id) => id != 0)
        .toList(growable: false);

    final recordMatches = parentIds.where(recordIds.contains).length;
    final placeMatches = parentIds.where(placeIds.contains).length;
    return recordMatches > placeMatches;
  }

  int _treeKey(GetMiejscaItem item, bool parentUsesRecordId) {
    return parentUsesRecordId ? item.id : item.idMiejsca;
  }
}

Future<void> _showLocationDetailsModal(
  BuildContext context,
  GetMiejscaItem item,
  List<GetMiejscaItem> allItems,
) {
  final intl = context.l10n;
  final companyNames = {
    for (final company in context.read<StockFilterService>().companies)
      company.idFirmy: company.nazwa,
  };

  return AppModalSheet.show(
    context,
    title: item.nazwa?.trim().isNotEmpty == true
        ? item.nazwa!.trim()
        : intl.inventoryNoName,
    subtitle: item.baza?.trim().isNotEmpty == true
        ? '${intl.inventoryCode}: ${item.baza!.trim()}'
        : intl.inventoryLocation,
    body: _LocationDetailsModalBody(
      item: item,
      allItems: allItems,
      companyNames: companyNames,
    ),
    minBodyHeight: 260,
    maxBodyHeight: 520,
  );
}

/// Tresc modala szczegolow miejsca.
class _LocationDetailsModalBody extends StatelessWidget {
  /// Tworzy body modala szczegolow miejsca.
  const _LocationDetailsModalBody({
    required this.item,
    required this.allItems,
    required this.companyNames,
  });

  final GetMiejscaItem item;
  final List<GetMiejscaItem> allItems;
  final Map<int, String?> companyNames;

  @override
  Widget build(BuildContext context) {
    final parent = _findParentLocation(item, allItems);
    final childCount = _countChildLocations(item, allItems);

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        _buildLocationSectionTitle(context, 'Podstawowe informacje'),
        _buildLocationInfoRow(
          context,
          Icons.business_outlined,
          context.l10n.inventoryCompany,
          companyNames[item.idFirmy] ??
              context.l10n.inventoryCompanyWithId(item.idFirmy),
        ),
        _buildLocationInfoRow(
          context,
          Icons.tag_rounded,
          context.l10n.inventoryCode,
          item.baza,
        ),
        _buildLocationInfoRow(
          context,
          Icons.badge_outlined,
          context.l10n.inventoryName,
          item.nazwa,
        ),
        _buildLocationInfoRow(
          context,
          Icons.layers_outlined,
          context.l10n.inventoryLevel,
          item.lvl,
        ),
        Gaps.h20,
        _buildLocationSectionTitle(context, 'Struktura'),
        _buildLocationInfoRow(
          context,
          Icons.account_tree_outlined,
          'Rodzic',
          parent?.nazwa ?? parent?.baza,
        ),
        _buildLocationInfoRow(
          context,
          Icons.alt_route_rounded,
          'Sciezka',
          _buildLocationBreadcrumb(item, allItems),
        ),
        _buildLocationInfoRow(
          context,
          Icons.hub_outlined,
          'Liczba dzieci',
          '$childCount',
        ),
        _buildLocationInfoRow(
          context,
          Icons.category_outlined,
          'Typ wezla',
          childCount == 0 ? 'Wezel koncowy' : 'Wezel nadrzedny',
        ),
      ],
    );
  }
}

Widget _buildLocationSectionTitle(BuildContext context, String title) {
  return Padding(
    padding: const .only(bottom: Sizes.p8),
    child: AppText(
      title.toUpperCase(),
      style: context.text.labelSmall?.copyWith(
        color: context.colors.primary,
        fontWeight: .w800,
        letterSpacing: 1.2,
      ),
    ),
  );
}

Widget _buildLocationInfoRow(
  BuildContext context,
  IconData icon,
  String label,
  String? value,
) {
  final normalizedValue = value?.trim().isNotEmpty == true
      ? value!.trim()
      : context.l10n.inventoryNoData;

  return Padding(
    padding: const .symmetric(vertical: Sizes.p4),
    child: Row(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .only(top: Sizes.p2),
          child: Icon(
            icon,
            size: Sizes.p18,
            color: context.colors.onSurfaceVariant.withValues(alpha: .7),
          ),
        ),
        Gaps.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              AppText(
                label,
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              AppText(
                normalizedValue,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: .w600,
                  color: context.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

GetMiejscaItem? _findParentLocation(
  GetMiejscaItem item,
  List<GetMiejscaItem> allItems,
) {
  final parentId = item.idparent;
  if (parentId == null || parentId == 0) {
    return null;
  }

  for (final candidate in allItems) {
    if (candidate.idMiejsca == parentId || candidate.id == parentId) {
      return candidate;
    }
  }

  return null;
}

int _countChildLocations(GetMiejscaItem item, List<GetMiejscaItem> allItems) {
  return allItems.where((candidate) {
    return candidate.idparent == item.idMiejsca ||
        candidate.idparent == item.id;
  }).length;
}

String _buildLocationBreadcrumb(
  GetMiejscaItem item,
  List<GetMiejscaItem> allItems,
) {
  final nodesById = {for (final candidate in allItems) candidate.id: candidate};
  final nodesByPlaceId = {
    for (final candidate in allItems) candidate.idMiejsca: candidate,
  };
  final visited = <int>{};
  final parts = <String>[];
  GetMiejscaItem? current = item;

  while (current != null && visited.add(current.id)) {
    parts.add(
      current.nazwa?.trim().isNotEmpty == true
          ? current.nazwa!.trim()
          : current.baza ?? '-',
    );
    final parentId = current.idparent;
    current = switch (parentId) {
      null || 0 => null,
      final value => nodesByPlaceId[value] ?? nodesById[value],
    };
  }

  return parts.reversed.join(' / ');
}
