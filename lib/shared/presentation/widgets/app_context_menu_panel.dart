import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_entry_group.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Jedna powierzchnia menu wraz z obsługą klawiatury i focusu.
class AppContextMenuPanel<T> extends StatefulWidget {
  const AppContextMenuPanel({
    required this.entries,
    required this.onSelected,
    this.headerTitle,
    this.headerSubtitle,
    this.contentBuilder,
    super.key,
  });

  /// Pozycje menu.
  final List<AppContextMenuEntry<T>> entries;

  /// Wywoływane z wartością wybranej pozycji.
  final ValueChanged<T> onSelected;

  final String? headerTitle;
  final String? headerSubtitle;
  final AppContextMenuContentBuilder? contentBuilder;

  @override
  State<AppContextMenuPanel<T>> createState() => _AppContextMenuPanelState<T>();
}

class _AppContextMenuPanelState<T> extends State<AppContextMenuPanel<T>> {
  final Map<int, GlobalKey> _rowKeys = {};
  int? _highlightedIndex;

  List<int> get _selectableIndexes => [
    for (var index = 0; index < widget.entries.length; index++)
      if (widget.entries[index].enabled) index,
  ];

  @override
  void initState() {
    super.initState();
    for (var index = 0; index < widget.entries.length; index++) {
      _rowKeys[index] = GlobalKey();
    }
    _highlightedIndex = _selectableIndexes.firstOrNull;
  }

  @override
  void didUpdateWidget(covariant AppContextMenuPanel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final entriesCount = widget.entries.length;
    _rowKeys.removeWhere((index, _) => index >= entriesCount);
    for (var index = 0; index < entriesCount; index++) {
      _rowKeys.putIfAbsent(index, GlobalKey.new);
    }
    if (!_selectableIndexes.contains(_highlightedIndex)) {
      _highlightedIndex = _selectableIndexes.firstOrNull;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuTheme = context.menuTheme;
    return FocusScope(
      autofocus: true,
      child: Focus(
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: FocusTraversalGroup(
          child: Material(
            type: MaterialType.transparency,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: menuTheme.surface,
                borderRadius: BorderRadius.all(
                  Radius.circular(menuTheme.radius),
                ),
                border: Border.all(color: menuTheme.border),
                boxShadow: [
                  BoxShadow(
                    color: menuTheme.shadow.withValues(alpha: .16),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: menuTheme.shadow.withValues(alpha: .06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(menuTheme.radius),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(menuTheme.padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.headerTitle case final title?)
                        _MenuHeader(
                          title: title,
                          subtitle: widget.headerSubtitle,
                        ),
                      if (widget.contentBuilder case final builder?)
                        builder(context, () => Navigator.of(context).pop())
                      else
                        for (
                          var index = 0;
                          index < widget.entries.length;
                          index++
                        )
                          AppContextMenuEntryGroup<T>(
                            entry: widget.entries[index],
                            index: index,
                            previousSectionTitle: index == 0
                                ? null
                                : widget.entries[index - 1].sectionTitle,
                            rowKey: _rowKeys[index]!,
                            isHighlighted: _highlightedIndex == index,
                            onHighlighted: _highlight,
                            onSelected: widget.onSelected,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final selectable = _selectableIndexes;
    if (selectable.isEmpty) return KeyEventResult.ignored;

    final currentPosition = selectable.indexOf(_highlightedIndex ?? -1);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _highlight(selectable[(currentPosition + 1) % selectable.length]);
      case LogicalKeyboardKey.arrowUp:
        _highlight(
          selectable[(currentPosition - 1 + selectable.length) %
              selectable.length],
        );
      case LogicalKeyboardKey.home:
        _highlight(selectable.first);
      case LogicalKeyboardKey.end:
        _highlight(selectable.last);
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        final index = _highlightedIndex;
        if (index == null) return KeyEventResult.ignored;
        widget.onSelected(widget.entries[index].value);
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _highlight(int index) {
    setState(() => _highlightedIndex = index);
    final rowKey = _rowKeys[index];
    final rowContext = rowKey?.currentContext;
    if (rowKey == null || rowContext == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !rowContext.mounted ||
          !identical(_rowKeys[index], rowKey) ||
          !identical(rowKey.currentContext, rowContext)) {
        return;
      }
      Scrollable.ensureVisible(rowContext);
    });
  }
}

/// Nagłówek powierzchni menu.
class _MenuHeader extends StatelessWidget {
  const _MenuHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final menuTheme = context.menuTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: menuTheme.itemText.copyWith(
              fontWeight: FontWeight.w600,
              color: menuTheme.itemForeground,
            ),
          ),
          if (subtitle case final value?) ...[
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: menuTheme.shortcutText.copyWith(
                color: menuTheme.sectionForeground,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: menuTheme.divider),
        ],
      ),
    );
  }
}
