import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/milestone/cubit/task_milestone_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_milestone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements MilestoneRepository {}

void main() {
  for (final dark in [false, true]) {
    testWidgets('milestone picker long error 200%, dark=$dark', (tester) async {
      tester.view.physicalSize = const Size(420, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repository = _Repository();
      final milestone = MilestoneResponse(
        id: 'milestone-1',
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        name: 'Release',
        status: MilestoneStatus.active,
        progress: 0,
        createdAtUtc: DateTime.utc(2026),
        updatedAtUtc: DateTime.utc(2026),
        version: 1,
      );
      final error = ApiError(
        type: ApiErrorType.validation,
        message: List.filled(12, 'Long actionable error message').join(' '),
        apiCode: 'milestone.validation_failed',
        traceId: 'trace-milestone',
        statusCode: 422,
        fields: {
          for (var i = 0; i < 30; i++) 'field-$i': ['Invalid value $i'],
        },
      );
      when(
        () => repository.listMilestones(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer((_) async => Right([milestone]));
      when(
        () => repository.assignTask(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          milestoneId: 'milestone-1',
          taskId: 'task-1',
        ),
      ).thenThrow(error);
      final cubit = TaskMilestoneCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
        assignedMilestoneId: null,
      );
      addTearDown(cubit.close);
      await cubit.load();
      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            theme: dark
                ? MaterialTheme.crm().dark()
                : MaterialTheme.crm().light(),
            locale: Locale(dark ? 'en' : 'pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => TaskMilestonePickerLauncher.show(
                    context,
                    cubit.state as TaskMilestoneReady,
                  ),
                  child: const Text('Open milestone'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open milestone'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Release'));
      await tester.pumpAndSettle();
      expect((cubit.state as TaskMilestoneReady).apiError, same(error));
      expect(tester.takeException(), isNull);
      expect(find.textContaining('trace-milestone'), findsOneWidget);
      expect(find.textContaining('milestone.validation_failed'), findsWidgets);
      expect(find.byIcon(Symbols.close).hitTestable(), findsOneWidget);
      await tester.tap(find.byIcon(Symbols.close));
      await tester.pumpAndSettle();
      expect(find.byType(TaskMilestonePicker), findsNothing);
      expect(tester.takeException(), isNull);
      verify(
        () => repository.assignTask(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          milestoneId: 'milestone-1',
          taskId: 'task-1',
        ),
      ).called(1);
    });
  }
}
