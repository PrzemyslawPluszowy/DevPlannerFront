import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_item.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_models.dart';
import 'package:flutter/material.dart';

/// Renders one menu entry and its optional section heading or separator.
class AppContextMenuEntryGroup<T> extends StatelessWidget {
  const AppContextMenuEntryGroup({
    required this.entry,
    required this.index,
    required this.previousSectionTitle,
    required this.rowKey,
    required this.isHighlighted,
    required this.onHighlighted,
    required this.onSelected,
    super.key,
  });

  final AppContextMenuEntry<T> entry;
  final int index;
  final String? previousSectionTitle;
  final GlobalKey rowKey;
  final bool isHighlighted;
  final ValueChanged<int> onHighlighted;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final sectionTitle = entry.sectionTitle;
    final startsSection =
        sectionTitle != null && sectionTitle != previousSectionTitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (startsSection)
          Padding(
            padding: context.menuTheme.sectionPadding,
            child: Text(
              sectionTitle.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.menuTheme.sectionText.copyWith(
                color: context.menuTheme.sectionForeground,
              ),
            ),
          ),
        if (entry.separatorBefore)
          Divider(
            height: 8,
            thickness: 1,
            color: context.menuTheme.divider.withValues(alpha: .6),
          ),
        AppContextMenuItem<T>(
          key: rowKey,
          entry: entry,
          isHighlighted: isHighlighted,
          onHoverChanged: (isHovered) {
            if (isHovered) onHighlighted(index);
          },
          onPressed: () => onSelected(entry.value),
        ),
      ],
    );
  }
}
