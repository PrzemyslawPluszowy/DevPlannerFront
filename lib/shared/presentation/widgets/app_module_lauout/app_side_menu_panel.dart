import 'package:flutter/material.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Model pojedynczej pozycji menu bocznego.
///
/// Używaj go, gdy chcesz zbudować standardowe menu bez ręcznego pisania
/// własnych przycisków.
class AppSideMenuItem {
  const AppSideMenuItem({
    required this.label,
    required this.icon,
    this.onTap,
    this.isSimple = false,
    this.isSelected = false,
    this.trailing,
    this.children = const [],
    this.initiallyExpanded = false,
  });

  /// Fabryka dla pozycji rozwijanej w sekcji `extended`.
  factory AppSideMenuItem.expandable({
    required String label,
    required IconData icon,
    required List<AppSideMenuItem> children,
    VoidCallback? onTap,
    bool isSelected = false,
    Widget? trailing,
    bool initiallyExpanded = false,
  }) {
    return AppSideMenuItem(
      label: label,
      icon: icon,
      onTap: onTap,
      isSelected: isSelected,
      trailing: trailing,
      children: children,
      initiallyExpanded: initiallyExpanded,
    );
  }

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSimple;
  final bool isSelected;
  final Widget? trailing;
  final List<AppSideMenuItem> children;
  final bool initiallyExpanded;

  bool get hasChildren => children.isNotEmpty;
  bool get hasSelectionInTree =>
      isSelected || children.any((child) => child.hasSelectionInTree);
}

typedef AppSideMenuEntryTap = void Function(BuildContext context);

/// Prosty opis pozycji menu używany do budowania sekcji w sposób deklaratywny.
class AppSideMenuEntrySpec {
  const AppSideMenuEntrySpec({
    required this.label,
    required this.icon,
    this.routeName,
    this.onTap,
    this.isSelected = false,
    this.isSimple = false,
    this.children = const [],
    this.trailing,
    this.initiallyExpanded,
  });

  factory AppSideMenuEntrySpec.route({
    required String label,
    required IconData icon,
    required bool isSelected,
    String? routeName,
    AppSideMenuEntryTap? onTap,
    bool isSimple = false,
    Widget? trailing,
  }) {
    return AppSideMenuEntrySpec(
      label: label,
      icon: icon,
      routeName: routeName,
      onTap: onTap,
      isSelected: isSelected,
      isSimple: isSimple,
      trailing: trailing,
    );
  }

  factory AppSideMenuEntrySpec.action({
    required String label,
    required IconData icon,
    AppSideMenuEntryTap? onTap,
    Widget? trailing,
  }) {
    return AppSideMenuEntrySpec(
      label: label,
      icon: icon,
      onTap: onTap,
      trailing: trailing,
    );
  }

  factory AppSideMenuEntrySpec.expandable({
    required String label,
    required IconData icon,
    required List<AppSideMenuEntrySpec> children,
    bool isSelected = false,
    bool? initiallyExpanded,
    String? routeName,
    AppSideMenuEntryTap? onTap,
  }) {
    return AppSideMenuEntrySpec(
      label: label,
      icon: icon,
      routeName: routeName,
      onTap: onTap,
      children: children,
      isSelected: isSelected,
      initiallyExpanded: initiallyExpanded,
    );
  }

  final String label;
  final IconData icon;
  final String? routeName;
  final AppSideMenuEntryTap? onTap;
  final bool isSelected;
  final bool isSimple;
  final List<AppSideMenuEntrySpec> children;
  final Widget? trailing;
  final bool? initiallyExpanded;
}

/// Deklaratywny opis sekcji menu do zbudowania listy `AppSideMenuSection`.
class AppSideMenuSectionSpec {
  const AppSideMenuSectionSpec({
    required this.items,
    this.title,
    this.style = AppSideMenuSectionStyle.extended,
  });

  const AppSideMenuSectionSpec.simple({
    required this.items,
    this.title,
  }) : style = AppSideMenuSectionStyle.simple;

  const AppSideMenuSectionSpec.extended({
    required this.items,
    this.title,
  }) : style = AppSideMenuSectionStyle.extended;

  final List<AppSideMenuEntrySpec> items;
  final String? title;
  final AppSideMenuSectionStyle style;
}

/// Pomocniczy builder: z `AppSideMenuSectionSpec` robi gotowe sekcje menu.
List<AppSideMenuSection> buildSideMenuSectionsFromSpecs(
  BuildContext context,
  List<AppSideMenuSectionSpec> specs,
  void Function(BuildContext context, String label)? onDefaultAction,
) {
  AppSideMenuItem toItem(AppSideMenuEntrySpec spec) {
    final expandedFlag =
        spec.initiallyExpanded ??
        spec.isSelected ||
            spec.children.any(
              (child) =>
                  child.isSelected ||
                  child.children.any(
                    (g) => g.isSelected || g.children.isNotEmpty,
                  ),
            );

    if (spec.children.isNotEmpty) {
      return AppSideMenuItem.expandable(
        label: spec.label,
        icon: spec.icon,
        isSelected: spec.isSelected,
        initiallyExpanded: expandedFlag,
        onTap: spec.onTap == null ? null : () => spec.onTap!(context),
        children: spec.children.map(toItem).toList(),
      );
    }

    return AppSideMenuItem(
      label: spec.label,
      icon: spec.icon,
      trailing: spec.trailing,
      isSimple: spec.isSimple,
      isSelected: spec.isSelected,
      onTap: spec.onTap != null
          ? () => spec.onTap!(context)
          : spec.routeName != null
          ? () => context.router.navigatePath(spec.routeName!)
          : onDefaultAction == null
          ? null
          : () => onDefaultAction(context, spec.label),
    );
  }

  return [
    for (final section in specs)
      AppSideMenuSection(
        title: section.title,
        style: section.style,
        items: section.items.map(toItem).toList(),
      ),
  ];
}

enum AppSideMenuSectionStyle { simple, extended }

/// Sekcja menu bocznego.
///
/// Pozwala grupować pozycje w dwa style:
/// - `simple`: lekkie przyciski tekstowe (jak `TextButton.icon`),
/// - `extended`: sekcja z jaśniejszym tłem pod spodem i większymi przyciskami.
class AppSideMenuSection {
  const AppSideMenuSection({
    required this.items,
    this.style = AppSideMenuSectionStyle.extended,
    this.title,
  });

  const AppSideMenuSection.simple({required this.items, this.title})
    : style = AppSideMenuSectionStyle.simple;

  const AppSideMenuSection.extended({required this.items, this.title})
    : style = AppSideMenuSectionStyle.extended;

  final List<AppSideMenuItem> items;
  final AppSideMenuSectionStyle style;
  final String? title;
}

/// Reużywalny panel menu bocznego dla ekranów modułowych.
///
/// Kiedy używać:
/// - do nawigacji po sekcjach modułu,
/// - gdy chcesz mieć nagłówek (ikona + tytuł + subtitle),
/// - gdy potrzebujesz opcjonalnych slotów `belowMenu` i `footer`.
///
/// Sposób użycia:
/// - standardowo podajesz `menuItems`,
/// - jeśli chcesz grupy o różnych stylach, użyj `menuSections`,
/// - dla niestandardowego layoutu możesz podać własne `menuChildren`,
/// - `AppSideMenuItem.isSimple` włącza lekki wariant przycisku
///   (podobny do `TextButton.icon`),
/// - `flat` pozwala zrobić wariant „wtopiony” (bez karty/cienia),
/// - `showBorder` kontroluje obramowanie panelu.
class AppSideMenuPanel extends StatelessWidget {
  const AppSideMenuPanel({
    required this.primaryIcon,
    required this.title,
    required this.subtitle,
    super.key,
    this.menuSections = const [],
    this.menuItems = const [],
    this.menuChildren = const [],
    this.width = 296,
    this.margin,
    this.padding,
    this.footer,
    this.belowMenu,
    this.flat = false,
    this.showBorder = true,
  });

  final IconData primaryIcon;
  final String title;
  final String subtitle;
  final List<AppSideMenuSection> menuSections;
  final List<AppSideMenuItem> menuItems;
  final List<Widget> menuChildren;
  final double width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? footer;
  final Widget? belowMenu;
  final bool flat;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final resolvedMenuChildren = [
      if (menuSections.isNotEmpty) ..._buildMenuSections(context),
      if (menuSections.isEmpty && menuItems.isNotEmpty)
        ..._buildMenuItems(context),
      ...menuChildren,
    ];

    final colors = context.colors;

    return Container(
      margin: margin ?? const .all(Sizes.p16),
      width: width,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: flat ? .zero : const .all(.circular(Sizes.p16)),
        border: showBorder ? Border.all(color: colors.outlineVariant) : null,
        boxShadow: flat
            ? null
            : [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: .06),
                  blurRadius: Sizes.p16,
                  offset: const Offset(0, Sizes.p4),
                ),
              ],
      ),
      child: Padding(
        padding: padding ?? const .all(Sizes.p20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _AppSideMenuHeader(
              primaryIcon: primaryIcon,
              title: title,
              subtitle: subtitle,
            ),
            Gaps.h20,
            ...resolvedMenuChildren,
            if (belowMenu != null) ...[Gaps.h16, belowMenu!],
            if (footer != null) ...[const Spacer(), footer!],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuSections(BuildContext context) {
    final colors = context.colors;
    final widgets = <Widget>[];

    for (
      var sectionIndex = 0;
      sectionIndex < menuSections.length;
      sectionIndex++
    ) {
      final section = menuSections[sectionIndex];

      if (section.items.isEmpty) {
        continue;
      }

      if (sectionIndex > 0) {
        widgets.add(Gaps.h12);
      }

      if (section.title case final title?) {
        widgets.add(
          Padding(
            padding: const .symmetric(horizontal: Sizes.p4),
            child: Text(
              title,
              style: context.text.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: .w700,
              ),
            ),
          ),
        );
        widgets.add(Gaps.h8);
      }

      switch (section.style) {
        case AppSideMenuSectionStyle.simple:
          widgets.add(
            Column(
              children: [
                for (var i = 0; i < section.items.length; i++) ...[
                  _SimpleMenuButton(item: section.items[i]),
                  if (i != section.items.length - 1) Gaps.h2,
                ],
              ],
            ),
          );
        case AppSideMenuSectionStyle.extended:
          widgets.add(
            Container(
              padding: const .all(Sizes.p8),
              decoration: BoxDecoration(
                color: colors.surfaceBright,
                borderRadius: const .all(.circular(Sizes.p12)),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < section.items.length; i++) ...[
                    _AppSideMenuButton(item: section.items[i]),
                    if (i != section.items.length - 1) Gaps.h8,
                  ],
                ],
              ),
            ),
          );
      }
    }

    return widgets;
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final items = <Widget>[];

    for (var index = 0; index < menuItems.length; index++) {
      final item = menuItems[index];
      items.add(_AppSideMenuButton(item: item));

      if (index != menuItems.length - 1) {
        items.add(Gaps.h8);
      }
    }

    return items;
  }
}

/// Prywatny nagłówek panelu bocznego.
///
/// Składa się z ikony sekcji oraz bloku tytuł + opis.
class _AppSideMenuHeader extends StatelessWidget {
  const _AppSideMenuHeader({
    required this.primaryIcon,
    required this.title,
    required this.subtitle,
  });

  final IconData primaryIcon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: .start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: const .all(.circular(Sizes.p12)),
          ),
          child: Icon(primaryIcon, size: 20, color: colors.primary),
        ),
        Gaps.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: context.text.titleLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: .w700,
                ),
              ),
              Gaps.h4,
              Text(
                subtitle,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Prywatny przycisk pozycji menu.
///
/// Używany wewnętrznie do renderowania `AppSideMenuItem`.
class _AppSideMenuButton extends StatelessWidget {
  const _AppSideMenuButton({required this.item});

  final AppSideMenuItem item;

  @override
  Widget build(BuildContext context) {
    if (item.hasChildren && !item.isSimple) {
      return _ExtendedExpandableMenuButton(item: item);
    }

    if (item.isSimple) {
      return _SimpleMenuButton(item: item);
    }

    return _ExtendedMenuButton(item: item);
  }
}

class _ExtendedMenuButton extends StatelessWidget {
  const _ExtendedMenuButton({required this.item});

  final AppSideMenuItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final backgroundColor = item.isSelected
        ? colors.primaryContainer
        : colors.surfaceContainerLow.withValues(alpha: .32);
    final foregroundColor = item.isSelected ? colors.primary : colors.onSurface;
    final selectedShadow = [
      BoxShadow(
        color: colors.primary.withValues(alpha: .12),
        blurRadius: 14,
        spreadRadius: .2,
        offset: const Offset(0, 2),
      ),
    ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: const .all(.circular(Sizes.p12)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const .all(.circular(Sizes.p12)),
            border: Border.all(
              color: item.isSelected
                  ? colors.primary.withValues(alpha: .16)
                  : colors.outlineVariant.withValues(alpha: .5),
            ),
            boxShadow: item.isSelected ? selectedShadow : null,
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 20, color: foregroundColor),
              Gaps.w8,
              Expanded(
                child: Text(
                  item.label,
                  style: context.text.titleSmall?.copyWith(
                    color: foregroundColor,
                    fontWeight: .w600,
                  ),
                ),
              ),
              item.trailing ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: Sizes.p12,
                    color: foregroundColor.withValues(alpha: .56),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rozwijana pozycja menu dla sekcji `extended`.
///
/// Nagłówek wygląda jak standardowy przycisk, a po rozwinięciu pokazuje
/// podlistę skrótów.
class _ExtendedExpandableMenuButton extends StatefulWidget {
  const _ExtendedExpandableMenuButton({required this.item});

  final AppSideMenuItem item;

  @override
  State<_ExtendedExpandableMenuButton> createState() =>
      _ExtendedExpandableMenuButtonState();
}

class _ExtendedExpandableMenuButtonState
    extends State<_ExtendedExpandableMenuButton> {
  late bool isExpanded =
      widget.item.initiallyExpanded || widget.item.hasSelectionInTree;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = widget.item.hasSelectionInTree;
    final backgroundColor = isSelected
        ? colors.primaryContainer.withValues(alpha: .7)
        : colors.surfaceContainerLow.withValues(alpha: .24);
    final foregroundColor = isSelected ? colors.primary : colors.onSurface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const .all(.circular(Sizes.p12)),
        border: Border.all(
          color: isSelected
              ? colors.primary.withValues(alpha: .18)
              : colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.item.onTap?.call();
                setState(() => isExpanded = !isExpanded);
              },
              borderRadius: const .all(.circular(Sizes.p12)),
              child: Padding(
                padding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p12,
                ),
                child: Row(
                  children: [
                    Icon(widget.item.icon, size: 20, color: foregroundColor),
                    Gaps.w8,
                    Expanded(
                      child: Text(
                        widget.item.label,
                        style: context.text.titleSmall?.copyWith(
                          color: foregroundColor,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? .5 : .0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      child:
                          widget.item.trailing ??
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: foregroundColor.withValues(alpha: .72),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const .fromLTRB(Sizes.p12, 0, Sizes.p8, Sizes.p8),
              child: Column(
                children: [
                  for (var i = 0; i < widget.item.children.length; i++) ...[
                    _ExtendedNestedMenuItem(
                      item: widget.item.children[i],
                      depth: 1,
                    ),
                    if (i != widget.item.children.length - 1) Gaps.h4,
                  ],
                ],
              ),
            ),
            crossFadeState: isExpanded ? .showSecond : .showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _ExtendedNestedMenuItem extends StatelessWidget {
  const _ExtendedNestedMenuItem({
    required this.item,
    required this.depth,
  });

  final AppSideMenuItem item;
  final int depth;

  @override
  Widget build(BuildContext context) {
    if (!item.hasChildren) {
      return _ExtendedShortcutButton(item: item, depth: depth);
    }

    return _ExtendedNestedExpandableMenuButton(
      item: item,
      depth: depth,
    );
  }
}

class _ExtendedNestedExpandableMenuButton extends StatefulWidget {
  const _ExtendedNestedExpandableMenuButton({
    required this.item,
    required this.depth,
  });

  final AppSideMenuItem item;
  final int depth;

  @override
  State<_ExtendedNestedExpandableMenuButton> createState() =>
      _ExtendedNestedExpandableMenuButtonState();
}

class _ExtendedNestedExpandableMenuButtonState
    extends State<_ExtendedNestedExpandableMenuButton> {
  late bool isExpanded =
      widget.item.initiallyExpanded || widget.item.hasSelectionInTree;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = widget.item.hasSelectionInTree;
    final foregroundColor = isSelected ? colors.primary : colors.onSurface;

    return Container(
      margin: EdgeInsets.only(left: widget.depth * Sizes.p8),
      decoration: BoxDecoration(
        color: isSelected
            ? colors.primaryContainer.withValues(alpha: .42)
            : Colors.transparent,
        borderRadius: const .all(.circular(Sizes.p8)),
      ),
      child: Column(
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: foregroundColor,
              padding: const .symmetric(
                horizontal: Sizes.p8,
                vertical: Sizes.p8,
              ),
              minimumSize: const Size(0, 34),
              alignment: .centerLeft,
              textStyle: context.text.labelLarge?.copyWith(
                fontWeight: isSelected ? .w700 : .w500,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: .all(.circular(Sizes.p8)),
              ),
            ),
            onPressed: () {
              widget.item.onTap?.call();
              setState(() => isExpanded = !isExpanded);
            },
            icon: Icon(widget.item.icon, size: 16),
            label: Row(
              children: [
                Expanded(child: Text(widget.item.label)),
                AnimatedRotation(
                  turns: isExpanded ? .5 : .0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: foregroundColor.withValues(alpha: .72),
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const .only(top: Sizes.p2),
              child: Column(
                children: [
                  for (var i = 0; i < widget.item.children.length; i++) ...[
                    _ExtendedNestedMenuItem(
                      item: widget.item.children[i],
                      depth: widget.depth + 1,
                    ),
                    if (i != widget.item.children.length - 1) Gaps.h2,
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Kompaktowa pozycja skrótu renderowana pod rozwijanym przyciskiem.
class _ExtendedShortcutButton extends StatelessWidget {
  const _ExtendedShortcutButton({
    required this.item,
    this.depth = 1,
  });

  final AppSideMenuItem item;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foregroundColor = item.isSelected ? colors.primary : colors.onSurface;

    return Container(
      margin: EdgeInsets.only(left: depth * Sizes.p8),
      decoration: BoxDecoration(
        color: item.isSelected
            ? colors.primaryContainer.withValues(alpha: .4)
            : Colors.transparent,
        borderRadius: const .all(.circular(Sizes.p8)),
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p8),
          minimumSize: const Size(0, 34),
          alignment: .centerLeft,
          textStyle: context.text.labelLarge?.copyWith(
            fontWeight: item.isSelected ? .w700 : .w500,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: .all(.circular(Sizes.p8)),
          ),
        ),
        onPressed: item.onTap,
        icon: Icon(item.icon, size: 16),
        label: Row(
          children: [
            Expanded(child: Text(item.label)),
            if (item.trailing != null) ...[Gaps.w8, item.trailing!],
          ],
        ),
      ),
    );
  }
}

/// Lekki wariant pozycji menu, zbliżony do stylu `TextButton.icon`.
class _SimpleMenuButton extends StatelessWidget {
  const _SimpleMenuButton({required this.item});

  final AppSideMenuItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foregroundColor = item.isSelected ? colors.primary : colors.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: item.isSelected
            ? colors.primaryContainer.withValues(alpha: .35)
            : Colors.transparent,
        borderRadius: const .all(.circular(Sizes.p8)),
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p8),
          minimumSize: const Size(0, 34),
          alignment: .centerLeft,
          textStyle: context.text.titleSmall?.copyWith(
            fontWeight: item.isSelected ? .w700 : .w500,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: .all(.circular(Sizes.p8)),
          ),
        ),
        onPressed: item.onTap,
        icon: Icon(item.icon, size: 18),
        label: Row(
          children: [
            Expanded(child: Text(item.label)),
            if (item.trailing != null) ...[Gaps.w8, item.trailing!],
          ],
        ),
      ),
    );
  }
}
