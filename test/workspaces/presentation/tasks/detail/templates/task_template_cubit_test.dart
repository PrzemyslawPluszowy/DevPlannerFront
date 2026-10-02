import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/templates/cubit/task_template_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TaskTemplateRepository implements TaskTemplateRepository {
  Either<ApiError, TaskTemplateResponse>? createResult;
  CreateTaskTemplatePayload? createPayload;
  String? createProjectId;
  Object? createException;
  Completer<Either<ApiError, TaskTemplateResponse>>? pending;
  int calls = 0;

  @override
  Future<Either<ApiError, TaskTemplateResponse>> create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskTemplatePayload payload,
  }) async {
    calls++;
    createPayload = payload;
    createProjectId = projectId;
    if (createException case final error?) return Future.error(error);
    if (pending case final response?) return response.future;
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
      projectId: 'project-1',
      taskId: 'task-1',
    );

void main() {
  test('zapisuje przyciętą nazwę szablonu dla bieżącego zadania', () async {
    final repository = _TaskTemplateRepository()
      ..createResult = Right(_template());
    final cubit = _cubit(repository);

    await cubit.createFromTask('  Wdrożenie  ');

    expect(repository.createPayload?.name, 'Wdrożenie');
    expect(repository.createProjectId, 'project-1');
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
  test('throws preserve ApiError and report lost access', () async {
    const error = ApiError(
      type: ApiErrorType.forbidden,
      message: 'No access',
      statusCode: 403,
      apiCode: 'tasks.forbidden',
      contractCode: 'forbidden',
      traceId: 'template-trace',
      fields: {
        'name': ['Denied'],
      },
    );
    final repository = _TaskTemplateRepository()..createException = error;
    final revoked = <ApiError>[];
    final cubit = TaskTemplateCubit(
      repository: repository,
      workspaceId: 'ws',
      projectId: 'project-1',
      taskId: 'task',
      onAccessLost: revoked.add,
    );
    await cubit.createFromTask('Draft');
    final failure = cubit.state as TaskTemplateFailure;
    expect(identical(failure.apiError, error), true);
    expect(revoked, [error]);
    await cubit.close();
  });

  test(
    'Dio429 keeps metadata and blocks repeated submit until deadline',
    () async {
      final request = RequestOptions(path: '/templates');
      final repository = _TaskTemplateRepository()
        ..createException = DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: request,
            statusCode: 429,
            headers: Headers.fromMap({
              'Retry-After': ['1'],
            }),
            data: {
              'code': 'tasks.rate_limit',
              'message': 'Wait',
              'traceId': '429-trace',
              'fields': {
                'name': ['Wait'],
              },
            },
          ),
        );
      final cubit = _cubit(repository);
      await cubit.createFromTask('Draft');
      final error = (cubit.state as TaskTemplateFailure).apiError!;
      expect(error.statusCode, 429);
      expect(error.traceId, '429-trace');
      expect(error.fields['name'], ['Wait']);
      expect(cubit.canSubmit, false);
      await cubit.createFromTask('Draft');
      expect(repository.calls, 1);
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      expect(cubit.canSubmit, true);
      repository.createException = null;
      repository.createResult = Right(_template());
      await cubit.createFromTask('Draft');
      expect(cubit.state, isA<TaskTemplateSaved>());
      expect(repository.calls, 2);
      await cubit.close();
    },
  );

  test('unknown exception is safe and releases saving state', () async {
    final repository = _TaskTemplateRepository()
      ..createException = StateError('private fixture');
    final cubit = _cubit(repository);
    await cubit.createFromTask('Draft');
    final failure = cubit.state as TaskTemplateFailure;
    expect(failure.message, isEmpty);
    expect(failure.apiError?.apiCode, 'tasks.template_save_failed');
    expect(cubit.canSubmit, true);
    await cubit.close();
  });

  test(
    'busy and closed owner reject duplicate submit and late response',
    () async {
      final pending = Completer<Either<ApiError, TaskTemplateResponse>>();
      final repository = _TaskTemplateRepository()..pending = pending;
      final cubit = _cubit(repository);
      final first = cubit.createFromTask('Draft');
      await cubit.createFromTask('Duplicate');
      expect(repository.calls, 1);
      await cubit.close();
      pending.complete(Right(_template()));
      await first;
      await cubit.createFromTask('After close');
      expect(repository.calls, 1);
      expect(cubit.state, isA<TaskTemplateSaving>());
    },
  );
}
