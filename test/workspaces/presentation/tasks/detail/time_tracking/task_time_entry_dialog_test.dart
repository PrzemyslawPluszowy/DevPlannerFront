import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_time_entry_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskTimeTrackingRepository {
  Either<ApiError, TaskTimeEntryResponse> createResult = const Left(
    ApiError(
      type: ApiErrorType.validation,
      message: 'Duration is outside the permitted range.',
      statusCode: 400,
      contractCode: 'time_entry_invalid',
      fields: {
        'durationMinutes': ['Must be between 1 and 1440.'],
      },
      traceId: 'time-trace-42',
    ),
  );

  @override
  Future<Either<ApiError, List<TaskTimeEntryResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, TaskTimeEntryResponse>> create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskTimeEntryPayload payload,
  }) async => createResult;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('keeps a failed manual time draft visible and allows retry', (
    tester,
  ) async {
    final repository = _Repository();
    final cubit = TaskTimeTrackingCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MaterialTheme.crm().light(),
        home: TaskDetailsModalTheme(
          child: BlocProvider.value(
            value: cubit,
            child: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: cubit,
                      child: const ManualTimeEntryDialog(),
                    ),
                  ),
                  child: const Text('Open manual entry'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open manual entry'));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)))!;
    await tester.enterText(find.byType(TextField).first, '45');
    await tester.tap(find.text(l10n.save));
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailsModalError), findsOneWidget);
    final error = tester.widget<TaskDetailsModalError>(
      find.byType(TaskDetailsModalError),
    );
    expect(error.error.contractCode, 'time_entry_invalid');
    expect(error.error.traceId, 'time-trace-42');
    expect(error.error.fields['durationMinutes'], [
      'Must be between 1 and 1440.',
    ]);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      '45',
    );

    repository.createResult = Right(
      TaskTimeEntryResponse(
        id: 'entry-1',
        taskId: 'task-1',
        userId: 'user-1',
        kind: TaskTimeEntryKind.manual,
        startedAtUtc: DateTime.utc(2026, 9, 30, 9),
        stoppedAtUtc: DateTime.utc(2026, 9, 30, 9, 45),
        durationMinutes: 45,
        isBillable: true,
        createdAtUtc: DateTime.utc(2026, 9, 30),
        approvalStatus: TaskTimeEntryApprovalStatus.draft,
        version: 1,
        canSubmit: true,
      ),
    );
    await tester.tap(find.text(l10n.save));
    await tester.pumpAndSettle();

    expect(find.byType(ManualTimeEntryDialog), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });
}
