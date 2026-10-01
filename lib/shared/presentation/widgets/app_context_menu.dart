import 'dart:async';

import 'package:devplanner/shared/presentation/widgets/app_context_menu_models.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_route.dart';
import 'package:flutter/material.dart';

export 'package:devplanner/shared/presentation/widgets/app_context_menu_models.dart'
    show
        AppContextMenuAction,
        AppContextMenuActionTap,
        AppContextMenuContentBuilder,
        AppContextMenuOption;

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
      return overlay is RenderBox
          ? overlay.localToGlobal(Offset.zero)
          : Offset.zero;
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

    final entries = <AppContextMenuEntry<int>>[
      for (var index = 0; index < actions.length; index++)
        AppContextMenuEntry<int>(
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
          AppContextMenuEntry<T>(
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
    required List<AppContextMenuEntry<T>> entries,
    required double? maxWidth,
    double? maxHeight,
    String? headerTitle,
    String? headerSubtitle,
    AppContextMenuContentBuilder? contentBuilder,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final callerTheme = Theme.of(context);
    final barrierLabel = MaterialLocalizations.of(
      context,
    ).modalBarrierDismissLabel;
    final overlayBox =
        navigator.overlay!.context.findRenderObject()! as RenderBox;
    final overlayPosition =
        overlayBox.globalToLocal(globalPosition) + const Offset(4, 4);
    final previousFocus = FocusManager.instance.primaryFocus;

    final selected = await navigator.push<T>(
      AppContextMenuRoute<T>(
        position: overlayPosition,
        entries: entries,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        viewportMargin: viewportMargin,
        headerTitle: headerTitle,
        headerSubtitle: headerSubtitle,
        contentBuilder: contentBuilder,
        callerTheme: callerTheme,
        localizedBarrierLabel: barrierLabel,
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
  final List<AppContextMenuAction> Function(BuildContext context)
  actionsBuilder;

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
