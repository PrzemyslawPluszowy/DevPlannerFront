import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_list_tile.dart';
import 'package:flutter/material.dart';

/// Pojedynczy węzeł danych dla [AppTree].
class AppTreeNode<T> {
  /// Tworzy definicję pojedynczego węzła drzewa.
  const AppTreeNode({
    required this.title,
    this.titleSpan,
    this.subtitle,
    this.leading,
    this.trailing,
    this.value,
    this.children = const [],
    this.initiallyExpanded = false,
    this.selected = false,
    this.enabled = true,
    this.onTap,
  });

  /// Główny tytuł węzła.
  final String title;
  final InlineSpan? titleSpan;

  /// Opcjonalny opis pomocniczy węzła.
  final String? subtitle;

  /// Opcjonalny leading węzła.
  final Widget? leading;

  /// Opcjonalny trailing węzła.
  final Widget? trailing;

  /// Wartość domenowa skojarzona z węzłem.
  final T? value;

  /// Lista dzieci bieżącego węzła.
  final List<AppTreeNode<T>> children;

  /// Czy węzeł ma być rozwinięty przy pierwszym renderze.
  final bool initiallyExpanded;

  /// Czy węzeł jest zaznaczony.
  final bool selected;

  /// Czy węzeł jest aktywny.
  final bool enabled;

  /// Callback dla kliknięcia węzła.
  final ValueChanged<T?>? onTap;

  /// Czy węzeł ma potomków.
  bool get hasChildren => children.isNotEmpty;
}

/// Kompaktowy, rekurencyjny widget drzewa oparty o tile i strzałki rozwijania.
class AppTree<T> extends StatelessWidget {
  /// Tworzy drzewo z listy węzłów głównych.
  const AppTree({
    required this.nodes,
    super.key,
    this.padding = EdgeInsets.zero,
    this.indent = Sizes.p12,
    this.itemSpacing = Sizes.p4,
  });

  /// Węzły główne drzewa.
  final List<AppTreeNode<T>> nodes;

  /// Padding zewnętrzny listy drzewa.
  final EdgeInsetsGeometry padding;

  /// Wielkość wcięcia kolejnych poziomów.
  final double indent;

  /// Odstęp pionowy między elementami głównymi.
  final double itemSpacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: nodes.length,
      separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
      itemBuilder: (context, index) => _AppTreeNodeView<T>(
        node: nodes[index],
        depth: 0,
        indent: indent,
      ),
    );
  }
}

/// Rekurencyjny renderer pojedynczego węzła [AppTree].
class _AppTreeNodeView<T> extends StatelessWidget {
  /// Tworzy renderer pojedynczego węzła drzewa.
  const _AppTreeNodeView({
    required this.node,
    required this.depth,
    required this.indent,
  });

  /// Aktualnie renderowany węzeł.
  final AppTreeNode<T> node;

  /// Głębokość renderowanego węzła.
  final int depth;

  /// Wielkość wcięcia dla kolejnych poziomów.
  final double indent;

  @override
  Widget build(BuildContext context) {
    final horizontalInset = Sizes.p8 + (depth * indent);
    final tilePadding = EdgeInsets.only(
      left: horizontalInset,
      right: Sizes.p8,
      top: Sizes.p2,
      bottom: Sizes.p2,
    );

    if (!node.hasChildren) {
      return AppListTile(
        title: node.title,
        titleSpan: node.titleSpan,
        subtitle: node.subtitle,
        leading: node.leading,
        trailing: node.trailing,
        selected: node.selected,
        enabled: node.enabled,
        padding: tilePadding,
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        onTap: node.onTap == null ? null : () => node.onTap!(node.value),
      );
    }

    return AppExpansionListTile(
      title: node.title,
      titleSpan: node.titleSpan,
      subtitle: node.subtitle,
      leading: node.leading,
      trailing: node.trailing,
      onTap: node.onTap == null ? null : () => node.onTap!(node.value),
      selected: node.selected,
      enabled: node.enabled,
      initiallyExpanded: node.initiallyExpanded,
      padding: tilePadding,
      childrenPadding: const EdgeInsets.only(bottom: Sizes.p2),
      borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
      children: [
        for (final childNode in node.children)
          _AppTreeNodeView<T>(
            node: childNode,
            depth: depth + 1,
            indent: indent,
          ),
      ],
    );
  }
}
