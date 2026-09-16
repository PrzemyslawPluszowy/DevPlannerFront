part of 'framework_components_gallery_page.dart';

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.title,
    required this.subtitle,
    required this.child,
    this.codeSnippet,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final String? codeSnippet;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppText(
            title,
            style: context.text.titleMedium?.copyWith(fontWeight: .w700),
          ),
          Gaps.h4,
          AppText(
            subtitle,
            style: context.text.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h16,
          child,
          if (codeSnippet != null) ...[
            Gaps.h16,
            _GalleryCodeSnippetPanel(codeSnippet: codeSnippet!),
          ],
        ],
      ),
    );
  }
}

class _GalleryCodeSnippetPanel extends StatelessWidget {
  const _GalleryCodeSnippetPanel({required this.codeSnippet});

  final String codeSnippet;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          'Minimalny kod',
          style: context.text.labelLarge?.copyWith(
            fontWeight: .w700,
            color: colors.primary,
          ),
        ),
        leading: Icon(
          Icons.code_rounded,
          size: Sizes.p16,
          color: colors.primary,
        ),
        children: [
          AppSectionCard(
            tone: AppSectionCardTone.tinted,
            padding: const EdgeInsets.all(Sizes.p12),
            child: AppText(
              codeSnippet.trim(),
              selectable: true,
              style: context.text.bodySmall?.copyWith(
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
