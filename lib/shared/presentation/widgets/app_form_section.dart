import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:flutter/material.dart';

/// Pojedynczy element siatki w [AppFormSection].
///
/// Pozwala ustawic szerokosc pola niezaleznie dla mobilki/tabletu/desktopu.
class AppFormSectionItem {
  const AppFormSectionItem({
    required this.child,
    this.mobileSpan = 1,
    this.tabletSpan = 1,
    this.desktopSpan = 1,
    this.height,
  }) : assert(mobileSpan > 0, 'mobileSpan must be positive'),
       assert(tabletSpan > 0, 'tabletSpan must be positive'),
       assert(desktopSpan > 0, 'desktopSpan must be positive');

  final Widget child;
  final int mobileSpan;
  final int tabletSpan;
  final int desktopSpan;
  final double? height;
}

/// Sekcja formularza do ekranow CRM/web.
///
/// Komponent laczy:
/// - naglowek (tytul + opis + opcjonalne akcje),
/// - kontener wizualny sekcji,
/// - responsywna siatke pol (1 kolumna mobile, 2-3 desktop),
/// - walidacje konfiguracji kolumn i spanow.
class AppFormSection extends StatelessWidget {
  AppFormSection({
    required this.title,
    required this.items,
    super.key,
    this.description,
    this.headerActions,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.controlSize = AppControlSize.small,
    this.columnSpacing = Sizes.p12,
    this.rowSpacing = Sizes.p12,
    this.defaultItemHeight,
    this.padding = const EdgeInsets.all(Sizes.p16),
  }) : assert(mobileColumns > 0, 'mobileColumns must be positive'),
       assert(tabletColumns > 0, 'tabletColumns must be positive'),
       assert(
         desktopColumns == 2 || desktopColumns == 3,
         'desktopColumns must be 2 or 3',
       ),
       assert(
         _validateItemSpans(
           items: items,
           mobileColumns: mobileColumns,
           tabletColumns: tabletColumns,
           desktopColumns: desktopColumns,
         ),
         'Item span exceeds total columns',
       );

  final String title;
  final String? description;
  final Widget? headerActions;
  final List<AppFormSectionItem> items;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final AppControlSize controlSize;
  final double columnSpacing;
  final double rowSpacing;
  final double? defaultItemHeight;
  final EdgeInsetsGeometry padding;

  static bool _validateItemSpans({
    required List<AppFormSectionItem> items,
    required int mobileColumns,
    required int tabletColumns,
    required int desktopColumns,
  }) {
    for (final item in items) {
      if (item.mobileSpan > mobileColumns) {
        return false;
      }
      if (item.tabletSpan > tabletColumns) {
        return false;
      }
      if (item.desktopSpan > desktopColumns) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = switch (width) {
            < 760 => mobileColumns,
            < 1280 => tabletColumns,
            _ => desktopColumns,
          };

          final usableWidth = width.isFinite
              ? width
              : MediaQuery.sizeOf(context).width;
          final totalSpacing = columnSpacing * (columns - 1);
          final baseCellWidth = (usableWidth - totalSpacing) / columns;

          return Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          title,
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: .w700,
                          ),
                        ),
                        if (description case final message?) ...[
                          Gaps.h4,
                          Text(
                            message,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (headerActions case final actions?) ...[Gaps.w12, actions],
                ],
              ),
              Gaps.h16,
              Wrap(
                spacing: columnSpacing,
                runSpacing: rowSpacing,
                children: [
                  for (final item in items)
                    SizedBox(
                      width: _resolveItemWidth(
                        item: item,
                        columns: columns,
                        baseCellWidth: baseCellWidth,
                      ),
                      height: item.height ?? defaultItemHeight,
                      child: item.child,
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  double _resolveItemWidth({
    required AppFormSectionItem item,
    required int columns,
    required double baseCellWidth,
  }) {
    final span = switch (columns) {
      1 => item.mobileSpan,
      2 => item.tabletSpan,
      _ => item.desktopSpan,
    };
    return baseCellWidth * span + columnSpacing * (span - 1);
  }
}
