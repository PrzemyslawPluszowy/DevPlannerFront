part of 'framework_components_gallery_page.dart';

extension _IconsSection on _FrameworkComponentsGalleryPageState {
  Widget _buildIconsSection() {
    return const _GallerySection(
      title: 'Icons',
      subtitle:
          'Lekki wrapper na ikony z trzema rozmiarami, tonami i opcjonalnym tlem.',
      codeSnippet: '''
AppIcon(
  Icons.inventory_2_outlined,
  size: AppControlSize.small,
  tone: AppIconTone.primary,
  tooltip: 'Magazyn',
);
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppIcon(
                Icons.inventory_2_outlined,
                tooltip: 'Small normal',
              ),
              AppIcon(
                Icons.search_rounded,
                tone: AppIconTone.muted,
                tooltip: 'Medium muted',
              ),
              AppIcon(
                Icons.auto_awesome_rounded,
                size: AppControlSize.large,
                tone: AppIconTone.primary,
                tooltip: 'Large primary',
              ),
            ],
          ),
          Gaps.h16,
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppIcon(
                Icons.check_circle_rounded,
                tone: AppIconTone.success,
                decorated: true,
                tooltip: 'Success',
              ),
              AppIcon(
                Icons.warning_amber_rounded,
                tone: AppIconTone.warning,
                decorated: true,
                tooltip: 'Warning',
              ),
              AppIcon(
                Icons.error_outline_rounded,
                tone: AppIconTone.danger,
                decorated: true,
                tooltip: 'Danger',
              ),
              AppIcon(
                Icons.local_shipping_outlined,
                tone: AppIconTone.primary,
                decorated: true,
                tooltip: 'Primary decorated',
              ),
            ],
          ),
          Gaps.h16,
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppIcon(
                Icons.play_arrow_rounded,
                tone: AppIconTone.contrast,
                decorated: true,
                showBorder: false,
                tooltip: 'Contrast solid',
              ),
              AppIcon(
                Icons.flash_on_rounded,
                tone: AppIconTone.primarySolid,
                decorated: true,
                showBorder: false,
                tooltip: 'Primary solid',
              ),
              AppIcon(
                Icons.whatshot_rounded,
                tone: AppIconTone.warning,
                decorated: true,
                showBorder: false,
                tooltip: 'Warning solid',
              ),
              AppIcon(
                Icons.bolt_rounded,
                tone: AppIconTone.danger,
                decorated: true,
                showBorder: false,
                tooltip: 'Danger solid',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
