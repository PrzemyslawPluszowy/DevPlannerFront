import 'package:devplanner/workspaces/presentation/chat/shell/chat_message_target_scroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selecting the same target again scrolls back after leaving it', (
    tester,
  ) async {
    final history = GlobalKey<_LazyHistoryState>();
    final target = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 240,
          child: _LazyHistory(key: history, targetKey: target, target: 45),
        ),
      ),
    );
    for (var frame = 0; frame < 100; frame++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
    history.currentState!.repeatTarget();
    for (var frame = 0; frame < 100; frame++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(target.currentContext, isNotNull);
    final box = target.currentContext!.findRenderObject()! as RenderBox;
    expect(box.localToGlobal(Offset.zero).dy, lessThan(720));
    expect(box.localToGlobal(Offset(0, box.size.height)).dy, greaterThan(0));
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'skok odnajduje cel poza lazy viewportem przy różnych wysokościach',
    (tester) async {
      final targetKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 240,
              child: _LazyHistory(targetKey: targetKey, target: 45),
            ),
          ),
        ),
      );
      for (var frame = 0; frame < 100; frame++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
      expect(targetKey.currentContext, isNotNull);
      final box = targetKey.currentContext!.findRenderObject()! as RenderBox;
      expect(box.localToGlobal(Offset.zero).dy, lessThan(240));
      expect(box.localToGlobal(Offset(0, box.size.height)).dy, greaterThan(0));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('zamknięcie historii przerywa zaplanowany skok', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: _LazyHistory(targetKey: GlobalKey(), target: 45)),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

final class _LazyHistory extends StatefulWidget {
  const _LazyHistory({
    required this.targetKey,
    required this.target,
    super.key,
  });
  final GlobalKey targetKey;
  final int target;
  @override
  State<_LazyHistory> createState() => _LazyHistoryState();
}

final class _LazyHistoryState extends State<_LazyHistory> {
  final ScrollController _scroll = ScrollController();
  late final ChatMessageTargetScroller _scroller;
  int _request = 0;

  void repeatTarget() {
    _scroll.jumpTo(0);
    _scroller.schedule(
      '${widget.target}',
      messageCount: 60,
      requestId: ++_request,
    );
  }

  @override
  void initState() {
    super.initState();
    _scroller = ChatMessageTargetScroller(
      scroll: _scroll,
      targetKey: widget.targetKey,
      isMounted: () => mounted,
    );
    _scroller.schedule('${widget.target}', messageCount: 60);
  }

  @override
  void dispose() {
    _scroller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
    controller: _scroll,
    reverse: true,
    itemCount: 60,
    itemBuilder: (context, index) => SizedBox(
      key: index == widget.target ? widget.targetKey : ValueKey(index),
      height: 60.0 + index % 3 * 30,
      child: Text('row:$index'),
    ),
  );
}
