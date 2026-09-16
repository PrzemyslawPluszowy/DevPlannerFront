part of 'framework_components_gallery_page.dart';

extension _SimpleTableSection on _FrameworkComponentsGalleryPageState {
  Widget _buildSimpleTableSection(List<_GalleryInventoryRow> tableRows) {
    return _GallerySection(
      title: 'Simple Table',
      subtitle:
          'Lekka tabela: sort, search, resize kolumn, row tap, scroll i custom komorki.',
      codeSnippet: '''
AppSimpleTable<RowModel>(
  rows: rows,
  showSearch: true,
  onRowTap: (context, row, index) {},
  columns: [
    AppSimpleTableColumn<RowModel>(
      label: 'Nazwa',
      width: 260,
      sortable: true,
      sortValue: (row) => row.name,
      cellBuilder: (context, row) => Text(row.name),
    ),
  ],
)
''',
      child: AppSimpleTable<_GalleryInventoryRow>(
        stateId: 'framework_gallery_simple_table',
        persistState: true,
        rows: tableRows,
        title: 'Inwentaryzacje',
        subtitle: 'Przyklad tabeli do mniejszych i srednich list.',
        showSearch: true,
        searchHintText: 'Szukaj po nazwie/statusie/wlascicielu...',
        searchMatcher: (row, query) {
          return row.name.toLowerCase().contains(query) ||
              row.status.toLowerCase().contains(query) ||
              row.owner.toLowerCase().contains(query) ||
              '${row.count}'.contains(query);
        },
        onRowTap: (context, row, sourceIndex) {
          _showHint('Row #${sourceIndex + 1}: ${row.name}');
        },
        columns: [
          AppSimpleTableColumn<_GalleryInventoryRow>(
            label: 'Nazwa',
            width: 260,
            minResizeWidth: 180,
            maxResizeWidth: 460,
            sortValue: (row) => row.name,
            cellBuilder: (context, row) => Text(
              row.name,
              style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
            ),
          ),
          AppSimpleTableColumn<_GalleryInventoryRow>(
            label: 'Status',
            width: 160,
            minResizeWidth: 130,
            maxResizeWidth: 260,
            sortValue: (row) => row.status,
            cellBackgroundColor: (context, row) {
              final colors = context.colors;
              return switch (row.status) {
                'W toku' => colors.tertiaryContainer.withValues(alpha: .35),
                'Zamknięta' => colors.primaryContainer.withValues(alpha: .35),
                _ => null,
              };
            },
            cellBuilder: (context, row) => Text(row.status),
          ),
          AppSimpleTableColumn<_GalleryInventoryRow>(
            label: 'Pozycje',
            width: 120,
            minResizeWidth: 100,
            maxResizeWidth: 180,
            numeric: true,
            sortValue: (row) => row.count,
            cellBuilder: (context, row) => Text(
              '${row.count}',
              style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
            ),
          ),
          AppSimpleTableColumn<_GalleryInventoryRow>(
            label: 'Właściciel',
            width: 180,
            minResizeWidth: 140,
            maxResizeWidth: 300,
            sortValue: (row) => row.owner,
            cellBuilder: (context, row) => Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: Sizes.p16,
                  color: context.colors.onSurfaceVariant,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    row.owner,
                    overflow: .ellipsis,
                    style: context.text.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
