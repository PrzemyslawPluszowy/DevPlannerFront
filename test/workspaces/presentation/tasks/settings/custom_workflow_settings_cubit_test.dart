import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/custom_workflow_settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements CustomWorkflowRepository {
  DeleteProjectCustomStatusPayload? deleted;
  UpdateProjectCustomStatusPayload? updated;
  ReorderProjectCustomStatusesPayload? reordered;
  ApplyWorkflowTemplatePayload? appliedTemplate;
  final statuses = const [
    ProjectCustomStatusResponse(
      id: 'a',
      projectId: 'p',
      name: 'Todo',
      colorHex: '#111111',
      category: TaskStatusCategory.todo,
      position: 0,
      isDefault: true,
      taskCount: 0,
      version: 7,
    ),
    ProjectCustomStatusResponse(
      id: 'b',
      projectId: 'p',
      name: 'Done',
      colorHex: '#222222',
      category: TaskStatusCategory.done,
      position: 1,
      isDefault: false,
      taskCount: 0,
      version: 9,
    ),
  ];
  @override
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> listStatuses({
    required String workspaceId,
    required String projectId,
  }) async => Right(statuses);
  @override
  Future<Either<ApiError, List<WorkflowTemplateSummary>>> listTemplates({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);
  @override
  Future<Either<ApiError, AdminMutationResponse>> deleteStatus({
    required String workspaceId,
    required String projectId,
    required String statusId,
    required DeleteProjectCustomStatusPayload payload,
  }) async {
    deleted = payload;
    return const Right(AdminMutationResponse());
  }

  @override
  Future<Either<ApiError, ProjectCustomStatusResponse>> updateStatus({
    required String workspaceId,
    required String projectId,
    required String statusId,
    required UpdateProjectCustomStatusPayload payload,
  }) async {
    updated = payload;
    return Right(
      statuses.first.copyWith(
        name: payload.name,
        colorHex: payload.colorHex,
        category: payload.category,
        wipLimit: payload.wipLimit,
        isDefault: payload.isDefault,
      ),
    );
  }

  @override
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> reorderStatuses({
    required String workspaceId,
    required String projectId,
    required ReorderProjectCustomStatusesPayload payload,
  }) async {
    reordered = payload;
    return Right(
      payload.statusIds.reversed
          .map((id) => statuses.firstWhere((item) => item.id == id))
          .toList(),
    );
  }

  @override
  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> applyTemplate({
    required String workspaceId,
    required String projectId,
    required ApplyWorkflowTemplatePayload payload,
  }) async {
    appliedTemplate = payload;
    return Right(statuses.reversed.toList());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('usuwa status z fallbackiem i expectedVersion', () async {
    final repository = _Repository();
    final cubit = CustomWorkflowSettingsCubit(
      repository: repository,
      workspaceId: 'w',
      projectId: 'p',
    );
    await cubit.load();
    expect(await cubit.delete(repository.statuses.first, 'b'), isTrue);
    expect(repository.deleted?.fallbackStatusId, 'b');
    expect(repository.deleted?.expectedVersion, 7);
    await cubit.close();
  });

  test('edycja przekazuje kolor, kategorię i wersję statusu', () async {
    final repository = _Repository();
    final cubit = CustomWorkflowSettingsCubit(
      repository: repository,
      workspaceId: 'w',
      projectId: 'p',
    );
    await cubit.load();

    expect(
      await cubit.update(
        status: repository.statuses.first,
        name: '  W realizacji  ',
        colorHex: '#2563EB',
        category: TaskStatusCategory.inProgress,
        wipLimit: 4,
        isDefault: false,
      ),
      isTrue,
    );

    expect(repository.updated?.name, 'W realizacji');
    expect(repository.updated?.colorHex, '#2563EB');
    expect(repository.updated?.category, TaskStatusCategory.inProgress);
    expect(repository.updated?.wipLimit, 4);
    expect(repository.updated?.expectedVersion, 7);
    await cubit.close();
  });

  test('reorder i szablon wysyłają pełne, jawne payloady', () async {
    final repository = _Repository();
    final cubit = CustomWorkflowSettingsCubit(
      repository: repository,
      workspaceId: 'w',
      projectId: 'p',
    );
    await cubit.load();

    expect(await cubit.reorder(repository.statuses.reversed.toList()), isTrue);
    expect(repository.reordered?.statusIds, ['b', 'a']);
    expect(await cubit.applyTemplate('scrum'), isTrue);
    expect(repository.appliedTemplate?.templateKey, 'scrum');
    expect(repository.appliedTemplate?.replaceExisting, isTrue);
    await cubit.close();
  });
}
