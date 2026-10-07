import 'dart:async';

import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/cubit/workspace_quick_create_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'opening failure retries the created ID without a second mutation',
    () async {
      final gateway = _Gateway();
      final cubit = WorkspaceQuickCreateCubit(gateway: gateway);
      addTearDown(cubit.close);
      final first = cubit.createOrRetry('QA');
      expect(await cubit.createOrRetry('QA'), isNull);
      gateway.pending.complete(_created);
      expect(await first, 'created');
      cubit.finishOpening(succeeded: false);
      expect(cubit.state.openFailed, isTrue);
      expect(await cubit.createOrRetry('QA'), 'created');
      expect(gateway.calls, 1);
      cubit.finishOpening(succeeded: true);
      expect(cubit.state.openFailed, isFalse);
      expect(cubit.state.isSubmitting, isFalse);
    },
  );

  test('late creation after close has no result for navigation', () async {
    final gateway = _Gateway();
    final cubit = WorkspaceQuickCreateCubit(gateway: gateway);
    final result = cubit.createOrRetry('QA');
    await cubit.close();
    gateway.pending.complete(_created);
    expect(await result, isNull);
  });
}

const _created = WorkspaceSummary(
  id: 'created',
  name: 'QA',
  isPinned: false,
  isHidden: false,
  isOwner: true,
);

final class _Gateway implements WorkspaceManagementGateway {
  final pending = Completer<WorkspaceSummary>();
  int calls = 0;

  @override
  Future<WorkspaceSummary> createWorkspace({required String name}) {
    calls++;
    return pending.future;
  }
}
