import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show KanbanCardFrame, KanbanTaskCard;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Klucz probki pikselowej: karta na białym tle, żeby zmierzyć narysowane
/// kropki obrysu, a nie tylko deklarację widgetu.
const ValueKey<String> _probeKey = ValueKey<String>('kanban_card_probe');

/// Odstęp karty od krawędzi próbki — potrzebny, by odróżnić piksele karty
/// od pikseli tła.
const double _probeInset = 8.0;

/// Stany interakcji karty: spoczynek, hover, focus klawiatury i zaznaczenie.
///
/// Focus klawiatury jest tu istotny, bo plan §5.6 wymaga wyraźnego pierścienia
/// o kontraście minimum 3:1 — sam `onFocusChange` bez malowania nie spełnia
/// tego wymagania. Hover jest sprawdzany na pikselach, bo użytkownik zgłosił
/// zarówno brak kropek na kafelku, jak i podświetlanie się tła zamiast ramki.
void main() {
  KanbanTaskCardResponse task() => const KanbanTaskCardResponse(
    id: 'task-1',
    number: 101,
    taskCode: 'TASK-101',
    title: 'Karta do sprawdzenia stanów',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    position: 1_000,
    checklistTotal: 0,
    checklistCompleted: 0,
    attachmentCount: 0,
    version: 1,
  );

  BoxDecoration frameDecoration(WidgetTester tester) {
    final container = tester.widget<AnimatedContainer>(
      find
          .descendant(
            of: find.byType(KanbanTaskCard),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    return container.decoration! as BoxDecoration;
  }

  DottedRRectPainter dashedPainter(WidgetTester tester) {
    final paint = tester.widget<CustomPaint>(
      find
          .descendant(
            of: find.byType(KanbanCardFrame),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is CustomPaint &&
                  widget.foregroundPainter is DottedRRectPainter,
            ),
          )
          .first,
    );
    return paint.foregroundPainter! as DottedRRectPainter;
  }

  Future<void> pumpCard(
    WidgetTester tester, {
    bool isSelected = false,
    FocusNode? focusNode,
    bool withProbe = false,
  }) async {
    final theme = MaterialTheme.crm().light();
    final card = KanbanTaskCard(
      task: task(),
      workspaceId: 'w',
      projectId: 'p',
      visibleCardFields: const [],
      density: KanbanCardDensity.comfortable,
      isSelected: isSelected,
      memberProfilesByUserId: const {},
      focusNode: focusNode,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: withProbe
                ? RepaintBoundary(
                    key: _probeKey,
                    child: ColoredBox(
                      color: const Color(0xffffffff),
                      child: Padding(
                        padding: const EdgeInsets.all(_probeInset),
                        child: SizedBox(width: 290, child: card),
                      ),
                    ),
                  )
                : SizedBox(width: 290, child: card),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Liczba pikseli ciemniejszych od powierzchni karty w wierszu `dy` px od
  /// jej górnej krawędzi, pomijając zaokrąglone narożniki.
  Future<int> darkPixelsInTopEdge(WidgetTester tester, double dy) async {
    final cardRect = tester.getRect(find.byType(KanbanTaskCard));
    final probeOrigin = tester.getTopLeft(find.byKey(_probeKey));
    final surface = KanbanCardTokens.cardSurfaceRest(
      MaterialTheme.crm().light().colorScheme,
    );
    // Próg w skali 0–255, tak samo jak odczyt z bufora obrazu.
    final threshold = (surface.r * 255).round() - 20;
    var count = 0;
    await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(_probeKey),
      );
      final image = await boundary.toImage();
      final data = (await image.toByteData())!;
      final pixels = data.buffer.asUint8List();
      final width = image.width;
      final row = (cardRect.top - probeOrigin.dy + dy).round();
      final from = (cardRect.left - probeOrigin.dx + 14).round();
      final to = (cardRect.right - probeOrigin.dx - 14).round();
      for (var x = from; x <= to; x++) {
        final offset = (row * width + x) * 4;
        if (pixels[offset] < threshold) count++;
      }
      image.dispose();
    });
    return count;
  }

  testWidgets('spoczynek rysuje kropki tokenem, a nie ciągłą ramkę', (
    tester,
  ) async {
    await pumpCard(tester);
    final theme = MaterialTheme.crm().light();
    final decoration = frameDecoration(tester);

    expect(
      decoration.border,
      isNull,
      reason: 'spoczynek kafelka nie ma ciągłej ramki — obrys jest kropkowany',
    );
    expect(
      dashedPainter(tester).color,
      KanbanCardTokens.cardDashedBorderRest(theme.colorScheme, isDark: false),
    );
    expect(
      decoration.color,
      KanbanCardTokens.cardSurfaceRest(theme.colorScheme),
    );
  });

  testWidgets('kropki obrysu są widoczne w pikselach kafelka', (tester) async {
    await pumpCard(tester, withProbe: true);

    // Kropki mają 2 px średnicy i leżą na krawędzi karty, więc wiersze 1 px i
    // 2 px od górnej krawędzi przecinają je w całości.
    final firstRow = await darkPixelsInTopEdge(tester, 1);
    final secondRow = await darkPixelsInTopEdge(tester, 2);

    expect(
      firstRow + secondRow,
      greaterThan(10),
      reason:
          'użytkownik nie widzi przerywanego obrysu kafelka; kropki muszą być '
          'namalowane, a nie tylko zadeklarowane w tokenie',
    );
  });

  testWidgets('hover podświetla wyłącznie ramkę, a nie tło kafelka', (
    tester,
  ) async {
    await pumpCard(tester);
    final theme = MaterialTheme.crm().light();
    final restSurface = frameDecoration(tester).color;
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    await gesture.moveTo(tester.getCenter(find.byType(KanbanTaskCard)));
    await tester.pumpAndSettle();

    expect(
      dashedPainter(tester).color,
      KanbanCardTokens.cardFocusRing(theme.colorScheme),
      reason: 'hover ma podświetlać obrys kafelka',
    );
    expect(
      frameDecoration(tester).color,
      restSurface,
      reason: 'hover nie może zmieniać tła kafelka',
    );
    expect(
      frameDecoration(tester).border,
      isNull,
      reason: 'hover nie zamienia kropek na ciągłą ramkę',
    );
  });

  testWidgets('focus klawiatury maluje pierścień o większej grubości', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await pumpCard(tester, focusNode: focusNode);
    final theme = MaterialTheme.crm().light();
    final restColor = KanbanCardTokens.cardBorderRest(theme.colorScheme);

    focusNode.requestFocus();
    await tester.pumpAndSettle();
    final decoration = frameDecoration(tester);

    expect(focusNode.hasFocus, isTrue);
    expect(
      (decoration.border! as Border).top.color,
      KanbanCardTokens.cardFocusRing(theme.colorScheme),
      reason: 'focus musi być widoczny, a nie tylko śledzony w stanie',
    );
    expect((decoration.border! as Border).top.width, 2);
    expect(
      (decoration.border! as Border).top.color,
      isNot(restColor),
      reason: 'pierścień focusa musi różnić się od obrysu w spoczynku',
    );
  });

  testWidgets('zaznaczenie ma własny token obrysu i powierzchni', (
    tester,
  ) async {
    await pumpCard(tester, isSelected: true);
    final theme = MaterialTheme.crm().light();
    final decoration = frameDecoration(tester);

    expect(
      (decoration.border! as Border).top.color,
      KanbanCardTokens.cardBorderSelected(theme.colorScheme),
    );
    expect(
      decoration.color,
      KanbanCardTokens.cardSurfaceSelected(theme.colorScheme),
    );
  });
}
