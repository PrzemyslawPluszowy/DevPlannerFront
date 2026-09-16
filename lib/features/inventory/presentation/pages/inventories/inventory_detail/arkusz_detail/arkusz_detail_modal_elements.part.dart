part of 'arkusz_detail_modal.dart';

/// Sekcja elementow z lokalna wyszukiwarka.
class _ArkuszElementsSection extends StatefulWidget {
  /// Tworzy sekcje elementow z wyszukiwarka.
  const _ArkuszElementsSection({
    required this.arkuszId,
    required this.inventoryCompanies,
    required this.items,
    required this.placeLevel,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    required this.canEdit,
    required this.onVisibleItemsChanged,
    this.initialHighlightElementId,
    super.key,
    this.onDataChanged,
  });

  final int arkuszId;
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;
  final List<GetArkuszDetailsElementItem> items;
  final String? placeLevel;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final bool canEdit;
  final int? initialHighlightElementId;
  final ValueChanged<List<GetArkuszDetailsElementItem>> onVisibleItemsChanged;
  final VoidCallback? onDataChanged;

  @override
  State<_ArkuszElementsSection> createState() => _ArkuszElementsSectionState();
}

/// Stan sekcji elementow z lokalna wyszukiwarka.
class _ArkuszElementsSectionState extends State<_ArkuszElementsSection> {
  final TableViewController _tableController = TableViewController();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  ArkuszElementStatusSpisu? _statusSpisuFilter;
  ArkuszElementInwentStatus? _dostepnyFilter;
  bool? _scannerFilter;
  int? _highlightedItemId;
  int? _pendingFocusItemId;
  Timer? _highlightResetTimer;

  @override
  void dispose() {
    _highlightResetTimer?.cancel();
    _tableController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final initialHighlightElementId = widget.initialHighlightElementId;
    if (initialHighlightElementId != null) {
      _pendingFocusItemId = initialHighlightElementId;
      _highlightedItemId = initialHighlightElementId;
    }
  }

  @override
  void didUpdateWidget(covariant _ArkuszElementsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialHighlightElementId !=
            widget.initialHighlightElementId &&
        widget.initialHighlightElementId != null) {
      _pendingFocusItemId = widget.initialHighlightElementId;
      _highlightedItemId = widget.initialHighlightElementId;
    }
  }

  void focusItem(int itemId) {
    _handleEditSaved(itemId);
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final statusSpisuOptions = _statusSpisuFilterOptions(context);
    final dostepnyOptions = _dostepnyFilterOptions(context);
    final scannerOptions = _scannerFilterOptions(context);
    final filtered = widget.items
        .where(
          (item) =>
              _matchesQuery(item) &&
              _matchesStatusSpisu(item) &&
              _matchesDostepny(item) &&
              _matchesScanner(item),
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: .start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1320;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _searchController,
                      hintText: intl.inventorySearchSheetItemsHint,
                      prefixIcon: Icons.search_rounded,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  Gaps.w8,
                  SizedBox(
                    width: 220,
                    child: AppDropdown<ArkuszElementStatusSpisu?>(
                      variant: .filled,
                      value: _statusSpisuFilter,
                      inlineLabel: statusSpisuFieldLabel(context),
                      hintText: intl.inventoryAll,
                      options: statusSpisuOptions,
                      onChanged: (value) =>
                          setState(() => _statusSpisuFilter = value),
                    ),
                  ),
                  Gaps.w8,
                  SizedBox(
                    width: 170,
                    child: AppDropdown<ArkuszElementInwentStatus?>(
                      variant: .filled,
                      value: _dostepnyFilter,
                      inlineLabel:
                          context.l10n.inventoryInventoryStateAvailable,
                      hintText: intl.inventoryAll,
                      options: dostepnyOptions,
                      onChanged: (value) =>
                          setState(() => _dostepnyFilter = value),
                    ),
                  ),
                  Gaps.w8,
                  SizedBox(
                    width: 200,
                    child: AppDropdown<bool?>(
                      variant: .filled,
                      value: _scannerFilter,
                      inlineLabel: intl.inventoryScan,
                      hintText: intl.inventoryAll,
                      options: scannerOptions,
                      onChanged: (value) =>
                          setState(() => _scannerFilter = value),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _searchController,
                        hintText: intl.inventorySearchSheetItemsHint,
                        prefixIcon: Icons.search_rounded,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                    ),
                    Gaps.w8,
                    SizedBox(
                      width: 220,
                      child: AppDropdown<ArkuszElementStatusSpisu?>(
                        variant: .filled,
                        value: _statusSpisuFilter,
                        inlineLabel: statusSpisuFieldLabel(context),
                        hintText: intl.inventoryAll,
                        options: statusSpisuOptions,
                        onChanged: (value) =>
                            setState(() => _statusSpisuFilter = value),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    SizedBox(
                      width: 170,
                      child: AppDropdown<ArkuszElementInwentStatus?>(
                        variant: .filled,
                        value: _dostepnyFilter,
                        inlineLabel:
                            context.l10n.inventoryInventoryStateAvailable,
                        hintText: intl.inventoryAll,
                        options: dostepnyOptions,
                        onChanged: (value) =>
                            setState(() => _dostepnyFilter = value),
                      ),
                    ),
                    Gaps.w8,
                    SizedBox(
                      width: 200,
                      child: AppDropdown<bool?>(
                        variant: .filled,
                        value: _scannerFilter,
                        inlineLabel: intl.inventoryScan,
                        hintText: intl.inventoryAll,
                        options: scannerOptions,
                        onChanged: (value) =>
                            setState(() => _scannerFilter = value),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        Gaps.h8,
        AppText(
          intl.inventoryResultsCount(filtered.length, widget.items.length),
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.h8,
        Expanded(
          child: switch (filtered.isEmpty) {
            true => AppEmptyState.noData(
              title: _query.trim().isEmpty
                  ? intl.inventoryNoItemsTitle
                  : intl.inventoryNoSearchResultsTitle,
              message: _query.trim().isEmpty
                  ? intl.inventorySheetNoItemsMessage
                  : intl.inventoryTryAnotherPhraseMessage,
              compact: true,
            ),
            false => _ArkuszElementsTable(
              arkuszId: widget.arkuszId,
              inventoryCompanies: widget.inventoryCompanies,
              items: filtered,
              placeLevel: widget.placeLevel,
              tableController: _tableController,
              highlightedItemId: _highlightedItemId,
              inventoriesRepository: widget.inventoriesRepository,
              locationsRepository: widget.locationsRepository,
              stockRepository: widget.stockRepository,
              usersRepository: widget.usersRepository,
              canEdit: widget.canEdit,
              onVisibleRowsChanged: _handleVisibleRowsChanged,
              onEditSaved: _handleEditSaved,
              onDataChanged: widget.onDataChanged,
            ),
          },
        ),
      ],
    );
  }

  // Jedno miejsce prawdy dla opcji filtrowania po statusie spisu.
  List<AppDropdownOption<ArkuszElementStatusSpisu?>> _statusSpisuFilterOptions(
    BuildContext context,
  ) {
    return [
      AppDropdownOption<ArkuszElementStatusSpisu?>(
        value: null,
        label: statusSpisuNoSelectionLabel(context),
      ),
      ...kVisibleStatusSpisuOptions.map(
        (status) => status.toDropdownOption(context),
      ),
    ];
  }

  List<AppDropdownOption<ArkuszElementInwentStatus?>> _dostepnyFilterOptions(
    BuildContext context,
  ) {
    final intl = context.l10n;
    return [
      AppDropdownOption<ArkuszElementInwentStatus?>(
        value: null,
        label: intl.inventoryAll,
      ),
      AppDropdownOption<ArkuszElementInwentStatus?>(
        value: ArkuszElementInwentStatus.brak,
        label: ArkuszElementInwentStatus.brak.localizedLabel(context),
        icon: ArkuszElementInwentStatus.brak.icon,
        foregroundColor: ArkuszElementInwentStatus.brak.dropdownForegroundColor(
          context,
        ),
      ),
      AppDropdownOption<ArkuszElementInwentStatus?>(
        value: ArkuszElementInwentStatus.zgodny,
        label: ArkuszElementInwentStatus.zgodny.localizedLabel(context),
        icon: ArkuszElementInwentStatus.zgodny.icon,
        foregroundColor: ArkuszElementInwentStatus.zgodny
            .dropdownForegroundColor(context),
      ),
      AppDropdownOption<ArkuszElementInwentStatus?>(
        value: ArkuszElementInwentStatus.przeniesiony,
        label: ArkuszElementInwentStatus.przeniesiony.localizedLabel(context),
        icon: ArkuszElementInwentStatus.przeniesiony.icon,
        foregroundColor: ArkuszElementInwentStatus.przeniesiony
            .dropdownForegroundColor(context),
      ),
    ];
  }

  List<AppDropdownOption<bool?>> _scannerFilterOptions(BuildContext context) {
    final intl = context.l10n;
    return [
      AppDropdownOption<bool?>(value: null, label: intl.inventoryAll),
      AppDropdownOption<bool?>(
        value: false,
        label: intl.inventoryScannerNotRead,
      ),
      AppDropdownOption<bool?>(value: true, label: intl.inventoryScannerRead),
    ];
  }

  bool _matchesQuery(GetArkuszDetailsElementItem item) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return true;
    }

    final searchableValues = <String>[
      '${item.id}',
      item.nrewid ?? '',
      item.nazwa ?? '',
      item.nowaNazwa ?? '',
      item.osoba ?? '',
      item.nowaOsoba ?? '',
      item.miejsce ?? '',
      item.lvl ?? '',
      item.nadwMiejsce ?? '',
      item.nadwLvl ?? '',
      item.kodKreskowy?.toString() ?? '',
      item.nowyKodKreskowy ?? '',
      item.uwagiLoc ?? '',
    ];
    return searchableValues.any((value) => value.toLowerCase().contains(query));
  }

  bool _matchesStatusSpisu(GetArkuszDetailsElementItem item) {
    if (_statusSpisuFilter == null) {
      return true;
    }
    return item.statusSpisu == _statusSpisuFilter;
  }

  bool _matchesDostepny(GetArkuszDetailsElementItem item) {
    if (_dostepnyFilter == null) {
      return true;
    }
    final value = item.stanInwent ?? ArkuszElementInwentStatus.brak;
    return value == _dostepnyFilter;
  }

  bool _matchesScanner(GetArkuszDetailsElementItem item) {
    if (_scannerFilter == null) {
      return true;
    }
    return (item.kkWczytany ?? false) == _scannerFilter;
  }

  void _handleEditSaved(int itemId) {
    _highlightResetTimer?.cancel();
    setState(() {
      _highlightedItemId = itemId;
      _pendingFocusItemId = itemId;
    });
    _highlightResetTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      setState(() {
        if (_highlightedItemId == itemId) {
          _highlightedItemId = null;
        }
      });
    });
  }

  void _handleVisibleRowsChanged(List<GetArkuszDetailsElementItem> rows) {
    widget.onVisibleItemsChanged(rows);

    final targetId = _pendingFocusItemId;
    if (targetId == null) {
      return;
    }

    final targetIndex = rows.indexWhere((row) => row.id == targetId);
    if (targetIndex < 0 ||
        !_tableController.verticalScrollController.hasClients) {
      return;
    }

    _pendingFocusItemId = null;
    final targetOffset = (targetIndex * 58.0) - 116.0;
    final clampedOffset = targetOffset.clamp(
      0.0,
      _tableController.verticalScrollController.position.maxScrollExtent,
    );

    _tableController.verticalScrollController
        .animateTo(
          clampedOffset,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        )
        .ignore();
  }
}
