import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_element_status_ui.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_sheet_search_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_sheet_search_state.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Wynik wyboru w wyszukiwarce elementów między arkuszami.
final class InventorySheetSearchSelection {
  /// Tworzy wybór wyniku wyszukiwarki arkuszy.
  const InventorySheetSearchSelection({
    required this.arkuszId,
    required this.arkuszNumber,
    required this.elementId,
  });

  /// Id arkusza docelowego.
  final int arkuszId;

  /// Numer arkusza docelowego.
  final String arkuszNumber;

  /// Id elementu, który należy podświetlić.
  final int elementId;
}

/// Spłaszczony wiersz tabeli wyszukiwarki arkuszy.
final class _InventorySheetSearchTableRow {
  /// Tworzy wiersz tabeli wyszukiwarki.
  const _InventorySheetSearchTableRow({
    required this.group,
    required this.match,
  });

  /// Grupa produktu, z której pochodzi trafienie.
  final GetInwentaryzacjaSearchArkuszeGroup group;

  /// Trafienie widoczne w tabeli.
  final GetInwentaryzacjaSearchArkuszeMatch match;
}

/// Otwiera pełnoekranowy dialog wyszukiwania elementów w arkuszach.
Future<InventorySheetSearchSelection?> showInventorySheetSearchModal(
  BuildContext context, {
  required int inventoryId,
  required String inventoryNumber,
  required InventoriesRepository repository,
}) {
  return AppModalSheet.show<InventorySheetSearchSelection>(
    context,
    title: context.l10n.inventorySearchSheetsTitle,
    subtitle: context.l10n.inventorySearchSheetsSubtitle(inventoryNumber),
    size: AppModalSheetSize.fullscreen,
    minBodyHeight: double.infinity,
    maxBodyHeight: double.infinity,
    scrollBody: false,
    padding: const EdgeInsets.all(Sizes.p20),
    body: BlocProvider(
      create: (_) => InventorySheetSearchCubit(repository: repository),
      child: InventorySheetSearchContent(
        inventoryId: inventoryId,
        onSelection: (selection) => Navigator.of(context).pop(selection),
      ),
    ),
  );
}

/// Reuzywalna zawartość wyszukiwarki elementów pomiędzy arkuszami.
class InventorySheetSearchContent extends StatelessWidget {
  /// Tworzy zawartość wyszukiwarki arkuszy.
  const InventorySheetSearchContent({
    required this.inventoryId,
    this.searchController,
    this.autofocus = true,
    this.searchFieldWidth = 420,
    this.compact = false,
    this.onSelection,
    super.key,
  });

  /// Id inwentaryzacji używane w zapytaniach.
  final int inventoryId;

  /// Opcjonalny kontroler pozwalający podstawiać frazę z zewnątrz.
  final AppSearchTextFieldController? searchController;

  /// Czy fokus ma wejść w pole wyszukiwania po otwarciu.
  final bool autofocus;

  /// Opcjonalna szerokość pola wyszukiwania.
  final double? searchFieldWidth;

  /// Czy pokazać bardziej kompaktowy wariant osadzony w panelu bocznym.
  final bool compact;

  /// Callback po wyborze konkretnego trafienia.
  final ValueChanged<InventorySheetSearchSelection>? onSelection;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventorySheetSearchCubit, InventorySheetSearchState>(
      builder: (context, state) {
        final previousData = state.result.data;
        final groups = previousData?.items ?? const [];
        final rows = [
          for (final group in groups)
            for (final match in group.matches)
              _InventorySheetSearchTableRow(group: group, match: match),
        ];
        final totals = previousData?.meta.totals;
        final errorMessage = switch (state.result) {
          LoadableError(:final message) => message,
          _ => null,
        };

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            if (searchFieldWidth case final width?)
              SizedBox(
                width: width,
                child: AppSearchTextField(
                  controller: searchController,
                  autofocus: autofocus,
                  inlineLabel: context.l10n.inventorySearch,
                  hintText: context.l10n.inventorySearchSheetsHint,
                  onChanged: (value) {
                    context
                        .read<InventorySheetSearchCubit>()
                        .updateQuery(inventoryId, value)
                        .ignore();
                  },
                ),
              )
            else
              AppSearchTextField(
                controller: searchController,
                autofocus: autofocus,
                inlineLabel: context.l10n.inventorySearch,
                hintText: context.l10n.inventorySearchSheetsHint,
                onChanged: (value) {
                  context
                      .read<InventorySheetSearchCubit>()
                      .updateQuery(inventoryId, value)
                      .ignore();
                },
              ),
            SizedBox(height: compact ? Sizes.p8 : Sizes.p12),
            if (totals != null)
              AppText(
                context.l10n.inventorySearchSheetsResultsCount(
                  totals.groupsCount,
                  totals.matchesCount,
                ),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            if (errorMessage != null && rows.isNotEmpty) ...[
              SizedBox(height: compact ? Sizes.p8 : Sizes.p12),
              AppEmptyState.error(
                title: context.l10n.inventoryLoadingErrorTitle,
                message: errorMessage,
                compact: true,
              ),
            ],
            SizedBox(height: compact ? Sizes.p8 : Sizes.p12),
            Expanded(
              child: switch (state.result) {
                LoadableInitial() => AppEmptyState.noResults(
                  title: context.l10n.inventorySearchSheetsStartTitle,
                  message: context.l10n.inventorySearchSheetsStartMessage,
                  compact: true,
                ),
                LoadableLoading() when rows.isEmpty => const Center(
                  child: AppSpinner(size: Sizes.p24),
                ),
                LoadableError(:final message) when rows.isEmpty =>
                  AppEmptyState.error(
                    title: context.l10n.inventoryLoadingErrorTitle,
                    message: message,
                    compact: true,
                  ),
                LoadableSuccess() || LoadableLoading() || LoadableError() =>
                  rows.isEmpty
                      ? AppEmptyState.noResults(
                          title: context.l10n.inventoryNoSearchResultsTitle,
                          message:
                              context.l10n.inventoryTryAnotherPhraseMessage,
                          compact: true,
                        )
                      : AppSimpleTable<_InventorySheetSearchTableRow>(
                          rows: rows,
                          height: null,
                          columns: _tableColumns(context),
                          rowHeight: 40,
                          headerHeight: 32,
                          minScrollableWidthRatio: compact ? .9 : 1,
                          simpleExcelMode: true,
                          onRowTap: (_, row, _) => _selectRow(context, row),
                          rowKeyBuilder: (row) =>
                              '${row.group.identityKey}:${row.match.elementId}:${row.match.arkuszId ?? -1}',
                        ),
              },
            ),
          ],
        );
      },
    );
  }

  List<AppSimpleTableColumn<_InventorySheetSearchTableRow>> _tableColumns(
    BuildContext context,
  ) {
    return [
      AppSimpleTableColumn(
        label: context.l10n.inventoryRegisterNumber,
        width: 120,
        sortValue: (row) => row.group.nrewid ?? row.match.nrewid ?? '',
        cellBuilder: (_, row) => AppText(
          row.group.nrewid?.trim().isNotEmpty == true
              ? row.group.nrewid!
              : (row.match.nrewid?.trim().isNotEmpty == true
                    ? row.match.nrewid!
                    : context.l10n.inventoryNoNumber),
          style: context.text.bodySmall?.copyWith(fontWeight: .w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.inventoryName,
        width: 260,
        sortValue: (row) => row.group.nazwa ?? row.match.nazwa ?? '',
        cellBuilder: (_, row) => AppText(
          row.group.nazwa?.trim().isNotEmpty == true
              ? row.group.nazwa!
              : (row.match.nazwa?.trim().isNotEmpty == true
                    ? row.match.nazwa!
                    : context.l10n.inventoryNoName),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.inventorySheetLabel,
        width: 110,
        sortValue: (row) => row.match.arkuszNumer ?? '',
        cellBuilder: (_, row) => AppText(
          row.match.arkuszNumer?.trim().isNotEmpty == true
              ? row.match.arkuszNumer!
              : context.l10n.inventoryNoNumber,
          style: context.text.bodySmall?.copyWith(fontWeight: .w600),
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.inventoryLocation,
        width: 240,
        sortValue: (row) => row.match.arkuszMiejsce ?? '',
        cellBuilder: (_, row) => AppText(
          row.match.arkuszMiejsce?.trim().isNotEmpty == true
              ? row.match.arkuszMiejsce!
              : '-',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.inventoryBarcode,
        width: 140,
        sortValue: (row) => row.group.kodKreskowy ?? row.match.kodKreskowy ?? 0,
        cellBuilder: (_, row) => AppText(
          row.group.kodKreskowy?.toString() ??
              row.match.kodKreskowy?.toString() ??
              '-',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.inventoryPerson,
        width: 180,
        sortValue: (row) => row.group.osoba ?? row.match.osoba ?? '',
        cellBuilder: (_, row) => AppText(
          row.group.osoba?.trim().isNotEmpty == true
              ? row.group.osoba!
              : (row.match.osoba?.trim().isNotEmpty == true
                    ? row.match.osoba!
                    : '-'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.inventorySearchSheetsSortByMatches,
        width: 90,
        numeric: true,
        sortValue: (row) => row.group.matchesCount,
        cellBuilder: (_, row) => Align(
          alignment: .centerRight,
          child: AppText('${row.group.matchesCount}'),
        ),
      ),
      AppSimpleTableColumn(
        label: statusSpisuFieldLabel(context),
        width: 170,
        sortValue: (row) => row.match.uiStatus?.apiValue ?? '',
        cellBuilder: (context, row) => _statusBadgeForUiStatus(
          context,
          row.match.uiStatus ?? SearchArkuszeUiStatus.brak,
        ),
      ),
    ];
  }

  void _selectRow(BuildContext context, _InventorySheetSearchTableRow row) {
    final arkuszId = row.match.arkuszId;
    if (arkuszId == null) {
      return;
    }

    onSelection?.call(
      InventorySheetSearchSelection(
        arkuszId: arkuszId,
        arkuszNumber: row.match.arkuszNumer?.trim().isNotEmpty == true
            ? row.match.arkuszNumer!
            : context.l10n.inventoryNoNumber,
        elementId: row.match.elementId,
      ),
    );
  }
}

AppStatusBadge _statusBadgeForUiStatus(
  BuildContext context,
  SearchArkuszeUiStatus status,
) {
  return switch (status) {
    SearchArkuszeUiStatus.brak => ArkuszElementInwentStatus.brak.toBadge(
      context,
    ),
    SearchArkuszeUiStatus.potwierdzony =>
      ArkuszElementInwentStatus.zgodny.toBadge(context),
    SearchArkuszeUiStatus.niezgodnosc =>
      ArkuszElementInwentStatus.przeniesiony.toBadge(context),
    SearchArkuszeUiStatus.nadwyzka => ArkuszElementStatusSpisu.nadwyzka.toBadge(
      context,
    ),
    SearchArkuszeUiStatus.nowy => ArkuszElementStatusSpisu.nowy.toBadge(
      context,
    ),
    SearchArkuszeUiStatus.znalezionyWInnejFirmie =>
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie.toBadge(context),
    SearchArkuszeUiStatus.niejednoznacznyKod =>
      ArkuszElementStatusSpisu.niejednoznacznyKod.toBadge(context),
    SearchArkuszeUiStatus.sprzedanyWTrakcie =>
      ArkuszElementStatusSpisu.sprzedanyWTrakcie.toBadge(context),
    SearchArkuszeUiStatus.zakupionyWTrakcie =>
      ArkuszElementStatusSpisu.zakupionyWTrakcie.toBadge(context),
    SearchArkuszeUiStatus.doLikwidacji => AppStatusBadge(
      label: context.l10n.inventorySearchSheetsToDisposeStatus,
      tone: .danger,
      icon: Icons.delete_outline_rounded,
      showBorder: false,
    ),
  };
}
