part of 'framework_components_gallery_page.dart';

extension _ActionPillsSection on _FrameworkComponentsGalleryPageState {
  Widget _buildActionPillsSection() {
    return _GallerySection(
      title: 'Action Pills',
      subtitle:
          'Mocniejsze, bardziej kontrastowe akcje shared do toolbarow i widokow modulowych.',
      codeSnippet: '''
AppActionPill(
  label: 'Subskrybuj',
  icon: Icons.notifications_none_rounded,
  tone: AppActionPillTone.contrast,
  selected: true,
  onPressed: () {},
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppActionPill(
                label: 'Subskrybuj',
                icon: Icons.notifications_none_rounded,
                tone: AppActionPillTone.contrast,
                selected: true,
                onPressed: () => _showHint('Subskrybuj'),
              ),
              AppActionPill(
                label: 'Udostępnij',
                icon: Icons.reply_rounded,
                onPressed: () => _showHint('Udostępnij'),
              ),
              AppActionPill(
                label: 'Zapisz',
                icon: Icons.bookmark_border_rounded,
                tone: AppActionPillTone.primary,
                onPressed: () => _showHint('Zapisz'),
              ),
              AppActionPill(
                label: 'Usuń',
                icon: Icons.delete_outline_rounded,
                tone: AppActionPillTone.danger,
                onPressed: () => _showHint('Usuń'),
              ),
            ],
          ),
          Gaps.h16,
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppActionPill(
                label: 'Wszystkie',
                tone: AppActionPillTone.contrast,
                selected: true,
                trailingIcon: Icons.expand_more_rounded,
                onPressed: () => _showHint('Wszystkie'),
              ),
              AppActionPill(
                label: 'Komentarze',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () => _showHint('Komentarze'),
              ),
              AppActionPill(
                label: 'Materiały',
                icon: Icons.layers_outlined,
                tone: AppActionPillTone.primary,
                selected: true,
                onPressed: () => _showHint('Materiały'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
