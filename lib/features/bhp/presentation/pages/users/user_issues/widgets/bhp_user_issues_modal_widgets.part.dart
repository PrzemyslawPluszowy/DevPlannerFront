part of '../bhp_user_issues_modal.dart';

/// Buduje lokalne widgety i sekcje modala wydań pracownika.
extension _BhpUserIssuesModalWidgets on _BhpUserIssuesModalBodyState {
  bool get _isReadOnly => _isArchivedUser(_currentUser);

  List<Widget> _buildModuleActions(
    BuildContext context,
    BhpUserIssuesState state,
    BhpUserIssuesCubit cubit,
  ) {
    final selectedIssues = switch (state) {
      BhpUserIssuesSuccess(:final detail) => _resolveSelectedBulkRenewIssues(
        detail.wydaniaAktywne,
      ),
      _ => const <GetBhpUserIssue>[],
    };

    return [
      if (!_isReadOnly) ...[
        AppActionButton.filled(
          label: context.l10n.bhpUserIssuesActionAdd,
          icon: Icons.add_circle_outline_rounded,
          onPressed: () => _handleAddIssue(context, cubit),
        ),
        AppActionPill(
          label: selectedIssues.isEmpty
              ? context.l10n.bhpUserIssuesBulkRepeatAction
              : context.l10n.bhpUserIssuesBulkRepeatSelectedCount(
                  selectedIssues.length,
                ),
          icon: Icons.assignment_return_rounded,
          tone: selectedIssues.isEmpty ? .surface : .primary,
          onPressed: selectedIssues.isEmpty
              ? null
              : () => _handleBulkRepeatIssues(context, cubit, selectedIssues),
        ),
        AppActionPill(
          label: context.l10n.bhpPositionStandardTitle,
          icon: Icons.badge_outlined,
          onPressed: () => _handleShowPositionModal(context, cubit),
        ),
      ],
      if (state case BhpUserIssuesSuccess(:final detail)) ...[
        AppActionPill(
          label: context.l10n.bhpUserIssuesPrint,
          icon: Icons.print_rounded,
          onPressed: () => _handlePrintCard(context, detail, _currentUser),
        ),
      ],
      AppActionPill(
        label: context.l10n.bhpRefreshAction,
        icon: Icons.refresh_rounded,
        tone: .contrast,
        selected: true,
        onPressed: cubit.load,
      ),
    ];
  }

  Widget _buildUserSummary(BuildContext context) {
    return Padding(
      padding: const .only(bottom: Sizes.p12),
      child: _BhpUserIssuesSummary(
        employeeLabel: context.l10n.bhpUserIssuesEmployeeLabel,
        employeeName: _currentUser.fullName,
        employeeTooltip: context.l10n.bhpUserIssuesEditEmployeeTooltip,
        employeeIcon: Icons.edit_outlined,
        onEmployeeTap: _isReadOnly
            ? null
            : () =>
                  _handleEditUser(context, context.read<BhpUserIssuesCubit>()),
        positionLabel: context.l10n.bhpUserIssuesPositionLabel,
        positionName: _userPositionName ?? context.l10n.bhpUserIssuesNoPosition,
        positionTooltip: context.l10n.bhpUserIssuesOpenPositionDetails,
        onPositionTap: _isReadOnly
            ? null
            : () => _handleShowPositionModal(context),
      ),
    );
  }

  Widget _buildStateContent(
    BuildContext context, {
    required BhpUserIssuesState state,
    required BhpUserIssuesCubit cubit,
  }) {
    final intl = context.l10n;

    return switch (state) {
      BhpUserIssuesInitial() || BhpUserIssuesLoading() => const SizedBox(
        height: 300,
        child: Center(child: AppSpinner()),
      ),
      BhpUserIssuesError(:final message) => AppEmptyState.error(
        title: intl.bhpUserIssuesErrorTitle,
        message: message,
      ),
      BhpUserIssuesSuccess(:final detail) => _buildSectionsContent(
        context,
        cubit: cubit,
        detail: detail,
      ),
    };
  }

  Widget _buildSectionsContent(
    BuildContext context, {
    required BhpUserIssuesCubit cubit,
    required GetBhpUserDetail detail,
  }) {
    final activeIssueCardIds = detail.wydaniaAktywne
        .map((issue) => issue.kartaWyposazeniaId)
        .whereType<int>()
        .toSet();
    final missingStandardItems = detail.standardWyposazenia
        .where((standard) => standard.aktywny)
        .where((standard) => standard.kartaAktywna)
        .where((standard) {
          final cardId = standard.kartaWyposazeniaId;
          return cardId != null && !activeIssueCardIds.contains(cardId);
        })
        .map(
          (standard) => _BhpMissingStandardIssueRow(
            standard: standard,
            latestIssue: _findLatestIssueForStandard(detail, standard),
          ),
        )
        .toList(growable: false);
    final activeItems = detail.wydaniaAktywne;
    final selectedView =
        _selectedView == BhpUserIssuesView.standard &&
            missingStandardItems.isEmpty
        ? BhpUserIssuesView.aktywne
        : _selectedView;
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (!_isReadOnly)
          Padding(
            padding: const .only(bottom: Sizes.p12),
            child: _BhpUserIssuesComplianceBanner(
              missingCount: missingStandardItems.length,
              activeCount: activeItems.length,
              canReceiveIssues: detail.canReceiveIssues,
            ),
          ),
        _buildViewSelector(
          context,
          selectedView: selectedView,
          hasStandardItems: missingStandardItems.isNotEmpty,
        ),
        Gaps.h12,
        Expanded(
          child: _buildSelectedTable(
            context,
            cubit: cubit,
            activeItems: activeItems,
            missingStandardItems: missingStandardItems,
            detail: detail,
            selectedView: selectedView,
          ),
        ),
      ],
    );
  }

  Widget _buildViewSelector(
    BuildContext context, {
    required BhpUserIssuesView selectedView,
    required bool hasStandardItems,
  }) {
    final intl = context.l10n;
    final chips = <Widget>[
      AppActionChip(
        label: intl.bhpUserIssuesViewActive,
        icon: Icons.inventory_2_outlined,
        selected: selectedView == BhpUserIssuesView.aktywne,
        tone: .primary,
        onPressed: () => _setSelectedView(BhpUserIssuesView.aktywne),
      ),
    ];

    if (hasStandardItems) {
      chips.add(
        AppActionChip(
          label: intl.bhpUserIssuesViewStandard,
          icon: Icons.rule_folder_outlined,
          selected: selectedView == BhpUserIssuesView.standard,
          tone: .primary,
          onPressed: () => _setSelectedView(BhpUserIssuesView.standard),
        ),
      );
    }

    chips.addAll([
      AppActionChip(
        label: intl.bhpUserIssuesViewHistory,
        icon: Icons.history_rounded,
        selected: selectedView == BhpUserIssuesView.historia,
        tone: .primary,
        onPressed: () => _setSelectedView(BhpUserIssuesView.historia),
      ),
      AppActionChip(
        label: 'Operacje',
        icon: Icons.event_note_rounded,
        selected: selectedView == BhpUserIssuesView.operacje,
        tone: .primary,
        onPressed: () => _setSelectedView(BhpUserIssuesView.operacje),
      ),
    ]);

    return Wrap(
      spacing: Sizes.p8,
      runSpacing: Sizes.p8,
      children: chips,
    );
  }

  Widget _buildSelectedTable(
    BuildContext context, {
    required BhpUserIssuesCubit cubit,
    required List<GetBhpUserIssue> activeItems,
    required List<_BhpMissingStandardIssueRow> missingStandardItems,
    required GetBhpUserDetail detail,
    required BhpUserIssuesView selectedView,
  }) {
    return switch (selectedView) {
      BhpUserIssuesView.standard =>
        _BhpUserIssuesSectionCard<_BhpMissingStandardIssueRow>(
          stateId: 'bhp_user_issues_missing_standard_table',
          title: context.l10n.bhpUserIssuesStandardTitle,
          subtitle: context.l10n.bhpUserIssuesStandardSubtitle,
          items: missingStandardItems,
          emptyTitle: context.l10n.bhpUserIssuesStandardEmptyTitle,
          emptyMessage: context.l10n.bhpUserIssuesStandardEmptyMessage,
          searchHintText: context.l10n.bhpUserIssuesStandardSearchHint,
          columns: _buildMissingStandardColumns(context, cubit),
          searchMatcher: (row, query) {
            final phrase = query.toLowerCase();
            return row.label(context).toLowerCase().contains(phrase);
          },
          rowHeight: 52,
        ),
      BhpUserIssuesView.historia => _BhpUserIssuesSectionCard<GetBhpUserIssue>(
        stateId: 'bhp_user_issues_history_table',
        title: context.l10n.bhpUserIssuesHistoryTitle,
        subtitle: context.l10n.bhpUserIssuesHistorySubtitle,
        items: detail.historiaWydan
            .where((issue) => !issue.isActive)
            .toList(growable: false),
        emptyTitle: context.l10n.bhpUserIssuesHistoryEmptyTitle,
        emptyMessage: context.l10n.bhpUserIssuesHistoryEmptyMessage,
        searchHintText: context.l10n.bhpUserIssuesSearchHint,
        columns: _buildIssueColumns(context, cubit),
        searchMatcher: _matchIssueSearch,
        showSearch: true,
        rowHeight: 52,
        onRowSecondaryTap: _isReadOnly
            ? null
            : (row, details) => _showIssueActionsMenu(
                context,
                row: row,
                actions: _buildIssueActions(context, cubit, row),
                fromPointer: details.globalPosition,
              ),
      ),
      BhpUserIssuesView.operacje =>
        _BhpUserIssuesSectionCard<GetBhpUserOperation>(
          stateId: 'bhp_user_issues_operations_table',
          title: 'Historia operacji',
          subtitle:
              'Wydania, zwroty i ekwiwalenty w kolejności chronologicznej.',
          items: detail.operacje,
          emptyTitle: 'Brak operacji',
          emptyMessage:
              'W tym widoku pojawią się wydania, zwroty i ekwiwalenty.',
          searchHintText: 'Szukaj operacji, sprzętu lub opisu...',
          columns: _buildOperationColumns(context),
          searchMatcher: _matchOperationSearch,
          showSearch: true,
          rowHeight: 52,
        ),
      BhpUserIssuesView.aktywne => _BhpUserIssuesSectionCard<GetBhpUserIssue>(
        stateId: 'bhp_user_issues_active_table',
        title: context.l10n.bhpUserIssuesActiveTitle,
        subtitle: context.l10n.bhpUserIssuesActiveSubtitle,
        items: activeItems,
        emptyTitle: context.l10n.bhpUserIssuesActiveEmptyTitle,
        emptyMessage: context.l10n.bhpUserIssuesActiveEmptyMessage,
        searchHintText: context.l10n.bhpUserIssuesSearchHint,
        columns: _buildActiveIssueColumns(context, cubit),
        searchMatcher: _matchIssueSearch,
        showSearch: true,
        rowHeight: 48,
        onRowSecondaryTap: _isReadOnly
            ? null
            : (row, details) => _showIssueActionsMenu(
                context,
                row: row,
                actions: _buildIssueActions(context, cubit, row),
                fromPointer: details.globalPosition,
              ),
      ),
    };
  }

  bool _matchIssueSearch(GetBhpUserIssue row, String query) {
    final phrase = query.toLowerCase();
    final symbol = row.kartaWyposazeniaSymbol?.toLowerCase() ?? '';
    final name = row.kartaWyposazeniaNazwa?.toLowerCase() ?? '';
    return symbol.contains(phrase) || name.contains(phrase);
  }

  bool _matchOperationSearch(GetBhpUserOperation row, String query) {
    final phrase = query.toLowerCase();
    return row.typeLabel.toLowerCase().contains(phrase) ||
        row.details.toLowerCase().contains(phrase) ||
        row.kartaWyposazeniaSymbol?.toLowerCase().contains(phrase) == true ||
        row.kartaWyposazeniaNazwa?.toLowerCase().contains(phrase) == true;
  }

  GetBhpUserIssue? _findLatestIssueForStandard(
    GetBhpUserDetail detail,
    GetBhpUserStandardItem standard,
  ) {
    final cardId = standard.kartaWyposazeniaId;
    if (cardId == null) {
      return null;
    }

    for (final issue in detail.historiaWydan) {
      if (issue.kartaWyposazeniaId == cardId) {
        return issue;
      }
    }

    return null;
  }
}

bool _isArchivedUser(GetBhpUserListItem user) =>
    user.isArchived || !user.aktywny;

/// Nagłówek podsumowania pracownika w karcie wydań.
class _BhpUserIssuesSummary extends StatelessWidget {
  /// Tworzy nagłówek podsumowania.
  const _BhpUserIssuesSummary({
    required this.employeeLabel,
    required this.employeeName,
    required this.employeeTooltip,
    required this.employeeIcon,
    required this.positionLabel,
    required this.positionName,
    required this.positionTooltip,
    this.onEmployeeTap,
    this.onPositionTap,
  });

  /// Etykieta pola pracownika.
  final String employeeLabel;

  /// Nazwa pracownika.
  final String employeeName;

  /// Tooltip akcji edycji pracownika.
  final String employeeTooltip;

  /// Ikona akcji edycji pracownika.
  final IconData employeeIcon;

  /// Akcja otwarcia edycji pracownika.
  final VoidCallback? onEmployeeTap;

  /// Etykieta pola stanowiska.
  final String positionLabel;

  /// Nazwa stanowiska.
  final String positionName;

  /// Tooltip akcji stanowiska.
  final String positionTooltip;

  /// Akcja otwarcia szczegółów stanowiska.
  final VoidCallback? onPositionTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Sizes.p12,
      runSpacing: Sizes.p12,
      children: [
        _BhpUserIssuesInfoChip(
          label: employeeLabel,
          value: employeeName,
          tooltip: employeeTooltip,
          icon: employeeIcon,
          onTap: onEmployeeTap,
        ),
        _BhpUserIssuesInfoChip(
          label: positionLabel,
          value: positionName,
          tooltip: positionTooltip,
          onTap: onPositionTap,
        ),
      ],
    );
  }
}

/// Sekcja tabelaryczna używana w karcie wydań pracownika.
class _BhpUserIssuesSectionCard<T> extends StatelessWidget {
  /// Tworzy sekcję listy.
  const _BhpUserIssuesSectionCard({
    required this.stateId,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.searchHintText,
    required this.columns,
    required this.searchMatcher,
    this.showSearch = false,
    this.rowHeight = 72,
    this.tableHeight,
    this.onRowSecondaryTap,
  });

  /// Stabilny identyfikator stanu tabeli.
  final String stateId;

  /// Tytuł sekcji.
  final String title;

  /// Opis sekcji.
  final String subtitle;

  /// Lista wydań do pokazania.
  final List<T> items;

  /// Tytuł pustego stanu.
  final String emptyTitle;

  /// Komunikat pustego stanu.
  final String emptyMessage;

  /// Hint wyszukiwarki.
  final String searchHintText;

  /// Konfiguracja kolumn tabeli.
  final List<AppSimpleTableColumn<T>> columns;

  /// Matcher wyszukiwarki.
  final bool Function(T row, String query) searchMatcher;

  /// Czy pokazywać wyszukiwarkę sekcji.
  final bool showSearch;

  /// Wysokość wiersza tabeli.
  final double rowHeight;

  /// Opcjonalna wysokość tabeli.
  final double? tableHeight;

  /// Callback prawego kliknięcia na wierszu.
  final void Function(T row, TapDownDetails details)? onRowSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final table = DefaultTextStyle(
      style:
          context.text.bodyMedium?.copyWith(fontSize: 13) ?? const TextStyle(),
      child: AppSimpleTable<T>(
        rows: items,
        rowHeight: rowHeight,
        headerHeight: 40,
        height: tableHeight,
        stateId: stateId,
        persistState: true,
        scrollbarAlwaysVisible: true,
        simpleExcelMode: true,
        onRowSecondaryTap: onRowSecondaryTap == null
            ? null
            : (context, row, _, details) => onRowSecondaryTap!(row, details),
        showSearch: showSearch,
        searchHintText: searchHintText,
        searchMatcher: searchMatcher,
        columns: columns,
      ),
    );

    return AppSectionCard(
      expandChild: tableHeight == null,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: context.text.titleSmall?.copyWith(fontWeight: .w700),
          ),
          Gaps.h4,
          Text(
            subtitle,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Gaps.h12,
          if (items.isEmpty)
            AppEmptyState.noData(
              title: emptyTitle,
              message: emptyMessage,
            )
          else if (tableHeight == null)
            Expanded(child: table)
          else
            table,
        ],
      ),
    );
  }
}

/// Banner zgodności wydań z aktualnym standardem stanowiska.
class _BhpUserIssuesComplianceBanner extends StatelessWidget {
  /// Tworzy banner zgodności.
  const _BhpUserIssuesComplianceBanner({
    required this.missingCount,
    required this.activeCount,
    required this.canReceiveIssues,
  });

  final int missingCount;
  final int activeCount;
  final bool canReceiveIssues;

  @override
  Widget build(BuildContext context) {
    if (!canReceiveIssues) {
      return AppBanner(
        tone: .warning,
        title: context.l10n.bhpUserIssuesBlockedBannerTitle,
        message: context.l10n.bhpUserIssuesBlockedBannerMessage,
      );
    }

    if (missingCount == 0) {
      return AppBanner(
        tone: .success,
        title: context.l10n.bhpUserIssuesCompliantBannerTitle,
        message: context.l10n.bhpUserIssuesCompliantBannerMessage(activeCount),
      );
    }

    return AppBanner(
      tone: .warning,
      title: context.l10n.bhpUserIssuesMissingBannerTitle,
      message: context.l10n.bhpUserIssuesMissingBannerMessage(missingCount),
    );
  }
}

/// Wiersz sekcji braków standardu.
class _BhpMissingStandardIssueRow {
  /// Tworzy wiersz brakującej pozycji standardu.
  const _BhpMissingStandardIssueRow({
    required this.standard,
    required this.latestIssue,
  });

  final GetBhpUserStandardItem standard;
  final GetBhpUserIssue? latestIssue;

  String label(BuildContext context) {
    final symbol = standard.kartaWyposazeniaSymbol?.trim();
    final name = standard.kartaWyposazeniaNazwa?.trim();

    if ((symbol ?? '').isNotEmpty && (name ?? '').isNotEmpty) {
      return '$symbol - $name';
    }

    return symbol?.isNotEmpty == true
        ? symbol!
        : (name ?? context.l10n.bhpUserIssuesNoNameFallback);
  }
}

/// Chip informacji o pracowniku lub stanowisku w widoku wydań.
class _BhpUserIssuesInfoChip extends StatelessWidget {
  /// Tworzy chip informacji nagłówkowej.
  const _BhpUserIssuesInfoChip({
    required this.value,
    this.label,
    this.tooltip,
    this.icon,
    this.onTap,
  });

  /// Etykieta prezentowanej informacji.
  final String? label;

  /// Wartość prezentowanej informacji.
  final String value;

  /// Opcjonalny tooltip dla akcji.
  final String? tooltip;

  /// Opcjonalna ikona dla chipa akcji.
  final IconData? icon;

  /// Opcjonalna akcja kliknięcia.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p8),
      child: Row(
        mainAxisSize: .min,
        children: [
          if (icon case final iconValue?) ...[
            Icon(
              iconValue,
              size: 16,
              color: context.colors.primary,
            ),
            Gaps.w8,
          ],
          if (label case final labelValue?) ...[
            Text(
              '$labelValue ',
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          Text(
            value,
            style: context.text.bodyMedium?.copyWith(
              fontWeight: .bold,
              color: context.colors.onSurface,
            ),
          ),
          if (onTap != null) ...[
            Gaps.w8,
            Icon(
              Icons.open_in_new_rounded,
              size: 16,
              color: context.colors.primary,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return chip;
    }

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
          child: chip,
        ),
      ),
    );
  }
}

/// Klikalna komórka tabeli dla pól edytowalnych.
class _BhpUserIssuesEditableCell extends StatelessWidget {
  /// Tworzy komórkę edytowalną.
  const _BhpUserIssuesEditableCell({
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.textStyle,
    this.iconColor,
    this.alignTop = false,
  });

  /// Widoczny tekst komórki.
  final String label;

  /// Treść podpowiedzi.
  final String tooltip;

  /// Ikona akcji.
  final IconData icon;

  /// Akcja kliknięcia.
  final VoidCallback onTap;

  /// Opcjonalny styl tekstu.
  final TextStyle? textStyle;

  /// Opcjonalny kolor ikony.
  final Color? iconColor;

  /// Czy wyrównać zawartość do góry.
  final bool alignTop;

  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ??
        context.text.bodyMedium?.copyWith(
          color: context.colors.onSurface,
          fontSize: 12,
        );
    final resolvedIconColor = iconColor ?? context.colors.primary;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        child: Padding(
          padding: const .symmetric(horizontal: Sizes.p4, vertical: Sizes.p2),
          child: Row(
            mainAxisSize: .min,
            crossAxisAlignment: alignTop ? .start : .center,
            children: [
              Flexible(
                child: Text(
                  label,
                  softWrap: true,
                  style: style,
                ),
              ),
              Gaps.w4,
              Icon(
                icon,
                size: 14,
                color: resolvedIconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Klikalna komórka tabeli prowadząca do szczegółów wyposażenia.
class _BhpUserIssuesLinkCell extends StatelessWidget {
  /// Tworzy komórkę linkującą do szczegółów wyposażenia.
  const _BhpUserIssuesLinkCell({
    required this.label,
    required this.tooltip,
    required this.onTap,
    this.textStyle,
  });

  /// Widoczny tekst komórki.
  final String label;

  /// Treść podpowiedzi.
  final String tooltip;

  /// Akcja kliknięcia.
  final VoidCallback onTap;

  /// Opcjonalny styl tekstu.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ??
        context.text.bodyMedium?.copyWith(
          color: context.colors.primary,
          fontSize: 12,
          fontWeight: .w600,
          decoration: TextDecoration.underline,
          decorationColor: context.colors.primary.withValues(alpha: .72),
        );

    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const .symmetric(horizontal: Sizes.p4, vertical: Sizes.p2),
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
