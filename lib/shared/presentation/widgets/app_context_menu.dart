import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AppContextMenuActionTap = FutureOr<void> Function(BuildContext context);

/// Buduje interaktywną zawartość zachowującą powierzchnię i pozycjonowanie
/// wspólnego menu.
typedef AppContextMenuContentBuilder = Widget Function(
  BuildContext context,
  VoidCallback dismiss,
);

/// Akcja wspólnego menu wywołująca efekt po wybraniu.
class AppContextMenuAction {
  /// Tworzy akcję menu kontekstowego.
  const AppContextMenuAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    this.foregroundColor,
    this.iconColor,
    this.separatorBefore = false,
    this.sectionTitle,
    this.shortcutLabel,
    this.selected = false,
  });

  /// Etykieta akcji.
  final String label;

  /// Ikona akcji.
  final IconData? icon;

  /// Funkcja wykonywana po wybraniu akcji.
  final AppContextMenuActionTap onTap;

  /// Czy akcja ma charakter destrukcyjny.
  final bool isDestructive;

  /// Czy akcja jest dostępna.
  final bool enabled;

  /// Opcjonalny kolor akcji.
  final Color? foregroundColor;

  /// Opcjonalny kolor samej ikony, np. semantyczny kolor priorytetu.
  final Color? iconColor;

  /// Czy przed akcją ma pojawić się separator.
  final bool separatorBefore;

  /// Nagłówek sekcji poprzedzający tę akcję.
  final String? sectionTitle;

  /// Skrót klawiaturowy pokazywany po prawej stronie wiersza.
  final String? shortcutLabel;

  /// Czy akcja reprezentuje aktualnie wybraną wartość.
  final bool selected;
}

/// Pozycja menu wybierająca wartość i zamykająca menu po kliknięciu.
class AppContextMenuOption<T> {
  /// Tworzy pozycję menu wyboru.
  const AppContextMenuOption({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    this.selected = false,
    this.iconColor,
    this.leading,
    this.trailing,
    this.separatorBefore = false,
    this.sectionTitle,
    this.shortcutLabel,
  });

  /// Wartość zwracana po wybraniu pozycji.
  final T value;

  /// Etykieta pozycji.
  final String label;

  /// Ikona pozycji.
  final IconData? icon;

  /// Opcjonalny kolor samej ikony, np. semantyczny kolor priorytetu.
  final Color? iconColor;

  /// Widget przed etykietą, gdy sama ikona nie wystarcza (np. awatar).
  final Widget? leading;

  /// Widget po etykiecie, np. licznik albo próbka koloru.
  final Widget? trailing;

  /// Czy pozycja ma charakter destrukcyjny.
  final bool isDestructive;

  /// Czy pozycja jest dostępna.
  final bool enabled;

  /// Czy pozycja reprezentuje aktualnie wybraną wartość.
  final bool selected;

  /// Czy przed pozycją ma pojawić się separator.
  final bool separatorBefore;

  /// Nagłówek sekcji poprzedzający tę pozycję.
  final String? sectionTitle;

  /// Skrót klawiaturowy pokazywany po prawej stronie wiersza.
  final String? shortcutLabel;
}

/// Jedna powierzchnia menu kontekstowego DevPlanner.
///
/// Z tego komponentu korzystają kliknięcie `…`, prawy klik i pickery w Tasks,
/// Storage i katalogu workspace'ów. Menu ma jeden wiersz (32 px), jedną ikonę
/// (16 px), jeden promień i jedną powierzchnię z tokenów motywu, obsługuje
/// klawiaturę (strzałki, Home, End, Enter, Escape), przenosi i przywraca focus
/// oraz pozycjonuje się w root overlayu aplikacji.
abstract final class AppContextMenu {
  static const Duration _transitionDuration = Duration(milliseconds: 120);
  static const Duration _reverseTransitionDuration = Duration(milliseconds: 80);

  /// Margines, który trzyma powierzchnię menu wewnątrz widoku.
  static const double viewportMargin = 12;

  /// Kotwica menu dla widgetu, który je otwiera.
  ///
  /// Zwraca lewy dolny róg widgetu przesunięty o 4 px, czyli miejsce, w którym
  /// menu ma się pojawić po kliknięciu `…` lub prawego przycisku.
  static Offset positionFor(BuildContext context) {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      final overlay = Overlay.maybeOf(context)?.context.findRenderObject();
      return overlay is RenderBox ? overlay.localToGlobal(Offset.zero) : Offset.zero;
    }
    return renderObject.localToGlobal(Offset(0, renderObject.size.height)) +
        const Offset(0, 4);
  }

  /// Pokazuje menu przy wskazanej pozycji globalnej.
  static Future<void> show(
    BuildContext context, {
    required Offset globalPosition,
    required List<AppContextMenuAction> actions,
    String? headerTitle,
    String? headerSubtitle,
    double? maxWidth,
  }) async {
    if (actions.isEmpty) return;

    final entries = <_MenuEntry<int>>[
      for (var index = 0; index < actions.length; index++)
        _MenuEntry<int>(
          value: index,
          label: actions[index].label,
          icon: actions[index].icon,
          isDestructive: actions[index].isDestructive,
          enabled: actions[index].enabled,
          selected: actions[index].selected,
          foregroundColor: actions[index].foregroundColor,
          iconColor: actions[index].iconColor,
          separatorBefore: actions[index].separatorBefore,
          sectionTitle: actions[index].sectionTitle,
          shortcutLabel: actions[index].shortcutLabel,
        ),
    ];

    final selectedIndex = await _open<int>(
      context,
      globalPosition: globalPosition,
      entries: entries,
      headerTitle: headerTitle,
      headerSubtitle: headerSubtitle,
      maxWidth: maxWidth,
    );
    if (selectedIndex == null || !context.mounted) return;
    await actions[selectedIndex].onTap(context);
  }

  /// Pokazuje menu wyboru wartości.
  static Future<T?> select<T>(
    BuildContext context, {
    required Offset globalPosition,
    required List<AppContextMenuOption<T>> options,
    String? headerTitle,
    String? headerSubtitle,
    double? maxWidth,
  }) {
    if (options.isEmpty) return Future<T?>.value();

    return _open<T>(
      context,
      globalPosition: globalPosition,
      entries: [
        for (final option in options)
          _MenuEntry<T>(
            value: option.value,
            label: option.label,
            icon: option.icon,
            isDestructive: option.isDestructive,
            enabled: option.enabled,
            selected: option.selected,
            iconColor: option.iconColor,
            leading: option.leading,
            trailing: option.trailing,
            separatorBefore: option.separatorBefore,
            sectionTitle: option.sectionTitle,
            shortcutLabel: option.shortcutLabel,
          ),
      ],
      headerTitle: headerTitle,
      headerSubtitle: headerSubtitle,
      maxWidth: maxWidth,
    );
  }

  /// Pokazuje niestandardową, interaktywną zawartość w identycznej powierzchni.
  ///
  /// Służy np. do wyszukiwania, gdy zwykła lista akcji nie wystarcza.
  static Future<void> showCustom(
    BuildContext context, {
    required Offset globalPosition,
    required AppContextMenuContentBuilder contentBuilder,
    double maxWidth = 360,
    double maxHeight = 420,
    String? headerTitle,
  }) async {
    await _open<int>(
      context,
      globalPosition: globalPosition,
      entries: const [],
      contentBuilder: contentBuilder,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      headerTitle: headerTitle,
    );
  }

  /// Otwiera trasę menu i przywraca focus po jej zamknięciu.
  static Future<T?> _open<T>(
    BuildContext context, {
    required Offset globalPosition,
    required List<_MenuEntry<T>> entries,
    required double? maxWidth,
    double? maxHeight,
    String? headerTitle,
    String? headerSubtitle,
    AppContextMenuContentBuilder? contentBuilder,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final overlayBox =
        navigator.overlay!.context.findRenderObject()! as RenderBox;
    final overlayPosition =
        overlayBox.globalToLocal(globalPosition) + const Offset(4, 4);
    final previousFocus = FocusManager.instance.primaryFocus;

    final selected = await navigator.push<T>(
      _AppContextMenuRoute<T>(
        position: overlayPosition,
        entries: entries,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        headerTitle: headerTitle,
        headerSubtitle: headerSubtitle,
        contentBuilder: contentBuilder,
        transitionDuration: _transitionDuration,
        reverseTransitionDuration: _reverseTransitionDuration,
      ),
    );

    if (previousFocus != null && previousFocus.canRequestFocus) {
      previousFocus.requestFocus();
    }
    return selected;
  }
}

/// Widget otwierający wspólne menu prawym przyciskiem myszy.
///
/// Dzięki niemu prawy klik na wierszu tabeli, karcie Kanbanu czy pozycji drzewa
/// używa tego samego katalogu akcji co kliknięcie `…`.
class AppContextMenuRegion extends StatelessWidget {
  /// Tworzy obszar z menu kontekstowym prawego przycisku.
  const AppContextMenuRegion({
    required this.actionsBuilder,
    required this.child,
    this.headerTitle,
    this.headerSubtitle,
    super.key,
  });

  /// Buduje akcje dla bieżącego stanu widgetu.
  ///
  /// Pusta lista wyłącza menu dla tego obszaru.
  final List<AppContextMenuAction> Function(BuildContext context) actionsBuilder;

  /// Zawartość obszaru.
  final Widget child;

  /// Tytuł nagłówka menu.
  final String? headerTitle;

  /// Podtytuł nagłówka menu.
  final String? headerSubtitle;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onSecondaryTapDown: (details) {
      final actions = actionsBuilder(context);
      if (actions.isEmpty) return;
      unawaited(
        AppContextMenu.show(
          context,
          globalPosition: details.globalPosition,
          actions: actions,
          headerTitle: headerTitle,
          headerSubtitle: headerSubtitle,
        ),
      );
    },
    child: child,
  );
}

/// Pozycja menu w jednym modelu dla akcji i wyboru wartości.
class _MenuEntry<T> {
  const _MenuEntry({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    this.selected = false,
    this.foregroundColor,
    this.iconColor,
    this.leading,
    this.trailing,
    this.separatorBefore = false,
    this.sectionTitle,
    this.shortcutLabel,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool isDestructive;
  final bool enabled;
  final bool selected;
  final Color? foregroundColor;
  final Color? iconColor;
  final Widget? leading;
  final Widget? trailing;
  final bool separatorBefore;
  final String? sectionTitle;
  final String? shortcutLabel;
}

/// Trasa odpowiedzialna za prezentację menu ponad bieżącym ekranem.
class _AppContextMenuRoute<T> extends PopupRoute<T> {
  _AppContextMenuRoute({
    required this.position,
    required this.entries,
    required this.maxWidth,
    required this.maxHeight,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.contentBuilder,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
  });

  /// Pozycja menu w układzie overlayu.
  final Offset position;

  /// Pozycje menu.
  final List<_MenuEntry<T>> entries;

  /// Maksymalna szerokość powierzchni menu.
  final double? maxWidth;

  /// Maksymalna wysokość powierzchni menu.
  final double? maxHeight;

  final String? headerTitle;
  final String? headerSubtitle;
  final AppContextMenuContentBuilder? contentBuilder;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Zamknij menu kontekstowe';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return CustomSingleChildLayout(
      delegate: _AppContextMenuPositionDelegate(
        position,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      child: _AppContextMenuPanel<T>(
        entries: entries,
        headerTitle: headerTitle,
        headerSubtitle: headerSubtitle,
        contentBuilder: contentBuilder,
        onSelected: (value) => Navigator.of(context).pop(value),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        alignment: .topLeft,
        scale: Tween<double>(begin: .985, end: 1).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}

/// Delegat utrzymujący menu wewnątrz widocznego obszaru ekranu.
class _AppContextMenuPositionDelegate extends SingleChildLayoutDelegate {
  const _AppContextMenuPositionDelegate(
    this.position, {
    required this.maxWidth,
    this.maxHeight,
  });

  /// Pozycja menu w układzie overlayu.
  final Offset position;

  /// Maksymalna szerokość i wysokość powierzchni menu.
  final double? maxWidth;
  final double? maxHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    const margin = AppContextMenu.viewportMargin;
    return BoxConstraints(
      minWidth: constraints.maxWidth.clamp(0, 220),
      maxWidth: maxWidth ?? 300,
      maxHeight: (maxHeight ?? constraints.maxHeight).clamp(
        0,
        (constraints.maxHeight - margin * 2).clamp(0, double.infinity),
      ),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    const margin = AppContextMenu.viewportMargin;
    final maxX = (size.width - childSize.width - margin).clamp(
      margin,
      double.infinity,
    );
    final maxY = (size.height - childSize.height - margin).clamp(
      margin,
      double.infinity,
    );
    return Offset(
      position.dx.clamp(margin, maxX),
      position.dy.clamp(margin, maxY),
    );
  }

  @override
  bool shouldRelayout(_AppContextMenuPositionDelegate oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.maxWidth != maxWidth ||
        oldDelegate.maxHeight != maxHeight;
  }
}

/// Jedna powierzchnia menu wraz z obsługą klawiatury i focusu.
class _AppContextMenuPanel<T> extends StatefulWidget {
  const _AppContextMenuPanel({
    required this.entries,
    required this.onSelected,
    this.headerTitle,
    this.headerSubtitle,
    this.contentBuilder,
  });

  /// Pozycje menu.
  final List<_MenuEntry<T>> entries;

  /// Wywoływane z wartością wybranej pozycji.
  final ValueChanged<T> onSelected;

  final String? headerTitle;
  final String? headerSubtitle;
  final AppContextMenuContentBuilder? contentBuilder;

  @override
  State<_AppContextMenuPanel<T>> createState() => _AppContextMenuPanelState<T>();
}

class _AppContextMenuPanelState<T> extends State<_AppContextMenuPanel<T>> {
  final Map<int, GlobalKey> _rowKeys = {};
  int? _highlightedIndex;

  List<int> get _selectableIndexes => [
    for (var index = 0; index < widget.entries.length; index++)
      if (widget.entries[index].enabled) index,
  ];

  @override
  void initState() {
    super.initState();
    _highlightedIndex = _selectableIndexes.firstOrNull;
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
                borderRadius: BorderRadius.all(Radius.circular(menuTheme.radius)),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(menuTheme.padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.headerTitle case final title?)
                        _MenuHeader(title: title, subtitle: widget.headerSubtitle),
                      if (widget.contentBuilder case final builder?)
                        builder(context, () => Navigator.of(context).pop())
                      else
                        for (var index = 0; index < widget.entries.length; index++)
                          _buildEntry(context, index),
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

  Widget _buildEntry(BuildContext context, int index) {
    final entry = widget.entries[index];
    // Nagłówek sekcji rysujemy raz na początku grupy, więc kolejne pozycje
    // z tą samą nazwą sekcji nie powtarzają etykiety.
    final sectionTitle = entry.sectionTitle;
    final startsSection =
        sectionTitle != null &&
        (index == 0 || widget.entries[index - 1].sectionTitle != sectionTitle);
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
        _AppContextMenuItem<T>(
          key: _rowKeys.putIfAbsent(index, GlobalKey.new),
          entry: entry,
          isHighlighted: _highlightedIndex == index,
          onHoverChanged: (isHovered) {
            if (!isHovered || _highlightedIndex == index) return;
            setState(() => _highlightedIndex = index);
          },
          onPressed: () => widget.onSelected(entry.value),
        ),
      ],
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
          selectable[(currentPosition - 1 + selectable.length) % selectable.length],
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
    final rowContext = _rowKeys[index]?.currentContext;
    if (rowContext == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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

/// Pojedynczy wiersz menu: ikona, etykieta, skrót i znacznik wyboru.
class _AppContextMenuItem<T> extends StatefulWidget {
  const _AppContextMenuItem({
    required this.entry,
    required this.isHighlighted,
    required this.onHoverChanged,
    required this.onPressed,
    super.key,
  });

  final _MenuEntry<T> entry;
  final bool isHighlighted;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onPressed;

  @override
  State<_AppContextMenuItem<T>> createState() => _AppContextMenuItemState<T>();
}

class _AppContextMenuItemState<T> extends State<_AppContextMenuItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final menuTheme = context.menuTheme;
    final isActive = _isHovered || widget.isHighlighted;
    final Color foreground;
    if (entry.foregroundColor case final explicit?) {
      foreground = explicit;
    } else if (entry.isDestructive) {
      foreground = menuTheme.destructive;
    } else if (entry.selected || isActive) {
      foreground = menuTheme.itemSelectedForeground;
    } else {
      foreground = menuTheme.itemForeground;
    }
    final background = isActive
        ? (entry.isDestructive ? menuTheme.destructiveHover : menuTheme.itemHover)
        : (entry.selected ? menuTheme.itemSelectedSurface : Colors.transparent);

    return MouseRegion(
      cursor: entry.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (!entry.enabled) return;
        setState(() => _isHovered = true);
        widget.onHoverChanged(true);
      },
      onExit: (_) {
        if (!entry.enabled) return;
        setState(() => _isHovered = false);
        widget.onHoverChanged(false);
      },
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(menuTheme.itemRadius)),
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: entry.enabled ? widget.onPressed : null,
          child: Container(
            height: menuTheme.rowHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.all(
                Radius.circular(menuTheme.itemRadius),
              ),
            ),
            child: Opacity(
              opacity: entry.enabled ? 1 : menuTheme.disabledOpacity,
              child: Row(
                children: [
                  if (entry.leading case final leading?) ...[
                    leading,
                    const SizedBox(width: 8),
                  ] else ...[
                    SizedBox(
                      width: menuTheme.iconSize + 2,
                      child: entry.icon == null
                          ? null
                          : Icon(
                              entry.icon,
                              size: menuTheme.iconSize - 1,
                              color: entry.iconColor ?? foreground,
                            ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      entry.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: menuTheme.itemText.copyWith(
                        color: foreground,
                        fontWeight: entry.selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (entry.trailing case final trailing?) ...[
                    const SizedBox(width: 8),
                    trailing,
                  ],
                  if (entry.shortcutLabel case final shortcut?) ...[
                    const SizedBox(width: 12),
                    Text(
                      shortcut,
                      style: menuTheme.shortcutText.copyWith(
                        color: menuTheme.sectionForeground,
                      ),
                    ),
                  ],
                  if (entry.selected) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check_rounded,
                      size: menuTheme.iconSize - 1,
                      color: menuTheme.itemSelectedForeground,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
