part of 'framework_components_gallery_page.dart';

extension _FeedbackSection on _FrameworkComponentsGalleryPageState {
  Widget _buildFeedbackSection() {
    return _GallerySection(
      title: 'Toast + Banner',
      subtitle: 'Globalny toast oraz inline banner dla statusow operacji.',
      codeSnippet: '''
AppBubbleToast.show(
  context,
  message: 'Zapisano zmiany',
  tone: AppBubbleToastTone.success,
);

AppToast.show(
  context,
  message: 'Zapisano zmiany',
  tone: AppToastTone.success,
);

AppBanner(
  tone: AppBannerTone.warning,
  title: 'Weryfikacja',
  message: 'Brakuje wymaganych danych.',
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              AppActionButton.text(
                label: 'Dymek info',
                icon: Icons.info_outline_rounded,
                tone: .neutral,
                onPressed: () => AppBubbleToast.show(
                  context,
                  message: 'To jest lekki dymek info.',
                ),
              ),
              AppActionButton.text(
                label: 'Dymek success',
                icon: Icons.check_circle_outline_rounded,
                tone: .neutral,
                onPressed: () => AppBubbleToast.show(
                  context,
                  message: 'Zapisano poprawnie.',
                  tone: AppBubbleToastTone.success,
                ),
              ),
              AppActionButton.text(
                label: 'Dymek warning',
                icon: Icons.warning_amber_rounded,
                tone: .neutral,
                onPressed: () => AppBubbleToast.show(
                  context,
                  message: 'Sprawdz dane formularza.',
                  tone: AppBubbleToastTone.warning,
                ),
              ),
              AppActionButton.text(
                label: 'Dymek error',
                icon: Icons.error_outline_rounded,
                tone: .danger,
                onPressed: () => AppBubbleToast.show(
                  context,
                  message: 'Nie udalo sie zapisac zmian.',
                  tone: AppBubbleToastTone.error,
                ),
              ),
            ],
          ),
          Gaps.h12,
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              AppActionButton.outlined(
                label: 'Toast info',
                icon: Icons.info_outline_rounded,
                tone: .neutral,
                onPressed: () => AppToast.show(
                  context,
                  message: 'Informacja systemowa.',
                ),
              ),
              AppActionButton.filled(
                label: 'Toast success',
                icon: Icons.check_circle_outline_rounded,
                tone: .neutral,
                onPressed: () => AppToast.show(
                  context,
                  message: 'Dane zostaly zapisane.',
                  tone: AppToastTone.success,
                ),
              ),
              AppActionButton.outlined(
                label: 'Toast warning',
                icon: Icons.warning_amber_rounded,
                tone: .neutral,
                onPressed: () => AppToast.show(
                  context,
                  message: 'To jest ostrzezenie.',
                  tone: AppToastTone.warning,
                ),
              ),
              AppActionButton.outlined(
                label: 'Toast error',
                icon: Icons.error_outline_rounded,
                tone: .danger,
                onPressed: () => AppToast.show(
                  context,
                  message: 'Wystapil blad zapisu.',
                  tone: AppToastTone.error,
                  actionLabel: 'Ponow',
                  onAction: () => _showHint('Ponow'),
                ),
              ),
            ],
          ),
          Gaps.h12,
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              AppActionButton.text(
                label: 'Banner info',
                icon: Icons.info_outline_rounded,
                tone: .neutral,
                onPressed: () => _updateGalleryState(() {
                  feedbackBannerTone = .info;
                  showFeedbackBanner = true;
                }),
              ),
              AppActionButton.text(
                label: 'Banner success',
                icon: Icons.check_circle_outline_rounded,
                tone: .neutral,
                onPressed: () => _updateGalleryState(() {
                  feedbackBannerTone = .success;
                  showFeedbackBanner = true;
                }),
              ),
              AppActionButton.text(
                label: 'Banner warning',
                icon: Icons.warning_amber_rounded,
                tone: .neutral,
                onPressed: () => _updateGalleryState(() {
                  feedbackBannerTone = .warning;
                  showFeedbackBanner = true;
                }),
              ),
              AppActionButton.text(
                label: 'Banner error',
                icon: Icons.error_outline_rounded,
                tone: .danger,
                onPressed: () => _updateGalleryState(() {
                  feedbackBannerTone = .error;
                  showFeedbackBanner = true;
                }),
              ),
            ],
          ),
          if (showFeedbackBanner) ...[
            Gaps.h12,
            AppBanner(
              tone: feedbackBannerTone,
              title: switch (feedbackBannerTone) {
                AppBannerTone.info => 'Informacja',
                AppBannerTone.success => 'Sukces',
                AppBannerTone.warning => 'Uwaga',
                AppBannerTone.error => 'Blad',
              },
              message: switch (feedbackBannerTone) {
                AppBannerTone.info => 'To jest neutralny komunikat inline.',
                AppBannerTone.success => 'Operacja zakonczona powodzeniem.',
                AppBannerTone.warning => 'Sprawdz dane przed wyslaniem.',
                AppBannerTone.error => 'Nie udalo sie wykonac operacji.',
              },
              trailing: AppActionButton.text(
                label: 'Akcja',
                icon: Icons.play_arrow_rounded,
                tone: .neutral,
                onPressed: () => _showHint('Banner action'),
              ),
              onClose: () =>
                  _updateGalleryState(() => showFeedbackBanner = false),
            ),
          ],
        ],
      ),
    );
  }
}
