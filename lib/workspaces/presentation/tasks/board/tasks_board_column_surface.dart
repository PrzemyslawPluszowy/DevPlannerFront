part of 'tasks_board_page.dart';

/// Powierzchnia kolumny Kanbana: gradient akcentu, obrys i podświetlenie ramki.
///
/// Wspólna dla widoku statusów i widoku grupowania po osobach, żeby oba tryby
/// wyglądały identycznie — różni je wyłącznie źródło koloru akcentu (kolor
/// statusu w jednym, tożsamość osoby w drugim). Tło kolumny jest spokojne,
/// a hover podświetla samą ramkę, tak samo jak na kafelku karty.
class KanbanColumnSurface extends StatefulWidget {
  const KanbanColumnSurface({
    required this.accent,
    required this.density,
    required this.child,
    this.highlighted = false,
    this.footer,
    super.key,
  });

  /// Gęstość tablicy; decyduje też o szerokości kolumny, żeby Compact mieścił
  /// na ekranie realnie więcej kolumn niż Detailed.
  final KanbanCardDensity density;

  /// Kolor akcentu kolumny: statusu albo osoby, która ją zajmuje.
  final Color accent;

  /// Kolumna jest aktywną strefą upuszczenia, więc ramka świeci jak w hover.
  final bool highlighted;

  /// Wiersz przypięty do dolnej krawędzi kolumny, poza obszarem przewijania.
  final Widget? footer;

  final Widget child;

  @override
  State<KanbanColumnSurface> createState() => _KanbanColumnSurfaceState();
}

class _KanbanColumnSurfaceState extends State<KanbanColumnSurface> {
  final ValueNotifier<bool> _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    // Kolumna zajmuje całą wysokość planszy, więc upuszczenie działa na całej
    // jej powierzchni, a nie tylko na wysokości kart.
    width: KanbanCardTokens.columnWidthFor(widget.density),
    height: double.infinity,
    child: MouseRegion(
      onEnter: (_) => _hovered.value = true,
      onExit: (_) => _hovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _hovered,
        builder: (context, hovered, _) {
          final active = hovered || widget.highlighted;
          final colors = context.colors;
          final base = colors.surfaceContainerLow;
          return DecoratedBox(
            decoration: BoxDecoration(
              // Gradient akcentu jest stały: hover i strefa upuszczenia
              // podświetlają wyłącznie ramkę, więc tło kolumny nie mruga.
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  base,
                  Color.alphaBlend(
                    widget.accent.withValues(alpha: .10),
                    base,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? colors.primary
                    : colors.outlineVariant.withValues(alpha: .5),
                width: active ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: widget.child),
                ?widget.footer,
              ],
            ),
          );
        },
      ),
    ),
  );
}
