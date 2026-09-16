part of 'framework_components_gallery_page.dart';

extension _ActionButtonsSection on _FrameworkComponentsGalleryPageState {
  Widget _buildActionButtonsSection() {
    return _GallerySection(
      title: 'Action Buttons',
      subtitle: 'Warianty text/outlined/filled i tony kolorystyczne.',
      codeSnippet: '''
AppActionButton.filled(
  label: 'Zapisz',
  icon: Icons.save_outlined,
  onPressed: () {},
);
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppActionButton.text(
                label: 'Text',
                icon: Icons.tune_rounded,
                onPressed: () => _showHint('Text'),
              ),
              AppActionButton.outlined(
                label: 'Outlined',
                icon: Icons.download_rounded,
                onPressed: () => _showHint('Outlined'),
              ),
              AppActionButton.filled(
                label: 'Filled',
                icon: Icons.add_rounded,
                onPressed: () => _showHint('Filled'),
              ),
              AppActionButton.filled(
                label: 'Async',
                icon: Icons.sync_rounded,
                onPressedAsync: () async {
                  _showHint('Async start');
                  await Future<void>.delayed(const Duration(seconds: 1));
                  if (!mounted) {
                    return;
                  }
                  _showHint('Async done');
                },
              ),
              AppActionButton.outlined(
                label: 'Danger',
                icon: Icons.delete_outline_rounded,
                tone: .danger,
                onPressed: () => _showHint('Danger'),
              ),
            ],
          ),
          Gaps.h12,
          Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              AppActionBadge(
                label: 'Refresh',
                icon: Icons.refresh_rounded,
                tone: AppActionBadgeTone.info,
                onPressed: () => _showHint('Badge refresh'),
              ),
              AppActionBadge(
                label: 'Sync',
                icon: Icons.sync_rounded,
                tone: AppActionBadgeTone.primary,
                onPressedAsync: () async {
                  _showHint('Badge async start');
                  await Future<void>.delayed(const Duration(seconds: 1));
                  if (!mounted) {
                    return;
                  }
                  _showHint('Badge async done');
                },
              ),
              AppActionBadge(
                label: 'Gotowe',
                icon: Icons.check_rounded,
                tone: AppActionBadgeTone.success,
                onPressed: () => _showHint('Badge success'),
              ),
              AppActionBadge(
                label: 'Uwaga',
                icon: Icons.priority_high_rounded,
                tone: AppActionBadgeTone.warning,
                onPressed: () => _showHint('Badge warning'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
