part of 'framework_components_gallery_page.dart';

extension _ContextMenuSection on _FrameworkComponentsGalleryPageState {
  Widget _buildContextMenuSection() {
    return _GallerySection(
      title: 'Context Menu Button',
      subtitle: 'Menu akcji pod lewy i prawy klik.',
      codeSnippet: '''
AppContextMenuButton(
  label: 'Wiecej',
  icon: Icons.more_horiz_rounded,
  actions: [
    AppContextMenuAction(label: 'Odswiez', onTap: (_) {}),
  ],
)
''',
      child: Row(
        children: [
          AppContextMenuButton(
            label: 'Więcej',
            icon: Icons.more_horiz_rounded,
            actions: [
              AppContextMenuAction(
                label: 'Odśwież',
                icon: Icons.refresh_rounded,
                onTap: (_) => _showHint('Odśwież'),
              ),
              AppContextMenuAction(
                label: 'Duplikuj',
                icon: Icons.copy_all_rounded,
                onTap: (_) => _showHint('Duplikuj'),
              ),
              AppContextMenuAction(
                label: 'Usuń',
                icon: Icons.delete_outline_rounded,
                isDestructive: true,
                onTap: (_) => _showHint('Usuń'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
