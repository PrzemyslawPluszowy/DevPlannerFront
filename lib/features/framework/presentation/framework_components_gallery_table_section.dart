part of 'framework_components_gallery_page.dart';

class _GalleryDataTableSection extends StatelessWidget {
  const _GalleryDataTableSection({
    required this.rows,
    required this.showTableLoading,
    required this.tableErrorText,
    required this.onCellTap,
    required this.onOpenStressTest,
    required this.onToggleLoading,
    required this.onToggleError,
    required this.onShowTable,
    required this.onRetry,
  });

  final List<_GalleryInventoryRow> rows;
  final bool showTableLoading;
  final String? tableErrorText;
  final ValueChanged<String> onCellTap;
  final VoidCallback onOpenStressTest;
  final VoidCallback onToggleLoading;
  final VoidCallback onToggleError;
  final VoidCallback onShowTable;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final columns = _buildColumns(context);

    return _GallerySection(
      title: context.l10n.frameworkDataTableTitle,
      subtitle: context.l10n.frameworkDataTableSubtitle,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              AppActionButton.outlined(
                label: showTableLoading
                    ? context.l10n.frameworkHideLoading
                    : context.l10n.frameworkToggleLoading,
                icon: Icons.hourglass_top_rounded,
                tone: .neutral,
                onPressed: onToggleLoading,
              ),
              AppActionButton.outlined(
                label: tableErrorText == null
                    ? context.l10n.frameworkShowError
                    : context.l10n.frameworkHideError,
                icon: Icons.error_outline_rounded,
                tone: .danger,
                onPressed: onToggleError,
              ),
              AppActionButton.text(
                label: context.l10n.frameworkShowTable,
                icon: Icons.table_rows_outlined,
                tone: .neutral,
                onPressed: onShowTable,
              ),
              AppActionButton.filled(
                label: context.l10n.frameworkStressTest,
                icon: Icons.open_in_full_rounded,
                tone: .neutral,
                onPressed: onOpenStressTest,
              ),
            ],
          ),
          Gaps.h12,
          _TableContainer(
            child: showTableLoading
                ? _GalleryStateBox(
                    icon: Icons.sync_rounded,
                    title: context.l10n.frameworkLoadingText,
                    message: context.l10n.frameworkLoadingMessage,
                    loading: true,
                  )
                : tableErrorText == null
                ? SizedBox(
                    height: 360,
                    child: SearchableTableView<_GalleryInventoryRow>(
                      columns: columns,
                      rows: rows,
                      rowHeight: 46,
                      searchMatcher: (row, query) {
                        return row.name.toLowerCase().contains(query) ||
                            row.status.toLowerCase().contains(query) ||
                            row.owner.toLowerCase().contains(query) ||
                            '${row.count}'.contains(query);
                      },
                      onRowHoverChanged: (row, hovered) {
                        if (hovered) {
                          onCellTap('Hover: ${row.name}');
                        }
                      },
                      onRowTap: (context, row, sourceIndex) {
                        onCellTap(
                          'Kliknięto wiersz #${sourceIndex + 1}: ${row.name} | ${row.status} | ${row.count} | ${row.owner}',
                        );
                      },
                      headerBackgroundColor: context.colors.surfaceContainerLow,
                    ),
                  )
                : _GalleryStateBox(
                    icon: Icons.error_outline_rounded,
                    title: context.l10n.frameworkErrorTitle,
                    message: tableErrorText!,
                    actionLabel: 'Spróbuj ponownie',
                    onAction: onRetry,
                  ),
          ),
        ],
      ),
    );
  }

  List<SearchableTableColumn<_GalleryInventoryRow>> _buildColumns(
    BuildContext context,
  ) {
    final intl = context.l10n;
    return [
      SearchableTableColumn<_GalleryInventoryRow>(
        label: intl.frameworkTableName,
        width: 240,
        minResizeWidth: 160,
        maxResizeWidth: 420,
        cellBuilder: _nameCell,
      ),
      SearchableTableColumn<_GalleryInventoryRow>(
        label: intl.frameworkTableStatus,
        width: 170,
        minResizeWidth: 130,
        maxResizeWidth: 280,
        cellBuilder: _statusCell,
      ),
      SearchableTableColumn<_GalleryInventoryRow>(
        label: intl.frameworkTableItems,
        width: 130,
        minResizeWidth: 100,
        maxResizeWidth: 220,
        numeric: true,
        cellBuilder: _countCell,
      ),
      SearchableTableColumn<_GalleryInventoryRow>(
        label: intl.frameworkTableOwner,
        width: 170,
        minResizeWidth: 130,
        maxResizeWidth: 320,
        cellBuilder: _ownerCell,
      ),
    ];
  }
}

class _GalleryInventoryRow {
  const _GalleryInventoryRow({
    required this.name,
    required this.status,
    required this.count,
    required this.owner,
  });

  final String name;
  final String status;
  final int count;
  final String owner;
}

Widget _nameCell(BuildContext context, _GalleryInventoryRow row) {
  return Text(
    row.name,
    style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
  );
}

Widget _statusCell(BuildContext context, _GalleryInventoryRow row) {
  final colors = context.colors;
  final (background, foreground) = switch (row.status) {
    'W toku' => (colors.tertiaryContainer, colors.onTertiaryContainer),
    'Zamknięta' => (colors.primaryContainer, colors.onPrimaryContainer),
    _ => (colors.surfaceContainerHigh, colors.onSurfaceVariant),
  };

  return Container(
    padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
    ),
    child: Text(
      row.status,
      style: context.text.labelSmall?.copyWith(
        color: foreground,
        fontWeight: .w700,
      ),
    ),
  );
}

Widget _countCell(BuildContext context, _GalleryInventoryRow row) {
  return Align(
    alignment: .centerRight,
    child: Text(
      '${row.count}',
      style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
    ),
  );
}

Widget _ownerCell(BuildContext context, _GalleryInventoryRow row) {
  return Text(
    row.owner,
    style: context.text.bodyMedium,
  );
}

class _TableContainer extends StatelessWidget {
  const _TableContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      clipBehavior: .antiAlias,
      child: child,
    );
  }
}

class _GalleryStateBox extends StatelessWidget {
  const _GalleryStateBox({
    required this.icon,
    required this.title,
    required this.message,
    this.loading = false,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool loading;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Padding(
          padding: const .all(Sizes.p20),
          child: Column(
            mainAxisSize: .min,
            children: [
              if (loading)
                const SizedBox.square(
                  dimension: Sizes.p24,
                  child: AppSpinner(strokeWidth: 2),
                )
              else
                Icon(icon, color: context.colors.onSurfaceVariant, size: 22),
              Gaps.h12,
              Text(
                title,
                style: context.text.titleSmall?.copyWith(fontWeight: .w700),
                textAlign: TextAlign.center,
              ),
              Gaps.h4,
              Text(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                Gaps.h12,
                TextButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
