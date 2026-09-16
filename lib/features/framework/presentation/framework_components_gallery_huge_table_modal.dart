part of 'framework_components_gallery_page.dart';

class _HugeTableStressModal extends StatefulWidget {
  const _HugeTableStressModal();

  @override
  State<_HugeTableStressModal> createState() => _HugeTableStressModalState();
}

class _HugeTableStressModalState extends State<_HugeTableStressModal> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      unawaited(BrowserContextMenu.disableContextMenu());
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      unawaited(BrowserContextMenu.enableContextMenu());
    }
    super.dispose();
  }

  static const _columnsCount = 100;
  static const _rowsCount = 4000;

  List<SearchableTableColumn<int>> _buildColumns() {
    return [
      for (var i = 0; i < _columnsCount; i++)
        SearchableTableColumn<int>(
          label: 'Kolumna ${i + 1}',
          width: i == 0 ? 220 : 170,
          minResizeWidth: 120,
          maxResizeWidth: 420,
          numeric: i % 4 == 0 || i % 4 == 1,
          cellBuilder: (context, row) =>
              _buildCellValue(context: context, row: row, column: i),
        ),
    ];
  }

  Widget _buildCellValue({
    required BuildContext context,
    required int row,
    required int column,
  }) {
    final value = switch (column % 4) {
      0 => '#${row + 1}',
      1 => ((row + 1) * (column + 1) * .17).toStringAsFixed(2),
      2 => _formatDate(DateTime(2024).add(Duration(days: row + column))),
      _ => 'R${row + 1} / C${column + 1}',
    };

    return Text(
      value,
      maxLines: 1,
      overflow: .ellipsis,
      style: context.text.bodyMedium,
    );
  }

  String _formatDate(DateTime date) {
    final day = '${date.day}'.padLeft(2, '0');
    final month = '${date.month}'.padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final columns = _buildColumns();
    final rows = List<int>.generate(_rowsCount, (index) => index);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Test Table'),
        actions: [
          Padding(
            padding: const .symmetric(horizontal: Sizes.p12),
            child: Center(
              child: Text(
                '100 kolumn • 4000 wierszy',
                style: context.text.labelLarge?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          AppActionButton.text(
            label: 'Zamknij',
            icon: Icons.close_rounded,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Gaps.w12,
        ],
      ),
      body: Padding(
        padding: const .all(Sizes.p16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SearchableTableView<int>(
              columns: columns,
              rows: rows,
              searchHintText: 'Szukaj po numerze, dacie lub tekście...',
              searchFieldMaxWidth: 360,
              searchMatcher: (row, query) {
                final text = 'R${row + 1}'.toLowerCase();
                final textWithSlash = 'R${row + 1} /'.toLowerCase();
                final amount = ((row + 1) * .17).toStringAsFixed(2);
                final date = _formatDate(
                  DateTime(2024).add(Duration(days: row)),
                ).toLowerCase();
                return text.contains(query) ||
                    textWithSlash.contains(query) ||
                    amount.contains(query) ||
                    date.contains(query) ||
                    '$row'.contains(query);
              },
              onRowTap: (context, row, sourceIndex) {
                // Celowo bez snackbara - callback jest dostępny pod logikę domenową.
              },
              onRowRightTap: (context, row, sourceIndex, globalPosition) async {
                await showMenu<String>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    globalPosition.dx,
                    globalPosition.dy,
                    globalPosition.dx,
                    globalPosition.dy,
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'details',
                      child: Text('Szczegóły row(T): $row'),
                    ),
                    const PopupMenuItem(
                      value: 'copy',
                      child: Text('Kopiuj identyfikator'),
                    ),
                  ],
                );
              },
              headerBackgroundColor: context.colors.surfaceContainerLow,
              minScrollableWidth: constraints.maxWidth * .5,
            );
          },
        ),
      ),
    );
  }
}
