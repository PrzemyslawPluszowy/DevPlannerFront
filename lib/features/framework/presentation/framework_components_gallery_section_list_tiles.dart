part of 'framework_components_gallery_page.dart';

extension _ListTilesSection on _FrameworkComponentsGalleryPageState {
  Widget _buildListTilesSection() {
    return _GallerySection(
      title: context.l10n.frameworkListTilesTitle,
      subtitle: context.l10n.frameworkListTilesSubtitle,
      codeSnippet: '''
AppListTile(
   title: context.l10n.frameworkInbox,
  leading: const Icon(Icons.inbox_outlined),
  selected: selected == 'inbox',
  onTap: () {},
);

AppExpansionListTile(
   title: context.l10n.frameworkReports,
  initiallyExpanded: true,
   children: [AppListTile(title: context.l10n.frameworkDaily)],
)
''',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            AppListTile(
              title: context.l10n.frameworkInbox,
              subtitle: context.l10n.frameworkListTileInboxCount,
              leading: Icon(
                Icons.inbox_outlined,
                size: Sizes.p20,
                color: context.colors.onSurfaceVariant,
              ),
              trailing: Text(
                '12',
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: .w700,
                ),
              ),
              selected: selectedListTile == 'inbox',
              onTap: () =>
                  _updateGalleryState(() => selectedListTile = 'inbox'),
            ),
            Gaps.h4,
            AppListTile(
              title: context.l10n.frameworkFavorites,
              leading: Icon(
                Icons.star_outline_rounded,
                size: Sizes.p20,
                color: context.colors.onSurfaceVariant,
              ),
              selected: selectedListTile == 'fav',
              onTap: () => _updateGalleryState(() => selectedListTile = 'fav'),
            ),
            Gaps.h8,
            AppExpansionListTile(
              title: context.l10n.frameworkReports,
              subtitle: context.l10n.frameworkListTileAnalytics,
              leading: Icon(
                Icons.analytics_outlined,
                size: Sizes.p20,
                color: context.colors.onSurfaceVariant,
              ),
              selected: selectedListTile.startsWith('report_'),
              initiallyExpanded: listExpanded,
              onExpansionChanged: (expanded) {
                _updateGalleryState(() => listExpanded = expanded);
              },
              children: [
                AppListTile(
                  title: context.l10n.frameworkListTileDailyReport,
                  leading: Icon(
                    Icons.today_outlined,
                    size: Sizes.p16,
                    color: context.colors.onSurfaceVariant,
                  ),
                  selected: selectedListTile == 'report_daily',
                  onTap: () => _updateGalleryState(
                    () => selectedListTile = 'report_daily',
                  ),
                ),
                AppListTile(
                  title: context.l10n.frameworkListTileMonthlyReport,
                  leading: Icon(
                    Icons.calendar_month_outlined,
                    size: Sizes.p16,
                    color: context.colors.onSurfaceVariant,
                  ),
                  selected: selectedListTile == 'report_monthly',
                  onTap: () => _updateGalleryState(
                    () => selectedListTile = 'report_monthly',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
