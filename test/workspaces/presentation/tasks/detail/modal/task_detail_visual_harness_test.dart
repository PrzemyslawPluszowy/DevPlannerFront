import 'dart:io';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/app/shell/overlays/devplanner_modal_layer.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/milestone/cubit/task_milestone_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_shell.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_milestone.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_error_banner.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../test_support/task_detail_visual_fixture.dart';
import '../../../../../test_support/tasks_board_route_fixture.dart';

final GlobalKey _captureKey = GlobalKey();

Future<void> _loadFonts() async {
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-Bold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-Light.ttf'));
  final outlined =
      FontLoader(
        'packages/material_symbols_icons/MaterialSymbolsOutlined',
      )..addFont(
        rootBundle.load(
          'packages/material_symbols_icons/lib/fonts/MaterialSymbolsOutlined.ttf',
        ),
      );
  final rounded =
      FontLoader(
        'packages/material_symbols_icons/MaterialSymbolsRounded',
      )..addFont(
        rootBundle.load(
          'packages/material_symbols_icons/lib/fonts/MaterialSymbolsRounded.ttf',
        ),
      );
  final sharp =
      FontLoader(
        'packages/material_symbols_icons/MaterialSymbolsSharp',
      )..addFont(
        rootBundle.load(
          'packages/material_symbols_icons/lib/fonts/MaterialSymbolsSharp.ttf',
        ),
      );
  final materialIcons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await inter.load();
  await outlined.load();
  await rounded.load();
  await sharp.load();
  await materialIcons.load();
}

Future<void> _precacheShellAssets(WidgetTester tester) async {
  final context = tester.element(find.byKey(_captureKey));
  await tester
      .runAsync(() async {
        await precacheImage(DevPlannerShellTheme.backdropImage, context);
        await precacheImage(DevPlannerShellTheme.logoImage, context);
      })
      .timeout(const Duration(seconds: 30));
  await tester.pump();
}

Future<void> _waitForModalEntrance(WidgetTester tester) async {
  for (var frame = 0; frame < 20; frame++) {
    final modal = find.byType(TaskDetailsModalShell);
    if (modal.evaluate().isNotEmpty) {
      final route = ModalRoute.of(tester.element(modal));
      final animation = route?.animation;
      if (animation == null ||
          (animation.status == AnimationStatus.completed &&
              animation.value >= 1)) {
        return;
      }
    }
    await tester.pump(const Duration(milliseconds: 50));
  }
  throw TestFailure('Task details modal entrance did not complete.');
}

Widget _app(TaskDetailVisualFixture fixture, ThemeMode mode) =>
    MaterialApp.router(
      routerConfig: fixture.router.config,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pl'),
      theme: MaterialTheme.crm().light(),
      darkTheme: MaterialTheme.crm().dark(),
      themeMode: mode,
      builder: (context, child) => RepaintBoundary(
        key: _captureKey,
        child: DevPlannerGlobalPanelsHost(
          navigation: DevPlannerNavigation(fixture.router.config),
          authSession: fixture.authSession,
          chat: fixture.chatComposition,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );

Future<void> _pumpMilestoneToTerminalState(WidgetTester tester) async {
  for (var frame = 0; frame < 12; frame++) {
    final finder = find.byType(TaskMilestoneValue);
    if (finder.evaluate().isNotEmpty) {
      final state = tester.element(finder).read<TaskMilestoneCubit>().state;
      if (state is! TaskMilestoneLoading) {
        await tester.pump();
        return;
      }
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerTasksBoardRouteFallbacks();
    SharedPreferences.setMockInitialValues({});
  });
  setUpAll(() async {
    await _loadFonts().timeout(const Duration(seconds: 30));
  });

  for (final scenario
      in <
        ({
          TaskDetailVisualMode mode,
          ThemeMode theme,
          Size size,
          String capture,
        })
      >[
        (
          mode: TaskDetailVisualMode.editable,
          theme: ThemeMode.light,
          size: const Size(1440, 900),
          capture: 'editable-light-1440.png',
        ),
        (
          mode: TaskDetailVisualMode.editable,
          theme: ThemeMode.light,
          size: const Size(1920, 1080),
          capture: 'editable-light-1920.png',
        ),
        (
          mode: TaskDetailVisualMode.editable,
          theme: ThemeMode.dark,
          size: const Size(1280, 720),
          capture: 'editable-dark-1280.png',
        ),
        (
          mode: TaskDetailVisualMode.readOnly,
          theme: ThemeMode.dark,
          size: const Size(1440, 900),
          capture: 'readonly-dark-1440.png',
        ),
        (
          mode: TaskDetailVisualMode.archived,
          theme: ThemeMode.light,
          size: const Size(1920, 1080),
          capture: 'archived-light-1920.png',
        ),
        (
          mode: TaskDetailVisualMode.denied,
          theme: ThemeMode.light,
          size: const Size(1280, 720),
          capture: 'denied-light-1280.png',
        ),
        (
          mode: TaskDetailVisualMode.conflict,
          theme: ThemeMode.dark,
          size: const Size(1440, 900),
          capture: 'conflict-409-dark-1440.png',
        ),
      ]) {
    testWidgets(
      'fixture capture: ${scenario.mode.name}, ${scenario.theme.name}, ${scenario.size.width.toInt()}x${scenario.size.height.toInt()}',
      (tester) async {
        await tester.binding.setSurfaceSize(scenario.size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final fixture = TaskDetailVisualFixture(scenario.mode);
        addTearDown(fixture.dispose);

        await tester.pumpWidget(_app(fixture, scenario.theme));
        await _precacheShellAssets(tester);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 700));
        await _pumpMilestoneToTerminalState(tester);
        await _waitForModalEntrance(tester);

        expect(find.byType(TaskDetailsModalShell), findsOneWidget);
        verify(
          () => fixture.boardFixture.taskListConfigurationRepository
              .getEffectiveConfiguration(
                workspaceId: visualWorkspaceId,
                projectId: visualProjectId,
              ),
        ).called(2);
        expect(
          find.byType(TasksErrorBanner),
          findsNothing,
          reason: 'The visual fixture must render a stable Tasks board.',
        );
        expect(find.text('Do zrobienia'), findsOneWidget);
        if (scenario.mode == TaskDetailVisualMode.denied ||
            scenario.mode == TaskDetailVisualMode.conflict) {
          expect(find.textContaining('Fixture'), findsWidgets);
          expect(find.text('TASK-100'), findsNothing);
        } else {
          expect(find.text('TASK-100'), findsOneWidget);
          expect(
            find.text('Przygotować uruchomienie nowego procesu onboardingu'),
            findsOneWidget,
          );
          verify(
            () => fixture.milestoneRepository.listMilestones(
              workspaceId: visualWorkspaceId,
              projectId: visualProjectId,
            ),
          ).called(1);
          expect(
            tester
                .element(find.byType(TaskMilestoneValue))
                .read<TaskMilestoneCubit>()
                .state,
            isA<TaskMilestoneReady>(),
          );
          expect(
            find.descendant(
              of: find.byType(TaskMilestoneValue),
              matching: find.textContaining('Ładowanie'),
            ),
            findsNothing,
          );
        }
        const captureDirectory =
            'docs/recovery/visual-captures/task-detail-2026-09-30';
        Directory(captureDirectory).createSync(recursive: true);
        final capturePath =
            '../../../../../../$captureDirectory/${scenario.capture}';
        await expectLater(
          find.byKey(_captureKey),
          matchesGoldenFile(capturePath),
        );
      },
    );
  }

  for (final menu in ['status', 'priority', 'assignees', 'date', 'file']) {
    for (final theme in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('open menu fixture capture: $menu, ${theme.name}', (
        tester,
      ) async {
        const size = Size(1920, 1080);
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final fixture = TaskDetailVisualFixture(
          TaskDetailVisualMode.editable,
          initialTaskTab: menu == 'file' ? 'files' : null,
        );
        addTearDown(fixture.dispose);
        await tester.pumpWidget(_app(fixture, theme));
        await _precacheShellAssets(tester);
        await tester.pump(const Duration(milliseconds: 700));
        await _pumpMilestoneToTerminalState(tester);
        await _waitForModalEntrance(tester);
        expect(find.byType(TaskDetailsModalShell), findsOneWidget);
        const captureDirectory =
            'docs/recovery/visual-captures/task-detail-2026-09-30';
        Directory(captureDirectory).createSync(recursive: true);
        final modalNavigator = find
            .descendant(
              of: find.byType(DevPlannerModalLayer),
              matching: find.byType(Navigator),
            )
            .first;
        var statusMenuOpened = false;

        switch (menu) {
          case 'status':
            final statusTooltip = find.byTooltip('Ustaw status własny');
            final statusContext = tester.element(statusTooltip);
            expect(
              identical(
                ModalRoute.of(statusContext)?.navigator,
                Navigator.of(statusContext, rootNavigator: true),
              ),
              isTrue,
              reason:
                  'The status picker should use the active modal navigator.',
            );
            final modalLayerNavigator = tester.state<NavigatorState>(
              find
                  .descendant(
                    of: find.byType(DevPlannerModalLayer),
                    matching: find.byType(Navigator),
                  )
                  .first,
            );
            expect(
              identical(
                modalLayerNavigator,
                Navigator.of(statusContext, rootNavigator: true),
              ),
              isTrue,
              reason: 'Context menus must use the modal layer navigator.',
            );
            final statusButton = find.descendant(
              of: statusTooltip,
              matching: find.byType(TextButton),
            );
            expect(statusButton, findsOneWidget);
            expect(
              tester.widget<TextButton>(statusButton).onPressed,
              isNotNull,
            );
            await tester.tap(statusTooltip);
            await tester.pump(const Duration(milliseconds: 450));
            final statusLabels = find.text('W toku').evaluate();
            expect(statusLabels, hasLength(2));
            statusMenuOpened = true;
          case 'priority':
            await tester.tap(
              find.byKey(const ValueKey('task-header-priority')),
            );
            await tester.pump(const Duration(milliseconds: 450));
            expect(find.text('Priorytet'), findsWidgets);
          case 'assignees':
            await tester.tap(find.byTooltip('Edytuj wykonawców'));
            await tester.pump(const Duration(milliseconds: 450));
            expect(find.text('Edytuj wykonawców'), findsWidgets);
            expect(find.text('Marta Nowak'), findsWidgets);
          case 'date':
            await tester.tap(find.byTooltip('Edytuj terminy i estymację'));
            await tester.pump(const Duration(milliseconds: 450));
            await tester.tap(find.byTooltip('Data rozpoczęcia'));
            await tester.pump(const Duration(milliseconds: 450));
            expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
            final selectableDay = find
                .byType(TaskDatePickerDayCell)
                .hitTestable();
            expect(selectableDay, findsWidgets);
            await tester.tap(selectableDay.first);
            await tester.pump();
            expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
          case 'file':
            await tester.pump(const Duration(milliseconds: 700));
            expect(find.text('Plan wdrożenia klientów.xlsx'), findsOneWidget);
            final fileRow = find.ancestor(
              of: find.text('Plan wdrożenia klientów.xlsx'),
              matching: find.byType(ListTile),
            );
            final fileMenuButton = find.descendant(
              of: fileRow.first,
              matching: find.byTooltip('Więcej opcji'),
            );
            expect(fileMenuButton.hitTestable(), findsOneWidget);
            await tester.tap(fileMenuButton);
            await tester.pump(const Duration(milliseconds: 450));
            expect(find.text('Plan wdrożenia klientów.xlsx'), findsWidgets);
        }

        final captureName = 'open-$menu-${theme.name}-1920.png';
        await tester.pump(const Duration(milliseconds: 450));
        await expectLater(
          modalNavigator,
          matchesGoldenFile('../../../../../../$captureDirectory/$captureName'),
        );
        if (menu == 'priority') {
          final normalPriority = find.text('Normalny priorytet').last;
          expect(normalPriority.hitTestable(), findsOneWidget);
        }
        if (statusMenuOpened) {
          final statusMenuRow = find
              .ancestor(
                of: find.text('W toku').last,
                matching: find.byType(InkWell),
              )
              .first;
          expect(statusMenuRow.hitTestable(), findsOneWidget);
          await tester.tap(statusMenuRow);
          await tester.pumpAndSettle();
          expect(find.text('W toku'), findsOneWidget);
        }
      });
    }
  }
}
