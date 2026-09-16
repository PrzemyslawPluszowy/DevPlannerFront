part of '../inventory_overview_page.dart';

String _assetStatusLabel(BuildContext context, SrodekTrwalyStatus status) {
  final intl = context.l10n;
  return switch (status) {
    SrodekTrwalyStatus.brak => intl.inventoryAssetStatusNone,
    SrodekTrwalyStatus.niezatwierdzone => intl.inventoryAssetStatusUnconfirmed,
    SrodekTrwalyStatus.wUzytkowaniu => intl.inventoryAssetStatusInUse,
    SrodekTrwalyStatus.zlikwidowany => intl.inventoryAssetStatusDisposed,
    SrodekTrwalyStatus.sprzedane => intl.inventoryAssetStatusSold,
    SrodekTrwalyStatus.przeniesiony => intl.inventoryAssetStatusTransferred,
    SrodekTrwalyStatus.nieWystepujeWSt =>
      intl.inventoryAssetStatusMissingInAssets,
  };
}

/// Dropdown do wyboru firmy wykorzystujący [StockFilterService].
class _FirmaFilter extends StatelessWidget {
  const _FirmaFilter();

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final filterService = context.watch<StockFilterService>();
    return StreamBuilder<int?>(
      stream: filterService.firmaStream,
      initialData: filterService.currentFirma,
      builder: (context, snapshot) {
        final selectedFirma = snapshot.data;
        return StreamBuilder<List<GetFirmyItem>>(
          stream: filterService.companiesStream,
          initialData: filterService.companies,
          builder: (context, snapshot) {
            final companies = snapshot.data ?? const <GetFirmyItem>[];

            return SizedBox(
              width: 320,
              child: AppDropdown<int?>(
                variant: AppDropdownVariant.filled,
                value: selectedFirma,
                inlineLabel: intl.inventoryCompany,
                hintText: intl.inventoryAll,
                options: [
                  AppDropdownOption<int?>(
                    value: null,
                    label: intl.inventoryAllCompanies,
                  ),
                  ...companies.map(
                    (c) => AppDropdownOption<int?>(
                      value: c.idFirmy,
                      label: c.nazwa,
                    ),
                  ),
                ],
                onChanged: filterService.setFirma,
              ),
            );
          },
        );
      },
    );
  }
}

/// Dropdown do wyboru statusu środka trwałego.
class _StatusFilter extends StatelessWidget {
  const _StatusFilter();

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final filterService = context.watch<StockFilterService>();

    return StreamBuilder<SrodekTrwalyStatus?>(
      stream: filterService.statusStream,
      initialData: filterService.currentStatus,
      builder: (context, snapshot) {
        final selectedStatus = snapshot.data;

        return SizedBox(
          width: 240,
          child: AppDropdown<SrodekTrwalyStatus?>(
            variant: AppDropdownVariant.filled,
            value: selectedStatus,
            inlineLabel: intl.inventoryState,
            hintText: intl.inventoryAll,
            options: [
              AppDropdownOption<SrodekTrwalyStatus?>(
                value: null,
                label: intl.inventoryAll,
              ),
              ...SrodekTrwalyStatus.values
                  .where((status) => status != SrodekTrwalyStatus.brak)
                  .map(
                    (status) => AppDropdownOption<SrodekTrwalyStatus?>(
                      value: status,
                      label: _assetStatusLabel(context, status),
                    ),
                  ),
            ],
            onChanged: filterService.setStatus,
          ),
        );
      },
    );
  }
}

/// Tabela stanów środków trwałych oparta o [AppSimpleTable].
class _StockList extends StatelessWidget {
  const _StockList({required this.data});

  final GetStanStResponseData data;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    if (data.items.isEmpty) {
      return Center(child: AppEmptyState.noResults());
    }

    return AppSimpleTable<GetStanStItem>(
      height: null,
      rowHeight: 64,
      rows: data.items,
      footer: AppPaginationBar(
        total: data.meta.total,
        limit: data.meta.limit,
        offset: data.meta.offset,
        onPageChanged: (offset) =>
            context.read<StockFilterService>().setOffset(offset),
        onLimitChanged: (limit) =>
            context.read<StockFilterService>().setLimit(limit),
      ),
      columns: [
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryRegisterNumberShort,
          width: 120,
          cellBuilder: (context, row) => AppText(row.nrewid ?? '-'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryName,
          width: 320,
          cellBuilder: (context, row) => AppText(
            row.nazwa ?? intl.inventoryNoName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryPerson,
          width: 180,
          cellBuilder: (context, row) => AppText(row.osoba ?? '-'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryLocation,
          width: 160,
          cellBuilder: (context, row) => AppText(row.miejsce ?? '-'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryState,
          width: 220,
          cellBuilder: (context, row) => AppText(switch (row.status) {
            final status? => _assetStatusLabel(context, status),
            _ => intl.inventoryUnknownWithCode(row.stan ?? '-'),
          }),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryBarcode,
          width: 140,
          cellBuilder: (context, row) =>
              AppText(row.kodKreskowy?.toString() ?? '-'),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryPurchaseDate,
          width: 120,
          cellBuilder: (context, row) => AppText(row.dataZakupu.toAppDate()),
        ),
        AppSimpleTableColumn<GetStanStItem>(
          label: intl.inventoryValueP,
          width: 100,
          numeric: true,
          cellBuilder: (context, row) => AppText(row.wartoscP.toAppMoney()),
        ),
      ],
      onRowTap: (context, row, index) async {
        final deleted = await _showStockDetailsModal(context, row);
        if (!context.mounted || deleted != true) {
          return;
        }

        context.read<StockFilterService>().refresh();
        context.read<StockDuplicatesCubit>().refresh().ignore();
      },
    );
  }
}

/// Wyświetla modal ze szczegółami środka trwałego.
Future<bool?> _showStockDetailsModal(BuildContext context, GetStanStItem item) {
  final intl = context.l10n;
  final repository = context.read<StockRepository>();
  return AppModalSheet.show(
    context,
    title: intl.inventoryAssetDetailsTitle,
    subtitle: item.nazwa ?? intl.inventoryNoName,
    body: _StockDetailsModalBody(
      item: item,
      stockRepository: repository,
    ),
  );
}

/// Treść modalu szczegółów środka trwałego.
class _StockDetailsModalBody extends StatelessWidget {
  const _StockDetailsModalBody({
    required this.item,
    required this.stockRepository,
  });

  final GetStanStItem item;
  final StockRepository stockRepository;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        _buildSectionTitle(context, intl.inventoryBasicInfoSection),
        _buildInfoRow(
          context,
          Icons.tag_rounded,
          intl.inventoryRegisterNumberShort,
          item.nrewid,
        ),
        _buildInfoRow(
          context,
          Icons.person_outline_rounded,
          intl.inventoryPerson,
          item.osoba,
        ),
        _buildInfoRow(
          context,
          Icons.verified_user_outlined,
          intl.inventoryState,
          switch (item.status) {
            final status? => _assetStatusLabel(context, status),
            _ => intl.inventoryUnknownWithCode(item.stan ?? '-'),
          },
        ),
        _buildInfoRow(
          context,
          Icons.qr_code_2_rounded,
          intl.inventoryBarcode,
          item.kodKreskowy?.toString(),
        ),
        Gaps.h20,
        _buildSectionTitle(context, intl.inventoryLocationSection),
        _buildInfoRow(
          context,
          Icons.place_outlined,
          intl.inventoryLocation,
          item.miejsce,
        ),
        _buildInfoRow(
          context,
          Icons.layers_outlined,
          intl.inventoryLevel,
          item.lvl,
        ),
        Gaps.h20,
        _buildSectionTitle(context, intl.inventoryFinancialSection),
        _buildInfoRow(
          context,
          Icons.calendar_today_rounded,
          intl.inventoryPurchaseDate,
          item.dataZakupu.toAppDate(),
        ),
        _buildInfoRow(
          context,
          Icons.savings_outlined,
          intl.inventoryValueP,
          item.wartoscP.toAppMoney(placeholder: intl.inventoryNoData),
        ),
        _buildInfoRow(
          context,
          Icons.trending_up_rounded,
          intl.inventoryValueA,
          item.wartoscA.toAppMoney(placeholder: intl.inventoryNoData),
        ),
        if (item.dataImportu != null) ...[
          Gaps.h12,
          _buildInfoRow(
            context,
            Icons.cloud_download_outlined,
            intl.inventoryImportedAt,
            item.dataImportu.toAppDate(),
          ),
        ],
        Gaps.h24,
        Row(
          mainAxisAlignment: .center,
          children: [
            AppActionButton.text(
              label: intl.close,
              icon: Icons.check_rounded,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            Gaps.w8,
            AppActionButton.filled(
              label: intl.delete,
              icon: Icons.delete_outline_rounded,
              tone: .danger,
              onPressedAsync: () async {
                final deleted = await _showDeleteStanStModal(
                  context,
                  item: item,
                  repository: stockRepository,
                );
                if (!context.mounted || deleted != true) {
                  return;
                }

                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
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

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
  ) {
    final colors = context.colors;
    final intl = context.l10n;
    final normalizedValue = value?.trim().isNotEmpty == true
        ? value!.trim()
        : intl.inventoryNoData;

    return Padding(
      padding: const .symmetric(vertical: Sizes.p4),
      child: Row(
        children: [
          Icon(
            icon,
            size: Sizes.p18,
            color: colors.onSurfaceVariant.withValues(alpha: .7),
          ),
          Gaps.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AppText(
                  label,
                  style: context.text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                AppText(
                  normalizedValue,
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: .w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
