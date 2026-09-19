import 'dart:io';
import 'dart:ui' as ui;

import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_support/tasks_board_route_fixture.dart';

/// Zrzuty widoków Listy i Kanbanu z realnej kompozycji modułu Tasks.
///
/// To nie jest odbiór GUI na żywym Backendzie: test renderuje ten sam widget
/// trasy z hermetycznym fixture'em, w motywie produktu i z załadowanymi fontami,
/// i zapisuje obrazy w rozdzielczościach z planu. Służą do przeglądu układu
/// i gęstości bez uruchamiania aplikacji.
const _outputDir = 'docs/recovery/visual-captures';

const _sizes = <String, Size>{
  '1024x768': Size(1024, 768),
  '1440x900': Size(1440, 900),
  '1920x1080': Size(1920, 1080),
};

Future<void> _capture(WidgetTester tester, String filename) async {
  await tester.runAsync(() async {
    final finder = find.byKey(const ValueKey('capture_target'));
    final boundary =
        finder.evaluate().single.renderObject! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = Directory(_outputDir);
    if (!directory.existsSync()) directory.createSync(recursive: true);
    File('$_outputDir/$filename').writeAsBytesSync(
      byteData!.buffer.asUint8List(),
    );
  });
}

Widget _app({
  required TasksBoardRouteFixture fixture,
  required ThemeData theme,
  required Size size,
  required String? view,
}) => MaterialApp(
  theme: theme,
  locale: const Locale('pl'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MediaQuery(
    data: MediaQueryData(size: size),
    child: RepaintBoundary(
      key: const ValueKey('capture_target'),
      child: TasksBoardRoutePage(
        composition: fixture.composition,
        projectSettings: fixture.settings.composition,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        authSession: AuthSessionController(
          initial: const AuthSessionSnapshot(
            status: AuthSessionStatus.signedIn,
            user: AuthUser(
              userId: 'user-1',
              login: 'tester',
              displayName: 'Tester',
            ),
          ),
        ),
        initialView: view,
      ),
    ),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Matchery fixture'a wymagają wartości zastępczych dla typów zapytań.
    registerTasksBoardRouteFallbacks();
    final fontLoader = FontLoader('Inter');
    for (final file in const [
      'assets/fonts/Inter-Regular.ttf',
      'assets/fonts/Inter-SemiBold.ttf',
      'assets/fonts/Inter-Bold.ttf',
    ]) {
      if (File(file).existsSync()) {
        fontLoader.addFont(
          File(file).readAsBytes().then(ByteData.sublistView),
        );
      }
    }
    await fontLoader.load();

    const symbolsPath =
        '/Users/przemyslawnowak/.pub-cache/hosted/pub.dev/material_symbols_icons-4.2960.0/lib/fonts/MaterialSymbolsRounded.ttf';
    if (File(symbolsPath).existsSync()) {
      final symbolLoader = FontLoader(
        'packages/material_symbols_icons/MaterialSymbolsRounded',
      );
      symbolLoader.addFont(
        File(symbolsPath).readAsBytes().then(ByteData.sublistView),
      );
      await symbolLoader.load();
    }

    const materialIconsPath =
        '/Users/Shared/flutter_sdk/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
    if (File(materialIconsPath).existsSync()) {
      final iconsLoader = FontLoader('MaterialIcons');
      iconsLoader.addFont(
        File(materialIconsPath).readAsBytes().then(ByteData.sublistView),
      );
      await iconsLoader.load();
    }
  });

  final themes = <String, ThemeData>{
    'light': MaterialTheme.crm().light(),
    'dark': MaterialTheme.crm().dark(),
  };

  for (final themeEntry in themes.entries) {
    for (final sizeEntry in _sizes.entries) {
      testWidgets(
        'zrzut Listy ${themeEntry.key} ${sizeEntry.key}',
        (tester) async {
          tester.view.physicalSize = sizeEntry.value;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          final fixture = TasksBoardRouteFixture(
            boardResult: populatedKanbanBoardResult,
            groupedListResult: populatedGroupedListResult,
          );
          await tester.pumpWidget(
            _app(
              fixture: fixture,
              theme: themeEntry.value,
              size: sizeEntry.value,
              view: null,
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          await _capture(
            tester,
            'lista_${sizeEntry.key}_${themeEntry.key}.png',
          );
        },
      );

      testWidgets(
        'zrzut Kanbanu ${themeEntry.key} ${sizeEntry.key}',
        (tester) async {
          tester.view.physicalSize = sizeEntry.value;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          final fixture = TasksBoardRouteFixture(
            boardResult: populatedKanbanBoardResult,
            groupedListResult: populatedGroupedListResult,
          );
          await tester.pumpWidget(
            _app(
              fixture: fixture,
              theme: themeEntry.value,
              size: sizeEntry.value,
              view: 'kanban',
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          await _capture(
            tester,
            'kanban_${sizeEntry.key}_${themeEntry.key}.png',
          );
        },
      );
    }
  }
}
