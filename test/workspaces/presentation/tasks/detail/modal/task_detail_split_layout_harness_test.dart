import 'dart:io';
import 'dart:ui' as ui;

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/milestone/cubit/task_milestone_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_shell.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_milestone.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_error_banner.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../test_support/task_detail_visual_fixture.dart';
import '../../../../../test_support/tasks_board_route_fixture.dart';

final GlobalKey _captureKey = GlobalKey();
final GlobalKey _rootCaptureKey = GlobalKey();

Future<void> _loadFonts() async {
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-Bold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Inter-Light.ttf'));
  final symbols =
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
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await inter.load();
  await symbols.load();
  await rounded.load();
  await sharp.load();
  await icons.load();
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

Widget _app(
  TaskDetailVisualFixture fixture,
  ThemeMode theme, {
  double textScale = 1,
  Size? viewportSize,
}) => MaterialApp.router(
  routerConfig: fixture.router.config,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('pl'),
  theme: MaterialTheme.crm().light(),
  darkTheme: MaterialTheme.crm().dark(),
  themeMode: theme,
  builder: (context, child) => MediaQuery(
    data: MediaQueryData.fromView(View.of(context)).copyWith(
      size: viewportSize ?? MediaQueryData.fromView(View.of(context)).size,
      textScaler: TextScaler.linear(textScale),
    ),
    child: RepaintBoundary(
      key: _captureKey,
      child: DevPlannerGlobalPanelsHost(
        navigation: DevPlannerNavigation(fixture.router.config),
        authSession: fixture.authSession,
        chat: fixture.chatComposition,
        child: child ?? const SizedBox.shrink(),
      ),
    ),
  ),
);

Future<void> _pumpReady(WidgetTester tester) async {
  for (var frame = 0; frame < 20; frame++) {
    final milestone = find.byType(TaskMilestoneValue);
    if (milestone.evaluate().isNotEmpty &&
        tester.element(milestone).read<TaskMilestoneCubit>().state
            is TaskMilestoneReady) {
      await tester.pump();
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void _expectPropertyLayout(WidgetTester tester, {required bool stacked}) {
  final rail = find.byKey(
    const PageStorageKey<String>('task-details-properties'),
  );
  final l10n = AppLocalizations.of(tester.element(rail))!;
  final railRect = tester.getRect(rail);
  final properties = <(String, String)>[
    (l10n.taskDetailsAssignees, 'Marta Nowak'),
    (l10n.taskDetailsStartDate, '28 wrz 2026'),
    (l10n.taskDetailsMilestone, 'Pilotaż onboardingowy'),
    (l10n.taskDetailsEstimate, l10n.taskDetailsMinutes(480)),
  ];

  for (final (label, value) in properties) {
    final labelFinder = find.descendant(of: rail, matching: find.text(label));
    final valueFinder = find.descendant(of: rail, matching: find.text(value));
    expect(labelFinder, findsOneWidget);
    expect(valueFinder, findsOneWidget);
    final labelRect = tester.getRect(labelFinder);
    final valueRect = tester.getRect(valueFinder);
    final labelContext = tester.element(labelFinder);
    final painter = TextPainter(
      text: tester.renderObject<RenderParagraph>(labelFinder).text,
      textDirection: Directionality.of(labelContext),
      textScaler: MediaQuery.textScalerOf(labelContext),
    )..layout(maxWidth: labelRect.width);
    expect(
      painter.computeLineMetrics(),
      hasLength(1),
      reason: 'Property label "$label" should stay on one line.',
    );
    painter.dispose();
    expect(labelRect.left, greaterThanOrEqualTo(railRect.left));
    expect(valueRect.right, lessThanOrEqualTo(railRect.right));
    if (stacked) {
      expect(valueRect.top, greaterThan(labelRect.bottom));
    } else {
      expect(valueRect.left, greaterThanOrEqualTo(labelRect.right));
      expect(valueRect.top, lessThanOrEqualTo(labelRect.top + 2));
    }
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

  for (final scenario in <({Size size, ThemeMode theme, String name})>[
    (size: const Size(1440, 900), theme: ThemeMode.light, name: 'light-1440'),
    (size: const Size(1440, 900), theme: ThemeMode.dark, name: 'dark-1440'),
    (size: const Size(1920, 1080), theme: ThemeMode.light, name: 'light-1920'),
    (size: const Size(1920, 1080), theme: ThemeMode.dark, name: 'dark-1920'),
  ]) {
    testWidgets('full Resource Chat split capture ${scenario.name}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(scenario.size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
      addTearDown(fixture.dispose);

      await tester.pumpWidget(
        _app(fixture, scenario.theme, viewportSize: scenario.size),
      );
      await _precacheShellAssets(tester);
      await tester.pump(const Duration(milliseconds: 700));
      await _pumpReady(tester);
      await _waitForModalEntrance(tester);
      if (scenario.name == 'light-1440') {
        _expectPropertyLayout(tester, stacked: false);
      }
      expect(find.byType(TaskDetailsModalShell), findsOneWidget);
      expect(find.byType(TaskDetailsModalTabs), findsOneWidget);
      expect(
        MediaQuery.sizeOf(tester.element(find.byType(TaskDetailsModalShell)))
            .width,
        scenario.size.width,
      );
      expect(find.byType(TasksErrorBanner), findsNothing);
      verifyNever(
        () => fixture.resourceChatRepository.resolveTaskConversation(
          taskId: visualTaskId,
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      );
      expect(find.byType(ChatPanelConversation), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('task-details-layout-toggle')),
      );
      for (
        var frame = 0;
        frame < 20 && find.byType(ChatPanelConversation).evaluate().isEmpty;
        frame++
      ) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pump(const Duration(milliseconds: 500));

      final chatPanel = find.byType(ChatPanelConversation, skipOffstage: false);
      expect(chatPanel, findsOneWidget);
      final chatState = tester.state<State>(chatPanel);
      expect(find.textContaining('Przekazałem zespołowi'), findsWidgets);
      final composerField = find.descendant(
        of: find.byType(ChatMessageComposer),
        matching: find.byType(TextField),
      );
      expect(composerField, findsOneWidget);
      await tester.enterText(composerField, 'Szkic zachowany w rozmowie taska');
      await tester.pump();
      verify(
        () => fixture.resourceChatRepository.resolveTaskConversation(
          taskId: visualTaskId,
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).called(1);
      await _saveCapture(tester, 'split-chat-${scenario.name}.png');

      await tester.tap(
        find.byKey(const ValueKey('task-details-layout-toggle')),
      );
      await tester.pump();
      expect(find.byType(ChatPanelConversation), findsNothing);
      expect(chatPanel.evaluate(), hasLength(1));
      expect(tester.state<State>(chatPanel), same(chatState));

      await tester.tap(
        find.byKey(const ValueKey('task-details-layout-toggle')),
      );
      await tester.pump();
      expect(tester.state<State>(chatPanel), same(chatState));
      expect(
        tester.widget<TextField>(composerField).controller?.text,
        'Szkic zachowany w rozmowie taska',
      );

      await tester.tap(find.text('Rozmowa').first);
      await tester.pump();
      expect(tester.state<State>(chatPanel), same(chatState));
      await tester.tap(find.text('Praca').first);
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('task-details-layout-toggle')),
      );
      await tester.pump();
      expect(tester.state<State>(chatPanel), same(chatState));
      expect(
        tester.widget<TextField>(composerField).controller?.text,
        'Szkic zachowany w rozmowie taska',
      );
      verify(
        () => fixture.conversationHistoryRepository.listConversationMessages(
          conversationId: visualConversationId,
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).called(1);
    });
  }

  testWidgets('1280 wide at 200 percent remains in tabbed layout', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
    addTearDown(fixture.dispose);

    await tester.pumpWidget(
      _app(
        fixture,
        ThemeMode.dark,
        textScale: 2,
        viewportSize: const Size(1280, 800),
      ),
    );
    await _precacheShellAssets(tester);
    await tester.pump(const Duration(milliseconds: 700));
    await _pumpReady(tester);
    await _waitForModalEntrance(tester);
    _expectPropertyLayout(tester, stacked: true);
    expect(
      find.byKey(const ValueKey('task-details-layout-toggle')),
      findsNothing,
    );
    expect(find.byType(ChatPanelConversation), findsNothing);
    verifyNever(
      () => fixture.resourceChatRepository.resolveTaskConversation(
        taskId: visualTaskId,
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
      ),
    );
    await _saveCapture(tester, 'fallback-tabs-dark-1280-200.png');
  });

  testWidgets('task Chat message and reaction menus are captured above modal', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final fixture = TaskDetailVisualFixture(TaskDetailVisualMode.editable);
    addTearDown(fixture.dispose);

    await tester.pumpWidget(
      RepaintBoundary(
        key: _rootCaptureKey,
        child: _app(
          fixture,
          ThemeMode.light,
          viewportSize: const Size(1920, 1080),
        ),
      ),
    );
    await _precacheShellAssets(tester);
    await tester.pump(const Duration(milliseconds: 700));
    await _pumpReady(tester);
    await _waitForModalEntrance(tester);
    await tester.tap(find.byKey(const ValueKey('task-details-layout-toggle')));
    for (
      var frame = 0;
      frame < 20 && find.byType(ChatPanelConversation).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump(const Duration(milliseconds: 500));

    final bubble = find.byType(ChatMessageBubble).hitTestable().first;
    final bubblePosition = tester.getCenter(bubble);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: bubblePosition);
    await mouse.moveTo(bubblePosition);
    await tester.pump(const Duration(milliseconds: 150));
    final action = find.descendant(
      of: bubble,
      matching: find.byType(ChatMessageActionMenu),
    );
    final button = find.descendant(
      of: action,
      matching: find.byTooltip('Akcje wiadomości'),
    );
    expect(button.hitTestable(), findsOneWidget);
    await tester.tap(button);
    await tester.pumpAndSettle();
    final reactAction = find.text('Dodaj reakcję');
    expect(reactAction.hitTestable(), findsOneWidget);
    final menuContext = tester.element(reactAction);
    final taskContext = tester.element(find.byType(TaskDetailsModalShell));
    final menuRoute = ModalRoute.of(menuContext);
    final taskRoute = ModalRoute.of(taskContext);
    expect(menuRoute, isA<PopupRoute<Object?>>());
    expect(identical(menuRoute?.navigator, taskRoute?.navigator), isTrue);
    expect(menuRoute?.isCurrent, isTrue);
    expect(menuRoute?.animation?.value, 1);
    await _saveRootCapture(tester, 'split-chat-message-menu-light-1920.png');

    await tester.tap(find.text('Dodaj reakcję'));
    await tester.pumpAndSettle();
    final quickReaction = find.byKey(
      const ValueKey<String>('chat-reaction-👍'),
    );
    final reactionRoute = ModalRoute.of(tester.element(quickReaction));
    expect(quickReaction.hitTestable(), findsOneWidget);
    expect(reactionRoute?.animation?.value, 1);
    await _saveRootCapture(tester, 'split-chat-reactions-light-1920.png');
  });
}

Future<void> _saveCapture(WidgetTester tester, String name) async {
  const directory = 'docs/recovery/visual-captures/task-detail-2026-09-30';
  Directory(directory).createSync(recursive: true);
  await expectLater(
    find.byKey(_captureKey),
    matchesGoldenFile('../../../../../../$directory/$name'),
  );
}

Future<void> _saveRootCapture(WidgetTester tester, String name) async {
  const directory = 'docs/recovery/visual-captures/task-detail-2026-09-30';
  final outputDirectory = Directory(directory)..createSync(recursive: true);
  final renderView = tester.binding.renderViews.firstWhere(
    (view) => view.flutterView.viewId == tester.view.viewId,
  );
  final rootLayer = renderView.debugLayer;
  if (rootLayer is! OffsetLayer) {
    throw TestFailure('The root RenderView layer is not capturable.');
  }
  final image = await tester.runAsync(
    () => rootLayer.toImage(renderView.paintBounds),
  );
  if (image == null) throw TestFailure('Root image capture timed out.');
  try {
    final bytes = await tester.runAsync(
      () => image.toByteData(format: ui.ImageByteFormat.png),
    );
    if (bytes == null) throw TestFailure('PNG encoding returned no bytes.');
    File('${outputDirectory.path}/$name').writeAsBytesSync(
      bytes.buffer.asUint8List(),
    );
    expect(bytes.lengthInBytes, greaterThan(0));
  } finally {
    image.dispose();
  }
}
