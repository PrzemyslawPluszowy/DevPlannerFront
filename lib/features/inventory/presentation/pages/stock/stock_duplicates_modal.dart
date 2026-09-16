import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/extensions/number_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_duplicates_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_duplicates_cubit.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

Future<void> showStockDuplicatesModal(
  BuildContext context, {
  required StockDuplicatesCubit cubit,
}) {
  cubit.load().ignore();

  return AppModalSheet.show<void>(
    context,
    title: context.l10n.inventoryDuplicateConflictsTitle,
    subtitle: context.l10n.inventoryDuplicateConflictsSubtitle,
    size: AppModalSheetSize.fullscreen,
    minBodyHeight: double.infinity,
    maxBodyHeight: double.infinity,
    scrollBody: false,
    padding: const EdgeInsets.all(Sizes.p20),
    body: BlocProvider.value(
      value: cubit,
      child: const _StockDuplicatesModalBody(),
    ),
  );
}

/// Cialo modalu prezentujace liste duplikatow `stan_st`.
class _StockDuplicatesModalBody extends StatefulWidget {
  const _StockDuplicatesModalBody();

  @override
  State<_StockDuplicatesModalBody> createState() =>
      _StockDuplicatesModalBodyState();
}

/// Stan modalu duplikatow z lokalnym filtrowaniem po numerze ewidencyjnym.
class _StockDuplicatesModalBodyState extends State<_StockDuplicatesModalBody> {
  final AppSearchTextFieldController _searchController =
      AppSearchTextFieldController();
  String _searchQuery = '';
  Set<int> _selectedCompanyIds = const <int>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      StockDuplicatesCubit,
      LoadableState<GetStanStDuplicatesResponseData>
    >(
      builder: (context, state) {
        final data = state.data;
        final allGroups = data?.items ?? const <GetStanStDuplicateGroup>[];
        final companyOptions = _buildCompanyOptions(allGroups);
        final groups = _filterGroups(allGroups);
        final totals = data?.meta;
        final hasActiveFilter = _searchQuery.trim().isNotEmpty;
        final hasCompanyFilter = _selectedCompanyIds.isNotEmpty;
        final hasLocalFilters = hasActiveFilter || hasCompanyFilter;
        final visibleRecordsCount = groups.fold<int>(
          0,
          (sum, group) => sum + group.entries.length,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(
                    context.l10n.inventoryDuplicateConflictsSummary(
                      hasLocalFilters
                          ? groups.length
                          : totals?.totalGroups ?? 0,
                      hasLocalFilters
                          ? visibleRecordsCount
                          : totals?.totalEntries ?? 0,
                    ),
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
                if (groups.isNotEmpty)
                  AppStatusBadge(
                    label: hasLocalFilters
                        ? context.l10n
                              .inventoryDuplicateConflictsVisibleResults(
                                groups.length,
                                visibleRecordsCount,
                              )
                        : context.l10n.inventoryDuplicateConflictsDetected(
                            groups.length,
                          ),
                    tone: AppStatusBadgeTone.danger,
                    icon: Icons.warning_rounded,
                    showBorder: false,
                  ),
                Gaps.w8,
                AppActionPill(
                  label: context.l10n.inventoryRefresh,
                  icon: Icons.refresh_rounded,
                  tone: AppActionPillTone.contrast,
                  selected: true,
                  onPressed: state.isLoading
                      ? null
                      : () => context
                            .read<StockDuplicatesCubit>()
                            .refresh()
                            .ignore(),
                ),
              ],
            ),
            Gaps.h12,
            AppSearchTextField(
              controller: _searchController,
              inlineLabel: context.l10n.inventoryRegisterNumber,
              hintText: context.l10n.inventoryOverviewSearchHintRegisterNumber,
              onChanged: (value) => setState(() {
                _searchQuery = value;
              }),
            ),
            if (companyOptions.isNotEmpty) ...[
              Gaps.h12,
              Wrap(
                spacing: Sizes.p8,
                runSpacing: Sizes.p8,
                children: [
                  AppActionPill(
                    label: context.l10n.inventoryAllCompanies,
                    selected: !hasCompanyFilter,
                    onPressed: hasCompanyFilter
                        ? () => setState(() {
                            _selectedCompanyIds = const <int>{};
                          })
                        : null,
                  ),
                  for (final option in companyOptions)
                    AppActionPill(
                      label: option.label,
                      selected: _selectedCompanyIds.contains(option.id),
                      onPressed: () => setState(() {
                        final next = {..._selectedCompanyIds};
                        if (!next.add(option.id)) {
                          next.remove(option.id);
                        }
                        _selectedCompanyIds = next;
                      }),
                    ),
                ],
              ),
            ],
            if (state.errorMessage != null && data != null) ...[
              Gaps.h12,
              AppEmptyState.error(
                title: context.l10n.inventoryLoadingErrorTitle,
                message: state.errorMessage!,
                compact: true,
              ),
            ],
            Gaps.h12,
            Expanded(
              child: switch (state) {
                LoadableInitial<GetStanStDuplicatesResponseData>() ||
                LoadableLoading<GetStanStDuplicatesResponseData>()
                    when data == null =>
                  const Center(child: AppSpinner()),
                LoadableError<GetStanStDuplicatesResponseData>()
                    when data == null =>
                  AppEmptyState.error(
                    title: context.l10n.inventoryLoadingErrorTitle,
                    message:
                        state.errorMessage ??
                        context.l10n.inventoryDuplicateConflictsFetchError,
                    compact: true,
                  ),
                _ when groups.isEmpty =>
                  hasLocalFilters
                      ? AppEmptyState.noResults(
                          title: context.l10n.inventoryNoResultsTitle,
                          message:
                              context.l10n.inventoryTryAnotherPhraseMessage,
                          compact: true,
                        )
                      : AppEmptyState.noResults(
                          title: context
                              .l10n
                              .inventoryDuplicateConflictsEmptyTitle,
                          message: context
                              .l10n
                              .inventoryDuplicateConflictsEmptyMessage,
                          compact: true,
                        ),
                _ => ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, _) => Gaps.h12,
                  itemBuilder: (context, index) =>
                      _StockDuplicateGroupSection(group: groups[index]),
                ),
              },
            ),
          ],
        );
      },
    );
  }

  List<GetStanStDuplicateGroup> _filterGroups(
    List<GetStanStDuplicateGroup> groups,
  ) {
    final query = _normalize(_searchQuery);
    return groups
        .map((group) {
          final filteredEntries = _selectedCompanyIds.isEmpty
              ? group.entries
              : group.entries
                    .where(
                      (entry) =>
                          entry.firma != null &&
                          _selectedCompanyIds.contains(entry.firma),
                    )
                    .toList(growable: false);

          if (filteredEntries.length < 2) {
            return null;
          }

          final filteredFirmy =
              filteredEntries
                  .map((entry) => entry.firma)
                  .whereType<int>()
                  .toSet()
                  .toList(growable: false)
                ..sort();

          final filteredVariants = filteredEntries
              .map((entry) => entry.nrewid?.trim() ?? '')
              .where((value) => value.isNotEmpty)
              .toSet()
              .toList(growable: false);

          final nextGroup = GetStanStDuplicateGroup(
            nrewid: group.nrewid,
            normalizedNrewid: group.normalizedNrewid,
            nrewidVariants: filteredVariants.isEmpty
                ? group.nrewidVariants
                : filteredVariants,
            firmy: filteredFirmy,
            duplicatesCount: filteredEntries.length,
            entries: filteredEntries,
          );

          if (query.isEmpty) {
            return nextGroup;
          }

          final candidates = <String>[
            nextGroup.nrewid,
            nextGroup.normalizedNrewid,
            ...nextGroup.nrewidVariants,
            ...nextGroup.entries.map((entry) => entry.nrewid ?? ''),
          ];

          return candidates.any((value) => _normalize(value).contains(query))
              ? nextGroup
              : null;
        })
        .whereType<GetStanStDuplicateGroup>()
        .toList(growable: false);
  }

  List<_CompanyFilterOption> _buildCompanyOptions(
    List<GetStanStDuplicateGroup> groups,
  ) {
    final optionsById = <int, _CompanyFilterOption>{};

    for (final group in groups) {
      for (final entry in group.entries) {
        final companyId = entry.firma;
        if (companyId == null || companyId <= 0) {
          continue;
        }

        final companyName = entry.firmaNazwa?.trim();
        optionsById[companyId] = _CompanyFilterOption(
          id: companyId,
          label: switch (companyName) {
            final String value when value.isNotEmpty => value,
            _ => '${context.l10n.inventoryCompany} $companyId',
          },
        );
      }

      for (final companyId in group.firmy) {
        if (companyId <= 0 || optionsById.containsKey(companyId)) {
          continue;
        }

        optionsById[companyId] = _CompanyFilterOption(
          id: companyId,
          label: '${context.l10n.inventoryCompany} $companyId',
        );
      }
    }

    final options = optionsById.values.toList(growable: false);
    options.sort((left, right) => left.label.compareTo(right.label));
    return options;
  }

  String _normalize(String? value) => (value ?? '').trim().toLowerCase();
}

/// Opcja lokalnego filtra firmy w modalu duplikatow.
class _CompanyFilterOption {
  /// Tworzy opcje filtra firmy.
  const _CompanyFilterOption({
    required this.id,
    required this.label,
  });

  /// Identyfikator firmy.
  final int id;

  /// Etykieta widoczna dla uzytkownika.
  final String label;
}

/// Sekcja jednej grupy duplikatow numeru ewidencyjnego.
class _StockDuplicateGroupSection extends StatelessWidget {
  const _StockDuplicateGroupSection({required this.group});

  final GetStanStDuplicateGroup group;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppText(
                '${context.l10n.inventoryRegisterNumber}: '
                '${group.nrewid.isEmpty ? group.normalizedNrewid : group.nrewid}',
                style: context.text.titleSmall?.copyWith(
                  fontWeight: .w700,
                ),
              ),
              InkWell(
                borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
                onTap: () => _copyNrewid(
                  context,
                  group.normalizedNrewid.isEmpty
                      ? group.nrewid
                      : group.normalizedNrewid,
                ),
                child: AppStatusBadge(
                  label: group.normalizedNrewid,
                  tone: AppStatusBadgeTone.info,
                  showBorder: false,
                ),
              ),
              AppStatusBadge(
                label: context.l10n.inventoryDuplicateGroupRecordsCount(
                  group.duplicatesCount,
                ),
                tone: AppStatusBadgeTone.danger,
                icon: Icons.close_rounded,
                showBorder: false,
              ),
              if (group.firmy.isNotEmpty)
                AppStatusBadge(
                  label: context.l10n.inventoryDuplicateCompaniesLabel(
                    group.firmy.join(', '),
                  ),
                  tone: AppStatusBadgeTone.warning,
                  showBorder: false,
                ),
            ],
          ),
          if (group.nrewidVariants.length > 1) ...[
            Gaps.h8,
            AppText(
              context.l10n.inventoryDuplicateVariantsLabel(
                group.nrewidVariants.join(' • '),
              ),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          Gaps.h12,
          Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Column(
              children: [
                for (var index = 0; index < group.entries.length; index++) ...[
                  _StockDuplicateEntryRow(entry: group.entries[index]),
                  if (index < group.entries.length - 1)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: context.colors.outlineVariant,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyNrewid(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) {
      return;
    }
    AppBubbleToast.show(
      context,
      message: context.l10n.inventoryDuplicateCopiedRegisterToast,
    );
  }
}

/// Zwarty wiersz pojedynczego rekordu nalezacego do grupy duplikatow.
class _StockDuplicateEntryRow extends StatelessWidget {
  const _StockDuplicateEntryRow({required this.entry});

  final GetStanStDuplicateEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.p12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      _companyLabel(context),
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    if ((entry.nazwa ?? '').trim().isNotEmpty) ...[
                      Gaps.h4,
                      AppText(
                        entry.nazwa!.trim(),
                        style: context.text.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if ((entry.nrewid ?? '').trim().isNotEmpty)
                AppStatusBadge(
                  label:
                      '${context.l10n.inventoryRegisterNumberShort}: '
                      '${entry.nrewid!.trim()}',
                  tone: AppStatusBadgeTone.warning,
                  showBorder: false,
                ),
            ],
          ),
          Gaps.h8,
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              if ((entry.baza ?? '').isNotEmpty)
                AppStatusBadge(
                  label: entry.baza!,
                  tone: AppStatusBadgeTone.info,
                  showBorder: false,
                ),
              if ((entry.miejsce ?? '').trim().isNotEmpty)
                AppStatusBadge(
                  label: entry.miejsce!.trim(),
                  showBorder: false,
                ),
              if ((entry.osoba ?? '').trim().isNotEmpty)
                AppStatusBadge(
                  label: entry.osoba!.trim(),
                  tone: AppStatusBadgeTone.warning,
                  showBorder: false,
                ),
              if ((entry.lvl ?? '').trim().isNotEmpty)
                AppStatusBadge(
                  label: 'LVL ${entry.lvl!.trim()}',
                  showBorder: false,
                ),
            ],
          ),
          Gaps.h8,
          AppText(
            _detailsLine(context),
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _companyLabel(BuildContext context) {
    return entry.firmaNazwa?.trim().isNotEmpty == true
        ? '${entry.firmaNazwa} (${entry.firma ?? '-'})'
        : '${context.l10n.inventoryCompany}: ${entry.firma ?? '-'}';
  }

  String _detailsLine(BuildContext context) {
    final details = <String>[
      if (entry.kodKreskowy != null)
        '${context.l10n.inventoryBarcode}: ${entry.kodKreskowy}',
      if ((entry.wartoscP?.trim() ?? '').isNotEmpty)
        '${context.l10n.inventoryValueP}: ${entry.wartoscP.toAppMoney()}',
      if ((entry.wartoscA?.trim() ?? '').isNotEmpty)
        '${context.l10n.inventoryValueA}: ${entry.wartoscA.toAppMoney()}',
      if ((entry.dataImportu?.trim() ?? '').isNotEmpty)
        'Import: ${entry.dataImportu.toAppDateTime()}',
    ];

    if (details.isEmpty) {
      return '-';
    }

    return details.join(' • ');
  }
}
