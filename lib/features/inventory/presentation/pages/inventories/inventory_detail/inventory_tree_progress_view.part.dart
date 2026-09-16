part of 'inventory_tree_progress_modal.dart';

const _treeRowHeight = 60.0;
const _treeIndent = 16.0;
const _treeExpanderWidth = 28.0;

/// Dane prezentacyjne pojedynczego wiersza drzewa postępu.
class _TreeProgressNodeData {
  const _TreeProgressNodeData({
    required this.title,
    required this.leading,
    this.titleSpan,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final InlineSpan? titleSpan;
  final String? subtitle;
  final Widget leading;
  final Widget? trailing;
}

/// Kompaktowa lista miejsc bez wykonanego arkusza.
class _IncompleteInventoryNodesStrip extends StatelessWidget {
  const _IncompleteInventoryNodesStrip({
    required this.items,
  });

  final List<GetInwentaryzacjaTreeProgressItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Row(
          children: [
            Icon(
              Icons.pending_actions_rounded,
              size: Sizes.p18,
              color: context.feedback.warningForeground,
            ),
            Gaps.w8,
            AppText(
              context.l10n.inventoryTreeIncompleteTitle(items.length),
              style: context.text.labelLarge?.copyWith(fontWeight: .w700),
            ),
          ],
        ),
        Gaps.h4,
        SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: .horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => Gaps.w8,
            itemBuilder: (context, index) {
              final item = items[index];
              final name = (item.nazwa ?? '').trim();
              final label = name.isNotEmpty
                  ? name
                  : context.l10n.inventoryIdWithValue(item.idMiejsca);

              return AppStatusBadge(
                label: '$label • ${item.productsCount}',
                tone: .warning,
                icon: Icons.pending_outlined,
                tooltip:
                    '$label • ${context.l10n.inventoryProductsCount(item.productsCount)}',
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Drzewo postępu oparte na natywnym [TreeSliver].
class _InventoryTreeProgressView extends StatelessWidget {
  const _InventoryTreeProgressView({
    required this.nodes,
  });

  final List<TreeSliverNode<_TreeProgressNodeData>> nodes;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(Sizes.p8),
          sliver: TreeSliver<_TreeProgressNodeData>(
            tree: nodes,
            indentation: .none,
            toggleAnimationStyle: const AnimationStyle(
              duration: Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
            ),
            treeRowExtentBuilder: (node, dimensions) => _treeRowHeight,
            treeNodeBuilder: (context, node, animationStyle) {
              final typedNode = node as TreeSliverNode<_TreeProgressNodeData>;

              return _InventoryTreeProgressRow(
                key: ObjectKey(typedNode),
                node: typedNode,
                animationStyle: animationStyle,
                onToggle: typedNode.children.isEmpty
                    ? null
                    : () => TreeSliverController.of(
                        context,
                      ).toggleNode(typedNode),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Pojedynczy wiersz drzewa z niezależnym stanem hover.
class _InventoryTreeProgressRow extends StatefulWidget {
  const _InventoryTreeProgressRow({
    required this.node,
    required this.animationStyle,
    required this.onToggle,
    super.key,
  });

  final TreeSliverNode<_TreeProgressNodeData> node;
  final AnimationStyle animationStyle;
  final VoidCallback? onToggle;

  @override
  State<_InventoryTreeProgressRow> createState() =>
      _InventoryTreeProgressRowState();
}

/// Stan hover pojedynczego wiersza drzewa postępu.
class _InventoryTreeProgressRowState extends State<_InventoryTreeProgressRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.node.content;
    final hoverColor = context.colors.surfaceContainerHighest.withValues(
      alpha: .72,
    );
    final titleStyle = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurface,
      fontWeight: .w600,
    );
    final subtitleStyle = context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );

    return Align(
      alignment: .centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _treeNodeContentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.p2),
          child: MouseRegion(
            cursor: widget.onToggle == null
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Material(
              color: _isHovered ? hoverColor : Colors.transparent,
              borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
              clipBehavior: .antiAlias,
              child: InkWell(
                onTap: widget.onToggle,
                hoverColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Sizes.p8 + (widget.node.depth! * _treeIndent),
                    right: Sizes.p8,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: _treeExpanderWidth,
                        child: widget.onToggle == null
                            ? null
                            : AnimatedRotation(
                                turns: widget.node.isExpanded ? .5 : 0,
                                duration:
                                    widget.animationStyle.duration ??
                                    TreeSliver.defaultAnimationDuration,
                                curve:
                                    widget.animationStyle.curve ??
                                    TreeSliver.defaultAnimationCurve,
                                child: Icon(
                                  Icons.expand_more_rounded,
                                  size: Sizes.p18,
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                      ),
                      Gaps.w4,
                      data.leading,
                      Gaps.w8,
                      Expanded(
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: [
                            if (data.titleSpan == null)
                              AppText(
                                data.title,
                                style: titleStyle,
                                maxLines: 1,
                                overflow: .ellipsis,
                              )
                            else
                              RichText(
                                maxLines: 1,
                                overflow: .ellipsis,
                                text: TextSpan(
                                  style: titleStyle,
                                  children: [data.titleSpan!],
                                ),
                              ),
                            if (data.subtitle != null)
                              AppText(
                                data.subtitle,
                                style: subtitleStyle,
                                maxLines: 1,
                                overflow: .ellipsis,
                              ),
                          ],
                        ),
                      ),
                      if (data.trailing != null) ...[
                        Gaps.w8,
                        data.trailing!,
                      ],
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
}
