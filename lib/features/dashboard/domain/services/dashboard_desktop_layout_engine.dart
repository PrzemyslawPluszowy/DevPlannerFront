import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';

/// Wspólna geometria pulpitu używana przez skróty i widgety.
abstract final class DashboardDesktopGeometry {
  /// Lewy margines siatki pulpitu.
  static const double paddingX = 24;

  /// Górny margines siatki pulpitu.
  static const double paddingY = 24;

  /// Szerokość logicznej komórki pulpitu.
  static const double cellWidth = 38;

  /// Wysokość logicznej komórki pulpitu.
  static const double cellHeight = 42;

  /// Odstęp pomiędzy komórkami pulpitu.
  static const double spacing = 8;

  /// Historyczny odstęp starej siatki używany do zachowania dawnych gabarytów.
  static const double legacyWidgetSpacing = 16;

  /// Szerokość skrótu wyrażona w logicznych kolumnach siatki.
  static const int shortcutSpanWidth = 2;

  /// Wysokość skrótu wyrażona w logicznych wierszach siatki.
  static const int shortcutSpanHeight = 2;

  /// Bazowy krok poziomy siatki.
  static const double baseStrideX = cellWidth + spacing;

  /// Bazowy krok pionowy siatki.
  static const double baseStrideY = cellHeight + spacing;

  /// Domyślny rozmiar roboczy przy normalizacji danych zapisanych lokalnie.
  static const Size fallbackDesktopSize = Size(1920, 1080);

  /// Wizualna szerokość ikony skrótu.
  static double get shortcutWidth => widgetWidthPx(shortcutSpanWidth);

  /// Wizualna wysokość ikony skrótu.
  static double get shortcutHeight => widgetHeightPx(shortcutSpanHeight);

  /// Krok poziomy siatki dopasowany dynamicznie do szerokości ekranu, aby wyeliminować martwe marginesy.
  static double cellStrideX([Size? desktopSize]) {
    if (desktopSize == null || desktopSize.width <= 0) {
      return baseStrideX;
    }
    final cols = maxColumnsForDesktop(desktopSize);
    final usableWidth =
        desktopSize.width - (paddingX * 2) + legacyWidgetSpacing;
    return usableWidth / cols;
  }

  /// Krok pionowy siatki dopasowany dynamicznie do wysokości ekranu, aby wyeliminować martwe marginesy.
  static double cellStrideY([Size? desktopSize]) {
    if (desktopSize == null || desktopSize.height <= 0) {
      return baseStrideY;
    }
    final rows = maxRowsForDesktop(desktopSize);
    final usableHeight =
        desktopSize.height - (paddingY * 2) + legacyWidgetSpacing;
    return usableHeight / rows;
  }

  /// Zwraca szerokość widgetu w pikselach.
  static double widgetWidthPx(int width, [Size? desktopSize]) {
    if (width <= 0) {
      return 0;
    }
    return (width * cellStrideX(desktopSize)) - legacyWidgetSpacing;
  }

  /// Zwraca wysokość widgetu w pikselach.
  static double widgetHeightPx(int height, [Size? desktopSize]) {
    if (height <= 0) {
      return 0;
    }
    return (height * cellStrideY(desktopSize)) - legacyWidgetSpacing;
  }

  /// Zwraca pozycję lewego górnego rogu komórki siatki.
  static Offset cellOffset(int col, int row, [Size? desktopSize]) {
    return Offset(
      paddingX + (col * cellStrideX(desktopSize)),
      paddingY + (row * cellStrideY(desktopSize)),
    );
  }

  /// Wyznacza najbliższą komórkę siatki dla zadanej pozycji pikselowej.
  static ({int col, int row}) offsetToCell(
    Offset offset, {
    int spanWidth = 1,
    int spanHeight = 1,
    Size? desktopSize,
  }) {
    final strideX = cellStrideX(desktopSize);
    final strideY = cellStrideY(desktopSize);
    final normalizedDx = (offset.dx - paddingX) / strideX;
    final normalizedDy = (offset.dy - paddingY) / strideY;

    var targetCol = normalizedDx.round();
    var targetRow = normalizedDy.round();

    if (desktopSize != null) {
      final maxCol = math.max(0, maxColumnsForDesktop(desktopSize) - spanWidth);
      final maxRow = math.max(0, maxRowsForDesktop(desktopSize) - spanHeight);
      targetCol = targetCol.clamp(0, maxCol);
      targetRow = targetRow.clamp(0, maxRow);
    } else {
      targetCol = targetCol.clamp(0, 999);
      targetRow = targetRow.clamp(0, 999);
    }

    return (
      col: targetCol,
      row: targetRow,
    );
  }

  /// Normalizuje numer kolumny do aktualnych granic pulpitu.
  static int clampColumn(int col, Size desktopSize) {
    return col.clamp(0, math.max(0, maxColumnsForDesktop(desktopSize) - 1));
  }

  /// Normalizuje numer kolumny z uwzględnieniem szerokości elementu.
  static int clampColumnForSpan(int col, int spanWidth, Size desktopSize) {
    final maxCol = math.max(0, maxColumnsForDesktop(desktopSize) - spanWidth);
    return col.clamp(0, maxCol);
  }

  /// Normalizuje numer wiersza do aktualnych granic pulpitu.
  static int clampRow(int row, Size desktopSize) {
    return row.clamp(0, math.max(0, maxRowsForDesktop(desktopSize) - 1));
  }

  /// Normalizuje numer wiersza z uwzględnieniem wysokości elementu.
  static int clampRowForSpan(int row, int spanHeight, Size desktopSize) {
    final maxRow = math.max(0, maxRowsForDesktop(desktopSize) - spanHeight);
    return row.clamp(0, maxRow);
  }

  /// Zwraca maksymalną liczbę kolumn, które mieszczą się na pulpicie.
  static int maxColumnsForDesktop(Size desktopSize) {
    final usableWidth =
        desktopSize.width - (paddingX * 2) + legacyWidgetSpacing;
    return (usableWidth / baseStrideX).floor().clamp(1, 999);
  }

  /// Zwraca maksymalną liczbę wierszy, które mieszczą się na pulpicie.
  static int maxRowsForDesktop(Size desktopSize) {
    final usableHeight =
        desktopSize.height - (paddingY * 2) + legacyWidgetSpacing;
    return (usableHeight / baseStrideY).floor().clamp(1, 999);
  }
}

/// Wynik przeliczenia układu pulpitu.
class DashboardDesktopLayoutResult {
  /// Tworzy wynik układu pulpitu.
  const DashboardDesktopLayoutResult({
    required this.widgets,
    required this.shortcuts,
    this.overflowedWidgets = const [],
    this.overflowedShortcuts = const [],
  });

  /// Przeliczone widgety pulpitu.
  final List<DashboardWidgetPreference> widgets;

  /// Przeliczone skróty pulpitu.
  final List<DashboardShortcutPreference> shortcuts;

  /// Widgety, które nie zmieściły się na pulpicie.
  final List<DashboardWidgetPreference> overflowedWidgets;

  /// Skróty, które nie zmieściły się na pulpicie.
  final List<DashboardShortcutPreference> overflowedShortcuts;
}

/// Silnik odpowiedzialny za układ elementów pulpitu na siatce.
abstract final class DashboardDesktopLayoutEngine {
  /// Normalizuje cały układ zapisanych danych pulpitu.
  static DashboardDesktopLayoutResult normalize({
    required DashboardPreferences preferences,
    required Size desktopSize,
  }) {
    final occupiedCells = <String>{};
    final overflowedShortcuts = <DashboardShortcutPreference>[];
    final overflowedWidgets = <DashboardWidgetPreference>[];

    final normalizedShortcuts = _normalizeShortcuts(
      shortcuts: preferences.shortcuts,
      desktopSize: desktopSize,
      occupiedCells: occupiedCells,
      overflowed: overflowedShortcuts,
    );
    final normalizedWidgets = _normalizeWidgets(
      widgets: preferences.widgets,
      desktopSize: desktopSize,
      occupiedCells: occupiedCells,
      overflowed: overflowedWidgets,
    );

    return DashboardDesktopLayoutResult(
      widgets: normalizedWidgets,
      shortcuts: normalizedShortcuts,
      overflowedWidgets: overflowedWidgets,
      overflowedShortcuts: overflowedShortcuts,
    );
  }

  /// Automatycznie grupuje wszystkie elementy na pulpicie zaczynając od lewego górnego rogu.
  static DashboardDesktopLayoutResult autoArrange({
    required DashboardPreferences preferences,
    required Size desktopSize,
  }) {
    final occupiedCells = <String>{};
    final overflowedShortcuts = <DashboardShortcutPreference>[];
    final overflowedWidgets = <DashboardWidgetPreference>[];
    final nextShortcuts = <DashboardShortcutPreference>[];
    final nextWidgets = <DashboardWidgetPreference>[];

    // Najpierw przypnijmy duże widgety
    for (final widget in preferences.widgets) {
      final targetCell = _findNearestFreeCell(
        occupiedCells: occupiedCells,
        desiredCell: (col: 0, row: 0),
        span: (width: widget.width, height: widget.height),
        desktopSize: desktopSize,
      );

      if (targetCell != null) {
        nextWidgets.add(
          widget.copyWith(
            gridColumn: targetCell.col,
            gridRow: targetCell.row,
            exactDx: null,
            exactDy: null,
          ),
        );
        _occupyCells(
          occupiedCells,
          col: targetCell.col,
          row: targetCell.row,
          width: widget.width,
          height: widget.height,
        );
      } else {
        overflowedWidgets.add(widget);
      }
    }

    // Następnie ułóżmy skróty
    for (final shortcut in preferences.shortcuts) {
      if (!shortcut.isVisible) {
        nextShortcuts.add(shortcut);
        continue;
      }

      final targetCell = _findNearestFreeCell(
        occupiedCells: occupiedCells,
        desiredCell: (col: 0, row: 0),
        span: (
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
        desktopSize: desktopSize,
        candidateStep: (
          col: DashboardDesktopGeometry.shortcutSpanWidth,
          row: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
      );

      if (targetCell != null) {
        nextShortcuts.add(
          shortcut.copyWith(
            gridColumn: targetCell.col,
            gridRow: targetCell.row,
            exactDx: null,
            exactDy: null,
          ),
        );
        _occupyCells(
          occupiedCells,
          col: targetCell.col,
          row: targetCell.row,
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        );
      } else {
        overflowedShortcuts.add(shortcut);
      }
    }

    return DashboardDesktopLayoutResult(
      widgets: nextWidgets,
      shortcuts: _withNormalizedPositions(nextShortcuts),
      overflowedWidgets: overflowedWidgets,
      overflowedShortcuts: overflowedShortcuts,
    );
  }

  /// Dodaje widget do układu, jeśli istnieje dla niego wolne miejsce.
  static DashboardDesktopLayoutResult? placeWidget({
    required DashboardPreferences preferences,
    required DashboardWidgetPreference widget,
    required Size desktopSize,
  }) {
    final occupiedCells = _occupiedCellsForLayout(
      widgets: preferences.widgets,
      shortcuts: preferences.shortcuts,
    );
    final targetCell = _findNearestFreeCell(
      occupiedCells: occupiedCells,
      desiredCell: (col: widget.gridColumn, row: widget.gridRow),
      span: (width: widget.width, height: widget.height),
      desktopSize: desktopSize,
    );
    if (targetCell == null) {
      return null;
    }

    return DashboardDesktopLayoutResult(
      widgets: [
        ...preferences.widgets,
        widget.copyWith(
          gridColumn: targetCell.col,
          gridRow: targetCell.row,
        ),
      ],
      shortcuts: preferences.shortcuts,
    );
  }

  /// Przesuwa widget i relokuje elementy zajmujące docelowy obszar.
  static DashboardDesktopLayoutResult moveWidget({
    required DashboardPreferences preferences,
    required String widgetId,
    required int gridColumn,
    required int gridRow,
    double? exactDx,
    double? exactDy,
    required Size desktopSize,
  }) {
    DashboardWidgetPreference? targetWidget;
    for (final widget in preferences.widgets) {
      if (widget.id == widgetId) {
        targetWidget = widget;
        break;
      }
    }
    if (targetWidget == null) {
      return normalize(preferences: preferences, desktopSize: desktopSize);
    }

    final desiredCell = (
      col: DashboardDesktopGeometry.clampColumnForSpan(
        gridColumn,
        targetWidget.width,
        desktopSize,
      ),
      row: DashboardDesktopGeometry.clampRowForSpan(
        gridRow,
        targetWidget.height,
        desktopSize,
      ),
    );
    if (!_canPlaceAt(
      occupiedCells: const {},
      col: desiredCell.col,
      row: desiredCell.row,
      width: targetWidget.width,
      height: targetWidget.height,
      desktopSize: desktopSize,
    )) {
      return DashboardDesktopLayoutResult(
        widgets: preferences.widgets,
        shortcuts: preferences.shortcuts,
      );
    }

    final movedWidget = targetWidget.copyWith(
      gridColumn: desiredCell.col,
      gridRow: desiredCell.row,
      exactDx: exactDx,
      exactDy: exactDy,
    );

    if (!preferences.snapToGrid) {
      final nextWidgets = preferences.widgets.map((w) {
        return w.id == widgetId ? movedWidget : w;
      }).toList();

      return DashboardDesktopLayoutResult(
        widgets: nextWidgets,
        shortcuts: preferences.shortcuts,
      );
    }

    return _relayoutWithPinnedElement(
      preferences: preferences,
      desktopSize: desktopSize,
      pinnedWidget: movedWidget,
    );
  }

  /// Zmienia rozmiar widgetu i utrzymuje poprawny układ siatki.
  static DashboardDesktopLayoutResult resizeWidget({
    required DashboardPreferences preferences,
    required String widgetId,
    required int width,
    required int height,
    required Size desktopSize,
  }) {
    final nextWidgets = [
      for (final widget in preferences.widgets)
        if (widget.id == widgetId)
          widget.copyWith(
            width: width,
            height: height,
            preferredWidth: width,
            preferredHeight: height,
          )
        else
          widget,
    ];

    return normalize(
      preferences: preferences.copyWith(widgets: nextWidgets),
      desktopSize: desktopSize,
    );
  }

  /// Pokazuje skrót i znajduje dla niego najbliższy wolny slot.
  static DashboardDesktopLayoutResult showShortcut({
    required DashboardPreferences preferences,
    required String shortcutId,
    required Size desktopSize,
    int? gridColumn,
    int? gridRow,
  }) {
    DashboardShortcutPreference? targetShortcut;
    final otherShortcuts = <DashboardShortcutPreference>[];

    for (final shortcut in preferences.shortcuts) {
      if (shortcut.shortcutId == shortcutId) {
        targetShortcut = shortcut.copyWith(
          isVisible: true,
          gridColumn: gridColumn ?? shortcut.gridColumn,
          gridRow: gridRow ?? shortcut.gridRow,
        );
      } else {
        otherShortcuts.add(shortcut);
      }
    }

    if (targetShortcut == null) {
      return normalize(preferences: preferences, desktopSize: desktopSize);
    }

    final occupiedCells = _occupiedCellsForLayout(
      widgets: preferences.widgets,
      shortcuts: otherShortcuts,
    );
    final targetCell = _findNearestFreeCell(
      occupiedCells: occupiedCells,
      desiredCell: _normalizeShortcutCell(
        col: targetShortcut.gridColumn,
        row: targetShortcut.gridRow,
        desktopSize: desktopSize,
      ),
      span: (
        width: DashboardDesktopGeometry.shortcutSpanWidth,
        height: DashboardDesktopGeometry.shortcutSpanHeight,
      ),
      desktopSize: desktopSize,
      candidateStep: (
        col: DashboardDesktopGeometry.shortcutSpanWidth,
        row: DashboardDesktopGeometry.shortcutSpanHeight,
      ),
    );
    if (targetCell == null) {
      return DashboardDesktopLayoutResult(
        widgets: preferences.widgets,
        shortcuts: preferences.shortcuts,
      );
    }

    final nextShortcuts = [
      targetShortcut.copyWith(
        gridColumn: targetCell.col,
        gridRow: targetCell.row,
      ),
      ...otherShortcuts,
    ];

    return DashboardDesktopLayoutResult(
      widgets: preferences.widgets,
      shortcuts: _withNormalizedPositions(nextShortcuts),
    );
  }

  /// Przesuwa skrót i relokuje elementy zajmujące docelową komórkę.
  static DashboardDesktopLayoutResult moveShortcut({
    required DashboardPreferences preferences,
    required String shortcutId,
    required int gridColumn,
    required int gridRow,
    double? exactDx,
    double? exactDy,
    required Size desktopSize,
  }) {
    DashboardShortcutPreference? targetShortcut;
    for (final shortcut in preferences.shortcuts) {
      if (shortcut.shortcutId == shortcutId) {
        targetShortcut = shortcut;
        break;
      }
    }

    if (targetShortcut == null) {
      return normalize(preferences: preferences, desktopSize: desktopSize);
    }

    final desiredCell = _normalizeShortcutCell(
      col: gridColumn,
      row: gridRow,
      desktopSize: desktopSize,
    );
    if (!_canPlaceAt(
      occupiedCells: const {},
      col: desiredCell.col,
      row: desiredCell.row,
      width: DashboardDesktopGeometry.shortcutSpanWidth,
      height: DashboardDesktopGeometry.shortcutSpanHeight,
      desktopSize: desktopSize,
    )) {
      return DashboardDesktopLayoutResult(
        widgets: preferences.widgets,
        shortcuts: preferences.shortcuts,
      );
    }

    final movedShortcut = targetShortcut.copyWith(
      gridColumn: desiredCell.col,
      gridRow: desiredCell.row,
      exactDx: exactDx,
      exactDy: exactDy,
    );

    if (!preferences.snapToGrid) {
      final nextShortcuts = preferences.shortcuts.map((s) {
        return s.shortcutId == shortcutId ? movedShortcut : s;
      }).toList();

      return DashboardDesktopLayoutResult(
        widgets: preferences.widgets,
        shortcuts: nextShortcuts,
      );
    }

    return _relayoutWithPinnedElement(
      preferences: preferences,
      desktopSize: desktopSize,
      pinnedShortcut: movedShortcut,
    );
  }

  static DashboardDesktopLayoutResult _relayoutWithPinnedElement({
    required DashboardPreferences preferences,
    required Size desktopSize,
    DashboardWidgetPreference? pinnedWidget,
    DashboardShortcutPreference? pinnedShortcut,
  }) {
    assert(
      (pinnedWidget == null) != (pinnedShortcut == null),
      'Dokładnie jeden element musi być przypięty podczas relokacji.',
    );

    final pinnedArea = pinnedWidget == null
        ? (
            col: pinnedShortcut!.gridColumn,
            row: pinnedShortcut.gridRow,
            width: DashboardDesktopGeometry.shortcutSpanWidth,
            height: DashboardDesktopGeometry.shortcutSpanHeight,
          )
        : (
            col: pinnedWidget.gridColumn,
            row: pinnedWidget.gridRow,
            width: pinnedWidget.width,
            height: pinnedWidget.height,
          );

    ({int col, int row})? originalWidgetLocation;
    if (pinnedWidget != null) {
      for (final w in preferences.widgets) {
        if (w.id == pinnedWidget.id) {
          originalWidgetLocation = (col: w.gridColumn, row: w.gridRow);
          break;
        }
      }
    }
    final occupiedCells = <String>{};
    _occupyCells(
      occupiedCells,
      col: pinnedArea.col,
      row: pinnedArea.row,
      width: pinnedArea.width,
      height: pinnedArea.height,
    );

    final nextWidgets = <DashboardWidgetPreference>[];
    final displacedWidgets = <DashboardWidgetPreference>[];
    for (final widget in preferences.widgets) {
      if (widget.id == pinnedWidget?.id) {
        nextWidgets.add(pinnedWidget!);
      } else if (_areasOverlap(
        first: pinnedArea,
        second: (
          col: widget.gridColumn,
          row: widget.gridRow,
          width: widget.width,
          height: widget.height,
        ),
      )) {
        displacedWidgets.add(widget);
      } else {
        nextWidgets.add(widget);
        _occupyCells(
          occupiedCells,
          col: widget.gridColumn,
          row: widget.gridRow,
          width: widget.width,
          height: widget.height,
        );
      }
    }

    final nextShortcuts = <DashboardShortcutPreference>[];
    final displacedShortcuts = <DashboardShortcutPreference>[];
    for (final shortcut in preferences.shortcuts) {
      if (!shortcut.isVisible) {
        nextShortcuts.add(shortcut);
      } else if (shortcut.shortcutId == pinnedShortcut?.shortcutId) {
        nextShortcuts.add(pinnedShortcut!);
      } else if (_areasOverlap(
        first: pinnedArea,
        second: (
          col: shortcut.gridColumn,
          row: shortcut.gridRow,
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
      )) {
        displacedShortcuts.add(shortcut);
      } else {
        nextShortcuts.add(shortcut);
        _occupyCells(
          occupiedCells,
          col: shortcut.gridColumn,
          row: shortcut.gridRow,
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        );
      }
    }

    for (final shortcut in displacedShortcuts) {
      var targetCell = _findNearestFreeCell(
        occupiedCells: occupiedCells,
        desiredCell: (col: shortcut.gridColumn, row: shortcut.gridRow),
        span: (
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
        desktopSize: desktopSize,
        candidateStep: (
          col: DashboardDesktopGeometry.shortcutSpanWidth,
          row: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
      );
      targetCell ??= _findNearestFreeCell(
        occupiedCells: occupiedCells,
        desiredCell: (col: shortcut.gridColumn, row: shortcut.gridRow),
        span: (
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
        desktopSize: desktopSize,
      );
      targetCell ??= _findFirstFreeCell(
        occupiedCells: occupiedCells,
        span: (
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
        desktopSize: desktopSize,
      );

      if (targetCell != null) {
        nextShortcuts.add(
          shortcut.copyWith(
            gridColumn: targetCell.col,
            gridRow: targetCell.row,
          ),
        );
        _occupyCells(
          occupiedCells,
          col: targetCell.col,
          row: targetCell.row,
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        );
      } else {
        nextShortcuts.add(shortcut);
      }
    }

    for (final widget in displacedWidgets) {
      // 1. Sprawdzamy czy zmieści się w pobliżu swojej starej pozycji
      var targetCell = _findNearestFreeCell(
        occupiedCells: occupiedCells,
        desiredCell: (col: widget.gridColumn, row: widget.gridRow),
        span: (width: widget.width, height: widget.height),
        desktopSize: desktopSize,
      );

      // 2. Sprawdzamy swap na pierwotnej pozycji przesuwanego elementu
      if (targetCell == null && originalWidgetLocation != null) {
        if (_canPlaceAt(
          occupiedCells: occupiedCells,
          col: originalWidgetLocation.col,
          row: originalWidgetLocation.row,
          width: widget.width,
          height: widget.height,
          desktopSize: desktopSize,
        )) {
          targetCell = originalWidgetLocation;
        }
      }

      // 3. Sprawdzamy pierwsze wolne miejsce na pulpicie
      targetCell ??= _findFirstFreeCell(
        occupiedCells: occupiedCells,
        span: (width: widget.width, height: widget.height),
        desktopSize: desktopSize,
      );

      if (targetCell != null) {
        nextWidgets.add(
          widget.copyWith(
            gridColumn: targetCell.col,
            gridRow: targetCell.row,
          ),
        );
        _occupyCells(
          occupiedCells,
          col: targetCell.col,
          row: targetCell.row,
          width: widget.width,
          height: widget.height,
        );
      } else {
        nextWidgets.add(widget);
      }
    }

    final widgetsById = {for (final widget in nextWidgets) widget.id: widget};
    final shortcutsById = {
      for (final shortcut in nextShortcuts) shortcut.shortcutId: shortcut,
    };

    return DashboardDesktopLayoutResult(
      widgets: [
        for (final widget in preferences.widgets) widgetsById[widget.id]!,
      ],
      shortcuts: [
        for (final shortcut in preferences.shortcuts)
          shortcutsById[shortcut.shortcutId]!,
      ],
    );
  }

  static bool _areasOverlap({
    required ({int col, int row, int width, int height}) first,
    required ({int col, int row, int width, int height}) second,
  }) {
    return first.col < second.col + second.width &&
        first.col + first.width > second.col &&
        first.row < second.row + second.height &&
        first.row + first.height > second.row;
  }

  static List<DashboardShortcutPreference> _normalizeShortcuts({
    required List<DashboardShortcutPreference> shortcuts,
    required Size desktopSize,
    required Set<String> occupiedCells,
    required List<DashboardShortcutPreference> overflowed,
  }) {
    final visibleShortcuts = <DashboardShortcutPreference>[
      for (final shortcut in shortcuts)
        if (shortcut.isVisible) shortcut,
    ]..sort((left, right) => left.position.compareTo(right.position));
    final hiddenShortcuts = <DashboardShortcutPreference>[
      for (final shortcut in shortcuts)
        if (!shortcut.isVisible) shortcut,
    ];

    final normalizedVisibleShortcuts = <DashboardShortcutPreference>[];
    for (final shortcut in visibleShortcuts) {
      final targetCell = _findNearestFreeCell(
        occupiedCells: occupiedCells,
        desiredCell: _normalizeShortcutCell(
          col: shortcut.gridColumn,
          row: shortcut.gridRow,
          desktopSize: desktopSize,
        ),
        span: (
          width: DashboardDesktopGeometry.shortcutSpanWidth,
          height: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
        desktopSize: desktopSize,
        candidateStep: (
          col: DashboardDesktopGeometry.shortcutSpanWidth,
          row: DashboardDesktopGeometry.shortcutSpanHeight,
        ),
      );
      if (targetCell == null) {
        overflowed.add(shortcut);
        normalizedVisibleShortcuts.add(shortcut.copyWith(isVisible: false));
        continue;
      }

      _occupyCells(
        occupiedCells,
        col: targetCell.col,
        row: targetCell.row,
        width: DashboardDesktopGeometry.shortcutSpanWidth,
        height: DashboardDesktopGeometry.shortcutSpanHeight,
      );
      normalizedVisibleShortcuts.add(
        shortcut.copyWith(
          gridColumn: targetCell.col,
          gridRow: targetCell.row,
        ),
      );
    }

    return _withNormalizedPositions([
      ...normalizedVisibleShortcuts,
      ...hiddenShortcuts,
    ]);
  }

  static List<DashboardWidgetPreference> _normalizeWidgets({
    required List<DashboardWidgetPreference> widgets,
    required Size desktopSize,
    required Set<String> occupiedCells,
    required List<DashboardWidgetPreference> overflowed,
  }) {
    final normalizedWidgets = <DashboardWidgetPreference>[];
    final maxRows = DashboardDesktopGeometry.maxRowsForDesktop(desktopSize);
    final maxCols = DashboardDesktopGeometry.maxColumnsForDesktop(desktopSize);

    for (final rawWidget in widgets) {
      final preferredW = rawWidget.preferredWidth ?? rawWidget.width;
      final preferredH = rawWidget.preferredHeight ?? rawWidget.height;

      // 1. Auto-Restore: Jeśli preferowany rozmiar mieści się na ekranie, spróbujmy go przywrócić
      var effectiveW = rawWidget.width;
      var effectiveH = rawWidget.height;

      if (preferredW <= maxCols && preferredH <= maxRows) {
        effectiveW = preferredW;
        effectiveH = preferredH;
      }

      // 2. Auto-Downscale: Jeśli rozmiar przekracza wymiary ekranu, zmniejszmy wysokość/szerokość
      if (effectiveH > maxRows) {
        if (14 <= maxRows && effectiveH > 14) {
          effectiveH = 14;
        } else if (12 <= maxRows && effectiveH > 12) {
          effectiveH = 12;
        } else if (8 <= maxRows && effectiveH > 8) {
          effectiveH = 8;
        } else {
          effectiveH = math.max(2, maxRows);
        }
      }
      if (effectiveW > maxCols) {
        effectiveW = math.max(2, maxCols);
      }

      var widget = rawWidget.copyWith(
        width: effectiveW,
        height: effectiveH,
        preferredWidth: preferredW,
        preferredHeight: preferredH,
      );

      var targetCell = _findNearestFreeCell(
        occupiedCells: occupiedCells,
        desiredCell: (
          col: DashboardDesktopGeometry.clampColumnForSpan(
            widget.gridColumn,
            widget.width,
            desktopSize,
          ),
          row: DashboardDesktopGeometry.clampRowForSpan(
            widget.gridRow,
            widget.height,
            desktopSize,
          ),
        ),
        span: (width: widget.width, height: widget.height),
        desktopSize: desktopSize,
      );

      // 3. Fallback Downscale: Jeśli brak miejsca w pełnym rozmiarze, spróbuj mniejszych wspieranych wysokości
      if (targetCell == null && widget.height > 8) {
        final fallbackHeights = [14, 12, 8].where((h) => h < widget.height && h <= maxRows);
        for (final fallbackH in fallbackHeights) {
          final downscaledWidget = widget.copyWith(height: fallbackH);
          final candidateCell = _findNearestFreeCell(
            occupiedCells: occupiedCells,
            desiredCell: (
              col: DashboardDesktopGeometry.clampColumnForSpan(
                downscaledWidget.gridColumn,
                downscaledWidget.width,
                desktopSize,
              ),
              row: DashboardDesktopGeometry.clampRowForSpan(
                downscaledWidget.gridRow,
                downscaledWidget.height,
                desktopSize,
              ),
            ),
            span: (width: downscaledWidget.width, height: downscaledWidget.height),
            desktopSize: desktopSize,
          );
          if (candidateCell != null) {
            targetCell = candidateCell;
            widget = downscaledWidget;
            break;
          }
        }
      }

      if (targetCell == null) {
        overflowed.add(widget);
        continue;
      }

      _occupyCells(
        occupiedCells,
        col: targetCell.col,
        row: targetCell.row,
        width: widget.width,
        height: widget.height,
      );
      normalizedWidgets.add(
        widget.copyWith(
          gridColumn: targetCell.col,
          gridRow: targetCell.row,
        ),
      );
    }

    return normalizedWidgets;
  }

  static ({int col, int row})? _findNearestFreeCell({
    required Set<String> occupiedCells,
    required ({int col, int row}) desiredCell,
    required ({int width, int height}) span,
    required Size desktopSize,
    ({int col, int row})? candidateStep,
  }) {
    final maxCols = DashboardDesktopGeometry.maxColumnsForDesktop(desktopSize);
    final maxRows = DashboardDesktopGeometry.maxRowsForDesktop(desktopSize);
    final maxRadius = math.max(maxCols, maxRows);

    for (var radius = 0; radius <= maxRadius; radius++) {
      final minRow = math.max(0, desiredCell.row - radius);
      final maxRow = math.min(maxRows - 1, desiredCell.row + radius);
      final minCol = math.max(0, desiredCell.col - radius);
      final maxCol = math.min(maxCols - 1, desiredCell.col + radius);

      for (var row = minRow; row <= maxRow; row++) {
        for (var col = minCol; col <= maxCol; col++) {
          if (candidateStep != null &&
              !_matchesCandidateGrid(
                col: col,
                row: row,
                span: span,
                candidateStep: candidateStep,
                desktopSize: desktopSize,
              )) {
            continue;
          }

          final distance = math.max(
            (col - desiredCell.col).abs(),
            (row - desiredCell.row).abs(),
          );
          if (distance != radius) {
            continue;
          }

          if (_canPlaceAt(
            occupiedCells: occupiedCells,
            col: col,
            row: row,
            width: span.width,
            height: span.height,
            desktopSize: desktopSize,
          )) {
            return (col: col, row: row);
          }
        }
      }
    }

    return null;
  }

  static ({int col, int row})? _findFirstFreeCell({
    required Set<String> occupiedCells,
    required ({int width, int height}) span,
    required Size desktopSize,
  }) {
    final maxCols = DashboardDesktopGeometry.maxColumnsForDesktop(desktopSize);
    final maxRows = DashboardDesktopGeometry.maxRowsForDesktop(desktopSize);

    for (var row = 0; row <= maxRows - span.height; row++) {
      for (var col = 0; col <= maxCols - span.width; col++) {
        if (_canPlaceAt(
          occupiedCells: occupiedCells,
          col: col,
          row: row,
          width: span.width,
          height: span.height,
          desktopSize: desktopSize,
        )) {
          return (col: col, row: row);
        }
      }
    }

    return null;
  }

  static bool _canPlaceAt({
    required Set<String> occupiedCells,
    required int col,
    required int row,
    required int width,
    required int height,
    required Size desktopSize,
  }) {
    final maxCols = DashboardDesktopGeometry.maxColumnsForDesktop(desktopSize);
    final maxRows = DashboardDesktopGeometry.maxRowsForDesktop(desktopSize);

    if (col < 0 || row < 0 || col + width > maxCols || row + height > maxRows) {
      return false;
    }

    for (var dx = 0; dx < width; dx++) {
      for (var dy = 0; dy < height; dy++) {
        if (occupiedCells.contains(_cellKey(col + dx, row + dy))) {
          return false;
        }
      }
    }

    return true;
  }

  static Set<String> _occupiedCellsForLayout({
    required List<DashboardWidgetPreference> widgets,
    required List<DashboardShortcutPreference> shortcuts,
    String? excludingWidgetId,
    String? excludingShortcutId,
  }) {
    final occupiedCells = <String>{};

    for (final widget in widgets) {
      if (widget.id == excludingWidgetId) {
        continue;
      }
      _occupyCells(
        occupiedCells,
        col: widget.gridColumn,
        row: widget.gridRow,
        width: widget.width,
        height: widget.height,
      );
    }

    for (final shortcut in shortcuts) {
      if (!shortcut.isVisible || shortcut.shortcutId == excludingShortcutId) {
        continue;
      }
      _occupyCells(
        occupiedCells,
        col: shortcut.gridColumn,
        row: shortcut.gridRow,
        width: DashboardDesktopGeometry.shortcutSpanWidth,
        height: DashboardDesktopGeometry.shortcutSpanHeight,
      );
    }

    return occupiedCells;
  }

  static List<DashboardShortcutPreference> _withNormalizedPositions(
    List<DashboardShortcutPreference> shortcuts,
  ) {
    return [
      for (var index = 0; index < shortcuts.length; index++)
        shortcuts[index].copyWith(position: index),
    ];
  }

  static void _occupyCells(
    Set<String> occupiedCells, {
    required int col,
    required int row,
    required int width,
    required int height,
  }) {
    for (var dx = 0; dx < width; dx++) {
      for (var dy = 0; dy < height; dy++) {
        occupiedCells.add(_cellKey(col + dx, row + dy));
      }
    }
  }

  static ({int col, int row}) _normalizeShortcutCell({
    required int col,
    required int row,
    required Size desktopSize,
  }) {
    final maxColumn = math.max(
      0,
      DashboardDesktopGeometry.maxColumnsForDesktop(desktopSize) -
          DashboardDesktopGeometry.shortcutSpanWidth,
    );
    final maxRow = math.max(
      0,
      DashboardDesktopGeometry.maxRowsForDesktop(desktopSize) -
          DashboardDesktopGeometry.shortcutSpanHeight,
    );

    final normalizedCol = _normalizeShortcutAxis(
      value: col,
      maxStart: maxColumn,
      step: DashboardDesktopGeometry.shortcutSpanWidth,
    );
    final normalizedRow = _normalizeShortcutAxis(
      value: row,
      maxStart: maxRow,
      step: DashboardDesktopGeometry.shortcutSpanHeight,
    );

    return (col: normalizedCol, row: normalizedRow);
  }

  static bool _matchesCandidateGrid({
    required int col,
    required int row,
    required ({int width, int height}) span,
    required ({int col, int row}) candidateStep,
    required Size desktopSize,
  }) {
    final maxColumn = math.max(
      0,
      DashboardDesktopGeometry.maxColumnsForDesktop(desktopSize) - span.width,
    );
    final maxRow = math.max(
      0,
      DashboardDesktopGeometry.maxRowsForDesktop(desktopSize) - span.height,
    );

    final matchesColumn = col == maxColumn || col % candidateStep.col == 0;
    final matchesRow = row == maxRow || row % candidateStep.row == 0;

    return matchesColumn && matchesRow;
  }

  static int _normalizeShortcutAxis({
    required int value,
    required int maxStart,
    required int step,
  }) {
    final clampedValue = value.clamp(0, maxStart);
    if (clampedValue == maxStart) {
      return maxStart;
    }

    return (clampedValue ~/ step) * step;
  }

  static String _cellKey(int col, int row) => '$col:$row';
}
