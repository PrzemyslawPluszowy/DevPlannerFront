import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/add_user/add_user_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/bulk_edit_position/bulk_edit_position_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/cubit/bhp_users_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/cubit/bhp_users_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/delete_user/delete_user_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/edit_user/edit_user_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/bhp_user_issues_modal.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Filtry dla listy pracowników BHP.
enum BhpUserFilter {
  /// Pokazuje wszystkich pracowników.
  wszyscy,

  /// Pokazuje tylko aktywnych pracowników (aktywni i niezarchiwizowani).
  aktywni,

  /// Pokazuje tylko zarchiwizowanych pracowników.
  zarchiwizowani,
}

/// Ekran sekcji pracowników BHP.
class BhpUsersPage extends StatelessWidget {
  /// Tworzy ekran sekcji pracowników BHP.
  const BhpUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = BhpUsersCubit(
          repository: context.read<BhpUsersRepository>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _BhpUsersContent(),
    );
  }
}

/// Zawartość sekcji pracowników BHP.
class _BhpUsersContent extends StatefulWidget {
  /// Tworzy zawartość sekcji pracowników BHP.
  const _BhpUsersContent();

  @override
  State<_BhpUsersContent> createState() => _BhpUsersContentState();
}

class _BhpUsersContentState extends State<_BhpUsersContent> {
  static const _tableRowHeight = 44.0;

  final TableViewController _tableController = TableViewController();
  final AppSearchTextFieldController _searchController =
      AppSearchTextFieldController();
  BhpUserFilter _selectedFilter = BhpUserFilter.aktywni;
  int? _pendingScrollUserId;
  bool _scrollingToPendingUser = false;
  String _tableSearchQuery = '';
  final Set<int> _selectedUserIds = {};
  String _selectedPositionFilter = '';
  List<String> _availablePositionFilters = const [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadAvailablePositionFilters());
  }

  @override
  void dispose() {
    _tableController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailablePositionFilters() async {
    final repository = context.read<BhpPositionsRepository>();
    final result = await repository.getPositions(active: true);

    if (!mounted) {
      return;
    }

    result.fold(
      (_) {},
      (positions) {
        final filters =
            positions
                .where((item) => item.aktywny)
                .map((item) => item.nazwa.trim())
                .where((name) => name.isNotEmpty)
                .toSet()
                .toList()
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        setState(() {
          _availablePositionFilters = filters;
        });
      },
    );
  }

  Future<void> _reloadUsersAndPositionFilters(BhpUsersCubit cubit) async {
    await Future.wait([
      cubit.load(),
      _loadAvailablePositionFilters(),
    ]);
  }

  void _scheduleScrollToPendingUser(List<GetBhpUserListItem> rows) {
    final targetUserId = _pendingScrollUserId;
    if (targetUserId == null || _scrollingToPendingUser) {
      return;
    }

    final targetIndex = rows.indexWhere((row) => row.id == targetUserId);
    if (targetIndex < 0) {
      return;
    }

    _scrollingToPendingUser = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _scrollingToPendingUser = false;
        return;
      }

      final scrollController = _tableController.verticalScrollController;
      if (!scrollController.hasClients) {
        _scrollingToPendingUser = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _scheduleScrollToPendingUser(rows);
          }
        });
        return;
      }

      final targetOffset =
          (targetIndex.toDouble() * _tableRowHeight) -
          (scrollController.position.viewportDimension / 2) +
          (_tableRowHeight / 2);
      final maxOffset = scrollController.position.maxScrollExtent;
      unawaited(
        scrollController
            .animateTo(
              targetOffset.clamp(0.0, maxOffset),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
            )
            .whenComplete(() {
              if (!mounted || _pendingScrollUserId != targetUserId) {
                _scrollingToPendingUser = false;
                return;
              }

              _scrollingToPendingUser = false;
              setState(() {
                _pendingScrollUserId = null;
              });
            }),
      );
    });
  }

  void _queueScrollToUser(int userId) {
    setState(() {
      _pendingScrollUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpUsersCubit, BhpUsersState>(
      builder: (context, state) {
        final cubit = context.read<BhpUsersCubit>();
        final intl = context.l10n;

        return AppModuleSection(
          title: intl.bhpUsersTitle,
          subtitle: switch (state) {
            BhpUsersSuccess(:final items) => intl.bhpUsersSubtitle(
              items.where(_isActiveUser).length,
              items.where(_isArchivedUser).length,
            ),
            _ => intl.bhpUsersSectionSubtitle,
          },
          chips: [
            AppActionChip(
              label: intl.bhpUsersFilterActive,
              icon: Icons.check_circle_outline_rounded,
              selected: _selectedFilter == .aktywni,
              tone: .primary,
              onPressed: () => setState(() {
                _selectedFilter = .aktywni;
                _selectedUserIds.clear();
              }),
            ),
            AppActionChip(
              label: intl.bhpUsersFilterArchived,
              icon: Icons.archive_outlined,
              selected: _selectedFilter == .zarchiwizowani,
              tone: .primary,
              onPressed: () => setState(() {
                _selectedFilter = .zarchiwizowani;
                _selectedUserIds.clear();
              }),
            ),
            AppActionChip(
              label: intl.bhpUsersFilterAll,
              icon: Icons.people_outline_rounded,
              selected: _selectedFilter == .wszyscy,
              tone: .primary,
              onPressed: () => setState(() {
                _selectedFilter = .wszyscy;
                _selectedUserIds.clear();
              }),
            ),
          ],
          actions: [
            if (state case BhpUsersSuccess(:final items)) ...[
              () {
                final activeEmployeesCountByPosition = <String, int>{};
                for (final item in items.where(_isActiveUser)) {
                  final positionName = item.stanowiskoNazwa?.trim();
                  if (positionName == null || positionName.isEmpty) {
                    continue;
                  }
                  activeEmployeesCountByPosition.update(
                    positionName,
                    (count) => count + 1,
                    ifAbsent: () => 1,
                  );
                }

                final positionOptions = [
                  const AppDropdownOption<String>(
                    value: '',
                    label: 'Wszystkie stanowiska',
                  ),
                  ..._availablePositionFilters.map(
                    (pos) => AppDropdownOption<String>(
                      value: pos,
                      label:
                          '$pos (${activeEmployeesCountByPosition[pos] ?? 0})',
                    ),
                  ),
                ];

                final selectedValue =
                    positionOptions.any(
                      (o) => o.value == _selectedPositionFilter,
                    )
                    ? _selectedPositionFilter
                    : '';

                return SizedBox(
                  width: 360,
                  child: AppDropdown<String>(
                    options: positionOptions,
                    value: selectedValue,
                    hintText: 'Filtruj po stanowisku',
                    inlineLabel: 'Stanowisko:',
                    onChanged: (value) => setState(() {
                      _selectedPositionFilter = value ?? '';
                    }),
                  ),
                );
              }(),
            ],
            AppActionPill(
              label: intl.bhpAddUserTitle,
              icon: Icons.person_add_alt_1_rounded,
              tone: .primary,
              onPressed: () =>
                  _handleAddUserPressed(context, cubit, _queueScrollToUser),
            ),
            AppActionPill(
              label: intl.bhpRefreshAction,
              icon: Icons.refresh_rounded,
              tone: .contrast,
              onPressed: () => _reloadUsersAndPositionFilters(cubit),
            ),
          ],
          child: switch (state) {
            BhpUsersInitial() || BhpUsersLoading() => const Center(
              child: AppSpinner(),
            ),
            BhpUsersError(:final message) => Center(
              child: AppEmptyState.error(
                title: intl.bhpUsersErrorTitle,
                message: message,
              ),
            ),
            BhpUsersSuccess(:final items) => () {
              final filteredItems = switch (_selectedFilter) {
                BhpUserFilter.aktywni => items.where(_isActiveUser).toList(),
                BhpUserFilter.zarchiwizowani =>
                  items.where(_isArchivedUser).toList(),
                BhpUserFilter.wszyscy => items,
              };
              final positionFilteredItems = _selectedPositionFilter.isEmpty
                  ? filteredItems
                  : filteredItems
                        .where(
                          (row) =>
                              row.stanowiskoNazwa == _selectedPositionFilter,
                        )
                        .toList();
              final sortedFilteredItems = [...positionFilteredItems]
                ..sort(_compareUsersByDeadlinePriority);
              final visibleSearchItems = _applyUsersSearch(
                sortedFilteredItems,
                _tableSearchQuery,
              );

              return AppSectionCard(
                expandChild: true,
                child: sortedFilteredItems.isEmpty
                    ? AppEmptyState.noData(
                        title: intl.bhpUsersEmptyTitle,
                        message: _selectedPositionFilter.isNotEmpty
                            ? 'Brak pracowników przypisanych do stanowiska „$_selectedPositionFilter” w wybranej grupie.'
                            : _emptyMessageForFilter(
                                intl,
                                _selectedFilter,
                              ),
                      )
                    : Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          Expanded(
                            child: AppSimpleTable<GetBhpUserListItem>(
                              rows: sortedFilteredItems,
                              tableController: _tableController,
                              searchController: _searchController,
                              onSearchChanged: (value) {
                                if (_tableSearchQuery == value) {
                                  return;
                                }
                                setState(() => _tableSearchQuery = value);
                              },
                              height: null,
                              stateId: 'bhp_users_table_v2',
                              persistState: true,
                              rowKeyBuilder: (row) => row.id,
                              highlightedRowKey: _pendingScrollUserId,
                              onVisibleRowsChanged:
                                  _scheduleScrollToPendingUser,
                              onRowTap: (context, row, sourceIndex) =>
                                  _handleOpenIssuesPressed(context, cubit, row),
                              onRowSecondaryTap:
                                  (context, row, sourceIndex, details) =>
                                      _showUserActionsMenu(
                                        context,
                                        cubit: cubit,
                                        row: row,
                                        fromPointer: details.globalPosition,
                                      ),
                              showSearch: true,
                              searchHintText: intl.bhpUsersSearchHint,
                              searchMatcher: _matchesUsersSearch,
                              footer: _tableSearchQuery.trim().isEmpty
                                  ? null
                                  : Padding(
                                      padding: const .only(top: Sizes.p12),
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  intl.bhpUsersSearchResultsSummary(
                                                    visibleSearchItems.length,
                                                    sortedFilteredItems.length,
                                                  ),
                                                  style: context.text.bodySmall
                                                      ?.copyWith(
                                                        color: context
                                                            .colors
                                                            .onSurfaceVariant,
                                                        fontWeight: .w600,
                                                      ),
                                                ),
                                              ),
                                              AppActionButton.text(
                                                label: intl
                                                    .bhpUsersClearSearchAction,
                                                icon: Icons.close_rounded,
                                                tone: .neutral,
                                                onPressed: () {
                                                  _searchController.reset();
                                                  setState(
                                                    () =>
                                                        _tableSearchQuery = '',
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          if (visibleSearchItems.isEmpty) ...[
                                            Gaps.h12,
                                            AppEmptyState.noResults(
                                              title: intl
                                                  .bhpUsersNoSearchResultsTitle,
                                              message: intl
                                                  .bhpUsersNoSearchResultsMessage,
                                              compact: true,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                              columns: [
                                AppSimpleTableColumn(
                                  label: '',
                                  width: 48,
                                  sortable: false,
                                  cellBuilder: (context, row) => Checkbox(
                                    value: _selectedUserIds.contains(row.id),
                                    activeColor: context.colors.primary,
                                    onChanged: (checked) {
                                      setState(() {
                                        if (checked == true) {
                                          _selectedUserIds.add(row.id);
                                        } else {
                                          _selectedUserIds.remove(row.id);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpUsersRowNumber,
                                  width: 84,
                                  sortable: false,
                                  numeric: true,
                                  indexedCellBuilder:
                                      (
                                        context,
                                        row,
                                        sourceIndex,
                                        visibleIndex,
                                      ) => Text('${visibleIndex + 1}'),
                                  cellBuilder: (context, row) =>
                                      const SizedBox(),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpTableEmployee,
                                  width: 280,
                                  sortValue: (row) => _sortText(row.fullName),
                                  cellBuilder: (context, row) =>
                                      Text(row.fullName),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpTablePosition,
                                  width: 200,
                                  sortValue: (row) =>
                                      _sortText(row.stanowiskoNazwa),
                                  cellBuilder: (context, row) =>
                                      Text(row.stanowiskoNazwa ?? '—'),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpUsersOverdueLabel,
                                  width: 120,
                                  numeric: true,
                                  sortValue: _overdueSortValue,
                                  cellBackgroundColor: (context, row) =>
                                      row.overdueCount > 0
                                      ? context.colors.errorContainer
                                            .withValues(
                                              alpha: .55,
                                            )
                                      : null,
                                  cellBuilder: (context, row) =>
                                      _DeadlineSummaryCell(
                                        primary: row.overdueCount > 0
                                            ? '${row.overdueCount}'
                                            : '',
                                        secondary:
                                            row.nearestOverdueDays != null
                                            ? '-${row.nearestOverdueDays} ${intl.bhpUsersDaysSuffix}'
                                            : '',
                                        textColor: row.overdueCount > 0
                                            ? context.colors.onErrorContainer
                                            : null,
                                      ),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpUsersUpcomingLabel,
                                  width: 120,
                                  numeric: true,
                                  sortValue: _upcomingSortValue,
                                  cellBackgroundColor: (context, row) =>
                                      row.daysUntilDue != null &&
                                          row.daysUntilDue! <= 30
                                      ? context.feedback.warningBackground
                                            .withValues(
                                              alpha: .78,
                                            )
                                      : null,
                                  cellBuilder: (context, row) =>
                                      _DeadlineSummaryCell(
                                        primary: row.daysUntilDue != null
                                            ? '${row.daysUntilDue}'
                                            : '',
                                        secondary: row.daysUntilDue != null
                                            ? intl.bhpUsersDaysSuffix
                                            : '',
                                        textColor:
                                            row.daysUntilDue != null &&
                                                row.daysUntilDue! <= 30
                                            ? context.feedback.warningForeground
                                            : null,
                                      ),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpTableEmploymentStart,
                                  width: 130,
                                  sortValue: (row) =>
                                      _sortDate(row.dataRozpPracy),
                                  cellBuilder: (context, row) => Text(
                                    _formatDisplayDate(row.dataRozpPracy),
                                  ),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpTableEmploymentEnd,
                                  width: 130,
                                  sortValue: (row) =>
                                      _sortDate(row.dataZakPracy),
                                  cellBuilder: (context, row) => Text(
                                    _formatDisplayDate(row.dataZakPracy),
                                  ),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.bhpTableStatus,
                                  width: 130,
                                  sortable: false,
                                  cellBuilder: (context, row) => AppStatusBadge(
                                    label: _isArchivedUser(row)
                                        ? intl.bhpStatusArchived
                                        : row.aktywny
                                        ? intl.bhpStatusActive
                                        : intl.bhpStatusInactive,
                                    icon: _isArchivedUser(row)
                                        ? Icons.archive_outlined
                                        : row.aktywny
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.pause_circle_outline_rounded,
                                    tone: _isArchivedUser(row)
                                        ? AppStatusBadgeTone.neutral
                                        : row.aktywny
                                        ? AppStatusBadgeTone.success
                                        : AppStatusBadgeTone.warning,
                                  ),
                                ),
                                AppSimpleTableColumn(
                                  label: intl.inventoryActionsLabel,
                                  width: 150,
                                  sortable: false,
                                  cellAlignment: .center,
                                  cellBuilder: (context, row) =>
                                      AppContextMenuButton(
                                        label: intl.inventoryActionsLabel,
                                        icon: Icons.more_horiz_rounded,
                                        dense: true,
                                        menuHeaderTitle: row.fullName,
                                        menuHeaderSubtitle:
                                            _getUserActionsMenuSubtitle(
                                              context,
                                              row,
                                            ),
                                        actions: _buildUserActions(
                                          context,
                                          cubit,
                                          row,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedUserIds.isNotEmpty) ...[
                            _buildBulkActionsBar(
                              context,
                              cubit,
                            ),
                          ],
                        ],
                      ),
              );
            }(),
          },
        );
      },
    );
  }

  Widget _buildBulkActionsBar(
    BuildContext context,
    BhpUsersCubit cubit,
  ) {
    final intl = context.l10n;
    final colors = context.colors;

    return Container(
      padding: const .symmetric(horizontal: Sizes.p16, vertical: Sizes.p12),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: .15),
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people_outline_rounded,
            color: colors.primary,
          ),
          Gaps.w12,
          Expanded(
            child: Text(
              intl.bhpUsersBulkSelectedCount(_selectedUserIds.length),
              style: context.text.titleSmall?.copyWith(
                fontWeight: .w600,
                color: colors.onSurface,
              ),
            ),
          ),
          AppActionButton.text(
            label: intl.cancel,
            icon: Icons.close_rounded,
            tone: .neutral,
            onPressed: () {
              setState(_selectedUserIds.clear);
            },
          ),
          Gaps.w12,
          AppActionButton.filled(
            label: intl.bhpUsersBulkChangePositionAction,
            icon: Icons.edit_location_alt_rounded,
            onPressed: () => _handleBulkChangePosition(context, cubit),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBulkChangePosition(
    BuildContext context,
    BhpUsersCubit cubit,
  ) async {
    final intl = context.l10n;
    final positionId = await showBulkEditPositionModal(
      context,
      selectedEmployeesCount: _selectedUserIds.length,
    );

    if (!context.mounted || positionId == null) {
      return;
    }

    final response = await cubit.bulkUpdatePosition(
      employeeIds: _selectedUserIds.toList(),
      stanowiskoId: positionId,
    );

    if (!context.mounted) {
      return;
    }

    response.fold(
      (error) => AppToast.show(
        context,
        message: error,
        tone: AppToastTone.error,
      ),
      (_) {
        AppToast.show(
          context,
          message: intl.bhpUsersBulkSuccessMessage(_selectedUserIds.length),
          tone: AppToastTone.success,
        );
        setState(_selectedUserIds.clear);
      },
    );
  }
}

String _sortText(String? value) => value?.trim().toLowerCase() ?? '';

String _formatDisplayDate(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return '—';
  }

  final parsed = DateTime.tryParse(text);
  return parsed == null ? text : DateFormat('dd.MM.yyyy').format(parsed);
}

String _sortDate(String? value) {
  final parsed = DateTime.tryParse(value?.trim() ?? '');
  return parsed?.toIso8601String() ?? '';
}

String _emptyMessageForFilter(
  AppLocalizations intl,
  BhpUserFilter filter,
) {
  return switch (filter) {
    BhpUserFilter.aktywni => intl.bhpUsersNoActiveMessage,
    BhpUserFilter.zarchiwizowani => intl.bhpUsersNoArchivedMessage,
    BhpUserFilter.wszyscy => intl.bhpUsersEmptyMessage,
  };
}

List<GetBhpUserListItem> _applyUsersSearch(
  List<GetBhpUserListItem> rows,
  String query,
) {
  final trimmedQuery = query.trim();
  if (trimmedQuery.isEmpty) {
    return rows;
  }

  return rows.where((row) => _matchesUsersSearch(row, trimmedQuery)).toList();
}

bool _matchesUsersSearch(GetBhpUserListItem row, String query) {
  final phrase = query.trim().toLowerCase();
  if (phrase.isEmpty) {
    return true;
  }

  return row.fullName.toLowerCase().contains(phrase) ||
      (row.stanowiskoNazwa ?? '').toLowerCase().contains(phrase) ||
      (row.nrEwidencyjny ?? '').toLowerCase().contains(phrase);
}

/// Zwraca wartość sortowania dla kolumny „Po terminie”.
/// Sortuje po liczbie dni spóźnienia (im większe spóźnienie, tym mniejsza wartość, czyli wyższa pozycja przy sortowaniu rosnącym),
/// a osoby bez zaległości umieszcza na końcu.
int _overdueSortValue(GetBhpUserListItem row) {
  if (row.overdueCount <= 0) {
    return 1 << 30;
  }

  return -(row.nearestOverdueDays ?? 0);
}

/// Zwraca wartość sortowania dla kolumny „Zbliża się termin”.
/// Sortuje po liczbie dni do terminu (im mniej dni, tym wyższa pozycja),
/// a osoby bez zaplanowanych terminów umieszcza na końcu.
int _upcomingSortValue(GetBhpUserListItem row) {
  if (row.daysUntilDue == null) {
    return 1 << 30;
  }

  return row.daysUntilDue!;
}

/// Porównuje dwóch pracowników pod kątem priorytetu terminów BHP do domyślnego sortowania na liście.
/// Pierwszeństwo mają osoby z największą liczbą dni po terminie (nearestOverdueDays).
int _compareUsersByDeadlinePriority(
  GetBhpUserListItem left,
  GetBhpUserListItem right,
) {
  final nearestOverdueLeft = left.nearestOverdueDays ?? -1;
  final nearestOverdueRight = right.nearestOverdueDays ?? -1;
  final nearestOverdueCompare = nearestOverdueRight.compareTo(
    nearestOverdueLeft,
  );
  if (nearestOverdueCompare != 0) {
    return nearestOverdueCompare;
  }

  final overdueCountCompare = right.overdueCount.compareTo(left.overdueCount);
  if (overdueCountCompare != 0) {
    return overdueCountCompare;
  }

  final nearestUpcomingLeft = left.daysUntilDue ?? 1 << 30;
  final nearestUpcomingRight = right.daysUntilDue ?? 1 << 30;
  final nearestUpcomingCompare = nearestUpcomingLeft.compareTo(
    nearestUpcomingRight,
  );
  if (nearestUpcomingCompare != 0) {
    return nearestUpcomingCompare;
  }

  final upcomingCountCompare = right.upcomingCount.compareTo(
    left.upcomingCount,
  );
  if (upcomingCountCompare != 0) {
    return upcomingCountCompare;
  }

  return _sortText(left.fullName).compareTo(_sortText(right.fullName));
}

/// Komórka podsumowania alertu terminów dla pojedynczego pracownika.
class _DeadlineSummaryCell extends StatelessWidget {
  /// Tworzy komórkę z główną liczbą i dopiskiem dni.
  const _DeadlineSummaryCell({
    required this.primary,
    required this.secondary,
    required this.textColor,
  });

  final String primary;
  final String secondary;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    if (primary.isEmpty && secondary.isEmpty) {
      return const SizedBox();
    }

    final text = [
      if (primary.isNotEmpty) primary,
      if (secondary.isNotEmpty) secondary,
    ].join(' ');

    return Align(
      alignment: .centerRight,
      child: Text(
        text,
        maxLines: 1,
        overflow: .ellipsis,
        textAlign: TextAlign.right,
        style: context.text.labelMedium?.copyWith(
          color: textColor,
          fontWeight: .w700,
          height: 1,
        ),
      ),
    );
  }
}

List<AppContextMenuAction> _buildUserActions(
  BuildContext context,
  BhpUsersCubit cubit,
  GetBhpUserListItem row,
) {
  final intl = context.l10n;
  final colors = context.colors;

  return [
    AppContextMenuAction(
      label: intl.bhpPreviewIssuesAction,
      icon: Icons.inventory_2_outlined,
      foregroundColor: colors.primary,
      onTap: (_) => _handleOpenIssuesPressed(context, cubit, row),
    ),
    if (!_isArchivedUser(row))
      AppContextMenuAction(
        label: context.l10n.edit,
        icon: Icons.edit_outlined,
        foregroundColor: colors.primary,
        onTap: (_) => _handleEditUserPressed(context, cubit, row),
      ),
    if (_isArchivedUser(row)) ...[
      AppContextMenuAction(
        label: intl.bhpPreviewRestoreAction,
        icon: Icons.restore_from_trash_rounded,
        foregroundColor: context.feedback.warningForeground,
        onTap: (_) => _handleRestoreUserPressed(context, cubit, row),
      ),
      AppContextMenuAction(
        label: intl.bhpPreviewForceDeleteAction,
        icon: Icons.delete_forever_rounded,
        isDestructive: true,
        foregroundColor: colors.error,
        onTap: (_) => _handleForceDeleteUserPressed(context, cubit, row),
      ),
    ] else
      AppContextMenuAction(
        label: intl.bhpArchiveUserAction,
        icon: Icons.archive_outlined,
        foregroundColor: context.feedback.warningForeground,
        onTap: (_) => _handleDeleteUserPressed(context, cubit, row),
      ),
  ];
}

Future<void> _showUserActionsMenu(
  BuildContext context, {
  required BhpUsersCubit cubit,
  required GetBhpUserListItem row,
  required Offset fromPointer,
}) async {
  final overlayBox =
      Overlay.of(context).context.findRenderObject()! as RenderBox;
  final selectedIndex = await showMenu<int>(
    context: context,
    position: RelativeRect.fromLTRB(
      fromPointer.dx,
      fromPointer.dy,
      overlayBox.size.width - fromPointer.dx,
      overlayBox.size.height - fromPointer.dy,
    ),
    items: [
      PopupMenuItem<int>(
        enabled: false,
        height: 56,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          children: [
            Text(
              row.fullName,
              maxLines: 1,
              overflow: .ellipsis,
              style: context.text.labelLarge?.copyWith(fontWeight: .w700),
            ),
            if (_getUserActionsMenuSubtitle(context, row)
                case final subtitle?) ...[
              Gaps.h2,
              Text(
                subtitle,
                maxLines: 1,
                overflow: .ellipsis,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
      const PopupMenuDivider(),
      for (final entry in _buildUserActions(context, cubit, row).indexed)
        PopupMenuItem<int>(
          value: entry.$1,
          child: Row(
            children: [
              if (entry.$2.icon case final icon?) ...[
                Icon(
                  icon,
                  size: 18,
                  color:
                      entry.$2.foregroundColor ??
                      (entry.$2.isDestructive
                          ? context.colors.error
                          : context.colors.primary),
                ),
                Gaps.w8,
              ],
              Text(
                entry.$2.label,
                style: context.text.labelLarge?.copyWith(
                  color:
                      entry.$2.foregroundColor ??
                      (entry.$2.isDestructive
                          ? context.colors.error
                          : context.colors.primary),
                  fontWeight: .w500,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  if (!context.mounted || selectedIndex == null) {
    return;
  }

  await _buildUserActions(context, cubit, row)[selectedIndex].onTap(context);
}

bool _isActiveUser(GetBhpUserListItem row) => row.aktywny && !row.isArchived;

bool _isArchivedUser(GetBhpUserListItem row) => row.isArchived || !row.aktywny;

String? _getUserActionsMenuSubtitle(
  BuildContext context,
  GetBhpUserListItem row,
) {
  final parts = <String>[];

  if (row.stanowiskoNazwa case final position?) {
    final trimmedPosition = position.trim();
    if (trimmedPosition.isNotEmpty) {
      parts.add(trimmedPosition);
    }
  }

  if (_isArchivedUser(row)) {
    parts.add(context.l10n.bhpStatusArchived);
  } else if (!row.aktywny) {
    parts.add(context.l10n.bhpStatusInactive);
  }

  if (parts.isEmpty) {
    return null;
  }

  return parts.join(' · ');
}

Future<void> _handleAddUserPressed(
  BuildContext context,
  BhpUsersCubit cubit,
  void Function(int userId) onUserCreated,
) async {
  final existingUsers = switch (cubit.state) {
    BhpUsersSuccess(:final items) => items,
    _ => const <GetBhpUserListItem>[],
  };
  final created = await showAddBhpUserModal(
    context,
    existingUsers: existingUsers,
  );
  if (!context.mounted || created == null) {
    return;
  }

  onUserCreated(created.id);
  await cubit.load();
}

Future<void> _handleOpenIssuesPressed(
  BuildContext context,
  BhpUsersCubit cubit,
  GetBhpUserListItem row,
) async {
  await showBhpUserIssuesModal(context, user: row);
  if (!context.mounted) {
    return;
  }

  await cubit.load();
}

Future<void> _handleEditUserPressed(
  BuildContext context,
  BhpUsersCubit cubit,
  GetBhpUserListItem row,
) async {
  final updated = await showEditBhpUserModal(context, user: row);
  if (!context.mounted || updated == null) {
    return;
  }

  await cubit.load();
}

Future<void> _handleDeleteUserPressed(
  BuildContext context,
  BhpUsersCubit cubit,
  GetBhpUserListItem row,
) async {
  final deleted = await showDeleteBhpUserModal(context, user: row);
  if (!context.mounted || deleted != true) {
    return;
  }

  AppToast.show(
    context,
    message: context.l10n.bhpPreviewArchivedMessage(row.fullName),
    tone: AppToastTone.success,
  );
  await cubit.load();
}

Future<void> _handleRestoreUserPressed(
  BuildContext context,
  BhpUsersCubit cubit,
  GetBhpUserListItem row,
) async {
  final confirmed = await AppConfirmDialog.show(
    context,
    title: context.l10n.bhpPreviewRestoreAction,
    message: context.l10n.bhpPreviewRestoreEmployeeMessage,
    confirmLabel: context.l10n.bhpPreviewRestoreAction,
    tone: AppConfirmDialogTone.warning,
  );

  if (!context.mounted || !confirmed) {
    return;
  }

  final repository = context.read<BhpUsersRepository>();
  final result = await repository.unarchiveUser(row.id);

  if (!context.mounted) {
    return;
  }

  result.fold(
    (error) => AppToast.show(
      context,
      message: error.message,
      tone: AppToastTone.error,
    ),
    (_) {
      AppToast.show(
        context,
        message: context.l10n.bhpPreviewRestoredMessage(row.fullName),
        tone: AppToastTone.success,
      );
      unawaited(cubit.load());
    },
  );
}

Future<void> _handleForceDeleteUserPressed(
  BuildContext context,
  BhpUsersCubit cubit,
  GetBhpUserListItem row,
) async {
  final deleted = await showForceDeleteBhpUserModal(context, user: row);
  if (!context.mounted || deleted != true) {
    return;
  }

  AppToast.show(
    context,
    message: context.l10n.bhpPreviewForceDeletedMessage(row.fullName),
    tone: .success,
  );
  await cubit.load();
}
