import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/domain/repositories/kanban_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/kanban_settings_cubit.dart';

void main() {
  group('KanbanSettingsCubit', () {
    test('ładuje ustawienia i porządkuje pola deterministycznie', () async {
      final cubit = KanbanSettingsCubit(
        repository: _KanbanRepository(),
        workspaceId: 'workspace',
        projectId: 'project',
      );

      await cubit.load();

      final state = cubit.state as KanbanSettingsReady;
      expect(state.settings.hiddenColumns, [ProjectTaskStatus.todo]);
      expect(state.settings.visibleCardFields, [
        KanbanCardField.assignee,
        KanbanCardField.labels,
      ]);
    });

    test('nie zapisuje zmian przed jawnym zapisem', () async {
      final repository = _KanbanRepository();
      final cubit = KanbanSettingsCubit(
        repository: repository,
        workspaceId: 'workspace',
        projectId: 'project',
      );
      await cubit.load();

      cubit.setWipLimit(ProjectTaskStatus.inProgress, 3);
      cubit.setColumnVisible(ProjectTaskStatus.todo, true);
      cubit.setCardFieldVisible(KanbanCardField.labels, false);

      expect(repository.updateCalls, 0);
      final settings = (cubit.state as KanbanSettingsReady).settings;
      expect(settings.columnWipLimits['InProgress'], 3);
      expect(settings.hiddenColumns, isEmpty);
      expect(settings.visibleCardFields, [KanbanCardField.assignee]);
    });

    test(
      'wysyła pełny payload z aktualną wersją i zastępuje wersję odpowiedzią',
      () async {
        final repository = _KanbanRepository();
        final cubit = KanbanSettingsCubit(
          repository: repository,
          workspaceId: 'workspace',
          projectId: 'project',
        );
        await cubit.load();
        cubit.setSwimlaneMode(KanbanSwimlaneMode.assignee);

        expect(await cubit.save(), isTrue);

        expect(repository.updateCalls, 1);
        expect(repository.payload!.expectedVersion, 4);
        expect(repository.payload!.swimlaneMode, KanbanSwimlaneMode.assignee);
        expect((cubit.state as KanbanSettingsReady).settings.version, 5);
      },
    );
  });
}

final class _KanbanRepository implements KanbanRepository {
  int updateCalls = 0;
  UpdateProjectKanbanSettingsPayload? payload;

  @override
  Future<Either<ApiError, ProjectKanbanSettingsResponse>> getSettings({
    required String workspaceId,
    required String projectId,
  }) async => Right(_settings());

  @override
  Future<Either<ApiError, ProjectKanbanSettingsResponse>> updateSettings({
    required String workspaceId,
    required String projectId,
    required UpdateProjectKanbanSettingsPayload payload,
  }) async {
    updateCalls++;
    this.payload = payload;
    return Right(
      _settings().copyWith(
        swimlaneMode: payload.swimlaneMode,
        columnWipLimits: payload.columnWipLimits,
        hiddenColumns: payload.hiddenColumns,
        visibleCardFields: payload.visibleCardFields ?? const [],
        defaultCardDensity: payload.defaultCardDensity,
        version: 5,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ProjectKanbanSettingsResponse _settings() => ProjectKanbanSettingsResponse(
  projectId: 'project',
  swimlaneMode: KanbanSwimlaneMode.none,
  columnWipLimits: const {},
  hiddenColumns: [ProjectTaskStatus.todo],
  visibleCardFields: [KanbanCardField.labels, KanbanCardField.assignee],
  defaultCardDensity: KanbanCardDensity.comfortable,
  updatedAtUtc: DateTime.utc(2026),
  version: 4,
);
