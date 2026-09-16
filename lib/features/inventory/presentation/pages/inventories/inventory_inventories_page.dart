import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/create_inventory/create_inventory_modal.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/cubit/inventories_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/cubit/inventory_companies_dictionary_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_detail_modal.dart';
import 'package:ready_next/features/inventory/presentation/widgets/inventory_section_placeholder_card.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_icon.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ekran listy rekordów inwentaryzacji.
class InventoryInventoriesPage extends StatelessWidget {
  const InventoryInventoriesPage({this.initialInventoryId, super.key});

  final int? initialInventoryId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InventoriesCubit(
            repository: context.read<InventoriesRepository>(),
          )..load().ignore(),
        ),
        BlocProvider(
          create: (context) => InventoryCompaniesDictionaryCubit(
            repository: context.read<StockRepository>(),
          )..load().ignore(),
        ),
      ],
      child: _InventoryInventoriesContent(initialInventoryId: initialInventoryId),
    );
  }
}

class _InventoryInventoriesContent extends StatefulWidget {
  const _InventoryInventoriesContent({this.initialInventoryId});

  final int? initialInventoryId;

  @override
  State<_InventoryInventoriesContent> createState() =>
      _InventoryInventoriesContentState();
}

class _InventoryInventoriesContentState
    extends State<_InventoryInventoriesContent> {
  static const _hideFinishedInventoriesKey =
      'inventory_inventories_hide_finished';

  bool _hideFinished = false;

  @override
  void initState() {
    super.initState();
    _restoreHideFinishedPreference().ignore();
    if (widget.initialInventoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openInitialInventoryDetail(widget.initialInventoryId!).ignore();
      });
    }
  }

  Future<void> _openInitialInventoryDetail(int inventoryId) async {
    if (!mounted) return;
    await showInventoryDetailModal(
      context,
      inventoryId: inventoryId,
      inventoryNumber: 'Inwentaryzacja',
      onDataChanged: () {
        if (mounted) {
          context.read<InventoriesCubit>().load().ignore();
        }
      },
    );
    if (mounted) {
      await context.read<InventoriesCubit>().load();
    }
  }

  Future<void> _restoreHideFinishedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final hideFinished = prefs.getBool(_hideFinishedInventoriesKey) ?? false;

    if (!mounted) {
      return;
    }

    setState(() {
      _hideFinished = hideFinished;
    });
  }

  Future<void> _updateHideFinished(bool value) async {
    setState(() {
      _hideFinished = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hideFinishedInventoriesKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      InventoriesCubit,
      LoadableState<GetInwentaryzacjeResponseData>
    >(
      builder: (context, state) {
        final intl = context.l10n;
        return InventorySectionPlaceholderCard(
          title: intl.inventorySectionInventories,
          subtitle: intl.inventoryInventoriesSubtitle,
          actions: [
            _HideFinishedInventoriesSwitch(
              value: _hideFinished,
              onChanged: _updateHideFinished,
            ),
            AppActionPill(
              label: intl.inventoryNew,
              icon: Icons.add_rounded,
              tone: AppActionPillTone.primary,
              selected: true,
              onPressed: () {
                (() async {
                  final created = await showCreateInventoryModal(context);
                  if (!context.mounted || created != true) {
                    return;
                  }
                  await context.read<InventoriesCubit>().load();
                })().ignore();
              },
            ),
            AppActionPill(
              label: intl.inventoryRefresh,
              icon: Icons.refresh_rounded,
              tone: AppActionPillTone.contrast,
              selected: true,
              onPressed: () => context.read<InventoriesCubit>().load().ignore(),
            ),
          ],
          child: switch (state) {
            LoadableInitial() || LoadableLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            LoadableSuccess(:final data) => _InventoriesList(
              data: data,
              hideFinished: _hideFinished,
            ),
            LoadableError(:final message) => _InventoriesError(
              message: message,
            ),
          },
        );
      },
    );
  }
}

class _InventoriesList extends StatelessWidget {
  const _InventoriesList({
    required this.data,
    required this.hideFinished,
  });

  final GetInwentaryzacjeResponseData data;
  final bool hideFinished;

  @override
  Widget build(BuildContext context) {
    final filteredItems = hideFinished
        ? data.items
              .where((item) => item.status != InwentaryzacjaStatus.zakonczona)
              .toList(growable: false)
        : data.items;

    if (data.items.isEmpty) {
      return Center(child: AppEmptyState.noResults());
    }

    return BlocBuilder<
      InventoryCompaniesDictionaryCubit,
      LoadableState<Map<int, String>>
    >(
      builder: (context, state) {
        final companiesById = state.data ?? const <int, String>{};
        final companyLookupFailed = state is LoadableError<Map<int, String>>;

        return switch (filteredItems.isEmpty) {
          true => Padding(
            padding: const .all(Sizes.p16),
            child: AppEmptyState.noResults(
              title: context.l10n.inventoryNoResultsTitle,
              message: context.l10n.inventoryHideFinishedEmptyMessage,
              compact: true,
            ),
          ),
          false => LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = switch (constraints.maxWidth) {
                >= 1440 => 3,
                >= 760 => 2,
                _ => 1,
              };
              final mainAxisExtent = switch (crossAxisCount) {
                1 => 430.0,
                2 => 420.0,
                _ => 436.0,
              };

              return GridView.builder(
                padding: const .all(Sizes.p16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: Sizes.p16,
                  mainAxisSpacing: Sizes.p16,
                  mainAxisExtent: mainAxisExtent,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) => _InventoryOverviewCard(
                  item: filteredItems[index],
                  companiesById: companiesById,
                  companyLookupFailed: companyLookupFailed,
                ),
              );
            },
          ),
        };
      },
    );
  }
}

/// Przelacznik ukrywania zakonczonych inwentaryzacji.
class _HideFinishedInventoriesSwitch extends StatelessWidget {
  /// Tworzy przelacznik ukrywania zakonczonych inwentaryzacji.
  const _HideFinishedInventoriesSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        AppText(
          context.l10n.inventoryHideFinished,
          style: context.text.bodySmall?.copyWith(fontWeight: .w600),
        ),
        Gaps.w8,
        Switch.adaptive(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _InventoryOverviewCard extends StatelessWidget {
  const _InventoryOverviewCard({
    required this.item,
    required this.companiesById,
    this.companyLookupFailed = false,
  });

  final GetInwentaryzacjeItem item;
  final Map<int, String> companiesById;
  final bool companyLookupFailed;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;
    final title = item.numer.trim().isEmpty
        ? intl.inventoryNoNumber
        : item.numer.trim();
    final companiesLabel = _companiesLabel(context);
    final cardBorder = switch (item.status) {
      InwentaryzacjaStatus.nowa => colors.primary.withValues(alpha: .24),
      InwentaryzacjaStatus.wToku => colors.tertiary.withValues(alpha: .34),
      InwentaryzacjaStatus.zakonczona => colors.secondary.withValues(
        alpha: .28,
      ),
      InwentaryzacjaStatus.nieznany => colors.outlineVariant,
    };

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLowest,
          borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
          border: Border.all(color: cardBorder),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
          mouseCursor: SystemMouseCursors.click,
          hoverColor: colors.primary.withValues(alpha: .05),
          highlightColor: colors.primary.withValues(alpha: .03),
          splashColor: colors.primary.withValues(alpha: .08),
          onTap: () {
            (() async {
              await showInventoryDetailModal(
                context,
                inventoryId: item.id,
                inventoryNumber: title,
                onDataChanged: () =>
                    context.read<InventoriesCubit>().load().ignore(),
              );
              if (!context.mounted) {
                return;
              }
              await context.read<InventoriesCubit>().load();
            })().ignore();
          },
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: double.infinity,
                padding: const .fromLTRB(
                  Sizes.p16,
                  Sizes.p12,
                  Sizes.p16,
                  Sizes.p12,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Sizes.p16),
                    topRight: Radius.circular(Sizes.p16),
                  ),
                  border: Border(
                    bottom: BorderSide(color: colors.outlineVariant),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    _InventoryLeadingIcon(status: item.status),
                    Gaps.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          AppText(
                            title,
                            selectable: true,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w800,
                              letterSpacing: -.2,
                            ),
                          ),
                          Gaps.h4,
                          AppText(
                            'ID ${item.id}',
                            style: context.text.labelMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontWeight: .w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.w12,
                    Icon(
                      Icons.chevron_right_rounded,
                      size: Sizes.p18,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      _InventoryFieldGrid(
                        rows: [
                          _InventoryFieldData(
                            label: 'Status',
                            child: _InventoryStatusTrailing(
                              label: _inventoryStatusLabel(
                                context,
                                item.status,
                              ),
                              tone: _statusTone(item.status),
                              icon: _statusIcon(item.status),
                            ),
                          ),
                          _InventoryFieldData(
                            label: intl.inventoryDateRangeLabel,
                            value: _formatDateRange(item),
                          ),
                          _InventoryFieldData(
                            label: intl.inventoryCompany,
                            value: companiesLabel,
                          ),
                          _InventoryFieldData(
                            label: intl.inventoryCommissionLabel,
                            value: intl.inventoryPeopleCount(
                              item.komisjaCount,
                            ),
                          ),
                          _InventoryFieldData(
                            label: intl.inventorySheetsLabel,
                            value: '${item.arkuszeCount}',
                          ),
                        ],
                      ),
                      if (item.uwagi case final val?
                          when val.trim().isNotEmpty) ...[
                        Gaps.h12,
                        _InventoryFooterNote(value: val.trim()),
                      ],
                      const Spacer(),
                      _InventoryDetailsButton(
                        label: intl.inventoryDetailsTitle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateRange(GetInwentaryzacjeItem item) {
    final from = item.dataOd.toAppDate();
    final to = item.dataDo.toAppDate();
    return '$from - $to';
  }

  String _companiesLabel(BuildContext context) {
    final intl = context.l10n;
    final namesFromPayload = item.firmy
        .map((firma) => firma.nazwa?.trim())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (namesFromPayload.isNotEmpty) {
      return namesFromPayload.join(', ');
    }

    final idsFromPayload = item.firmy
        .map((firma) => firma.idFirmy)
        .where((id) => id > 0)
        .toSet()
        .toList(growable: false);
    if (idsFromPayload.isNotEmpty) {
      final labels = idsFromPayload
          .map((id) {
            final name = companiesById[id]?.trim();
            return switch (name) {
              final String value when value.isNotEmpty => value,
              _ => intl.inventoryCompanyWithId(id),
            };
          })
          .toList(growable: false);
      return labels.join(', ');
    }

    if (companyLookupFailed) {
      return intl.inventoryLoadCompaniesErrorTitle;
    }
    return switch (companiesById[item.firma]?.trim()) {
      final String name when name.isNotEmpty => name,
      _ => intl.inventoryCompanyWithId(item.firma),
    };
  }

  AppStatusBadgeTone _statusTone(InwentaryzacjaStatus s) => switch (s) {
    InwentaryzacjaStatus.nowa => AppStatusBadgeTone.info,
    InwentaryzacjaStatus.wToku => AppStatusBadgeTone.warning,
    InwentaryzacjaStatus.zakonczona => AppStatusBadgeTone.success,
    InwentaryzacjaStatus.nieznany => AppStatusBadgeTone.neutral,
  };

  IconData _statusIcon(InwentaryzacjaStatus s) => switch (s) {
    InwentaryzacjaStatus.nowa => Icons.fiber_new_rounded,
    InwentaryzacjaStatus.wToku => Icons.sync_rounded,
    InwentaryzacjaStatus.zakonczona => Icons.check_circle_rounded,
    InwentaryzacjaStatus.nieznany => Icons.help_outline_rounded,
  };

  String _inventoryStatusLabel(
    BuildContext context,
    InwentaryzacjaStatus status,
  ) {
    final intl = context.l10n;
    return switch (status) {
      InwentaryzacjaStatus.nowa => intl.inventoryStatusNew,
      InwentaryzacjaStatus.wToku => intl.inventoryStatusInProgress,
      InwentaryzacjaStatus.zakonczona => intl.inventoryStatusFinished,
      InwentaryzacjaStatus.nieznany => intl.inventoryStatusUnknown,
    };
  }
}

class _InventoryStatusTrailing extends StatelessWidget {
  const _InventoryStatusTrailing({
    required this.label,
    required this.tone,
    required this.icon,
  });

  final String label;
  final AppStatusBadgeTone tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppStatusBadge(
      label: label,
      tone: tone,
      icon: icon,
      showBorder: false,
    );
  }
}

class _InventoryDetailsButton extends StatelessWidget {
  const _InventoryDetailsButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: .centerRight,
      child: Container(
        padding: const .symmetric(
          horizontal: Sizes.p10,
          vertical: Sizes.p8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .8),
          ),
          borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            AppText(
              label,
              style: context.text.labelMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: .w700,
              ),
            ),
            Gaps.w4,
            Icon(
              Icons.arrow_forward_rounded,
              size: Sizes.p16,
              color: colors.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryFieldData {
  const _InventoryFieldData({required this.label, this.value, this.child});

  final String label;
  final String? value;
  final Widget? child;
}

class _InventoryFieldGrid extends StatelessWidget {
  const _InventoryFieldGrid({required this.rows});

  final List<_InventoryFieldData> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
      ),
      child: Column(
        children: rows.indexed
            .map(
              (entry) => Container(
                padding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p8,
                ),
                decoration: BoxDecoration(
                  border: entry.$1 == rows.length - 1
                      ? null
                      : Border(
                          bottom: BorderSide(color: colors.outlineVariant),
                        ),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    SizedBox(
                      width: 132,
                      child: AppText(
                        entry.$2.label,
                        style: context.text.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                    Gaps.w12,
                    Expanded(
                      child:
                          entry.$2.child ??
                          AppText(
                            entry.$2.value ?? '-',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.bodyMedium?.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _InventoryLeadingIcon extends StatelessWidget {
  const _InventoryLeadingIcon({required this.status});
  final InwentaryzacjaStatus status;

  @override
  Widget build(BuildContext context) {
    return AppIcon(
      switch (status) {
        InwentaryzacjaStatus.nowa => Icons.inventory_2_outlined,
        InwentaryzacjaStatus.wToku => Icons.pending_actions_rounded,
        InwentaryzacjaStatus.zakonczona => Icons.fact_check_outlined,
        InwentaryzacjaStatus.nieznany => Icons.help_outline_rounded,
      },
      tone: switch (status) {
        InwentaryzacjaStatus.nowa => AppIconTone.primary,
        InwentaryzacjaStatus.wToku => AppIconTone.warning,
        InwentaryzacjaStatus.zakonczona => AppIconTone.success,
        InwentaryzacjaStatus.nieznany => AppIconTone.muted,
      },
    );
  }
}

class _InventoryFooterNote extends StatelessWidget {
  const _InventoryFooterNote({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: .32),
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline_rounded, size: Sizes.p16),
          Gaps.w8,
          Expanded(
            child: AppText(
              value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoriesError extends StatelessWidget {
  const _InventoriesError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEmptyState.error(
        title: context.l10n.inventoryFetchErrorTitle,
        message: message,
      ),
    );
  }
}
