part of 'task_list_header.dart';

/// Kontener wspierający interaktywne przeciąganie kolumny (Drag and Drop)
/// z płynnymi animacjami rozsuwania slotów, podglądu karty oraz wskaźnika upuszczenia.
class _DraggableHeaderCellWrapper extends StatelessWidget {
  const _DraggableHeaderCellWrapper({
    required this.index,
    required this.width,
    required this.height,
    required this.label,
    required this.builder,
    required this.onReorder,
    this.icon,
  });

  /// Indeks kolumny w bieżącym układzie.
  final int index;

  /// Szerokość kolumny w pikselach.
  final double width;

  /// Wysokość paska nagłówka w pikselach.
  final double height;

  /// Etykieta kolumny.
  final String label;

  /// Opcjonalna ikona kolumny.
  final IconData? icon;

  /// Kreator komórki nagłówka otrzymujący dekorator chwytaka (ograniczonego do ikony i tekstu).
  final Widget Function(
    BuildContext context,
    Widget Function(Widget child) dragHandleBuilder,
  )
  builder;

  /// Callback wywoływany po upuszczeniu kolumny na nowej pozycji.
  final void Function(int oldIndex, int newIndex)? onReorder;

  @override
  Widget build(BuildContext context) {
    if (onReorder == null) {
      return builder(context, (child) => child);
    }

    final colors = context.colors;
    final text = context.text;

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) {
        onReorder?.call(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isTargeted =
            candidateData.isNotEmpty &&
            candidateData.first != null &&
            candidateData.first != index;
        final isTargetFromLeft = isTargeted && candidateData.first! < index;
        final isTargetFromRight = isTargeted && candidateData.first! > index;

        // Płynne mikro-przesunięcie (nudge) zawartości kolumny, robiące miejsce dla upuszczanej karty
        final slideOffset = isTargetFromRight
            ? const Offset(0.04, 0)
            : (isTargetFromLeft ? const Offset(-0.04, 0) : Offset.zero);

        // Chwytak do przeciągania obejmuje WYŁĄCZNIE ikonę i tekst kolumny,
        // dzięki czemu krawędź boczna (resize handle) i pusta przestrzeń nie kolidują z drag & dropem.
        Widget dragHandleBuilder(Widget handleChild) {
          return LongPressDraggable<int>(
            data: index,
            delay: const Duration(milliseconds: 180),
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: _buildFeedbackCard(context, colors, text),
            childWhenDragging: Opacity(
              opacity: 0.35,
              child: handleChild,
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: handleChild,
            ),
          );
        }

        final cell = builder(context, dragHandleBuilder);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isTargeted
                    ? colors.primary.withValues(alpha: 0.08)
                    : Colors.transparent,
                borderRadius: .circular(6),
              ),
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                offset: slideOffset,
                child: cell,
              ),
            ),
            Positioned(
              left: isTargetFromLeft ? null : -2,
              right: isTargetFromLeft ? -2 : null,
              top: 0,
              bottom: 0,
              width: 6,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeInOut,
                opacity: isTargeted ? 1.0 : 0.0,
                child: isTargeted
                    ? _ColumnDropIndicatorMarker(height: height)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Buduje unoszoną kartę podglądu przeciąganej kolumny z cieniem, gradientem i chipem.
  Widget _buildFeedbackCard(
    BuildContext context,
    ColorScheme colors,
    TextTheme text,
  ) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateZ(0.015)
        ..scaleByDouble(1.02, 1.02, 1.0, 1.0),
      alignment: .center,
      child: Material(
        elevation: 12,
        borderRadius: .circular(10),
        color: colors.surfaceContainerHighest,
        shadowColor: colors.shadow.withValues(alpha: 0.35),
        child: Container(
          width: width,
          height: height,
          padding: const .symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: .circular(10),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.8),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: .topLeft,
              end: .bottomRight,
              colors: [
                colors.surfaceContainerHighest,
                colors.surfaceContainerHigh,
              ],
            ),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              Container(
                padding: const .all(2),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: .circular(4),
                ),
                child: Icon(
                  Symbols.drag_indicator_rounded,
                  size: 14,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 6),
              if (icon != null) ...[
                Icon(icon, size: 14, color: colors.primary),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Świecący, pionowy znacznik upuszczenia kolumny z okrągłymi pinezkami na końcach.
class _ColumnDropIndicatorMarker extends StatelessWidget {
  const _ColumnDropIndicatorMarker({
    required this.height,
  });

  /// Wysokość znacznika.
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Stack(
        alignment: .center,
        children: [
          // Pionowy słupek ze świetlistym gradientem
          Container(
            width: 3.5,
            height: height - 4,
            decoration: BoxDecoration(
              borderRadius: .circular(2),
              gradient: LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                colors: [
                  colors.primary,
                  colors.primary.withValues(alpha: 0.85),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          // Górna pinezka pozycji
          Positioned(
            top: 0,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          // Dolna pinezka pozycji
          Positioned(
            bottom: 0,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
