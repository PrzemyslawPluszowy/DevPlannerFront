import 'dart:async';

import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_save_confirmation_watch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('new save ignores an old pending read and starts its own read', (
    tester,
  ) async {
    final requests = <Completer<int?>>[];
    final confirmed = <int>[];
    final watch = StorageOfficeSaveConfirmationWatch(
      readVersion: () {
        final request = Completer<int?>();
        requests.add(request);
        return request.future;
      },
      onConfirmed: confirmed.add,
      onUnconfirmed: () => fail('no timeout expected'),
      interval: const Duration(milliseconds: 5),
      timeout: const Duration(minutes: 1),
    );
    addTearDown(watch.stop);
    watch.start(4);
    await tester.pump(const Duration(milliseconds: 5));
    expect(requests, hasLength(1));
    watch.start(5);
    await tester.pump(const Duration(milliseconds: 5));
    expect(requests, hasLength(2));
    requests[0].complete(6);
    await tester.pump();
    expect(confirmed, isEmpty);
    requests[1].complete(7);
    await tester.pump();
    expect(confirmed, [7]);
  });

  testWidgets('stop rejects an in-flight response', (tester) async {
    final pending = Completer<int?>();
    final watch = StorageOfficeSaveConfirmationWatch(
      readVersion: () => pending.future,
      onConfirmed: (_) => fail('stopped watch must not confirm'),
      onUnconfirmed: () => fail('stopped watch must not emit'),
      interval: const Duration(milliseconds: 5),
      timeout: const Duration(minutes: 1),
    );
    addTearDown(watch.stop);
    watch.start(4);
    await tester.pump(const Duration(milliseconds: 5));
    watch.stop();
    pending.complete(5);
    await tester.pump();
  });

  test('a pending request cannot suppress the confirmation deadline', () async {
    final pending = Completer<int?>();
    final requested = Completer<void>();
    final unconfirmed = Completer<void>();
    final confirmed = Completer<int>();
    final watch = StorageOfficeSaveConfirmationWatch(
      readVersion: () {
        if (!requested.isCompleted) requested.complete();
        return pending.future;
      },
      onConfirmed: confirmed.complete,
      onUnconfirmed: unconfirmed.complete,
      interval: const Duration(milliseconds: 5),
      timeout: const Duration(milliseconds: 15),
    );
    addTearDown(watch.stop);
    watch.start(4);
    await requested.future.timeout(const Duration(seconds: 1));
    await unconfirmed.future.timeout(const Duration(seconds: 1));
    expect(confirmed.isCompleted, isFalse);
    pending.complete(5);
    expect(await confirmed.future.timeout(const Duration(seconds: 1)), 5);
  });

  for (final throws in [false, true]) {
    testWidgets('read failure stays unconfirmed and recovers: throw=$throws', (
      tester,
    ) async {
      var calls = 0;
      var unconfirmed = 0;
      final confirmed = <int>[];
      final watch = StorageOfficeSaveConfirmationWatch(
        readVersion: () async {
          calls++;
          if (calls == 1) {
            if (throws) throw StateError('transport unavailable');
            return null;
          }
          return 5;
        },
        onConfirmed: confirmed.add,
        onUnconfirmed: () => unconfirmed++,
        interval: const Duration(milliseconds: 5),
        timeout: const Duration(minutes: 1),
      );
      addTearDown(watch.stop);
      watch.start(4);
      await tester.pump(const Duration(milliseconds: 5));
      expect(unconfirmed, 1);
      expect(confirmed, isEmpty);
      await tester.pump(const Duration(seconds: 5));
      expect(confirmed, [5]);
      expect(unconfirmed, 1);
    });
  }
}
