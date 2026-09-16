part of 'framework_components_gallery_page.dart';

extension _FooterNoteSection on _FrameworkComponentsGalleryPageState {
  Widget _buildFooterNoteSection() {
    return Container(
      padding: const .all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Text(
        'Ta strona jest miejscem na kolejne wspolne komponenty (table, dialog, alerts, filter bar).',
        style: context.text.bodyMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
