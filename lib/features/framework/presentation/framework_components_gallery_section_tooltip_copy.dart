part of 'framework_components_gallery_page.dart';

extension _TooltipCopySection on _FrameworkComponentsGalleryPageState {
  Widget _buildTooltipCopySection() {
    return _GallerySection(
      title: 'Tooltip + Copy Field',
      subtitle: 'Spojny tooltip hover i pole z szybkim kopiowaniem wartosci.',
      codeSnippet: '''
AppTooltip(
  message: 'Odswiez dane',
  child: Icon(Icons.refresh_rounded),
);

AppCopyField(
  label: 'API key',
  value: 'rn_live_8f7a12c4',
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppTooltip(
                message: 'Odśwież dane',
                child: Container(
                  width: Sizes.p36,
                  height: Sizes.p36,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLow,
                    borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
                  ),
                  alignment: .center,
                  child: const AppIcon(
                    Icons.refresh_rounded,
                    tone: AppIconTone.primary,
                  ),
                ),
              ),
              AppTooltip(
                message: 'Eksport CSV',
                child: Container(
                  width: Sizes.p36,
                  height: Sizes.p36,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLow,
                    borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
                  ),
                  alignment: .center,
                  child: const AppIcon(
                    Icons.download_rounded,
                    tone: AppIconTone.muted,
                  ),
                ),
              ),
            ],
          ),
          Gaps.h16,
          const AppCopyField(
            label: 'API key',
            value: 'rn_live_8f7a12c4f51c90f2',
          ),
          Gaps.h12,
          const AppCopyField(
            label: 'URL webhooka',
            value: 'https://api.readynext.local/hooks/inventory-sync',
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
