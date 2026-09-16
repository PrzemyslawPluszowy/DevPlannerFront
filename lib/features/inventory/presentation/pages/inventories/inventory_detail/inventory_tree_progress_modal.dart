import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_tree_progress_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_detail_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/inventory_sheet_search_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/create_arkusz_tree_utils.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_sheet_search_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_expandable_side_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

part 'inventory_tree_progress_view.part.dart';

const _treeNodeContentMaxWidth = 980.0;
const _treeProductsColumnWidth = 112.0;
const _treeStatusColumnWidth = 176.0;
const _treeActionColumnWidth = 40.0;
const _treeProductsPageLimit = 1000;
const _treeProductsCollapsedWidth = 1120.0;
const _treeProductsExpandedWidth = 1760.0;
const _treeProductsSplitBreakpoint = 1360.0;

bool _isMissingArkusz(GetInwentaryzacjaTreeProgressItem item) =>
    !item.isAmbiguous && !item.arkuszExists && item.productsCount != 0;

Future<void> showInventoryTreeProgressModal(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  required List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies,
  required InventoriesRepository inventoriesRepository,
  required LocationsRepository locationsRepository,
  required StockRepository stockRepository,
  required UsersRepository usersRepository,
  required bool canDeleteArkusz,
  required bool canEditArkusz,
  VoidCallback? onDataChanged,
}) {
  final viewportWidth = MediaQuery.sizeOf(context).width;
  final modalWidth = viewportWidth * .95;

  return AppModalSheet.showSideSheet<void>(
    context,
    title: context.l10n.inventoryTreeProgressTitle,
    subtitle: inventoryNumber,
    size: AppModalSheetSize.large,
    width: modalWidth,
    scrollBody: false,
    body: _InventoryTreeProgressModalBody(
      inventoryId: inventoryId,
      inventoryCompanies: inventoryCompanies,
      inventoriesRepository: inventoriesRepository,
      locationsRepository: locationsRepository,
      stockRepository: stockRepository,
      usersRepository: usersRepository,
      canDeleteArkusz: canDeleteArkusz,
      canEditArkusz: canEditArkusz,
      onDataChanged: onDataChanged,
    ),
  );
}

/// Body modala postepu wykonania arkuszy w drzewie miejsc.
class _InventoryTreeProgressModalBody extends StatefulWidget {
  const _InventoryTreeProgressModalBody({
    required this.inventoryId,
    required this.inventoryCompanies,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    required this.canDeleteArkusz,
    required this.canEditArkusz,
    this.onDataChanged,
  });

  final int inventoryId;
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final bool canDeleteArkusz;
  final bool canEditArkusz;
  final VoidCallback? onDataChanged;

  @override
  State<_InventoryTreeProgressModalBody> createState() =>
      _InventoryTreeProgressModalBodyState();
}

/// Stan body modala postepu wykonania arkuszy.
class _InventoryTreeProgressModalBodyState
    extends State<_InventoryTreeProgressModalBody> {
  bool _isLoading = true;
  String? _errorMessage;
  GetInwentaryzacjaTreeProgressResponseData? _data;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await widget.inventoriesRepository
        .fetchInventoryTreeProgress(
          widget.inventoryId,
        );

    if (!mounted) {
      return;
    }

    result.fold(
      (error) => setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      }),
      (data) => setState(() {
        _isLoading = false;
        _data = data;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _data == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.p24),
          child: AppSpinner(size: Sizes.p24),
        ),
      );
    }

    if (_errorMessage != null && _data == null) {
      return AppEmptyState.error(
        title: context.l10n.inventoryTreeLoadErrorTitle,
        message: _errorMessage!,
        compact: true,
        action: AppActionButton.outlined(
          label: context.l10n.inventoryRetryAction,
          icon: Icons.refresh_rounded,
          tone: .danger,
          onPressedAsync: _load,
        ),
      );
    }

    final data = _data;
    if (data == null || data.items.isEmpty) {
      return AppEmptyState.noData(
        title: context.l10n.inventoryTreeNoLocationsTitle,
        message: context.l10n.inventoryTreeNoLocationsMessage,
        compact: true,
      );
    }

    final companyNames = {
      for (final company in widget.inventoryCompanies)
        company.id: switch ((company.nazwaFirmy ?? '').trim()) {
          final String value when value.isNotEmpty => value,
          _ => context.l10n.inventoryCompanyWithId(company.id),
        },
    };

    final nodes = _buildCompanyNodes(
      companyNames: companyNames,
      items: data.items,
    );
    final incompleteItems = data.items.where(_isMissingArkusz).toList()
      ..sort(_compareTreeItems);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                data.meta.totals.ambiguousPlacesCount > 0
                    ? context.l10n.inventoryTreeNodesAmbiguousSummary(
                        data.meta.totals.itemsCount,
                        data.meta.totals.ambiguousPlacesCount,
                      )
                    : context.l10n.inventoryTreeNodesSummary(
                        data.meta.totals.itemsCount,
                      ),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            AppActionButton.outlined(
              label: context.l10n.inventoryRefresh,
              icon: Icons.refresh_rounded,
              onPressedAsync: _load,
            ),
          ],
        ),
        if (_errorMessage != null) ...[
          Gaps.h12,
          AppEmptyState.error(
            title: context.l10n.inventoryShowingLastDataTitle,
            message: _errorMessage!,
            compact: true,
          ),
        ],
        Gaps.h12,
        if (incompleteItems.isNotEmpty) ...[
          _IncompleteInventoryNodesStrip(
            items: incompleteItems,
          ),
          Gaps.h12,
        ],
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: _InventoryTreeProgressView(nodes: nodes),
          ),
        ),
      ],
    );
  }

  List<TreeSliverNode<_TreeProgressNodeData>> _buildCompanyNodes({
    required Map<int, String> companyNames,
    required List<GetInwentaryzacjaTreeProgressItem> items,
  }) {
    final grouped = <int, List<GetInwentaryzacjaTreeProgressItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.idFirmy, () => []).add(item);
    }

    final orderedCompanies = grouped.keys.toList(growable: false)..sort();

    return orderedCompanies
        .map((companyId) {
          final companyItems = grouped[companyId]!..sort(_compareTreeItems);
          final locations = companyItems
              .map(
                (item) => GetMiejscaItem(
                  id: item.id,
                  idMiejsca: item.idMiejsca,
                  idFirmy: item.idFirmy,
                  idparent: item.idparent,
                  baza: item.baza,
                  nazwa: item.nazwa,
                  lvl: item.lvl,
                ),
              )
              .toList(growable: false);
          final parentUsesRecordId = createArkuszParentUsesRecordId(locations);
          final itemsByRecordId = {
            for (final item in companyItems) item.id: item,
          };
          final locationsByTreeKey = {
            for (final location in locations)
              createArkuszScopedTreeKey(location, parentUsesRecordId): location,
          };
          final childrenByParent =
              <CreateArkuszScopedTreeKey, List<GetMiejscaItem>>{};

          for (final location in locations) {
            final parentKey = createArkuszScopedParentKey(location);
            childrenByParent.putIfAbsent(parentKey, () => []).add(location);
          }

          final roots =
              locations
                  .where((location) {
                    final parentKey = createArkuszScopedParentKey(location);
                    return parentKey.id == 0 ||
                        !locationsByTreeKey.containsKey(parentKey);
                  })
                  .toList(growable: false)
                ..sort(_compareLocations);

          return TreeSliverNode<_TreeProgressNodeData>(
            _TreeProgressNodeData(
              title:
                  companyNames[companyId] ??
                  context.l10n.inventoryCompanyWithId(companyId),
              subtitle:
                  '${context.l10n.inventoryTreeCompanySummary(companyItems.length, companyItems.where((item) => item.arkuszExists).length)}${companyItems.any((item) => item.isAmbiguous) ? context.l10n.inventoryTreeCompanyAmbiguousSuffix : ''}',
              leading: const Icon(Icons.business_rounded, size: Sizes.p18),
            ),
            expanded: true,
            children: [
              for (final root in roots)
                _buildLocationNode(
                  location: root,
                  itemsByRecordId: itemsByRecordId,
                  childrenByParent: childrenByParent,
                  parentUsesRecordId: parentUsesRecordId,
                ),
            ],
          );
        })
        .toList(growable: false);
  }

  TreeSliverNode<_TreeProgressNodeData> _buildLocationNode({
    required GetMiejscaItem location,
    required Map<int, GetInwentaryzacjaTreeProgressItem> itemsByRecordId,
    required Map<CreateArkuszScopedTreeKey, List<GetMiejscaItem>>
    childrenByParent,
    required bool parentUsesRecordId,
  }) {
    final item = itemsByRecordId[location.id]!;
    final children = List<GetMiejscaItem>.from(
      childrenByParent[createArkuszScopedTreeKey(
            location,
            parentUsesRecordId,
          )] ??
          const <GetMiejscaItem>[],
    )..sort(_compareLocations);

    return TreeSliverNode<_TreeProgressNodeData>(
      _TreeProgressNodeData(
        title: _locationTitle(location),
        titleSpan: _locationTitleSpan(location),
        subtitle:
            '${context.l10n.inventoryProductsCount(item.productsCount)} • ${item.baza}',
        leading: Icon(
          children.isEmpty ? Icons.place_outlined : Icons.account_tree_outlined,
          size: Sizes.p18,
        ),
        trailing: _TreeProgressNodeActions(
          item: item,
          onOpenProducts: item.productsCount > 0
              ? () => _openProducts(item)
              : null,
          onOpenArkusz:
              !item.isAmbiguous && item.arkuszExists && item.arkuszId != null
              ? () => _openArkusz(item)
              : null,
        ),
      ),
      expanded: true,
      children: [
        for (final child in children)
          _buildLocationNode(
            location: child,
            itemsByRecordId: itemsByRecordId,
            childrenByParent: childrenByParent,
            parentUsesRecordId: parentUsesRecordId,
          ),
      ],
    );
  }

  Future<void> _openArkusz(GetInwentaryzacjaTreeProgressItem item) async {
    final arkuszId = item.arkuszId;
    if (arkuszId == null) {
      return;
    }

    await showArkuszDetailModal(
      context,
      arkuszId: arkuszId,
      arkuszNumber: (item.arkuszNumer ?? '').trim().isNotEmpty
          ? item.arkuszNumer!.trim()
          : '${context.l10n.inventorySheetLabel} $arkuszId',
      inventoryCompanies: widget.inventoryCompanies,
      canDeleteArkusz: widget.canDeleteArkusz,
      canEditArkusz: widget.canEditArkusz,
      inventoriesRepository: widget.inventoriesRepository,
      locationsRepository: widget.locationsRepository,
      stockRepository: widget.stockRepository,
      usersRepository: widget.usersRepository,
      onDataChanged: widget.onDataChanged,
    );

    if (!mounted) {
      return;
    }

    await _load();
    widget.onDataChanged?.call();
  }

  Future<void> _openProducts(GetInwentaryzacjaTreeProgressItem item) {
    return showInventoryTreeProductsModal(
      context,
      inventoryId: widget.inventoryId,
      item: item,
      inventoryCompanies: widget.inventoryCompanies,
      inventoriesRepository: widget.inventoriesRepository,
      locationsRepository: widget.locationsRepository,
      stockRepository: widget.stockRepository,
      usersRepository: widget.usersRepository,
      canDeleteArkusz: widget.canDeleteArkusz,
      canEditArkusz: widget.canEditArkusz,
      onDataChanged: widget.onDataChanged,
    );
  }

  String _locationTitle(GetMiejscaItem location) {
    final name = (location.nazwa ?? '').trim();
    return name.isNotEmpty
        ? name
        : context.l10n.inventoryIdWithValue(location.idMiejsca);
  }

  InlineSpan _locationTitleSpan(GetMiejscaItem location) {
    final title = _locationTitle(location);
    final level = (location.lvl ?? '').trim();
    if (level.isEmpty) {
      return TextSpan(text: title);
    }

    return TextSpan(
      children: [
        TextSpan(text: title),
        const TextSpan(text: ' '),
        TextSpan(
          text: '($level)',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  int _compareTreeItems(
    GetInwentaryzacjaTreeProgressItem left,
    GetInwentaryzacjaTreeProgressItem right,
  ) => _compareLocations(
    GetMiejscaItem(
      id: left.id,
      idMiejsca: left.idMiejsca,
      idFirmy: left.idFirmy,
      idparent: left.idparent,
      baza: left.baza,
      nazwa: left.nazwa,
      lvl: left.lvl,
    ),
    GetMiejscaItem(
      id: right.id,
      idMiejsca: right.idMiejsca,
      idFirmy: right.idFirmy,
      idparent: right.idparent,
      baza: right.baza,
      nazwa: right.nazwa,
      lvl: right.lvl,
    ),
  );

  int _compareLocations(GetMiejscaItem left, GetMiejscaItem right) {
    final leftName = (left.nazwa ?? '').trim().toLowerCase();
    final rightName = (right.nazwa ?? '').trim().toLowerCase();
    final byName = leftName.compareTo(rightName);
    if (byName != 0) {
      return byName;
    }
    return left.idMiejsca.compareTo(right.idMiejsca);
  }
}

/// Akcje i statusy pokazywane przy pojedynczym wezle drzewa.
class _TreeProgressNodeActions extends StatelessWidget {
  const _TreeProgressNodeActions({
    required this.item,
    this.onOpenProducts,
    this.onOpenArkusz,
  });

  final GetInwentaryzacjaTreeProgressItem item;
  final VoidCallback? onOpenProducts;
  final VoidCallback? onOpenArkusz;

  @override
  Widget build(BuildContext context) {
    final shouldShowMissingArkusz = _isMissingArkusz(item);
    final statusLabel = switch ((item.isAmbiguous, item.arkuszExists)) {
      (true, _) => context.l10n.inventoryTreeStatusAmbiguous,
      (false, true) => context.l10n.inventoryTreeStatusCompleted,
      (false, false) when shouldShowMissingArkusz =>
        context.l10n.inventoryTreeStatusMissingSheet,
      (false, false) => context.l10n.inventoryTreeStatusNoProducts,
    };
    final statusTone = switch ((item.isAmbiguous, item.arkuszExists)) {
      (true, _) => AppStatusBadgeTone.danger,
      (false, true) => AppStatusBadgeTone.success,
      (false, false) when shouldShowMissingArkusz => AppStatusBadgeTone.warning,
      (false, false) => AppStatusBadgeTone.neutral,
    };
    final statusIcon = switch ((item.isAmbiguous, item.arkuszExists)) {
      (true, _) => Icons.error_outline_rounded,
      (false, true) => Icons.check_circle_rounded,
      (false, false) when shouldShowMissingArkusz => Icons.pending_outlined,
      (false, false) => Icons.remove_circle_outline_rounded,
    };
    final statusColor = switch (statusTone) {
      AppStatusBadgeTone.danger => context.feedback.errorForeground,
      AppStatusBadgeTone.success => context.feedback.successForeground,
      AppStatusBadgeTone.warning => context.feedback.warningForeground,
      AppStatusBadgeTone.info => context.feedback.infoForeground,
      AppStatusBadgeTone.neutral => context.colors.onSurfaceVariant,
    };

    if (MediaQuery.sizeOf(context).width < 720) {
      return Row(
        mainAxisSize: .min,
        children: [
          _TreeProductsBadge(
            count: item.productsCount,
            onPressed: onOpenProducts,
          ),
          Gaps.w4,
          Tooltip(
            message: item.isAmbiguous
                ? context.l10n.inventoryTreeAmbiguousTooltip
                : statusLabel,
            child: SizedBox.square(
              dimension: Sizes.p28,
              child: Icon(statusIcon, size: Sizes.p18, color: statusColor),
            ),
          ),
          if (onOpenArkusz != null) ...[
            Gaps.w4,
            IconButton(
              tooltip: context.l10n.inventorySearchSheetsOpenSheetAction,
              onPressed: onOpenArkusz,
              icon: const Icon(
                Icons.open_in_new_rounded,
                size: Sizes.p18,
              ),
              visualDensity: .compact,
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: .min,
      children: [
        SizedBox(
          width: _treeProductsColumnWidth,
          child: Align(
            alignment: .centerLeft,
            child: _TreeProductsBadge(
              count: item.productsCount,
              onPressed: onOpenProducts,
            ),
          ),
        ),
        Gaps.w8,
        SizedBox(
          width: _treeStatusColumnWidth,
          child: Align(
            alignment: .centerLeft,
            child: AppStatusBadge(
              label: statusLabel,
              tone: statusTone,
              icon: statusIcon,
              tooltip: item.isAmbiguous
                  ? context.l10n.inventoryTreeAmbiguousTooltip
                  : null,
              showBorder: false,
            ),
          ),
        ),
        Gaps.w8,
        SizedBox(
          width: _treeActionColumnWidth,
          child: Align(
            child: onOpenArkusz == null
                ? null
                : IconButton(
                    tooltip: context.l10n.inventorySearchSheetsOpenSheetAction,
                    onPressed: onOpenArkusz,
                    icon: const Icon(
                      Icons.open_in_new_rounded,
                      size: Sizes.p18,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
          ),
        ),
      ],
    );
  }
}

Future<void> showInventoryTreeProductsModal(
  BuildContext context, {
  required int inventoryId,
  required GetInwentaryzacjaTreeProgressItem item,
  required List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies,
  required InventoriesRepository inventoriesRepository,
  required LocationsRepository locationsRepository,
  required StockRepository stockRepository,
  required UsersRepository usersRepository,
  required bool canDeleteArkusz,
  required bool canEditArkusz,
  VoidCallback? onDataChanged,
}) {
  final title = (item.nazwa ?? '').trim().isNotEmpty
      ? item.nazwa!.trim()
      : context.l10n.inventoryLocationWithId(item.idMiejsca);
  final subtitle =
      '${item.baza} • ${context.l10n.inventoryProductsCount(item.productsCount)}';

  return AppExpandableSideSheet.show<void>(
    context,
    collapsedWidth: _treeProductsCollapsedWidth,
    expandedWidth: _treeProductsExpandedWidth,
    collapsedWidthFactor: .62,
    expandedWidthFactor: .8,
    title: context.l10n.inventoryLocationProductsTitle,
    subtitle: '$title • $subtitle',
    scrollBody: false,
    bodyBuilder: (context, controller) => _InventoryTreeProductsModalBody(
      expansionController: controller,
      inventoryId: inventoryId,
      item: item,
      inventoryCompanies: inventoryCompanies,
      inventoriesRepository: inventoriesRepository,
      locationsRepository: locationsRepository,
      stockRepository: stockRepository,
      usersRepository: usersRepository,
      canDeleteArkusz: canDeleteArkusz,
      canEditArkusz: canEditArkusz,
      onDataChanged: onDataChanged,
    ),
  );
}

/// Klikalny licznik produktów przypisanych do miejsca.
class _TreeProductsBadge extends StatelessWidget {
  const _TreeProductsBadge({
    required this.count,
    this.onPressed,
  });

  final int count;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final badge = AppStatusBadge(
      label: '$count',
      tone: count > 0 ? .info : .neutral,
      icon: Icons.inventory_2_outlined,
      tooltip: count > 0 ? context.l10n.inventoryTreeProductsTooltip : null,
      showBorder: false,
    );

    if (onPressed == null) {
      return badge;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.p2),
          child: badge,
        ),
      ),
    );
  }
}

/// Zawartość modala produktów przypisanych do miejsca drzewa.
class _InventoryTreeProductsModalBody extends StatefulWidget {
  const _InventoryTreeProductsModalBody({
    required this.expansionController,
    required this.inventoryId,
    required this.item,
    required this.inventoryCompanies,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    required this.canDeleteArkusz,
    required this.canEditArkusz,
    this.onDataChanged,
  });

  final AppExpandableSideSheetController expansionController;
  final int inventoryId;
  final GetInwentaryzacjaTreeProgressItem item;
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final bool canDeleteArkusz;
  final bool canEditArkusz;
  final VoidCallback? onDataChanged;

  @override
  State<_InventoryTreeProductsModalBody> createState() =>
      _InventoryTreeProductsModalBodyState();
}

/// Stan pobierania i wyszukiwania produktów przypisanych do miejsca.
class _InventoryTreeProductsModalBodyState
    extends State<_InventoryTreeProductsModalBody> {
  final AppSearchTextFieldController _sheetSearchController =
      AppSearchTextFieldController();
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  int _requestRevision = 0;
  GetStanStResponseData? _data;

  @override
  void initState() {
    super.initState();
    widget.expansionController.addListener(_handleExpansionChanged);
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant _InventoryTreeProductsModalBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expansionController != widget.expansionController) {
      oldWidget.expansionController.removeListener(_handleExpansionChanged);
      widget.expansionController.addListener(_handleExpansionChanged);
    }
  }

  @override
  void dispose() {
    widget.expansionController.removeListener(_handleExpansionChanged);
    _sheetSearchController.dispose();
    super.dispose();
  }

  void _handleExpansionChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _load() async {
    final requestRevision = ++_requestRevision;
    final query = _searchQuery.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await widget.stockRepository.fetchStock(
      GetStanStQuery(
        firma: widget.item.idFirmy,
        baza: widget.item.baza,
        idmiejsce: widget.item.idMiejsca,
        stan: '1',
        q: query.isEmpty ? null : query,
        limit: _treeProductsPageLimit,
        offset: 0,
      ),
    );

    if (!mounted || requestRevision != _requestRevision) {
      return;
    }

    result.fold(
      (error) => setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      }),
      (data) => setState(() {
        _isLoading = false;
        _data = data;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _data == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.p24),
          child: AppSpinner(size: Sizes.p24),
        ),
      );
    }

    if (_errorMessage != null && _data == null) {
      return AppEmptyState.error(
        title: context.l10n.inventoryProductsLoadErrorTitle,
        message: _errorMessage!,
        compact: true,
        action: AppActionButton.outlined(
          label: context.l10n.inventoryRetryAction,
          icon: Icons.refresh_rounded,
          tone: .danger,
          onPressedAsync: _load,
        ),
      );
    }

    final data = _data;
    if (data == null) {
      return const SizedBox.shrink();
    }

    if (data.items.isEmpty && _searchQuery.isEmpty && !_isLoading) {
      return AppEmptyState.noData(
        title: context.l10n.inventoryProductsEmptyTitle,
        message: context.l10n.inventoryProductsEmptyMessage,
        compact: true,
      );
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                data.meta.total > data.items.length
                    ? context.l10n.inventoryProductsShownSummary(
                        data.items.length,
                        data.meta.total,
                      )
                    : context.l10n.inventoryProductsSummary(data.meta.total),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            AppActionButton.outlined(
              label: context.l10n.inventoryRefresh,
              icon: Icons.refresh_rounded,
              onPressedAsync: _load,
            ),
            Gaps.w8,
            AppActionButton.outlined(
              label: context.l10n.inventorySearchSheetsTitle,
              icon: Icons.manage_search_rounded,
              onPressed: _toggleSheetSearchPanel,
            ),
          ],
        ),
        if (_errorMessage != null) ...[
          Gaps.h12,
          AppEmptyState.error(
            title: context.l10n.inventoryShowingLastDataTitle,
            message: _errorMessage!,
            compact: true,
          ),
        ],
        Gaps.h12,
        AppSearchTextField(
          inlineLabel: context.l10n.inventorySearch,
          hintText: context.l10n.inventorySearchSheetsHint,
          onChanged: (value) {
            _searchQuery = value;
            unawaited(_load());
          },
        ),
        Gaps.h12,
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final canSplit =
                  constraints.maxWidth >= _treeProductsSplitBreakpoint;
              final isExpanded = widget.expansionController.isExpanded;
              final showSidePanel = isExpanded && canSplit;
              final showBottomPanel = isExpanded && !canSplit;

              return Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: .stretch,
                      children: [
                        Flexible(
                          flex: showSidePanel ? 9 : 1,
                          child: _buildProductsResults(context, data),
                        ),
                        if (showSidePanel) ...[
                          Gaps.w12,
                          Flexible(
                            flex: 11,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 520,
                              ),
                              child: _buildSheetSearchPanel(
                                context,
                                autofocus: false,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showBottomPanel) ...[
                    Gaps.h12,
                    SizedBox(
                      height: 420,
                      child: _buildSheetSearchPanel(
                        context,
                        autofocus: false,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsResults(
    BuildContext context,
    GetStanStResponseData data,
  ) {
    if (data.items.isEmpty) {
      return Center(
        child: AppEmptyState.noResults(
          title: context.l10n.inventoryNoSearchResultsTitle,
          message: context.l10n.inventoryTryAnotherPhraseMessage,
        ),
      );
    }

    return AppSimpleTable<GetStanStItem>(
      rows: data.items,
      height: null,
      columns: [
        AppSimpleTableColumn<GetStanStItem>(
          label: context.l10n.inventoryRegisterNumberShort,
          width: 140,
          cellBuilder: (context, row) => AppText(row.nrewid ?? '—'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: context.l10n.inventoryName,
          width: 260,
          cellBuilder: (context, row) =>
              AppText(row.nazwa ?? context.l10n.inventoryNoName),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: context.l10n.inventoryPerson,
          width: 180,
          cellBuilder: (context, row) => AppText(row.osoba ?? '—'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: context.l10n.inventoryCode,
          width: 130,
          numeric: true,
          cellBuilder: (context, row) =>
              AppText(row.kodKreskowy?.toString() ?? '—'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: context.l10n.inventoryValueP,
          width: 120,
          numeric: true,
          cellBuilder: (context, row) => AppText(row.wartoscP ?? '—'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: '',
          width: 56,
          sortable: false,
          cellAlignment: .center,
          cellBuilder: (context, row) => IconButton(
            tooltip: context.l10n.inventorySearchSheetsTitle,
            onPressed: () => _openSheetSearchForItem(row),
            visualDensity: .compact,
            icon: const Icon(Icons.manage_search_rounded, size: Sizes.p18),
          ),
        ),
      ],
      onRowTap: (_, row, _) => _openSheetSearchForItem(row),
    );
  }

  Widget _buildSheetSearchPanel(
    BuildContext context, {
    required bool autofocus,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p12),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(
                    context.l10n.inventorySearchSheetsTitle,
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: .w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.close,
                  onPressed: _toggleSheetSearchPanel,
                  visualDensity: .compact,
                  icon: const Icon(Icons.close_rounded, size: Sizes.p18),
                ),
              ],
            ),
            Gaps.h4,
            AppText(
              context.l10n.inventorySearchSheetsHint,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            Gaps.h12,
            Expanded(
              child: BlocProvider(
                create: (_) => InventorySheetSearchCubit(
                  repository: widget.inventoriesRepository,
                ),
                child: InventorySheetSearchContent(
                  inventoryId: widget.inventoryId,
                  searchController: _sheetSearchController,
                  autofocus: autofocus,
                  searchFieldWidth: null,
                  compact: true,
                  onSelection: _handleSheetSelection,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSheetSearchPanel() {
    widget.expansionController.toggle();
  }

  void _openSheetSearchForItem(GetStanStItem item) {
    final query = _bestSheetSearchQuery(item);
    widget.expansionController.expand();
    if (query != null) {
      _sheetSearchController.setQuery(query);
    }
  }

  String? _bestSheetSearchQuery(GetStanStItem item) {
    final nrewid = item.nrewid?.trim();
    if (nrewid != null && nrewid.isNotEmpty) {
      return nrewid;
    }

    final barcode = item.kodKreskowy?.toString().trim();
    if (barcode != null && barcode.isNotEmpty) {
      return barcode;
    }

    final name = item.nazwa?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }

    return null;
  }

  Future<void> _handleSheetSelection(
    InventorySheetSearchSelection selection,
  ) async {
    await showArkuszDetailModal(
      context,
      arkuszId: selection.arkuszId,
      arkuszNumber: selection.arkuszNumber,
      inventoryCompanies: widget.inventoryCompanies,
      canDeleteArkusz: widget.canDeleteArkusz,
      canEditArkusz: widget.canEditArkusz,
      inventoriesRepository: widget.inventoriesRepository,
      locationsRepository: widget.locationsRepository,
      stockRepository: widget.stockRepository,
      usersRepository: widget.usersRepository,
      initialHighlightElementId: selection.elementId,
      onDataChanged: widget.onDataChanged,
    );

    if (!mounted) {
      return;
    }

    await _load();
    widget.onDataChanged?.call();
  }
}
