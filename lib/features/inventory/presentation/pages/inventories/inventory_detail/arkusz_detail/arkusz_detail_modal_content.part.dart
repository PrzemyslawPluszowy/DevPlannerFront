part of 'arkusz_detail_modal.dart';

/// Pelnoekranowa strona szczegolow arkusza.
class _ArkuszDetailPage extends StatelessWidget {
  /// Tworzy strone szczegolow arkusza.
  const _ArkuszDetailPage({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.inventoryCompanies,
    required this.canDeleteArkusz,
    required this.canEditArkusz,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    this.initialHighlightElementId,
    this.onDataChanged,
  });

  final int arkuszId;
  final String arkuszNumber;
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;
  final bool canDeleteArkusz;
  final bool canEditArkusz;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final int? initialHighlightElementId;
  final VoidCallback? onDataChanged;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(intl.inventorySheetDetailsTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(Sizes.p28),
          child: Padding(
            padding: const .fromLTRB(Sizes.p16, 0, Sizes.p16, Sizes.p8),
            child: Align(
              alignment: .centerLeft,
              child: AppText(
                intl.inventoryNumberLabel(arkuszNumber),
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _ArkuszDetailBody(
        arkuszId: arkuszId,
        arkuszNumber: arkuszNumber,
        inventoryCompanies: inventoryCompanies,
        canDeleteArkusz: canDeleteArkusz,
        canEditArkusz: canEditArkusz,
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
        stockRepository: stockRepository,
        usersRepository: usersRepository,
        initialHighlightElementId: initialHighlightElementId,
        onDataChanged: onDataChanged,
      ),
    );
  }
}

/// Zawartosc widoku szczegolow arkusza.
class _ArkuszDetailBody extends StatelessWidget {
  /// Tworzy body szczegolow arkusza.
  const _ArkuszDetailBody({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.inventoryCompanies,
    required this.canDeleteArkusz,
    required this.canEditArkusz,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    this.initialHighlightElementId,
    this.onDataChanged,
  });

  final int arkuszId;
  final String arkuszNumber;
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;
  final bool canDeleteArkusz;
  final bool canEditArkusz;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final int? initialHighlightElementId;
  final VoidCallback? onDataChanged;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocBuilder<
      ArkuszPreviewCubit,
      LoadableState<GetArkuszDetailsResponseData>
    >(
      builder: (context, state) {
        return switch (state) {
          LoadableInitial() || LoadableLoading() => const Center(
            child: Padding(
              padding: .symmetric(vertical: Sizes.p24),
              child: AppSpinner(size: Sizes.p24),
            ),
          ),
          LoadableError(:final message) => Padding(
            padding: const .all(Sizes.p16),
            child: AppEmptyState.error(
              title: intl.inventorySheetDetailsLoadErrorTitle,
              message: message,
              compact: true,
              action: AppActionButton.outlined(
                label: intl.retry,
                icon: Icons.refresh_rounded,
                tone: .neutral,
                onPressed: () =>
                    context.read<ArkuszPreviewCubit>().load(arkuszId),
              ),
            ),
          ),
          LoadableSuccess(:final data) => Padding(
            padding: const .all(Sizes.p16),
            child: _ArkuszDetailLoaded(
              arkuszId: arkuszId,
              arkuszNumber: arkuszNumber,
              inventoryCompanies: inventoryCompanies,
              canDeleteArkusz: canDeleteArkusz,
              canEditArkusz: canEditArkusz,
              data: data,
              inventoriesRepository: inventoriesRepository,
              locationsRepository: locationsRepository,
              stockRepository: stockRepository,
              usersRepository: usersRepository,
              initialHighlightElementId: initialHighlightElementId,
              onDataChanged: onDataChanged,
            ),
          ),
        };
      },
    );
  }
}

/// Widok danych zaladowanych szczegolow arkusza.
class _ArkuszDetailLoaded extends StatefulWidget {
  /// Tworzy widok zaladowanych danych arkusza.
  const _ArkuszDetailLoaded({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.inventoryCompanies,
    required this.canDeleteArkusz,
    required this.canEditArkusz,
    required this.data,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    this.initialHighlightElementId,
    this.onDataChanged,
  });

  final int arkuszId;
  final String arkuszNumber;
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;
  final bool canDeleteArkusz;
  final bool canEditArkusz;
  final GetArkuszDetailsResponseData data;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final int? initialHighlightElementId;
  final VoidCallback? onDataChanged;

  @override
  State<_ArkuszDetailLoaded> createState() => _ArkuszDetailLoadedState();
}

class _ArkuszDetailLoadedState extends State<_ArkuszDetailLoaded> {
  final GlobalKey<_ArkuszElementsSectionState> _elementsSectionKey =
      GlobalKey<_ArkuszElementsSectionState>();
  late List<GetArkuszDetailsElementItem> _visibleItemsForExport;

  List<GetArkuszDetailsElementItem> get _visibleItems =>
      widget.data.elementy.toList(growable: false);

  @override
  void initState() {
    super.initState();
    _visibleItemsForExport = _visibleItems;
  }

  @override
  void didUpdateWidget(covariant _ArkuszDetailLoaded oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.data, widget.data)) {
      _visibleItemsForExport = _visibleItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.data.arkusz;
    return Column(
      crossAxisAlignment: .start,
      children: [
        _ArkuszDetailSummaryCard(
          arkuszId: widget.arkuszId,
          arkuszNumber: widget.arkuszNumber,
          canEditArkusz: widget.canEditArkusz,
          data: widget.data,
          inventoriesRepository: widget.inventoriesRepository,
          usersRepository: widget.usersRepository,
          onDataChanged: widget.onDataChanged,
        ),
        Gaps.h16,
        _ArkuszElementsToolbar(
          arkuszId: widget.arkuszId,
          arkuszNumber: widget.arkuszNumber,
          inventoryCompanies: widget.inventoryCompanies,
          data: widget.data,
          visibleItemsForExport: _visibleItemsForExport,
          canEditArkusz: widget.canEditArkusz,
          canDeleteArkusz: widget.canDeleteArkusz,
          startDateTime: header.rozpoczecie,
          endDateTime: header.zakonczenie,
          repository: widget.inventoriesRepository,
          usersRepository: widget.usersRepository,
          stockRepository: widget.stockRepository,
          onItemAdded: _handleItemAdded,
          onDataChanged: widget.onDataChanged,
        ),
        Gaps.h8,
        Expanded(
          child: _ArkuszElementsSection(
            key: _elementsSectionKey,
            arkuszId: widget.arkuszId,
            inventoryCompanies: widget.inventoryCompanies,
            items: _visibleItems,
            placeLevel: header.lvlMiejsca,
            inventoriesRepository: widget.inventoriesRepository,
            locationsRepository: widget.locationsRepository,
            stockRepository: widget.stockRepository,
            usersRepository: widget.usersRepository,
            canEdit: widget.canEditArkusz,
            initialHighlightElementId: widget.initialHighlightElementId,
            onVisibleItemsChanged: _handleVisibleItemsChanged,
            onDataChanged: widget.onDataChanged,
          ),
        ),
      ],
    );
  }

  void _handleItemAdded(int itemId) {
    _elementsSectionKey.currentState?.focusItem(itemId);
  }

  void _handleVisibleItemsChanged(List<GetArkuszDetailsElementItem> items) {
    if (_haveSameVisibleItems(_visibleItemsForExport, items)) {
      return;
    }

    setState(() {
      _visibleItemsForExport = List<GetArkuszDetailsElementItem>.unmodifiable(
        items,
      );
    });
  }

  bool _haveSameVisibleItems(
    List<GetArkuszDetailsElementItem> current,
    List<GetArkuszDetailsElementItem> next,
  ) {
    if (identical(current, next)) {
      return true;
    }
    if (current.length != next.length) {
      return false;
    }

    for (var index = 0; index < current.length; index++) {
      if (current[index].id != next[index].id) {
        return false;
      }
    }

    return true;
  }
}
