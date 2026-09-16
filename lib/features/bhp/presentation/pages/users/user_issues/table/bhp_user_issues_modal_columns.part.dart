part of '../bhp_user_issues_modal.dart';

/// Buduje kolumny tabeli wydań pracownika.
extension _BhpUserIssuesModalColumns on _BhpUserIssuesModalBodyState {
  List<AppSimpleTableColumn<_BhpMissingStandardIssueRow>>
  _buildMissingStandardColumns(
    BuildContext context,
    BhpUserIssuesCubit cubit,
  ) {
    final intl = context.l10n;
    return [
      AppSimpleTableColumn(
        label: context.l10n.bhpUserIssuesRowNumber,
        width: 64,
        sortable: false,
        numeric: true,
        indexedCellBuilder: (context, row, sourceIndex, visibleIndex) =>
            Text('${visibleIndex + 1}'),
        cellBuilder: (context, row) => const SizedBox(),
      ),
      AppSimpleTableColumn(
        label: context.l10n.bhpTableSymbol,
        width: 120,
        sortValue: (row) =>
            row.standard.kartaWyposazeniaSymbol?.toLowerCase() ?? '',
        cellBuilder: (context, row) => Text(
          row.standard.kartaWyposazeniaSymbol ?? '—',
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.bhpTableEquipmentName,
        width: 320,
        sortValue: (row) =>
            row.standard.kartaWyposazeniaNazwa?.toLowerCase() ?? '',
        cellBuilder: (context, row) => Text(
          row.standard.kartaWyposazeniaNazwa ??
              context.l10n.bhpUserIssuesNoEquipmentName,
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.bhpTableQuantity,
        width: 90,
        sortValue: (row) =>
            double.tryParse(
              row.standard.ilosc ?? row.standard.kartaIloscDomyslna ?? '',
            ) ??
            0,
        cellBuilder: (context, row) => Text(
          _formatQuantity(
            row.standard.ilosc ?? row.standard.kartaIloscDomyslna ?? '1',
          ),
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.bhpTablePeriod,
        width: 110,
        sortValue: (row) => row.standard.okres ?? 0,
        cellBuilder: (context, row) => Text(
          row.standard.okres?.toString() ??
              row.standard.kartaOkresUzywalnosci ??
              '—',
        ),
      ),
      AppSimpleTableColumn(
        label: intl.bhpUserIssuesLastIssueLabel,
        width: 120,
        sortValue: (row) => row.latestIssue?.dataPrzydzialu ?? '',
        cellBuilder: (context, row) => Text(
          row.latestIssue?.dataPrzydzialu.toAppDate(placeholder: '—') ?? '—',
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.inventoryActionsLabel,
        width: 150,
        sortable: false,
        cellAlignment: .center,
        cellBuilder: (context, row) => _isReadOnly
            ? const Text('—')
            : AppActionButton.filled(
                label: intl.bhpUserIssuesIssueStandardConfirmAction,
                icon: Icons.assignment_turned_in_outlined,
                onPressed: () => _handleIssueFromStandard(
                  context,
                  cubit,
                  row.standard,
                ),
              ),
      ),
    ];
  }

  List<AppSimpleTableColumn<GetBhpUserIssue>> _buildIssueColumns(
    BuildContext context,
    BhpUserIssuesCubit cubit,
  ) {
    final intl = context.l10n;

    return [
      AppSimpleTableColumn(
        label: intl.bhpUserIssuesRowNumber,
        width: 64,
        sortable: false,
        numeric: true,
        indexedCellBuilder: (context, row, sourceIndex, visibleIndex) =>
            Text('${visibleIndex + 1}'),
        cellBuilder: (context, row) => const SizedBox(),
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableSymbol,
        width: 120,
        sortValue: (row) => row.kartaWyposazeniaSymbol?.toLowerCase() ?? '',
        cellBuilder: (context, row) {
          final label = row.kartaWyposazeniaSymbol ?? '—';
          if (row.kartaWyposazeniaId == null) {
            return Text(label, style: _getRowTextStyle(context, row));
          }

          return _BhpUserIssuesLinkCell(
            label: label,
            tooltip: intl.bhpUserIssuesTooltipEquipmentInfo,
            textStyle: _getRowInfoTextStyle(context, row),
            onTap: () => _handleShowIssueInfo(context, row),
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableEquipmentName,
        width: 350,
        sortValue: (row) => row.kartaWyposazeniaNazwa?.toLowerCase() ?? '',
        cellBuilder: (context, row) {
          final label =
              row.kartaWyposazeniaNazwa ?? intl.bhpUserIssuesNoEquipmentName;
          if (row.kartaWyposazeniaId == null) {
            return Text(label, style: _getRowTextStyle(context, row));
          }

          return _BhpUserIssuesLinkCell(
            label: label,
            tooltip: intl.bhpUserIssuesTooltipEquipmentInfo,
            textStyle: _getRowInfoTextStyle(context, row),
            onTap: () => _handleShowIssueInfo(context, row),
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableQuantity,
        width: 90,
        sortValue: (row) => double.tryParse(row.ilosc ?? '') ?? 0,
        cellBuilder: (context, row) {
          final label = _formatQuantity(row.ilosc ?? '0');
          if (_isReadOnly || !row.canEdit) {
            return Text(label, style: _getRowTextStyle(context, row));
          }

          return _BhpUserIssuesEditableCell(
            label: label,
            tooltip: intl.bhpUserIssuesTooltipEditQuantity,
            icon: Icons.edit_outlined,
            textStyle: _getRowTextStyle(context, row),
            iconColor: _getRowIconColor(context, row),
            onTap: () => _handleEditIssueQuantity(context, cubit, row),
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableIssueDate,
        width: 120,
        sortValue: (row) => row.dataPrzydzialu,
        cellBuilder: (context, row) {
          final label = row.dataPrzydzialu.toAppDate(placeholder: '—');
          if (_isReadOnly || !row.canEdit) {
            return Text(label, style: _getRowTextStyle(context, row));
          }

          return _BhpUserIssuesEditableCell(
            label: label,
            tooltip: intl.bhpUserIssuesTooltipEditIssueDate,
            icon: Icons.edit_calendar_outlined,
            textStyle: _getRowTextStyle(context, row),
            iconColor: _getRowIconColor(context, row),
            onTap: () => _handleEditIssueDate(context, cubit, row),
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableEndDate,
        width: 120,
        sortValue: (row) => row.dataZakonczenia ?? '',
        cellBuilder: (context, row) {
          final label = row.dataZakonczenia.toAppDate(placeholder: '—');
          if (_isReadOnly || !row.canEdit || row.dataZakonczenia == null) {
            return Text(label, style: _getRowTextStyle(context, row));
          }

          return _BhpUserIssuesEditableCell(
            label: label,
            tooltip: intl.bhpIssueEditEndDateTitle,
            icon: Icons.edit_calendar_outlined,
            textStyle: _getRowTextStyle(context, row),
            iconColor: _getRowIconColor(context, row),
            onTap: () => _handleEditIssueEndDate(context, cubit, row),
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableDueDate,
        width: 120,
        sortValue: (row) => row.dueDate ?? '',
        cellBackgroundColor: _getDueDateCellColor,
        cellBuilder: (context, row) {
          final dueLabel = row.dueDate.toAppDate(placeholder: '—');
          final deltaLabel = _buildDueDateDeltaLabel(row);

          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                dueLabel,
                style: _getDueDateTextStyle(context, row),
              ),
              if (deltaLabel case final value?)
                Text(
                  value,
                  style: _getDueDateDeltaTextStyle(context, row),
                ),
            ],
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableEquivalentAmount,
        width: 130,
        sortValue: (row) => double.tryParse(row.kwotaEkwiwalent ?? '') ?? 0,
        cellBuilder: (context, row) {
          final amountString = row.kwotaEkwiwalent;
          if (amountString == null) {
            if (_isReadOnly || !row.canRegisterEquivalent) {
              return Text('—', style: _getRowTextStyle(context, row));
            }

            return _BhpUserIssuesEditableCell(
              label: intl.bhpUserIssuesAddEquivalent,
              tooltip: intl.bhpUserIssuesTooltipAddEquivalent,
              icon: Icons.add_rounded,
              textStyle: _getRowTextStyle(context, row),
              iconColor: _getRowIconColor(context, row),
              onTap: () => _handleRegisterEquivalent(context, cubit, row),
            );
          }

          final amount = double.tryParse(amountString) ?? 0;
          final formattedAmount = amount == amount.toInt()
              ? amount.toInt().toString()
              : amount.toStringAsFixed(2);

          if (_isReadOnly || !row.canRegisterEquivalent) {
            return Text(
              '$formattedAmount zł',
              style: _getRowTextStyle(context, row),
            );
          }

          return _BhpUserIssuesEditableCell(
            label: '$formattedAmount zł',
            tooltip: intl.bhpUserIssuesTooltipEditEquivalent,
            icon: row.hasEquivalent ? Icons.edit_rounded : Icons.add_rounded,
            textStyle: _getRowTextStyle(context, row),
            iconColor: _getRowIconColor(context, row),
            onTap: () => _handleRegisterEquivalent(context, cubit, row),
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableEquivalentDate,
        width: 150,
        sortValue: (row) => row.dataEkwiwalent ?? '',
        cellBuilder: (context, row) {
          final label = row.dataEkwiwalent.toAppDate(placeholder: '—');
          if (row.dataEkwiwalent == null) {
            return Text(label, style: _getRowTextStyle(context, row));
          }

          if (_isReadOnly || !row.canRegisterEquivalent) {
            return Text(label, style: _getRowTextStyle(context, row));
          }

          return _BhpUserIssuesEditableCell(
            label: label,
            tooltip: intl.bhpUserIssuesTooltipEditEquivalentDate,
            icon: Icons.edit_calendar_outlined,
            textStyle: _getRowTextStyle(context, row),
            iconColor: _getRowIconColor(context, row),
            onTap: () => _handleRegisterEquivalent(context, cubit, row),
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableNotes,
        width: 200,
        sortValue: (row) => row.uwagi?.toLowerCase() ?? '',
        cellBuilder: (context, row) {
          final hasNotes = row.uwagi?.trim().isNotEmpty ?? false;
          final label = hasNotes
              ? row.uwagi!.trim()
              : intl.bhpUserIssuesAddNote;

          if (_isReadOnly || !row.canEdit) {
            return Text(
              label,
              style: _getRowTextStyle(context, row),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            );
          }

          return _BhpUserIssuesEditableCell(
            label: label,
            tooltip: hasNotes
                ? row.uwagi!.trim()
                : intl.bhpUserIssuesTooltipAddNote,
            icon: hasNotes ? Icons.edit_outlined : Icons.add_rounded,
            textStyle: _getRowTextStyle(context, row),
            iconColor: _getRowIconColor(context, row),
            onTap: () => _handleEditIssueNotes(context, cubit, row),
            alignTop: true,
          );
        },
      ),
      AppSimpleTableColumn(
        label: intl.bhpTableStatus,
        width: 100,
        sortable: false,
        cellBuilder: (context, row) => Tooltip(
          message: row.isActive
              ? intl.bhpUserIssuesActiveStatusTooltip
              : intl.bhpUserIssuesInactiveStatusTooltip,
          child: AppStatusBadge(
            label: row.isActive ? intl.bhpStatusActive : intl.bhpStatusInactive,
            tone: row.isActive
                ? AppStatusBadgeTone.success
                : AppStatusBadgeTone.neutral,
            icon: row.isActive
                ? Icons.check_circle_outline_rounded
                : Icons.remove_circle_outline_rounded,
          ),
        ),
      ),
      AppSimpleTableColumn(
        label: intl.inventoryActionsLabel,
        width: 150,
        sortable: false,
        cellAlignment: .center,
        cellBuilder: (context, row) {
          if (_isReadOnly) {
            return Text('—', style: _getRowTextStyle(context, row));
          }

          final actions = _buildIssueActions(context, cubit, row);
          if (actions.isEmpty) {
            return Text('—', style: _getRowTextStyle(context, row));
          }

          return AppContextMenuButton(
            label: intl.inventoryActionsLabel,
            icon: Icons.more_horiz_rounded,
            dense: true,
            actions: actions,
          );
        },
      ),
    ];
  }

  List<AppSimpleTableColumn<GetBhpUserIssue>> _buildActiveIssueColumns(
    BuildContext context,
    BhpUserIssuesCubit cubit,
  ) {
    final activeItems = switch (cubit.state) {
      BhpUserIssuesSuccess(:final detail) => detail.wydaniaAktywne,
      _ => const <GetBhpUserIssue>[],
    };
    final selectedIssueIds = _resolveSelectedBulkRenewIssues(
      activeItems,
    ).map((issue) => issue.id).toSet();
    final selectionColumn = AppSimpleTableColumn<GetBhpUserIssue>(
      label: '',
      width: 56,
      sortable: false,
      cellAlignment: .center,
      cellBuilder: (context, row) => Checkbox(
        value: selectedIssueIds.contains(row.id),
        onChanged: _isReadOnly
            ? null
            : (value) => _toggleBulkRenewIssueSelection(
                row,
                value ?? false,
                activeItems,
              ),
      ),
    );

    return [selectionColumn, ..._buildIssueColumns(context, cubit)];
  }

  List<AppSimpleTableColumn<GetBhpUserOperation>> _buildOperationColumns(
    BuildContext context,
  ) {
    return [
      AppSimpleTableColumn(
        label: 'Data',
        width: 130,
        sortValue: (row) => row.occurredAt ?? '',
        cellBuilder: (context, row) =>
            Text(row.occurredAt.toAppDate(placeholder: '—')),
      ),
      AppSimpleTableColumn(
        label: 'Operacja',
        width: 160,
        sortValue: (row) => row.typeLabel.toLowerCase(),
        cellBuilder: (context, row) => AppStatusBadge(
          label: row.typeLabel,
          tone: switch (row.type) {
            'issued' => AppStatusBadgeTone.success,
            'closed' => AppStatusBadgeTone.warning,
            'equivalent_registered' => AppStatusBadgeTone.info,
            _ => AppStatusBadgeTone.neutral,
          },
          icon: switch (row.type) {
            'issued' => Icons.call_received_rounded,
            'closed' => Icons.call_made_rounded,
            'equivalent_registered' => Icons.payments_outlined,
            _ => Icons.change_circle_outlined,
          },
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.bhpTableSymbol,
        width: 120,
        sortValue: (row) => row.kartaWyposazeniaSymbol?.toLowerCase() ?? '',
        cellBuilder: (context, row) => Text(row.kartaWyposazeniaSymbol ?? '—'),
      ),
      AppSimpleTableColumn(
        label: context.l10n.bhpTableEquipmentName,
        width: 320,
        sortValue: (row) => row.kartaWyposazeniaNazwa?.toLowerCase() ?? '',
        cellBuilder: (context, row) => Text(
          row.equipmentLabel,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppSimpleTableColumn(
        label: context.l10n.bhpTableQuantity,
        width: 90,
        sortValue: (row) => double.tryParse(row.quantity ?? '') ?? 0,
        cellAlignment: .center,
        cellBuilder: (context, row) => Text(row.quantity ?? '—'),
      ),
      AppSimpleTableColumn(
        label: 'Szczegóły',
        width: 420,
        sortValue: (row) => row.details.toLowerCase(),
        cellBuilder: (context, row) => Text(
          row.details,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
  }
}
