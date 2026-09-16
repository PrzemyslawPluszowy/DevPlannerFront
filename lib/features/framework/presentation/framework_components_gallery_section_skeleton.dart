part of 'framework_components_gallery_page.dart';

extension _SkeletonSection on _FrameworkComponentsGalleryPageState {
  Widget _buildSkeletonSection() {
    return _GallerySection(
      title: 'Skeleton',
      subtitle: 'Loading dla kart, formularzy i sekcji tabelarycznych.',
      codeSnippet: '''
const AppSkeletonCard();

const AppSkeleton.line(width: 180);
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const AppSkeletonCard(),
          Gaps.h16,
          Row(
            children: [
              AppSkeleton.circle(size: Sizes.p36),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton.line(width: 180),
                    Gaps.h8,
                    AppSkeleton.line(width: 240),
                    Gaps.h8,
                    AppSkeleton.line(width: 120),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
