part of 'framework_components_gallery_page.dart';

extension _EmptyStateSection on _FrameworkComponentsGalleryPageState {
  Widget _buildEmptyStateSection() {
    return _GallerySection(
      title: 'Empty State',
      subtitle: 'Puste widoki dla list, wyszukiwania i bledow sekcji.',
      codeSnippet: '''
AppEmptyState.noData(
  title: 'Brak dokumentow',
  message: 'Dodaj pierwszy dokument, aby zaczac prace.',
  action: AppActionButton.filled(
    label: 'Dodaj',
    icon: Icons.add_rounded,
    onPressed: () {},
  ),
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppEmptyState.noData(
            title: 'Brak dokumentow',
            message: 'Dodaj pierwszy dokument, aby zaczac prace z modulem.',
            action: AppActionButton.filled(
              label: 'Dodaj dokument',
              icon: Icons.add_rounded,
              onPressed: () => _showHint('Dodaj dokument'),
            ),
          ),
          Gaps.h16,
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: AppEmptyState.noResults(
                  compact: true,
                  action: AppActionButton.text(
                    label: 'Wyczysc filtry',
                    icon: Icons.filter_alt_off_rounded,
                    onPressed: () => _showHint('Wyczysc filtry'),
                  ),
                ),
              ),
              Gaps.w16,
              Expanded(
                child: AppEmptyState.error(
                  compact: true,
                  action: AppActionButton.outlined(
                    label: 'Ponow',
                    icon: Icons.refresh_rounded,
                    onPressed: () => _showHint('Ponow'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
