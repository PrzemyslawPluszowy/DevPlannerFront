import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Koordynator płynnego automatycznego przewijania krawędziowego (auto-scroll)
/// dla tablicy Kanban w osi poziomej (tablica) oraz pionowej (aktywna kolumna).
///
/// Implementuje wytyczne punktu 5 audytu Kanban:
/// - Rejestr kontrolera poziomego oraz pionowych kontrolerów kolumn.
/// - Strefa krawędziowa 48 px.
/// - Prędkość skalowana nieliniowo od 80 do 600 px/s w zależności od głębokości wejścia w margines.
/// - Płynny `Ticker` oparty o `delta` czasu klatki, działający także przy nieruchomym kursorze.
/// - Zatrzymanie po zakończeniu lub anulowaniu dragu.
class KanbanAutoScrollCoordinator {
  KanbanAutoScrollCoordinator();

  ScrollController? _boardHorizontalController;
  final Map<Key, _ColumnScrollRegistration> _columns = {};

  Ticker? _ticker;
  Duration _lastFrameTime = Duration.zero;
  Offset? _currentPointerPosition;

  static const double edgeThreshold = 52.0;
  static const double minScrollSpeed = 90.0; // px/s
  static const double maxScrollSpeed = 650.0; // px/s

  /// Rejestruje główny poziomy kontroler tablicy.
  void registerBoardController(ScrollController controller) {
    _boardHorizontalController = controller;
  }

  /// Wyrejestrowuje główny poziomy kontroler tablicy.
  void unregisterBoardController(ScrollController controller) {
    if (_boardHorizontalController == controller) {
      _boardHorizontalController = null;
    }
  }

  /// Rejestruje kontroler pionowy kolumny wraz z jej kontekstem/RenderBoxem.
  void registerColumn({
    required Key columnKey,
    required ScrollController controller,
    required BuildContext context,
  }) {
    _columns[columnKey] = _ColumnScrollRegistration(
      controller: controller,
      context: context,
    );
  }

  /// Wyrejestrowuje kolumnę po jej zniszczeniu (dispose).
  void unregisterColumn(Key columnKey) {
    _columns.remove(columnKey);
  }

  /// Inicjalizuje sesję dragu i uruchamia ticker.
  void startDrag(TickerProvider vsync, Offset initialPosition) {
    _currentPointerPosition = initialPosition;
    _lastFrameTime = Duration.zero;
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = vsync.createTicker(_onTick)..start();
  }

  /// Aktualizuje bieżącą pozycję wskaźnika podczas przeciągania karty.
  void updatePointer(Offset globalPosition) {
    _currentPointerPosition = globalPosition;
  }

  /// Kończy sesję dragu i zatrzymuje ticker.
  void endDrag() {
    _currentPointerPosition = null;
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    _lastFrameTime = Duration.zero;
  }

  void _onTick(Duration elapsed) {
    if (_lastFrameTime == Duration.zero) {
      _lastFrameTime = elapsed;
      return;
    }
    final deltaSeconds = (elapsed - _lastFrameTime).inMicroseconds / 1000000.0;
    _lastFrameTime = elapsed;

    final pointer = _currentPointerPosition;
    if (pointer == null || deltaSeconds <= 0) return;

    _scrollHorizontalIfNeeded(pointer, deltaSeconds);
    _scrollVerticalIfNeeded(pointer, deltaSeconds);
  }

  void _scrollHorizontalIfNeeded(Offset pointer, double deltaSeconds) {
    final controller = _boardHorizontalController;
    if (controller == null || !controller.hasClients) return;

    final position = controller.position;
    final context = position.context.notificationContext;
    final renderBox = context?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final globalOrigin = renderBox.localToGlobal(Offset.zero);
    final boxRect = globalOrigin & renderBox.size;

    // Przewijanie tylko wtedy, gdy wskaźnik znajduje się w pionowym zakresie tablicy
    if (pointer.dy < boxRect.top || pointer.dy > boxRect.bottom) return;

    double velocity = 0;

    // Krawędź lewa
    if (pointer.dx >= boxRect.left &&
        pointer.dx <= boxRect.left + edgeThreshold) {
      final depth = (boxRect.left + edgeThreshold - pointer.dx) / edgeThreshold;
      velocity = -_calculateSpeed(depth);
    }
    // Krawędź prawa
    else if (pointer.dx <= boxRect.right &&
        pointer.dx >= boxRect.right - edgeThreshold) {
      final depth =
          (pointer.dx - (boxRect.right - edgeThreshold)) / edgeThreshold;
      velocity = _calculateSpeed(depth);
    }

    if (velocity != 0) {
      final delta = velocity * deltaSeconds;
      final newOffset = (controller.offset + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      if (newOffset != controller.offset) {
        controller.jumpTo(newOffset);
      }
    }
  }

  void _scrollVerticalIfNeeded(Offset pointer, double deltaSeconds) {
    for (final reg in _columns.values) {
      if (!reg.controller.hasClients) continue;
      final renderBox = reg.context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) continue;

      final origin = renderBox.localToGlobal(Offset.zero);
      final columnRect = origin & renderBox.size;

      // Sprawdzamy, czy wskaźnik znajduje się w obrębie poziomego pasa kolumny
      if (pointer.dx >= columnRect.left && pointer.dx <= columnRect.right) {
        final position = reg.controller.position;
        double velocity = 0;

        // Krawędź górna kolumny
        if (pointer.dy >= columnRect.top &&
            pointer.dy <= columnRect.top + edgeThreshold) {
          final depth =
              (columnRect.top + edgeThreshold - pointer.dy) / edgeThreshold;
          velocity = -_calculateSpeed(depth);
        }
        // Krawędź dolna kolumny
        else if (pointer.dy <= columnRect.bottom &&
            pointer.dy >= columnRect.bottom - edgeThreshold) {
          final depth =
              (pointer.dy - (columnRect.bottom - edgeThreshold)) /
              edgeThreshold;
          velocity = _calculateSpeed(depth);
        }

        if (velocity != 0) {
          final delta = velocity * deltaSeconds;
          final newOffset = (reg.controller.offset + delta).clamp(
            position.minScrollExtent,
            position.maxScrollExtent,
          );
          if (newOffset != reg.controller.offset) {
            reg.controller.jumpTo(newOffset);
          }
        }
        break; // Tylko jedna kolumna pod wskaźnikiem
      }
    }
  }

  double _calculateSpeed(double normalizedDepth) {
    final clamped = normalizedDepth.clamp(0.0, 1.0);
    // Nieliniowa krzywa kwadratowa dla płynnego startu i szybkiego przewijania na samej krawędzi
    final curve = math.pow(clamped, 1.5).toDouble();
    return minScrollSpeed + (maxScrollSpeed - minScrollSpeed) * curve;
  }

  /// Sprzątanie zasobów koordynatora.
  void dispose() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    _columns.clear();
    _boardHorizontalController = null;
  }
}

class _ColumnScrollRegistration {
  const _ColumnScrollRegistration({
    required this.controller,
    required this.context,
  });

  final ScrollController controller;
  final BuildContext context;
}

/// InheritedWidget udostępniający koordynator przewijania w drzewie Kanbana.
class KanbanAutoScrollScope extends InheritedWidget {
  const KanbanAutoScrollScope({
    required this.coordinator,
    required super.child,
    super.key,
  });

  final KanbanAutoScrollCoordinator coordinator;

  static KanbanAutoScrollCoordinator? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<KanbanAutoScrollScope>()
      ?.coordinator;

  static KanbanAutoScrollCoordinator of(BuildContext context) {
    final result = maybeOf(context);
    assert(
      result != null,
      'Nie znaleziono KanbanAutoScrollScope w drzewie widgetów',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(KanbanAutoScrollScope oldWidget) =>
      coordinator != oldWidget.coordinator;
}
