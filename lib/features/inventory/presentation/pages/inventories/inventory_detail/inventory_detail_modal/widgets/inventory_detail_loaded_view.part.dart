part of 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_detail_modal.dart';

/// Widok danych zaladowanych szczegolow inwentaryzacji.
class _InventoryDetailLoadedView extends StatefulWidget {
  /// Tworzy widok danych szczegolow inwentaryzacji.
  const _InventoryDetailLoadedView({
    required this.inventoryId,
    required this.data,
    required this.inventoriesRepository,
    required this.locationsRepository,
    required this.stockRepository,
    required this.usersRepository,
    this.onDataChanged,
  });

  final int inventoryId;
  final GetInwentaryzacjaDetailsResponseData data;
  final InventoriesRepository inventoriesRepository;
  final LocationsRepository locationsRepository;
  final StockRepository stockRepository;
  final UsersRepository usersRepository;
  final VoidCallback? onDataChanged;

  @override
  State<_InventoryDetailLoadedView> createState() =>
      _InventoryDetailLoadedViewState();
}

/// Stan widoku danych zaladowanych szczegolow inwentaryzacji.
class _InventoryDetailLoadedViewState
    extends State<_InventoryDetailLoadedView> {
  final AppSearchTextFieldController _arkuszeSearchController =
      AppSearchTextFieldController();

  String _arkuszeSearchQuery = '';
  LoadableState<GetInwentaryzacjaPresenceConflictsResponseData>
  _presenceConflicts = const LoadableInitial();
  LoadableState<GetInwentaryzacjaSurplusConflictsResponseData>
  _surplusConflicts = const LoadableInitial();
  int _presenceConflictsRequestId = 0;
  int _surplusConflictsRequestId = 0;

  @override
  void initState() {
    super.initState();
    _loadPresenceConflicts().ignore();
    _loadSurplusConflicts().ignore();
  }

  @override
  void didUpdateWidget(covariant _InventoryDetailLoadedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.inventoryId != widget.inventoryId ||
        oldWidget.data != widget.data) {
      _loadPresenceConflicts().ignore();
      _loadSurplusConflicts().ignore();
    }
  }

  @override
  void dispose() {
    _arkuszeSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadPresenceConflicts() async {
    final requestId = ++_presenceConflictsRequestId;
    final previousData = _presenceConflicts.data;

    setState(() {
      _presenceConflicts =
          LoadableState<GetInwentaryzacjaPresenceConflictsResponseData>.loading(
            previousData: previousData,
          );
    });

    final result = await widget.inventoriesRepository
        .fetchInventoryPresenceConflicts(
          widget.inventoryId,
        );

    if (!mounted || requestId != _presenceConflictsRequestId) {
      return;
    }

    result.fold(
      (error) => setState(() {
        _presenceConflicts =
            LoadableState<GetInwentaryzacjaPresenceConflictsResponseData>.error(
              message: error.message,
              previousData: previousData,
            );
      }),
      (data) => setState(() {
        _presenceConflicts =
            LoadableState<
              GetInwentaryzacjaPresenceConflictsResponseData
            >.success(data: data);
      }),
    );
  }

  Future<void> _loadSurplusConflicts() async {
    final requestId = ++_surplusConflictsRequestId;
    final previousData = _surplusConflicts.data;

    setState(() {
      _surplusConflicts =
          LoadableState<GetInwentaryzacjaSurplusConflictsResponseData>.loading(
            previousData: previousData,
          );
    });

    final result = await widget.inventoriesRepository
        .fetchInventorySurplusConflicts(
          widget.inventoryId,
        );

    if (!mounted || requestId != _surplusConflictsRequestId) {
      return;
    }

    result.fold(
      (error) => setState(() {
        _surplusConflicts =
            LoadableState<GetInwentaryzacjaSurplusConflictsResponseData>.error(
              message: error.message,
              previousData: previousData,
            );
      }),
      (data) => setState(() {
        _surplusConflicts =
            LoadableState<
              GetInwentaryzacjaSurplusConflictsResponseData
            >.success(
              data: data,
            );
      }),
    );
  }

  Future<void> _handleOpenPresenceConflicts() async {
    if (_presenceConflicts case LoadableSuccess(:final data)) {
      await _openPresenceConflictsModal(data);
      return;
    }

    await _loadPresenceConflicts();
    if (!mounted) {
      return;
    }

    if (_presenceConflicts case LoadableSuccess(:final data)) {
      await _openPresenceConflictsModal(data);
      return;
    }

    if (_presenceConflicts case LoadableError(:final message)) {
      final staleData = _presenceConflicts.data;
      if (staleData != null) {
        await _openPresenceConflictsModal(staleData);
        return;
      }
      await _showPresenceConflictsErrorModal(
        context,
        message: message,
      );
    }
  }

  Future<void> _openPresenceConflictsModal(
    GetInwentaryzacjaPresenceConflictsResponseData data,
  ) async {
    final errorMessage = switch (_presenceConflicts) {
      LoadableError(:final message) => message,
      _ => null,
    };
    final selection = await showInventoryPresenceConflictsModal(
      context,
      inventoryNumber: widget.data.inwentaryzacja.numer,
      data: data,
      errorMessage: errorMessage,
      onRefresh: _refreshPresenceConflictsForModal,
    );
    if (!mounted || selection == null) {
      return;
    }

    await _openArkuszForSelection(
      arkuszId: selection.arkuszId,
      arkuszNumber: selection.arkuszNumber,
      elementId: selection.elementId,
    );
  }

  Future<void> _handleOpenSurplusConflicts() async {
    if (_surplusConflicts case LoadableSuccess(:final data)) {
      await _openSurplusConflictsModal(data);
      return;
    }

    await _loadSurplusConflicts();
    if (!mounted) {
      return;
    }

    if (_surplusConflicts case LoadableSuccess(:final data)) {
      await _openSurplusConflictsModal(data);
      return;
    }

    if (_surplusConflicts case LoadableError(:final message)) {
      final staleData = _surplusConflicts.data;
      if (staleData != null) {
        await _openSurplusConflictsModal(staleData);
        return;
      }
      await _showPresenceConflictsErrorModal(
        context,
        message: message,
      );
    }
  }

  Future<void> _openSurplusConflictsModal(
    GetInwentaryzacjaSurplusConflictsResponseData data,
  ) async {
    final errorMessage = switch (_surplusConflicts) {
      LoadableError(:final message) => message,
      _ => null,
    };
    final selection = await showInventorySurplusConflictsModal(
      context,
      inventoryNumber: widget.data.inwentaryzacja.numer,
      data: data,
      errorMessage: errorMessage,
      onRefresh: _refreshSurplusConflictsForModal,
    );
    if (!mounted || selection == null) {
      return;
    }

    await _openArkuszForSelection(
      arkuszId: selection.arkuszId,
      arkuszNumber: selection.arkuszNumber,
      elementId: selection.elementId,
    );
  }

  Future<void> _openArkuszForSelection({
    required int arkuszId,
    required String arkuszNumber,
    required int elementId,
  }) async {
    await showArkuszDetailModal(
      context,
      arkuszId: arkuszId,
      arkuszNumber: arkuszNumber,
      inventoryCompanies: widget.data.inwentaryzacja.firmy,
      canDeleteArkusz:
          widget.data.inwentaryzacja.inventoryStatus !=
          InwentaryzacjaStatus.zakonczona,
      canEditArkusz:
          widget.data.inwentaryzacja.inventoryStatus !=
          InwentaryzacjaStatus.zakonczona,
      inventoriesRepository: widget.inventoriesRepository,
      locationsRepository: widget.locationsRepository,
      stockRepository: widget.stockRepository,
      usersRepository: widget.usersRepository,
      initialHighlightElementId: elementId,
      onDataChanged: widget.onDataChanged,
    );
    if (!mounted) {
      return;
    }
    await context.read<InventoryDetailCubit>().load(widget.inventoryId);
  }

  Future<InventoryPresenceConflictsRefreshResult>
  _refreshPresenceConflictsForModal() async {
    final previousData = _presenceConflicts.data;
    await _loadPresenceConflicts();

    final data =
        _presenceConflicts.data ??
        previousData ??
        GetInwentaryzacjaPresenceConflictsResponseData(
          meta: GetInwentaryzacjaPresenceConflictsMeta(
            scope: 'inventory',
            scopeId: widget.inventoryId,
            generatedAt: DateTime.now().toIso8601String(),
            inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta(
              id: widget.inventoryId,
            ),
            totals: const GetInwentaryzacjaPresenceConflictsTotals(
              itemsCount: 0,
            ),
          ),
          items: const [],
        );

    return InventoryPresenceConflictsRefreshResult(
      data: data,
      errorMessage: switch (_presenceConflicts) {
        LoadableError(:final message) => message,
        _ => null,
      },
    );
  }

  Future<InventorySurplusConflictsRefreshResult>
  _refreshSurplusConflictsForModal() async {
    final previousData = _surplusConflicts.data;
    await _loadSurplusConflicts();

    final data =
        _surplusConflicts.data ??
        previousData ??
        GetInwentaryzacjaSurplusConflictsResponseData(
          meta: GetInwentaryzacjaSurplusConflictsMeta(
            scope: 'inventory',
            scopeId: widget.inventoryId,
            generatedAt: DateTime.now().toIso8601String(),
            inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta(
              id: widget.inventoryId,
            ),
            totals: const GetInwentaryzacjaSurplusConflictsTotals(
              itemsCount: 0,
            ),
          ),
          items: const [],
        );

    return InventorySurplusConflictsRefreshResult(
      data: data,
      errorMessage: switch (_surplusConflicts) {
        LoadableError(:final message) => message,
        _ => null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final data = widget.data;
    final header = data.inwentaryzacja;
    final status = header.inventoryStatus;
    final isInventoryClosed = status == InwentaryzacjaStatus.zakonczona;
    final canEditInventory = !isInventoryClosed;
    final filteredArkusze = _filteredArkusze(data.arkusze);
    final presenceConflictsData = _presenceConflicts.data;
    final presenceConflictCount =
        presenceConflictsData?.meta.totals.itemsCount ??
        presenceConflictsData?.items.length ??
        0;
    final hasPresenceConflicts = presenceConflictCount > 0;
    final presenceConflictsLabel = switch (_presenceConflicts) {
      LoadableLoading() when presenceConflictsData == null =>
        intl.inventoryPresenceConflictsLoadingLabel,
      LoadableError() when presenceConflictsData == null =>
        intl.inventoryPresenceConflictsRetryLabel,
      _ when hasPresenceConflicts =>
        intl.inventoryPresenceConflictsDetectedAction(presenceConflictCount),
      _ => intl.inventoryPresenceConflictsEmptyBadge,
    };
    final presenceConflictsIcon = switch (_presenceConflicts) {
      LoadableLoading() when presenceConflictsData == null =>
        Icons.hourglass_top_rounded,
      _ when hasPresenceConflicts => Icons.close_rounded,
      _ => Icons.check_circle_outline_rounded,
    };
    final presenceConflictsTone =
        (_presenceConflicts is LoadableError || hasPresenceConflicts)
        ? AppActionButtonTone.danger
        : AppActionButtonTone.neutral;
    final presenceConflictsErrorMessage = switch (_presenceConflicts) {
      LoadableError(:final message) when presenceConflictsData == null =>
        message,
      _ => null,
    };
    final surplusConflictsData = _surplusConflicts.data;
    final surplusConflictCount =
        surplusConflictsData?.meta.totals.itemsCount ??
        surplusConflictsData?.items.length ??
        0;
    final hasSurplusConflicts = surplusConflictCount > 0;
    final surplusConflictsLabel = switch (_surplusConflicts) {
      LoadableLoading() when surplusConflictsData == null =>
        intl.inventorySurplusConflictsLoadingLabel,
      LoadableError() when surplusConflictsData == null =>
        intl.inventorySurplusConflictsRetryLabel,
      _ when hasSurplusConflicts =>
        intl.inventorySurplusConflictsDetectedAction(surplusConflictCount),
      _ => intl.inventorySurplusConflictsEmptyBadge,
    };
    final surplusConflictsIcon = switch (_surplusConflicts) {
      LoadableLoading() when surplusConflictsData == null =>
        Icons.hourglass_top_rounded,
      _ when hasSurplusConflicts => Icons.warning_amber_rounded,
      _ => Icons.check_circle_outline_rounded,
    };
    final surplusConflictsTone =
        (_surplusConflicts is LoadableError || hasSurplusConflicts)
        ? AppActionButtonTone.danger
        : AppActionButtonTone.neutral;
    final surplusConflictsErrorMessage = switch (_surplusConflicts) {
      LoadableError(:final message) when surplusConflictsData == null =>
        message,
      _ => null,
    };

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: Sizes.p8,
                runSpacing: Sizes.p8,
                children: [
                  _InventoryDetailMetaChip(
                    label: intl.id,
                    value: '${header.id}',
                  ),
                  _InventoryDetailMetaChip(
                    label: intl.inventoryCompany,
                    value: switch (header.firmaNazwa) {
                      final String name when name.trim().isNotEmpty =>
                        name.trim(),
                      _ => '${header.firma}',
                    },
                  ),
                  _InventoryDetailMetaChip(
                    label: intl.inventoryDateRangeLabel,
                    value:
                        '${header.dataOd.toAppDate()} - ${header.dataDo.toAppDate()}',
                  ),
                  _InventoryDetailMetaChip(
                    label: intl.inventorySheetsLabel,
                    value: '${data.arkusze.length}',
                  ),
                ],
              ),
            ),
            Gaps.w8,
            Row(
              mainAxisSize: .min,
              children: [
                AppActionButton.outlined(
                  label: intl.inventoryReportsTitle,
                  icon: Icons.assessment_outlined,
                  tone: .neutral,
                  onPressed: () => showInventoryReportsFlow(
                    context,
                    inventoryId: widget.inventoryId,
                    inventoryNumber: header.numer,
                    inventoryDetails: data,
                    repository: widget.inventoriesRepository,
                  ),
                ),
                Gaps.w8,
                AppActionButton.outlined(
                  label: intl.inventoryDeleteTitle,
                  icon: Icons.delete_outline_rounded,
                  tone: .danger,
                  onPressed: () {
                    (() async {
                      final deleted = await _showDeleteInventoryModal(
                        context,
                        inventoryId: widget.inventoryId,
                        inventoryNumber: header.numer,
                        repository: widget.inventoriesRepository,
                      );
                      if (!context.mounted || deleted != true) {
                        return;
                      }

                      AppToast.show(
                        context,
                        message: intl.inventoryDeletedMessage,
                        tone: AppToastTone.success,
                      );
                      widget.onDataChanged?.call();
                      Navigator.of(context, rootNavigator: true).pop();
                    })().ignore();
                  },
                ),
                Gaps.w8,
                AppActionButton.outlined(
                  label: context.l10n.inventoryEditDatesAction,
                  icon: Icons.edit_calendar_rounded,
                  tone: .neutral,
                  onPressed: () {
                    (() async {
                      final updated = await _showUpdateInventoryDatesModal(
                        context,
                        inventoryId: widget.inventoryId,
                        inventoryNumber: header.numer,
                        status: status,
                        dataOd: header.dataOd,
                        dataDo: header.dataDo,
                        numer: header.numer,
                        uwagi: header.uwagi,
                        repository: widget.inventoriesRepository,
                      );
                      if (!context.mounted || updated != true) {
                        return;
                      }

                      AppToast.show(
                        context,
                        message: context.l10n.inventoryDatesSavedMessage,
                        tone: AppToastTone.success,
                      );
                      await context.read<InventoryDetailCubit>().load(
                        widget.inventoryId,
                      );
                      widget.onDataChanged?.call();
                    })().ignore();
                  },
                ),
                Gaps.w8,
                AppActionButton.outlined(
                  label: intl.inventoryCloseTitle,
                  icon: Icons.task_alt_rounded,
                  onPressed: () {
                    (() async {
                      final closed = await _showCloseInventoryModal(
                        context,
                        inventoryId: widget.inventoryId,
                        inventoryNumber: header.numer,
                        status: status,
                        repository: widget.inventoriesRepository,
                      );
                      if (!context.mounted || closed != true) {
                        return;
                      }

                      AppToast.show(
                        context,
                        message: intl.inventoryClosedMessage,
                        tone: AppToastTone.success,
                      );
                      await context.read<InventoryDetailCubit>().load(
                        widget.inventoryId,
                      );
                      widget.onDataChanged?.call();
                    })().ignore();
                  },
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: intl.inventoryNewSheet,
                  icon: Icons.add_rounded,
                  onPressed: !canEditInventory
                      ? null
                      : () {
                          (() async {
                            final created = await showCreateArkuszModal(
                              context,
                              inventoryId: widget.inventoryId,
                              firmaId: header.firma,
                              firmy: header.firmy,
                              inventoriesRepository:
                                  widget.inventoriesRepository,
                              locationsRepository: widget.locationsRepository,
                              usersRepository: widget.usersRepository,
                            );
                            if (!context.mounted || created != true) {
                              return;
                            }

                            AppToast.show(
                              context,
                              message: intl.inventorySheetCreatedMessage,
                              tone: AppToastTone.success,
                            );
                            await context.read<InventoryDetailCubit>().load(
                              widget.inventoryId,
                            );
                            widget.onDataChanged?.call();
                          })().ignore();
                        },
                ),
              ],
            ),
          ],
        ),
        if (presenceConflictsErrorMessage != null) ...[
          Gaps.h12,
          AppEmptyState.error(
            title: intl.inventoryLoadingErrorTitle,
            message: presenceConflictsErrorMessage,
            compact: true,
            action: AppActionButton.outlined(
              label: intl.retry,
              icon: Icons.refresh_rounded,
              tone: .danger,
              onPressedAsync: _loadPresenceConflicts,
            ),
          ),
        ],
        if (surplusConflictsErrorMessage != null) ...[
          Gaps.h12,
          AppEmptyState.error(
            title: intl.inventoryLoadingErrorTitle,
            message: surplusConflictsErrorMessage,
            compact: true,
            action: AppActionButton.outlined(
              label: intl.retry,
              icon: Icons.refresh_rounded,
              tone: .danger,
              onPressedAsync: _loadSurplusConflicts,
            ),
          ),
        ],
        if (status != null) ...[
          Gaps.h12,
          AppStatusBadge(
            label: _inventoryStatusLabel(context, status),
            tone: switch (status) {
              InwentaryzacjaStatus.nowa => AppStatusBadgeTone.info,
              InwentaryzacjaStatus.wToku => AppStatusBadgeTone.warning,
              InwentaryzacjaStatus.zakonczona => AppStatusBadgeTone.success,
              InwentaryzacjaStatus.nieznany => AppStatusBadgeTone.neutral,
            },
            icon: switch (status) {
              InwentaryzacjaStatus.nowa => Icons.fiber_new_rounded,
              InwentaryzacjaStatus.wToku => Icons.sync_rounded,
              InwentaryzacjaStatus.zakonczona => Icons.check_circle_rounded,
              InwentaryzacjaStatus.nieznany => Icons.help_outline_rounded,
            },
            showBorder: false,
          ),
        ],
        Gaps.h16,
        Row(
          children: [
            Expanded(
              child: AppText(
                intl.inventoryCommissionTitle,
                style: context.text.titleSmall?.copyWith(fontWeight: .w700),
              ),
            ),
            AppActionButton.outlined(
              label: intl.edit,
              icon: Icons.edit_outlined,
              tone: .neutral,
              onPressed: !canEditInventory
                  ? null
                  : () {
                      (() async {
                        final saved = await showEditCommissionModal(
                          context,
                          title: intl.inventoryEditCommissionTitle,
                          subtitle: intl.inventoryCommissionForInventory(
                            header.numer,
                          ),
                          targetId: widget.inventoryId,
                          targetType: EditCommissionTargetType.inventory,
                          initialSelected: _inventoryCommitteeInitialSelected(
                            context,
                            data.komisja,
                          ),
                          inventoriesRepository: widget.inventoriesRepository,
                          usersRepository: widget.usersRepository,
                        );
                        if (!context.mounted || saved != true) {
                          return;
                        }

                        await context.read<InventoryDetailCubit>().load(
                          widget.inventoryId,
                        );
                        widget.onDataChanged?.call();
                      })().ignore();
                    },
            ),
          ],
        ),
        Gaps.h8,
        if (data.komisja.isEmpty)
          AppEmptyState.noData(
            title: intl.inventoryNoAssignedCommissionTitle,
            message: intl.inventoryNoAssignedCommissionMessage,
            compact: true,
          )
        else
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: data.komisja
                .map<Widget>(
                  (member) => _InventoryDetailCommissionChip(
                    name: switch (member.displayName) {
                      final String displayName
                          when displayName.trim().isNotEmpty =>
                        displayName.trim(),
                      _ => intl.inventoryUserWithId(member.userId),
                    },
                  ),
                )
                .toList(),
          ),
        Gaps.h16,
        Row(
          children: [
            Expanded(
              child: AppText(
                intl.inventorySheetsLabel,
                style: context.text.titleSmall?.copyWith(fontWeight: .w700),
              ),
            ),
            Wrap(
              spacing: Sizes.p8,
              runSpacing: Sizes.p8,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppActionButton.filled(
                  label: intl.inventorySearchSheetsAction,
                  icon: Icons.manage_search_rounded,
                  onPressedAsync: () => _handleSearchAcrossSheets(data),
                ),
                AppActionButton.outlined(
                  label: presenceConflictsLabel,
                  icon: presenceConflictsIcon,
                  tone: presenceConflictsTone,
                  onPressedAsync: _handleOpenPresenceConflicts,
                ),
                AppActionButton.outlined(
                  label: surplusConflictsLabel,
                  icon: surplusConflictsIcon,
                  tone: surplusConflictsTone,
                  onPressedAsync: _handleOpenSurplusConflicts,
                ),
                AppActionButton.outlined(
                  label: context.l10n.inventoryTreeProgressTitle,
                  icon: Icons.account_tree_rounded,
                  onPressed: () {
                    (() async {
                      await showInventoryTreeProgressModal(
                        context,
                        inventoryId: widget.inventoryId,
                        inventoryNumber: data.inwentaryzacja.numer,
                        inventoryCompanies: data.inwentaryzacja.firmy,
                        inventoriesRepository: widget.inventoriesRepository,
                        locationsRepository: widget.locationsRepository,
                        stockRepository: widget.stockRepository,
                        usersRepository: widget.usersRepository,
                        canDeleteArkusz:
                            status != InwentaryzacjaStatus.zakonczona,
                        canEditArkusz:
                            status != InwentaryzacjaStatus.zakonczona,
                        onDataChanged: widget.onDataChanged,
                      );
                      if (!context.mounted) {
                        return;
                      }
                      await context.read<InventoryDetailCubit>().load(
                        widget.inventoryId,
                      );
                      await _loadPresenceConflicts();
                      await _loadSurplusConflicts();
                    })().ignore();
                  },
                ),
                SizedBox(
                  height: 28,
                  child: VerticalDivider(
                    width: 16,
                    thickness: 1,
                    color: context.colors.outlineVariant,
                  ),
                ),
                AppActionPill(
                  label: intl.inventoryRefresh,
                  icon: Icons.refresh_rounded,
                  tone: .contrast,
                  selected: true,
                  onPressed: () => context.read<InventoryDetailCubit>().load(
                    widget.inventoryId,
                  ),
                ),
              ],
            ),
          ],
        ),
        Gaps.h8,
        AppSearchTextField(
          controller: _arkuszeSearchController,
          hintText:
              '${intl.inventorySearchBy}: ${intl.inventorySheetDateSearchHint}',
          onRawChanged: (value) {
            setState(() {
              _arkuszeSearchQuery = value;
            });
          },
        ),
        Gaps.h8,
        if (data.arkusze.isEmpty)
          AppEmptyState.noData(
            title: intl.inventoryNoSheetsTitle,
            message: intl.inventoryNoSheetsMessage,
            compact: true,
          )
        else if (filteredArkusze.isEmpty)
          AppEmptyState.noData(
            title: intl.inventoryNoSearchResultsTitle,
            compact: true,
          )
        else
          AppSimpleTable<GetInwentaryzacjaDetailsArkuszItem>(
            height: _tableHeightFor(filteredArkusze.length),
            rows: filteredArkusze,
            stateId: 'inventory_detail_arkusze_table_v1_${widget.inventoryId}',
            persistState: true,
            minScrollableWidthRatio: 1,
            simpleExcelMode: true,
            rowHeight: 92,
            onRowTap: (_, arkusz, _) {
              (() async {
                await showArkuszDetailModal(
                  context,
                  arkuszId: arkusz.id,
                  arkuszNumber: _sheetNumber(context, arkusz),
                  inventoryCompanies: data.inwentaryzacja.firmy,
                  canDeleteArkusz: status != InwentaryzacjaStatus.zakonczona,
                  canEditArkusz: status != InwentaryzacjaStatus.zakonczona,
                  inventoriesRepository: widget.inventoriesRepository,
                  locationsRepository: widget.locationsRepository,
                  stockRepository: widget.stockRepository,
                  usersRepository: widget.usersRepository,
                  onDataChanged: widget.onDataChanged,
                );
                if (!context.mounted) {
                  return;
                }
                await context.read<InventoryDetailCubit>().load(
                  widget.inventoryId,
                );
                await _loadPresenceConflicts();
                await _loadSurplusConflicts();
              })().ignore();
            },
            columns: [
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.inventorySheetLabel,
                width: 180,
                sortValue: (arkusz) =>
                    _naturalSortKey(_firstColumnValue(arkusz)),
                cellBuilder: (_, arkusz) => AppText(
                  _sheetNumber(context, arkusz),
                  style: context.text.bodyMedium?.copyWith(fontWeight: .w700),
                ),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.inventoryLocation,
                width: 220,
                sortValue: (arkusz) => _normalizeString(arkusz.nazwaMiejsca),
                cellBuilder: (_, arkusz) =>
                    AppText(_locationLabel(context, arkusz)),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.inventoryItemsLabel,
                width: 110,
                numeric: true,
                sortValue: (arkusz) => arkusz.elementyCount,
                cellBuilder: (_, arkusz) => AppText('${arkusz.elementyCount}'),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.inventoryCommissionLabel,
                width: 130,
                numeric: true,
                sortValue: (arkusz) => arkusz.komisja.length,
                cellBuilder: (_, arkusz) => AppText('${arkusz.komisja.length}'),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.inventoryLocationLevelLabel,
                width: 150,
                sortValue: (arkusz) => _normalizeString(arkusz.lvlMiejsca),
                cellBuilder: (_, arkusz) =>
                    AppText(_locationLevelLabel(arkusz)),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.start,
                width: 150,
                sortValue: (arkusz) => _sortDateValue(arkusz.rozpoczecie),
                cellBuilder: (_, arkusz) =>
                    AppText(_dateLabel(arkusz.rozpoczecie)),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.end,
                width: 150,
                sortValue: (arkusz) => _sortDateValue(arkusz.zakonczenie),
                cellBuilder: (_, arkusz) =>
                    AppText(_dateLabel(arkusz.zakonczenie)),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.inventoryWarehouseLabel,
                width: 320,
                sortValue: (arkusz) => _committeeNames(arkusz).toLowerCase(),
                cellBuilder: (_, arkusz) => AppText(
                  _committeeSummary(context, arkusz),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSimpleTableColumn<GetInwentaryzacjaDetailsArkuszItem>(
                label: context.l10n.inventoryActionsLabel,
                width: 480,
                sortable: false,
                cellBuilder: (_, arkusz) => _InventoryDetailSheetActionsCell(
                  onPrint: () => showArkuszPdfExportFlow(
                    context,
                    arkuszId: arkusz.id,
                    arkuszNumber: _sheetNumber(context, arkusz),
                    inventoriesRepository: widget.inventoriesRepository,
                  ),
                  onEditDates: !canEditInventory
                      ? null
                      : () {
                          (() async {
                            final updated = await _showUpdateArkuszDatesModal(
                              context,
                              arkuszId: arkusz.id,
                              startDateTime: arkusz.rozpoczecie,
                              endDateTime: arkusz.zakonczenie,
                              repository: widget.inventoriesRepository,
                            );
                            if (!context.mounted || updated != true) {
                              return;
                            }
                            await context.read<InventoryDetailCubit>().load(
                              widget.inventoryId,
                            );
                            widget.onDataChanged?.call();
                          })().ignore();
                        },
                  onEditNumber: !canEditInventory
                      ? null
                      : () {
                          (() async {
                            final updated = await _showUpdateArkuszNumerModal(
                              context,
                              arkuszId: arkusz.id,
                              initialNumer: arkusz.numer,
                              repository: widget.inventoriesRepository,
                            );
                            if (!context.mounted || updated != true) {
                              return;
                            }
                            AppToast.show(
                              context,
                              message:
                                  context.l10n.inventorySheetNumberSavedMessage,
                              tone: AppToastTone.success,
                            );
                            await context.read<InventoryDetailCubit>().load(
                              widget.inventoryId,
                            );
                            widget.onDataChanged?.call();
                          })().ignore();
                        },
                  onEditCommission: !canEditInventory
                      ? null
                      : () {
                          (() async {
                            final saved = await showEditCommissionModal(
                              context,
                              title: context.l10n.inventoryEditCommissionTitle,
                              subtitle: context.l10n
                                  .inventoryCommissionForSheet(
                                    _sheetNumber(context, arkusz),
                                  ),
                              targetId: arkusz.id,
                              targetType: EditCommissionTargetType.arkusz,
                              initialSelected: _arkuszCommitteeInitialSelected(
                                context,
                                arkusz.komisja,
                              ),
                              inventoriesRepository:
                                  widget.inventoriesRepository,
                              usersRepository: widget.usersRepository,
                            );
                            if (!context.mounted || saved != true) {
                              return;
                            }
                            await context.read<InventoryDetailCubit>().load(
                              widget.inventoryId,
                            );
                            widget.onDataChanged?.call();
                          })().ignore();
                        },
                ),
              ),
            ],
          ),
      ],
    );
  }

  List<GetInwentaryzacjaDetailsArkuszItem> _filteredArkusze(
    List<GetInwentaryzacjaDetailsArkuszItem> arkusze,
  ) {
    final query = _normalizedSearchQuery;
    final queryCompact = _compactSearchValue(query);
    if (query.isEmpty) {
      return arkusze;
    }

    return arkusze
        .where((arkusz) {
          final number = (arkusz.numer ?? '').trim().toLowerCase();
          final location = (arkusz.nazwaMiejsca ?? '').trim().toLowerCase();
          final compactNumber = _compactSearchValue(number);
          final compactLocation = _compactSearchValue(location);

          return number.contains(query) ||
              location.contains(query) ||
              compactNumber.contains(queryCompact) ||
              compactLocation.contains(queryCompact);
        })
        .toList(growable: false);
  }

  Future<void> _handleSearchAcrossSheets(
    GetInwentaryzacjaDetailsResponseData data,
  ) async {
    final selection = await showInventorySheetSearchModal(
      context,
      inventoryId: widget.inventoryId,
      inventoryNumber: data.inwentaryzacja.numer,
      repository: widget.inventoriesRepository,
    );
    if (!mounted || selection == null) {
      return;
    }

    await showArkuszDetailModal(
      context,
      arkuszId: selection.arkuszId,
      arkuszNumber: selection.arkuszNumber,
      inventoryCompanies: data.inwentaryzacja.firmy,
      canDeleteArkusz:
          data.inwentaryzacja.inventoryStatus !=
          InwentaryzacjaStatus.zakonczona,
      canEditArkusz:
          data.inwentaryzacja.inventoryStatus !=
          InwentaryzacjaStatus.zakonczona,
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
    await context.read<InventoryDetailCubit>().load(widget.inventoryId);
  }

  String get _normalizedSearchQuery => _arkuszeSearchQuery.trim().toLowerCase();

  String _firstColumnValue(GetInwentaryzacjaDetailsArkuszItem arkusz) {
    final number = (arkusz.numer ?? '').trim();
    if (number.isNotEmpty) {
      return number.toLowerCase();
    }
    return arkusz.id.toString().padLeft(12, '0');
  }

  String _naturalSortKey(String value) {
    return RegExp(r'\d+|\D+')
        .allMatches(value)
        .map((match) => match.group(0)!)
        .map((part) {
          final number = int.tryParse(part);
          if (number == null) {
            return 't:${part.toLowerCase()}';
          }
          return 'n:${number.toString().padLeft(20, '0')}';
        })
        .join('|');
  }

  String _sheetNumber(
    BuildContext context,
    GetInwentaryzacjaDetailsArkuszItem arkusz,
  ) {
    return switch (arkusz.numer) {
      final String number when number.trim().isNotEmpty => number.trim(),
      _ => context.l10n.inventorySheetWithId(arkusz.id),
    };
  }

  String _normalizeString(String? value) => (value ?? '').trim().toLowerCase();

  String _locationLabel(
    BuildContext context,
    GetInwentaryzacjaDetailsArkuszItem arkusz,
  ) {
    return switch (arkusz.nazwaMiejsca) {
      final String place when place.trim().isNotEmpty => place.trim(),
      _ => context.l10n.inventoryNoAssignedLocation,
    };
  }

  String _locationLevelLabel(GetInwentaryzacjaDetailsArkuszItem arkusz) {
    return switch (arkusz.lvlMiejsca) {
      final String level when level.trim().isNotEmpty => level.trim(),
      _ => '-',
    };
  }

  int _sortDateValue(String? isoDateTime) {
    return DateTime.tryParse(
          (isoDateTime ?? '').trim(),
        )?.millisecondsSinceEpoch ??
        -1;
  }

  String _dateLabel(String? isoDateTime) {
    return switch (isoDateTime) {
      final String dateTime when dateTime.trim().isNotEmpty => _formatDateTime(
        dateTime,
      ),
      _ => '-',
    };
  }

  String _committeeNames(GetInwentaryzacjaDetailsArkuszItem arkusz) {
    return arkusz.komisja
        .map((member) => member.displayName.trim())
        .where((name) => name.isNotEmpty)
        .join(', ');
  }

  String _committeeSummary(
    BuildContext context,
    GetInwentaryzacjaDetailsArkuszItem arkusz,
  ) {
    final names = _committeeNames(arkusz);
    if (names.isEmpty) {
      return context.l10n.inventorySheetCommissionNone;
    }
    return context.l10n.inventorySheetCommissionWithMembers(names);
  }

  String _compactSearchValue(String value) {
    return value.replaceAll(RegExp('[^a-z0-9]'), '');
  }

  double _tableHeightFor(int rowsCount) {
    final rawHeight = 220 + (rowsCount * 92);
    return rawHeight.clamp(320, 760).toDouble();
  }

  String _formatDateTime(String isoDateTime) {
    final parsed = DateTime.tryParse(isoDateTime.trim());
    if (parsed == null) {
      return isoDateTime.toAppDate();
    }
    final formattedDate = parsed.toIso8601String().split('T').first.toAppDate();
    final hh = parsed.hour.toString().padLeft(2, '0');
    final mm = parsed.minute.toString().padLeft(2, '0');
    return '$formattedDate $hh:$mm';
  }

  Future<void> _showPresenceConflictsErrorModal(
    BuildContext context, {
    required String message,
  }) {
    return AppModalSheet.show<void>(
      context,
      title: context.l10n.inventoryPresenceConflictsTitle,
      subtitle: context.l10n.inventoryLoadingErrorTitle,
      size: AppModalSheetSize.small,
      body: AppEmptyState(
        title: context.l10n.inventoryLoadingErrorTitle,
        message: message,
        icon: Icons.error_outline_rounded,
        compact: true,
        maxWidth: 320,
        action: AppActionButton.outlined(
          label: context.l10n.retry,
          icon: Icons.refresh_rounded,
          tone: .danger,
          onPressed: () {
            Navigator.of(context).pop();
            _loadPresenceConflicts().ignore();
          },
        ),
      ),
    );
  }

  List<GetReadyUsersSearchItem> _inventoryCommitteeInitialSelected(
    BuildContext context,
    List<GetInwentaryzacjaDetailsKomisjaItem> members,
  ) {
    return members
        .map(
          (member) => GetReadyUsersSearchItem(
            usrId: member.userId,
            firnam: _normalizeMemberName(
              context,
              member.displayName,
              member.userId,
            ),
          ),
        )
        .toList(growable: false);
  }

  List<GetReadyUsersSearchItem> _arkuszCommitteeInitialSelected(
    BuildContext context,
    List<GetInwentaryzacjaDetailsArkuszKomisjaItem> members,
  ) {
    return members
        .map(
          (member) => GetReadyUsersSearchItem(
            usrId: member.userId,
            firnam: _normalizeMemberName(
              context,
              member.displayName,
              member.userId,
            ),
          ),
        )
        .toList(growable: false);
  }

  String _normalizeMemberName(
    BuildContext context,
    String displayName,
    int userId,
  ) {
    final normalized = displayName.trim();
    return normalized.isEmpty
        ? context.l10n.inventoryUserWithId(userId)
        : normalized;
  }

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
