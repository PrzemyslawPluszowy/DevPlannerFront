import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/templates/cubit/task_template_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TaskTemplateRepository implements TaskTemplateRepository {
  Either<ApiError, TaskTemplateResponse>? createResult;
  CreateTaskTemplatePayload? createPayload;

  @override
  Future<Either<ApiError, TaskTemplateResponse>> create({
    required String workspaceId,
    required String taskId,
    required CreateTaskTemplatePayload payload,
  }) async {
    createPayload = payload;
    return createResult!;
  }

  @override
  Future<Either<ApiError, ProjectTaskResponse>> apply({
    required String workspaceId,
    required String templateId,
    required ApplyTaskTemplatePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String templateId,
    required int expectedVersion,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskTemplateResponse>> createFromDefinition({
    required String workspaceId,
    required CreateTaskTemplateDefinitionPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> details({
    required String workspaceId,
    required String templateId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> getDefault(
    String workspaceId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<TaskTemplateResponse>>> list(
    String workspaceId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> setDefault({
    required String workspaceId,
    required SetDefaultTaskTemplatePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> update({
    required String workspaceId,
    required String templateId,
    required UpdateTaskTemplatePayload payload,
  }) => throw UnimplementedError();
}

TaskTemplateResponse _template() => TaskTemplateResponse(
  id: 'template-1',
  workspaceId: 'workspace-1',
  name: 'Wdrożenie',
  updatedAtUtc: DateTime.utc(2026, 8, 26),
  version: 1,
);

TaskTemplateCubit _cubit(_TaskTemplateRepository repository) =>
    TaskTemplateCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      taskId: 'task-1',
    );

void main() {
  test('zapisuje przyciętą nazwę szablonu dla bieżącego zadania', () async {
    final repository = _TaskTemplateRepository()
      ..createResult = Right(_template());
    final cubit = _cubit(repository);

    await cubit.createFromTask('  Wdrożenie  ');

    expect(repository.createPayload?.name, 'Wdrożenie');
    expect(cubit.state, isA<TaskTemplateSaved>());
    await cubit.close();
  });

  test('pokazuje błąd zapisu zwrócony przez backend', () async {
    final repository = _TaskTemplateRepository()
      ..createResult = const Left(
        ApiError(type: ApiErrorType.conflict, message: 'Nazwa jest zajęta'),
      );
    final cubit = _cubit(repository);

    await cubit.createFromTask('Wdrożenie');

    expect((cubit.state as TaskTemplateFailure).message, 'Nazwa jest zajęta');
    await cubit.close();
  });

  test('nie wysyła pustej nazwy', () async {
    final repository = _TaskTemplateRepository();
    final cubit = _cubit(repository);

    await cubit.createFromTask('   ');

    expect(repository.createPayload, isNull);
    expect(cubit.state, isA<TaskTemplateIdle>());
    await cubit.close();
  });
}
