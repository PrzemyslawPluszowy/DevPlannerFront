part of 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_detail_modal.dart';

/// Tabelowy wiersz arkusza z breakpointami.
class _InventoryDetailSheetRow extends StatefulWidget {
  /// Tworzy wiersz arkusza.
  const _InventoryDetailSheetRow({
    required this.arkusz,
    required this.arkuszNumber,
    required this.useWideLayout,
    required this.isOdd,
    required this.formatDateTime,
    required this.committeeSummary,
    required this.onTap,
    required this.onPrint,
    required this.onEditDates,
    required this.onEditNumber,
    required this.onEditCommission,
  });

  final GetInwentaryzacjaDetailsArkuszItem arkusz;
  final String arkuszNumber;
  final bool useWideLayout;
  final bool isOdd;
  final String Function(String isoDateTime) formatDateTime;
  final String committeeSummary;
  final VoidCallback onTap;
  final Future<void> Function() onPrint;
  final VoidCallback? onEditDates;
  final VoidCallback? onEditNumber;
  final VoidCallback? onEditCommission;

  @override
  State<_InventoryDetailSheetRow> createState() =>
      _InventoryDetailSheetRowState();
}

/// Stan hover dla tabelowego wiersza arkusza.
class _InventoryDetailSheetRowState extends State<_InventoryDetailSheetRow> {
  var _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return widget.useWideLayout
        ? _buildWideRow(context)
        : _buildCompactRow(context);
  }

  Widget _buildWideRow(BuildContext context) {
    final surfaceRoles = context.surfaceRoles;
    final background = _isHovered
        ? Color.alphaBlend(
            surfaceRoles.hoverOverlay,
            widget.isOdd
                ? context.colors.surfaceContainerHighest.withValues(alpha: .24)
                : context.colors.surfaceContainerLowest,
          )
        : widget.isOdd
        ? context.colors.surfaceContainerHighest.withValues(alpha: .24)
        : context.colors.surfaceContainerLowest;

    return InkWell(
      onTap: widget.onTap,
      onHover: (isHovered) {
        if (_isHovered == isHovered) {
          return;
        }
        setState(() => _isHovered = isHovered);
      },
      borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
          border: Border.all(
            color: _isHovered
                ? surfaceRoles.baseBorder
                : context.colors.outlineVariant.withValues(alpha: .5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 12,
              child: _InventoryDetailSheetPrimaryCell(
                title: widget.arkuszNumber,
                subtitle: '${context.l10n.id} ${widget.arkusz.id}',
              ),
            ),
            Expanded(
              flex: 15,
              child: _InventoryDetailSheetValueCell(_locationLabel(context)),
            ),
            Expanded(
              flex: 4,
              child: _InventoryDetailSheetValueCell(
                '${widget.arkusz.elementyCount}',
              ),
            ),
            Expanded(
              flex: 5,
              child: _InventoryDetailSheetValueCell(
                '${widget.arkusz.komisja.length}',
              ),
            ),
            Expanded(
              flex: 7,
              child: _InventoryDetailSheetValueCell(_locationLevelLabel()),
            ),
            Expanded(
              flex: 9,
              child: _InventoryDetailSheetValueCell(
                _dateLabel(widget.arkusz.rozpoczecie),
              ),
            ),
            Expanded(
              flex: 9,
              child: _InventoryDetailSheetValueCell(
                _dateLabel(widget.arkusz.zakonczenie),
              ),
            ),
            Expanded(
              flex: 12,
              child: _InventoryDetailSheetValueCell(
                widget.committeeSummary,
                maxLines: 2,
              ),
            ),
            Expanded(
              flex: 21,
              child: _InventoryDetailSheetActionsCell(
                onPrint: widget.onPrint,
                onEditDates: widget.onEditDates,
                onEditNumber: widget.onEditNumber,
                onEditCommission: widget.onEditCommission,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: Sizes.p20,
              color: context.colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactRow(BuildContext context) {
    return AppCompactListTile(
      title: widget.arkuszNumber,
      subtitle: _locationLabel(context),
      leading: const AppIcon(Icons.description_outlined),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: Sizes.p18,
        color: context.colors.onSurfaceVariant,
      ),
      onTap: widget.onTap,
      meta: Wrap(
        spacing: Sizes.p8,
        runSpacing: Sizes.p8,
        children: [
          _InventoryDetailMetaChip(
            label: context.l10n.inventoryItemsLabel,
            value: '${widget.arkusz.elementyCount}',
          ),
          _InventoryDetailMetaChip(
            label: context.l10n.inventoryCommissionLabel,
            value: '${widget.arkusz.komisja.length}',
          ),
          _InventoryDetailMetaChip(
            label: context.l10n.inventoryLocationLevelLabel,
            value: _locationLevelLabel(),
          ),
          _InventoryDetailMetaChip(
            label: context.l10n.start,
            value: _dateLabel(widget.arkusz.rozpoczecie),
          ),
          _InventoryDetailMetaChip(
            label: context.l10n.end,
            value: _dateLabel(widget.arkusz.zakonczenie),
          ),
        ],
      ),
      footer: _InventoryDetailSheetActionsWrap(
        committeeSummary: widget.committeeSummary,
        onPrint: widget.onPrint,
        onEditDates: widget.onEditDates,
        onEditNumber: widget.onEditNumber,
        onEditCommission: widget.onEditCommission,
      ),
    );
  }

  String _locationLabel(BuildContext context) =>
      switch (widget.arkusz.nazwaMiejsca) {
        final String place when place.trim().isNotEmpty => place.trim(),
        _ => context.l10n.inventoryNoAssignedLocation,
      };

  String _locationLevelLabel() => switch (widget.arkusz.lvlMiejsca) {
    final String level when level.trim().isNotEmpty => level.trim(),
    _ => '-',
  };

  String _dateLabel(String? value) => switch (value) {
    final String dateTime when dateTime.trim().isNotEmpty =>
      widget.formatDateTime(dateTime),
    _ => '-',
  };
}

/// Glowna komorka wiersza arkusza.
class _InventoryDetailSheetPrimaryCell extends StatelessWidget {
  /// Tworzy glowna komorke arkusza.
  const _InventoryDetailSheetPrimaryCell({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        AppText(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodyMedium?.copyWith(fontWeight: .w700),
        ),
        AppText(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Komorka wartosci tabeli arkuszy.
class _InventoryDetailSheetValueCell extends StatelessWidget {
  /// Tworzy komorke wartosci.
  const _InventoryDetailSheetValueCell(this.value, {this.maxLines = 1});

  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return AppText(
      value,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: context.text.bodySmall?.copyWith(fontWeight: .w600),
    );
  }
}

/// Komorka akcji szerokiego wiersza arkusza.
class _InventoryDetailSheetActionsCell extends StatelessWidget {
  /// Tworzy komorke akcji.
  const _InventoryDetailSheetActionsCell({
    required this.onPrint,
    required this.onEditDates,
    required this.onEditNumber,
    required this.onEditCommission,
  });

  final Future<void> Function() onPrint;
  final VoidCallback? onEditDates;
  final VoidCallback? onEditNumber;
  final VoidCallback? onEditCommission;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        AppActionButton.outlined(
          label: context.l10n.inventoryPrint,
          icon: Icons.print_rounded,
          tone: .neutral,
          onPressedAsync: onPrint,
        ),
        AppActionButton.outlined(
          label: context.l10n.inventoryDates,
          icon: Icons.event_outlined,
          tone: .neutral,
          onPressed: onEditDates,
        ),
        AppActionButton.outlined(
          label: context.l10n.inventoryEditSheetNumberAction,
          icon: Icons.tag_rounded,
          tone: .neutral,
          onPressed: onEditNumber,
        ),
        AppActionButton.outlined(
          label: context.l10n.inventoryCommissionLabel,
          icon: Icons.group_outlined,
          tone: .neutral,
          onPressed: onEditCommission,
        ),
      ],
    );
  }
}

/// Stopka kompaktowego wiersza arkusza.
class _InventoryDetailSheetActionsWrap extends StatelessWidget {
  /// Tworzy dolny blok akcji kompaktowego wiersza.
  const _InventoryDetailSheetActionsWrap({
    required this.committeeSummary,
    required this.onPrint,
    required this.onEditDates,
    required this.onEditNumber,
    required this.onEditCommission,
  });

  final String committeeSummary;
  final Future<void> Function() onPrint;
  final VoidCallback? onEditDates;
  final VoidCallback? onEditNumber;
  final VoidCallback? onEditCommission;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: AppText(
            committeeSummary,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        Gaps.w12,
        Wrap(
          spacing: Sizes.p8,
          runSpacing: Sizes.p8,
          alignment: WrapAlignment.end,
          children: [
            AppActionButton.outlined(
              label: context.l10n.inventoryPrint,
              icon: Icons.print_rounded,
              tone: .neutral,
              onPressedAsync: onPrint,
            ),
            AppActionButton.outlined(
              label: context.l10n.inventoryDates,
              icon: Icons.event_outlined,
              tone: .neutral,
              onPressed: onEditDates,
            ),
            AppActionButton.outlined(
              label: context.l10n.inventoryEditSheetNumberAction,
              icon: Icons.tag_rounded,
              tone: .neutral,
              onPressed: onEditNumber,
            ),
            AppActionButton.outlined(
              label: context.l10n.inventoryCommissionLabel,
              icon: Icons.group_outlined,
              tone: .neutral,
              onPressed: onEditCommission,
            ),
          ],
        ),
      ],
    );
  }
}
