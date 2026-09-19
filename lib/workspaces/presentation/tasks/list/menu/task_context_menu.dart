import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/workspace_context_menu.dart';
import 'package:flutter/material.dart';

/// Zunifikowane pozycje i style menu kontekstowego tabeli zadań.
///
/// Zapewnia spójną, produktową typografię (wyszarzony, mały tekst),
/// jednolitą wysokość wiersza (32px) oraz stałe marginesy i obramowania
/// we wszystkich pickerach tabeli zadań.
abstract final class TaskContextMenu {
  /// Wyświetla menu kontekstowe zoptymalizowane pod gęste tabele zadań.
  static Future<T?> show<T>(
    BuildContext context, {
    required RelativeRect position,
    required List<PopupMenuEntry<T>> items,
    BoxConstraints? constraints,
  }) => WorkspaceContextMenu.select<T>(
    context,
    position: position,
    items: items,
    constraints: constraints,
  );

  /// Oblicza pozycję menu kontekstowego względem głównego overlayu aplikacji.
  static RelativeRect positionFor(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    final overlayBox = overlay?.context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlayBox == null) {
      return RelativeRect.fill;
    }
    final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    return RelativeRect.fromRect(rect, Offset.zero & overlayBox.size);
  }
}

/// Standaryzowany element pojedynczej pozycji menu kontekstowego tabeli.
class TaskContextMenuItem<T> extends PopupMenuItem<T> {
  TaskContextMenuItem({
    super.key,
    required super.value,
    required String title,
    IconData? icon,
    Color? iconColor,
    bool isSelected = false,
    Widget? leading,
    Widget? trailing,
  }) : super(
         height: 32,
         padding: const EdgeInsets.symmetric(horizontal: 10),
         child: Builder(
           builder: (context) {
             final colors = context.colors;
             final text = context.text;
             final defaultIconColor = colors.onSurfaceVariant.withValues(
               alpha: 0.7,
             );

             return Row(
               children: [
                 if (leading != null) ...[
                   leading,
                   const SizedBox(width: 8),
                 ] else if (icon != null) ...[
                   Icon(
                     icon,
                     size: 14,
                     color: isSelected
                         ? (iconColor ?? colors.primary)
                         : (iconColor ?? defaultIconColor),
                   ),
                   const SizedBox(width: 8),
                 ],
                 Expanded(
                   child: Text(
                     title,
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                     style: text.bodySmall?.copyWith(
                       fontSize: 12,
                       color: isSelected ? colors.primary : colors.onSurface,
                       fontWeight: isSelected
                           ? FontWeight.w600
                           : FontWeight.w400,
                     ),
                   ),
                 ),
                 ?trailing,
               ],
             );
           },
         ),
       );
}

/// Standaryzowany nagłówek sekcji w menu kontekstowym.
class TaskContextMenuHeader<T> extends PopupMenuEntry<T> {
  const TaskContextMenuHeader({required this.title, super.key});

  final String title;

  @override
  double get height => 26;

  @override
  bool represents(T? value) => false;

  @override
  State<TaskContextMenuHeader<T>> createState() =>
      _TaskContextMenuHeaderState<T>();
}

class _TaskContextMenuHeaderState<T> extends State<TaskContextMenuHeader<T>> {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: Text(
      widget.title.toUpperCase(),
      style: context.text.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    ),
  );
}

/// Standaryzowany separator w menu kontekstowym tabeli.
class TaskContextMenuDivider extends PopupMenuDivider {
  const TaskContextMenuDivider({super.key}) : super(height: 5);
}
