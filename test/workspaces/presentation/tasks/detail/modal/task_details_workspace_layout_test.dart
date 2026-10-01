import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_layout.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TickerProbe extends StatefulWidget {
  const _TickerProbe({required this.onTick, super.key});

  final VoidCallback onTick;

  @override
  State<_TickerProbe> createState() => _TickerProbeState();
}

final class _TickerProbeState extends State<_TickerProbe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_onTick);
    _controller.repeat();
  }

  void _onTick() => widget.onTick();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.square(dimension: 20);
}

final class _LayoutApp extends StatelessWidget {
  const _LayoutApp({required this.tab, required this.onTick});

  final TaskDetailsModalTab tab;
  final VoidCallback onTick;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: TaskDetailsWorkspaceLayout(
        selectedTab: tab,
        splitConversationRequested: false,
        centerContent: const Text('Task work'),
        conversationContent: _TickerProbe(
          key: const ValueKey('conversation-ticker'),
          onTick: onTick,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('hidden Chat stops tickers and preserves its mounted state', (
    tester,
  ) async {
    var ticks = 0;
    void onTick() => ticks++;
    await tester.pumpWidget(
      _LayoutApp(tab: TaskDetailsModalTab.work, onTick: onTick),
    );
    await tester.pumpAndSettle();
    final probe = find.byKey(
      const ValueKey('conversation-ticker'),
      skipOffstage: false,
    );
    final originalState = tester.state(probe);
    final hiddenTicks = ticks;
    await tester.pump(const Duration(milliseconds: 500));
    expect(ticks, hiddenTicks);
    expect(tester.binding.hasScheduledFrame, isFalse);

    await tester.pumpWidget(
      _LayoutApp(tab: TaskDetailsModalTab.conversation, onTick: onTick),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(ticks, greaterThan(hiddenTicks));
    expect(identical(tester.state(probe), originalState), isTrue);

    await tester.pumpWidget(
      _LayoutApp(tab: TaskDetailsModalTab.work, onTick: onTick),
    );
    await tester.pumpAndSettle();
    final ticksAfterHiding = ticks;
    await tester.pump(const Duration(milliseconds: 500));
    expect(ticks, ticksAfterHiding);
    expect(identical(tester.state(probe), originalState), isTrue);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
