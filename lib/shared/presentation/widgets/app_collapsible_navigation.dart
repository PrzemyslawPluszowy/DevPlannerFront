import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:devplanner/shared/presentation/widgets/app_expansible_navigation_item.dart';

/// Kontroler ręcznego zwijania panelu nawigacyjnego.
///
/// Stan kontrolera powinien być przechowywany przez właściciela panelu (np.
/// shell aplikacji albo Cubit preferencji UI). Dzięki temu ten sam komponent
/// działa na Webie i desktopie oraz może zapamiętać wybór użytkownika.
class AppCollapsibleNavigationController extends ValueNotifier<bool> {
  /// Tworzy kontroler. `expanded` oznacza, że panel pokazuje pełne etykiety.
  AppCollapsibleNavigationController({
    bool expanded = true,
    this.onChanged,
  }) : super(expanded);

  /// Opcjonalna reakcja właściciela, np. zapis preferencji w Hive.
  ///
  /// Kontroler pozostaje niezależny od storage i routingu; callback służy
  /// wyłącznie do poinformowania warstwy nadrzędnej o zmianie stanu.
  final ValueChanged<bool>? onChanged;

  /// Czy panel jest aktualnie rozwinięty.
  bool get isExpanded => value;

  /// Rozwija panel.
  void expand() => _setValue(true);

  /// Zamyka panel do pionowego paska ikon.
  void collapse() => _setValue(false);

  /// Przełącza pomiędzy pełnym panelem i paskiem ikon.
  void toggle() => _setValue(!value);

  void _setValue(bool next) {
    if (next == value) return;
    value = next;
    onChanged?.call(next);
  }
}

/// Animowany panel nawigacyjny przechodzący z pełnego widoku do paska ikon.
///
/// Komponent nie zna routingu ani stanu modułu. `expandedBuilder` i
/// `collapsedBuilder` dostarczają odpowiednio treść obu wariantów, a decyzję
/// o stanie podejmuje właściciel przez [AppCollapsibleNavigationController].
/// W zwiniętym wariancie należy zapewnić tooltipy dla ikon.
class AppCollapsibleNavigationPanel extends StatelessWidget {
  /// Tworzy panel o płynnie animowanej szerokości.
  const AppCollapsibleNavigationPanel({
    required this.controller,
    required this.expandedBuilder,
    required this.collapsedBuilder,
    super.key,
    this.expandedWidth = 272,
    this.collapsedWidth = 56,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
    this.decoration,
    this.margin,
    this.enableKeyboardShortcut = true,
  });

  /// Kontroler stanu panelu. Właściciel powinien go zwolnić w `dispose`.
  final AppCollapsibleNavigationController controller;

  /// Buduje pełny panel z etykietami, podmenu i akcjami.
  final WidgetBuilder expandedBuilder;

  /// Buduje wąski pasek ikon widoczny po ręcznym zwinięciu.
  final WidgetBuilder collapsedBuilder;

  /// Szerokość pełnego panelu.
  final double expandedWidth;

  /// Szerokość paska ikon.
  final double collapsedWidth;

  /// Czas przejścia szerokości i przezroczystości.
  final Duration duration;

  /// Krzywa animacji panelu.
  final Curve curve;

  /// Opcjonalna dekoracja wspólna obu wariantów.
  final Decoration? decoration;

  /// Zewnętrzny margines panelu.
  final EdgeInsetsGeometry? margin;

  /// Włącza skrót Ctrl+B/Cmd+B, zgodny z popularnymi aplikacjami webowymi.
  ///
  /// Skrót działa tylko wtedy, gdy fokus znajduje się w panelu, więc nie
  /// przechwytuje skrótów edytora używanego w głównej treści strony.
  final bool enableKeyboardShortcut;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (context, expanded, _) {
        final panel = Container(
          width: expanded ? expandedWidth : collapsedWidth,
          margin: margin,
          decoration:
              decoration ??
              BoxDecoration(
                color: context.colors.surface,
                border: Border(
                  right: BorderSide(
                    color: context.colors.outlineVariant.withValues(alpha: .7),
                  ),
                ),
              ),
          clipBehavior: Clip.hardEdge,
          child: Material(
            type: MaterialType.transparency,
            child: FocusTraversalGroup(
              child: RepaintBoundary(
                child: expanded
                    ? expandedBuilder(context)
                    : collapsedBuilder(context),
              ),
            ),
          ),
        );

        if (!enableKeyboardShortcut) return panel;
        return Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(
              LogicalKeyboardKey.keyB,
              control: true,
            ): _ToggleNavigationPanelIntent(),
            SingleActivator(
              LogicalKeyboardKey.keyB,
              meta: true,
            ): _ToggleNavigationPanelIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              _ToggleNavigationPanelIntent:
                  CallbackAction<_ToggleNavigationPanelIntent>(
                    onInvoke: (_) {
                      controller.toggle();
                      return null;
                    },
                  ),
            },
            child: panel,
          ),
        );
      },
    );
  }
}

class _ToggleNavigationPanelIntent extends Intent {
  const _ToggleNavigationPanelIntent();
}
