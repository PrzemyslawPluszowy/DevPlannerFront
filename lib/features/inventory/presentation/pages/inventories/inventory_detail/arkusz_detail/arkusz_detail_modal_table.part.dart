part of 'arkusz_detail_modal.dart';

/// Tabela elementow arkusza.
class _ArkuszElementsTable extends StatelessWidget {
  /// Tworzy tabele elementow arkusza.
  const _ArkuszElementsTable({
    required this.arkuszId,
    required this.inventoryCompanies,
    required this.items,
    required this.placeLevel,
    required this.tableController,
    required this.highlightedItemId,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    required this.canEdit,
    required this.onVisibleRowsChanged,
    required this.onEditSaved,
    this.onDataChanged,
  });

  final int arkuszId;
  final List<GetInwentaryzacjaDetailsFirmaItem> inventoryCompanies;
  final List<GetArkuszDetailsElementItem> items;
  final String? placeLevel;
  final TableViewController tableController;
  final int? highlightedItemId;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final bool canEdit;
  final ValueChanged<List<GetArkuszDetailsElementItem>> onVisibleRowsChanged;
  final ValueChanged<int> onEditSaved;
  final VoidCallback? onDataChanged;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final modalContext = context;
    return AppSimpleTable<GetArkuszDetailsElementItem>(
      height: null,
      rows: items,
      rowHeight: 58,
      minScrollableWidthRatio: 1,
      simpleExcelMode: true,
      tableController: tableController,
      rowKeyBuilder: (row) => row.id,
      highlightedRowKey: highlightedItemId,
      rowBackgroundColor: (context, row) => row.isLiquidated
          ? context.colors.errorContainer.withValues(alpha: .42)
          : null,
      onVisibleRowsChanged: onVisibleRowsChanged,
      onRowTap: !canEdit
          ? null
          : (_, row, _) {
              (() async {
                final saved = await showChangeItemModal(
                  modalContext,
                  arkuszId: arkuszId,
                  inventoryCompanies: inventoryCompanies,
                  item: row,
                  inventoriesRepository: inventoriesRepository,
                  locationsRepository: locationsRepository,
                  stockRepository: stockRepository,
                  usersRepository: usersRepository,
                );
                if (!modalContext.mounted || saved != true) {
                  return;
                }
                await modalContext.read<ArkuszPreviewCubit>().load(arkuszId);
                onEditSaved(row.id);
                onDataChanged?.call();
              })().ignore();
            },
      columns: [
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: 'Lp.',
          width: 64,
          numeric: true,
          sortable: false,
          indexedCellBuilder: (context, row, sourceIndex, visibleIndex) =>
              AppText('${visibleIndex + 1}'),
          cellBuilder: (context, row) => const SizedBox.shrink(),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.id,
          width: 72,
          numeric: true,
          sortValue: (row) => row.id,
          cellBuilder: (context, row) => AppText('${row.id}'),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryRegisterNumberShort,
          width: 120,
          sortValue: (row) => _normalize(row.nrewid).toLowerCase(),
          cellBuilder: (context, row) => AppText(_normalize(row.nrewid)),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryName,
          width: 260,
          sortValue: (row) => _changedValueLabel(
            current: row.nazwa,
            next: row.nowaNazwa,
          ).toLowerCase(),
          cellBuilder: (context, row) => AppText(
            _changedValueLabel(current: row.nazwa, next: row.nowaNazwa),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryPerson,
          width: 180,
          sortValue: (row) => _changedValueLabel(
            current: row.osoba,
            next: row.nowaOsoba,
          ).toLowerCase(),
          cellBuilder: (context, row) {
            final personChanged = _hasMeaningfulChange(
              row.osoba,
              row.nowaOsoba,
            );
            return AppText(
              _changedValueLabel(current: row.osoba, next: row.nowaOsoba),
              style: personChanged
                  ? context.text.bodyMedium?.copyWith(fontWeight: .w700)
                  : null,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryLocation,
          width: 280,
          sortValue: (row) => _locationLabel(
            context: context,
            item: row,
            fallbackLevel: placeLevel,
          ).toLowerCase(),
          cellBuilder: (context, row) {
            final locationChanged = _hasLocationMeaningfulChange(
              item: row,
              fallbackLevel: placeLevel,
            );
            return AppText(
              _locationLabel(
                context: context,
                item: row,
                fallbackLevel: placeLevel,
              ),
              style: locationChanged
                  ? context.text.bodyMedium?.copyWith(fontWeight: .w700)
                  : null,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: statusSpisuFieldLabel(context),
          width: 180,
          sortValue: (row) => _statusSpisuSortValue(row.statusSpisu),
          cellBuilder: (context, row) =>
              _buildInventoryStatusBadge(context, row.statusSpisu),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: context.l10n.inventoryCurrentState,
          width: 170,
          sortValue: (row) => _assetStatusSortValue(row.assetStatus),
          cellBuilder: (context, row) =>
              AppText(_assetStatusLabel(row.assetStatus)),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: context.l10n.inventoryInventoryStateAvailable,
          width: 170,
          sortValue: (row) => _stanInwentSortValue(row.stanInwent),
          cellBuilder: (context, row) =>
              _buildStanInwentBadge(context, row.stanInwent),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: context.l10n.inventoryScan,
          width: 200,
          sortValue: (row) => switch (row.kkWczytany) {
            false => 0,
            true => 1,
            _ => -1,
          },
          cellBuilder: (context, row) =>
              _buildScannerBadge(context, row.kkWczytany),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryBarcode,
          width: 160,
          sortValue: _barcodeLabel,
          cellBuilder: (context, row) => AppText(_barcodeLabel(row)),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryValueP,
          width: 120,
          numeric: true,
          sortValue: (row) => _asSortableNumber(row.wartoscP),
          cellBuilder: (context, row) => AppText(row.wartoscP.toAppMoney()),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryValueA,
          width: 120,
          numeric: true,
          sortValue: (row) => _asSortableNumber(row.wartoscA),
          cellBuilder: (context, row) => AppText(row.wartoscA.toAppMoney()),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryRemarks,
          width: 220,
          sortValue: (row) => _normalize(row.uwagiLoc).toLowerCase(),
          cellBuilder: (context, row) => AppText(
            _normalize(row.uwagiLoc),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppSimpleTableColumn<GetArkuszDetailsElementItem>(
          label: intl.inventoryFoundInOtherSheet,
          width: 280,
          sortValue: (row) => _foundInOtherSheetLabel(row).toLowerCase(),
          cellBuilder: (context, row) => AppText(
            _foundInOtherSheetLabel(row),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _normalize(String? value) {
    final normalized = value?.trim();
    return switch (normalized) {
      final String v when v.isNotEmpty => v,
      _ => '-',
    };
  }

  String _placeLabel({
    required BuildContext context,
    String? place,
    String? level,
  }) {
    final intl = context.l10n;
    final normalizedPlace = _normalize(place);
    final normalizedLevel = _normalize(level);
    if (normalizedLevel == '-') {
      return normalizedPlace;
    }
    return '$normalizedPlace\n${intl.inventoryLevel}: $normalizedLevel';
  }

  String _locationLabel({
    required BuildContext context,
    required GetArkuszDetailsElementItem item,
    String? fallbackLevel,
  }) {
    final currentPlace = item.miejsce;
    final currentLevel = item.lvl ?? fallbackLevel;
    final nextPlace = item.nadwMiejsce;
    final nextLevel = item.nadwLvl;

    if (_hasLocationMeaningfulChange(
      item: item,
      fallbackLevel: fallbackLevel,
    )) {
      final placeLabel = _changedValueLabel(
        current: currentPlace,
        next: nextPlace,
      );
      final levelLabel = _changedValueLabel(
        current: currentLevel,
        next: nextLevel,
      );
      return '$placeLabel\n${context.l10n.inventoryLevel}: $levelLabel';
    }

    return _placeLabel(
      context: context,
      place: currentPlace,
      level: currentLevel,
    );
  }

  bool _hasLocationMeaningfulChange({
    required GetArkuszDetailsElementItem item,
    String? fallbackLevel,
  }) {
    final currentPlace = item.miejsce;
    final currentLevel = item.lvl ?? fallbackLevel;
    final nextPlace = item.nadwMiejsce;
    final nextLevel = item.nadwLvl;
    return _hasMeaningfulChange(currentPlace, nextPlace) ||
        _hasMeaningfulChange(currentLevel, nextLevel);
  }

  String _barcodeLabel(GetArkuszDetailsElementItem item) {
    return _changedValueLabel(
      current: item.kodKreskowy?.toString(),
      next: item.nowyKodKreskowy,
    );
  }

  String _foundInOtherSheetLabel(GetArkuszDetailsElementItem item) {
    final arkuszNumer = item.foundInArkuszNumer?.trim();
    final miejsce = item.foundInMiejsce?.trim();

    if ((arkuszNumer == null || arkuszNumer.isEmpty) &&
        (miejsce == null || miejsce.isEmpty)) {
      return '-';
    }

    if (arkuszNumer == null || arkuszNumer.isEmpty) {
      return miejsce!;
    }

    if (miejsce == null || miejsce.isEmpty) {
      return arkuszNumer;
    }

    return '$arkuszNumer\n$miejsce';
  }

  double _asSortableNumber(String? value) {
    final normalized = value?.trim().replaceAll(',', '.');
    if (normalized == null || normalized.isEmpty) {
      return -1;
    }
    return double.tryParse(normalized) ?? -1;
  }

  Widget _buildScannerBadge(BuildContext context, bool? scannerFlag) {
    final intl = context.l10n;
    final label = switch (scannerFlag) {
      false => intl.inventoryScannerNotRead,
      true => intl.inventoryScannerRead,
      _ => intl.inventoryUnknownWithCode('-'),
    };

    final tone = switch (scannerFlag) {
      false => AppStatusBadgeTone.warning,
      true => AppStatusBadgeTone.success,
      _ => AppStatusBadgeTone.neutral,
    };

    final icon = switch (scannerFlag) {
      false => Icons.radio_button_unchecked_rounded,
      true => Icons.qr_code_scanner_rounded,
      _ => Icons.help_outline_rounded,
    };

    return AppStatusBadge(
      label: label,
      tone: tone,
      icon: icon,
      showBorder: false,
    );
  }

  Widget _buildInventoryStatusBadge(
    BuildContext context,
    ArkuszElementStatusSpisu? statusCode,
  ) {
    return switch (statusCode) {
      final ArkuszElementStatusSpisu status => status.toBadge(context),
      null => AppStatusBadge(
        label: statusSpisuNoSelectionLabel(context),
        showBorder: false,
      ),
    };
  }

  int _statusSpisuSortValue(ArkuszElementStatusSpisu? status) {
    return switch (status) {
      null => 0,
      ArkuszElementStatusSpisu.nadwyzka => 1,
      ArkuszElementStatusSpisu.nowy => 2,
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie => 3,
      ArkuszElementStatusSpisu.niejednoznacznyKod => 4,
      ArkuszElementStatusSpisu.sprzedanyWTrakcie => 5,
      ArkuszElementStatusSpisu.zakupionyWTrakcie => 6,
    };
  }

  int _stanInwentSortValue(ArkuszElementInwentStatus? status) {
    return switch (status) {
      null || ArkuszElementInwentStatus.brak => 0,
      ArkuszElementInwentStatus.zgodny => 1,
      ArkuszElementInwentStatus.przeniesiony => 2,
    };
  }

  int _assetStatusSortValue(SrodekTrwalyStatus? status) {
    return switch (status) {
      null || SrodekTrwalyStatus.brak => 0,
      SrodekTrwalyStatus.niezatwierdzone => 1,
      SrodekTrwalyStatus.wUzytkowaniu => 2,
      SrodekTrwalyStatus.zlikwidowany => 3,
      SrodekTrwalyStatus.sprzedane => 4,
      SrodekTrwalyStatus.przeniesiony => 5,
      SrodekTrwalyStatus.nieWystepujeWSt => 6,
    };
  }

  String _assetStatusLabel(SrodekTrwalyStatus? status) {
    return (status ?? SrodekTrwalyStatus.brak).label;
  }

  Widget _buildStanInwentBadge(
    BuildContext context,
    ArkuszElementInwentStatus? status,
  ) {
    final resolvedStatus = status ?? ArkuszElementInwentStatus.brak;
    return resolvedStatus.toBadge(context);
  }

  bool _hasMeaningfulChange(String? current, String? next) {
    final normalizedCurrent = current?.trim();
    final normalizedNext = next?.trim();

    if (normalizedNext == null || normalizedNext.isEmpty) {
      return false;
    }

    return normalizedCurrent != normalizedNext;
  }

  String _changedValueLabel({String? current, String? next}) {
    final currentLabel = _normalize(current);
    final nextLabel = next?.trim();

    if (nextLabel == null ||
        nextLabel.isEmpty ||
        nextLabel == current?.trim()) {
      return currentLabel;
    }

    return '$currentLabel > $nextLabel';
  }
}
