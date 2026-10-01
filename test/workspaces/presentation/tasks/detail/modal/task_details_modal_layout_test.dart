import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_layout.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('split layout keeps one conversation pane mounted', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final paneKey = GlobalKey<_TrackedConversationPaneState>();

    await tester.pumpWidget(
      _layoutApp(
        selectedTab: TaskDetailsModalTab.work,
        splitRequested: false,
        conversation: _TrackedConversationPane(key: paneKey),
        viewportWidth: 1440,
      ),
    );
    final originalState = tester.state<_TrackedConversationPaneState>(
      find.byKey(paneKey, skipOffstage: false),
    );
    expect(_paneWidth(tester), 0);

    await tester.pumpWidget(
      _layoutApp(
        selectedTab: TaskDetailsModalTab.work,
        splitRequested: true,
        conversation: _TrackedConversationPane(key: paneKey),
        viewportWidth: 1440,
      ),
    );
    expect(
      tester.state<_TrackedConversationPaneState>(
        find.byKey(paneKey, skipOffstage: false),
      ),
      same(originalState),
    );
    expect(_paneWidth(tester), greaterThanOrEqualTo(400));

    await tester.pumpWidget(
      _layoutApp(
        selectedTab: TaskDetailsModalTab.conversation,
        splitRequested: false,
        conversation: _TrackedConversationPane(key: paneKey),
        viewportWidth: 1440,
      ),
    );
    expect(
      tester.state<_TrackedConversationPaneState>(
        find.byKey(paneKey, skipOffstage: false),
      ),
      same(originalState),
    );
    expect(_paneWidth(tester), greaterThan(800));
    expect(originalState.mountCount, 1);
  });

  testWidgets('1280 viewport and 200 percent text fall back to tabs', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final size in [const Size(1280, 800), const Size(1440, 900)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        _layoutApp(
          selectedTab: TaskDetailsModalTab.work,
          splitRequested: true,
          conversation: const _TrackedConversationPane(),
          viewportWidth: size.width,
          textScale: size.width == 1440 ? 2 : 1,
        ),
      );
      expect(_paneWidth(tester), 0);
    }
  });

  testWidgets('desktop layout toggle exposes localized accessible action', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var selected = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pl'),
        home: Scaffold(
          body: TaskDetailsModalTabs(
            selected: TaskDetailsModalTab.work,
            onSelected: (_) {},
            splitConversationAvailable: true,
            onSplitConversationChanged: () => selected = !selected,
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('task-details-layout-toggle')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('task-details-layout-toggle')));
    expect(selected, isTrue);
  });
}

double _paneWidth(WidgetTester tester) => tester
    .getSize(find.byKey(const ValueKey('task-detail-conversation-pane')))
    .width;

Widget _layoutApp({
  required TaskDetailsModalTab selectedTab,
  required bool splitRequested,
  required Widget conversation,
  required double viewportWidth,
  double textScale = 1,
}) => MaterialApp(
  theme: MaterialTheme.crm().light(),
  home: MediaQuery(
    data: MediaQueryData(
      size: Size(viewportWidth, 900),
      textScaler: TextScaler.linear(textScale),
    ),
    child: Scaffold(
      body: SizedBox.expand(
        child: TaskDetailsWorkspaceLayout(
          selectedTab: selectedTab,
          splitConversationRequested: splitRequested,
          centerContent: const ColoredBox(
            color: Colors.blue,
            child: Center(child: Text('Task work')),
          ),
          conversationContent: conversation,
        ),
      ),
    ),
  ),
);

final class _TrackedConversationPane extends StatefulWidget {
  const _TrackedConversationPane({super.key});

  @override
  State<_TrackedConversationPane> createState() =>
      _TrackedConversationPaneState();
}

final class _TrackedConversationPaneState
    extends State<_TrackedConversationPane> {
  int mountCount = 0;

  @override
  void initState() {
    super.initState();
    mountCount++;
  }

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: Colors.orange,
    child: Center(child: Text('Resource conversation')),
  );
}
