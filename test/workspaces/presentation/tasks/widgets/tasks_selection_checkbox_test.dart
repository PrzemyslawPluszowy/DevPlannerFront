import 'package:devplanner/workspaces/presentation/tasks/widgets/tasks_selection_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Bok kwadratu, w którym mierzymy narysowany glyph.
const double _probeSide = 32.0;
const ValueKey<String> _probeKey = ValueKey<String>('selection_checkbox_probe');

/// Rozmiar narysowanego glyphu mierzony z pikseli, a nie z pola układu:
/// Material rysuje kwadrat kontrolki o stałym boku `Checkbox.width` (18 px),
/// więc deklaracja rozmiaru w drzewie nie dowodzi, co użytkownik widzi.
Future<Size> _paintedGlyphSize(WidgetTester tester) async {
  late Size size;
  await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(_probeKey),
    );
    final image = await boundary.toImage();
    final data = (await image.toByteData())!;
    final pixels = data.buffer.asUint8List();
    final width = image.width;
    var minX = width;
    var minY = image.height;
    var maxX = -1;
    var maxY = -1;
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < width; x++) {
        final offset = (y * width + x) * 4;
        final isBackground =
            pixels[offset] == 255 &&
            pixels[offset + 1] == 255 &&
            pixels[offset + 2] == 255;
        if (isBackground) continue;
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }
    image.dispose();
    size = Size((maxX - minX + 1).toDouble(), (maxY - minY + 1).toDouble());
  });
  return size;
}

Future<void> _pumpProbe(
  WidgetTester tester, {
  required bool value,
  ValueChanged<bool>? onChanged,
  String? semanticLabel,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: _probeKey,
            child: SizedBox.square(
              dimension: _probeSide,
              child: ColoredBox(
                color: Colors.white,
                child: TasksSelectionCheckbox(
                  value: value,
                  onChanged: onChanged,
                  semanticLabel: semanticLabel,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('niezaznaczony checkbox rysuje glyph 16 px, nie 18 px', (
    tester,
  ) async {
    await _pumpProbe(tester, value: false, onChanged: (_) {});

    final glyph = await _paintedGlyphSize(tester);
    expect(glyph.width, closeTo(TasksSelectionCheckbox.glyphSize, 1));
    expect(glyph.height, closeTo(TasksSelectionCheckbox.glyphSize, 1));
  });

  testWidgets('zaznaczony checkbox mieści się w tym samym glyphie', (
    tester,
  ) async {
    await _pumpProbe(tester, value: true, onChanged: (_) {});

    final glyph = await _paintedGlyphSize(tester);
    expect(glyph.width, closeTo(TasksSelectionCheckbox.glyphSize, 1));
    expect(glyph.height, closeTo(TasksSelectionCheckbox.glyphSize, 1));
  });

  testWidgets('obrys jest lżejszy od domyślnego obrysu Materiala', (
    tester,
  ) async {
    await _pumpProbe(tester, value: false, onChanged: (_) {});

    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.side!.width, TasksSelectionCheckbox.borderWidth);
    expect(checkbox.visualDensity, VisualDensity.compact);
    expect(checkbox.materialTapTargetSize, MaterialTapTargetSize.shrinkWrap);
  });

  testWidgets('brak onChanged wyłącza kontrolkę i nie zjada trafień', (
    tester,
  ) async {
    await _pumpProbe(tester, value: false, semanticLabel: 'Zaznacz wszystko');

    expect(tester.widget<Checkbox>(find.byType(Checkbox)).onChanged, isNull);
    expect(find.bySemanticsLabel('Zaznacz wszystko'), findsOneWidget);
  });

  testWidgets('mniejszy glyph zachowuje pełne pole trafień kontrolki', (
    tester,
  ) async {
    final changes = <bool>[];
    await _pumpProbe(
      tester,
      value: false,
      onChanged: changes.add,
    );

    // Róg pola układu leży poza skalowanym glyphem: transformacja nie może
    // odebrać trafienia, bo pole pozostaje takie samo jak przed pomniejszeniem.
    final center = tester.getCenter(find.byType(TasksSelectionCheckbox));
    await tester.tapAt(center + const Offset(12, 0));
    await tester.pumpAndSettle();

    expect(changes, [true]);
  });
}
