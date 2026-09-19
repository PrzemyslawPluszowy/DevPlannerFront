import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TaskTemplateRepository implements TaskTemplateRepository {
  Either<ApiError, List<TaskTemplateResponse>>? listResult;
  Either<ApiError, DefaultTaskTemplateResponse>? defaultResult;
  Either<ApiError, DefaultTaskTemplateResponse>? setDefaultResult;
  Either<ApiError, TaskTemplateDetailsResponse>? detailsResult;
  Either<ApiError, TaskTemplateDetailsResponse>? updateResult;
  Either<ApiError, TaskTemplateResponse>? createFromDefinitionResult;
  SetDefaultTaskTemplatePayload? setDefaultPayload;
  UpdateTaskTemplatePayload? updatePayload;
  CreateTaskTemplateDefinitionPayload? createFromDefinitionPayload;

  @override
  Future<Either<ApiError, TaskTemplateResponse>> createFromDefinition({
    required String workspaceId,
    required CreateTaskTemplateDefinitionPayload payload,
  }) async {
    createFromDefinitionPayload = payload;
    return createFromDefinitionResult!;
  }

  @override
  Future<Either<ApiError, List<TaskTemplateResponse>>> list(
    String workspaceId,
  ) async => listResult!;

  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> getDefault(
    String workspaceId,
  ) async => defaultResult!;

  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> setDefault({
    required String workspaceId,
    required SetDefaultTaskTemplatePayload payload,
  }) async {
    setDefaultPayload = payload;
    return setDefaultResult!;
  }

  @override
  Future<Either<ApiError, ProjectTaskResponse>> apply({
    required String workspaceId,
    required String templateId,
    required ApplyTaskTemplatePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskTemplateResponse>> create({
    required String workspaceId,
    required String taskId,
    required CreateTaskTemplatePayload payload,
  }) => throw UnimplementedError();

  Either<ApiError, Unit>? deleteResult;

  @override
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String templateId,
    required int expectedVersion,
  }) async => deleteResult ?? const Right(unit);

  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> details({
    required String workspaceId,
    required String templateId,
  }) async => detailsResult!;

  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> update({
    required String workspaceId,
    required String templateId,
    required UpdateTaskTemplatePayload payload,
  }) async {
    updatePayload = payload;
    return updateResult!;
  }
}

TaskTemplateResponse _template(String id) => TaskTemplateResponse(
  id: id,
  workspaceId: 'workspace-1',
  name: 'Szablon $id',
  updatedAtUtc: DateTime.utc(2026, 8, 26),
  version: 1,
);

TaskTemplatePickerCubit _cubit(_TaskTemplateRepository repository) =>
    TaskTemplatePickerCubit(repository: repository, workspaceId: 'workspace-1');

TaskTemplateDetailsResponse _details() => TaskTemplateDetailsResponse(
  id: 'template-1',
  name: 'Stara nazwa',
  title: 'Zadanie z szablonu',
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  assigneeUserIds: const ['user-1'],
  checklistItems: const ['Krok 1'],
  acceptanceCriteria: const ['Gotowe'],
  labels: const [],
  customFieldValues: const [],
  updatedAtUtc: DateTime.utc(2026, 8, 26),
  version: 4,
);

void main() {
  test('ładuje katalog i osobisty szablon domyślny', () async {
    final repository = _TaskTemplateRepository()
      ..listResult = Right([_template('template-1')])
      ..defaultResult = const Right(
        DefaultTaskTemplateResponse(taskTemplateId: 'template-1'),
      );
    final cubit = _cubit(repository);

    await cubit.load();

    final state = cubit.state as TaskTemplatePickerReady;
    expect(state.templates.single.id, 'template-1');
    expect(state.defaultTemplateId, 'template-1');
    await cubit.close();
  });

  test('czyści domyślny szablon przez jawny payload null', () async {
    final repository = _TaskTemplateRepository()
      ..listResult = Right([_template('template-1')])
      ..defaultResult = const Right(
        DefaultTaskTemplateResponse(taskTemplateId: 'template-1'),
      )
      ..setDefaultResult = const Right(DefaultTaskTemplateResponse());
    final cubit = _cubit(repository);
    await cubit.load();

    await cubit.toggleDefault('template-1');

    expect(repository.setDefaultPayload?.taskTemplateId, isNull);
    expect(
      (cubit.state as TaskTemplatePickerReady).defaultTemplateId,
      isNull,
    );
    await cubit.close();
  });

  test('po błędzie zapisu przywraca poprzednią preferencję', () async {
    final repository = _TaskTemplateRepository()
      ..listResult = Right([_template('template-1'), _template('template-2')])
      ..defaultResult = const Right(
        DefaultTaskTemplateResponse(taskTemplateId: 'template-1'),
      )
      ..setDefaultResult = const Left(
        ApiError(type: ApiErrorType.connection, message: 'Brak połączenia'),
      );
    final cubit = _cubit(repository);
    await cubit.load();

    await cubit.toggleDefault('template-2');

    final state = cubit.state as TaskTemplatePickerReady;
    expect(state.defaultTemplateId, 'template-1');
    expect(state.error, 'Brak połączenia');
    await cubit.close();
  });

  test(
    'zmienia tylko nazwę, zachowując pełne dane i wersję szablonu',
    () async {
      final details = _details();
      final repository = _TaskTemplateRepository()
        ..listResult = Right([_template('template-1')])
        ..defaultResult = const Right(DefaultTaskTemplateResponse())
        ..detailsResult = Right(details)
        ..updateResult = Right(details.copyWith(name: 'Nowa nazwa'));
      final cubit = _cubit(repository);
      await cubit.load();

      final result = await cubit.rename(
        templateId: 'template-1',
        name: '  Nowa nazwa ',
      );

      expect(result, isA<TaskTemplateMutationSuccess>());
      expect(repository.updatePayload?.name, 'Nowa nazwa');
      expect(repository.updatePayload?.title, details.title);
      expect(repository.updatePayload?.checklistItems, details.checklistItems);
      expect(repository.updatePayload?.expectedVersion, 4);
      await cubit.close();
    },
  );

  test('zapisuje pełną edycję szablonu z aktualną wersją', () async {
    final details = _details();
    final repository = _TaskTemplateRepository()
      ..listResult = Right([_template('template-1')])
      ..defaultResult = const Right(DefaultTaskTemplateResponse())
      ..updateResult = Right(details.copyWith(title: 'Nowy tytuł'));
    final cubit = _cubit(repository);
    await cubit.load();

    final result = await cubit.updateDetails(
      templateId: details.id,
      payload: UpdateTaskTemplatePayload(
        name: 'Plan wdrożenia',
        title: 'Nowy tytuł',
        description: 'Opis',
        descriptionDeltaJson: '[{"insert":"Opis\\n"}]',
        status: ProjectTaskStatus.inProgress,
        priority: TaskPriority.high,
        startAtUtc: DateTime.utc(2026, 9),
        dueAtUtc: DateTime.utc(2026, 9, 7),
        taskType: 'Feature',
        size: 34,
        complexity: 55,
        risk: 8,
        businessValue: 89,
        estimatedMinutes: 240,
        assigneeUserIds: const ['user-1'],
        checklistItems: const ['Projekt', 'Wdrożenie'],
        acceptanceCriteria: const ['Testy przechodzą'],
        labels: const [
          TaskTemplateLabelResponse(name: 'Backend', color: '#4C7CF3'),
        ],
        customFieldValues: const [
          TaskTemplateCustomFieldValueResponse(
            fieldName: 'Środowisko',
            fieldType: TaskCustomFieldType.text,
            value: 'Produkcja',
          ),
        ],
        expectedVersion: details.version,
      ),
    );

    expect(result, isA<TaskTemplateMutationSuccess>());
    final payload = repository.updatePayload;
    expect(payload?.name, 'Plan wdrożenia');
    expect(payload?.status, ProjectTaskStatus.inProgress);
    expect(payload?.priority, TaskPriority.high);
    expect(payload?.dueAtUtc, DateTime.utc(2026, 9, 7));
    expect(payload?.businessValue, 89);
    expect(payload?.labels?.single.name, 'Backend');
    expect(payload?.customFieldValues?.single.value, 'Produkcja');
    expect(payload?.expectedVersion, details.version);
    await cubit.close();
  });

  test('tworzy nową definicję szablonu i odświeża katalog', () async {
    final repository = _TaskTemplateRepository()
      ..listResult = Right([_template('template-1')])
      ..defaultResult = const Right(DefaultTaskTemplateResponse())
      ..createFromDefinitionResult = Right(_template('template-new'));
    final cubit = _cubit(repository);
    await cubit.load();

    final result = await cubit.createFromDefinition(
      const CreateTaskTemplateDefinitionPayload(
        name: 'Nowy Szablon',
        title: 'Szablonowe zadanie',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.high,
      ),
    );

    expect(result, isA<TaskTemplateMutationSuccess>());
    expect(repository.createFromDefinitionPayload?.name, 'Nowy Szablon');
    expect(repository.createFromDefinitionPayload?.title, 'Szablonowe zadanie');
    expect(
      repository.createFromDefinitionPayload?.status,
      ProjectTaskStatus.todo,
    );
    expect(repository.createFromDefinitionPayload?.priority, TaskPriority.high);
    await cubit.close();
  });

  test(
    'loadDetails zachowuje pełny ApiError przy błędzie pobierania',
    () async {
      final repository = _TaskTemplateRepository()
        ..detailsResult = const Left(
          ApiError(
            type: ApiErrorType.notFound,
            message: 'Szablon nie istnieje',
          ),
        );
      final cubit = _cubit(repository);

      final result = await cubit.loadDetails('missing-template');

      expect(result, isA<TaskTemplateDetailsLoadFailure>());
      final failure = result as TaskTemplateDetailsLoadFailure;
      expect(failure.error.message, 'Szablon nie istnieje');
      expect(failure.error.type, ApiErrorType.notFound);
      await cubit.close();
    },
  );

  test('błąd mutacji zwraca TaskTemplateMutationFailure i zachowuje listę szablonów', () async {
    final repository = _TaskTemplateRepository()
      ..listResult = Right([_template('template-1')])
      ..defaultResult = const Right(DefaultTaskTemplateResponse())
      ..createFromDefinitionResult = const Left(
        ApiError(type: ApiErrorType.validation, message: 'Nazwa zajęta'),
      );
    final cubit = _cubit(repository);
    await cubit.load();

    final result = await cubit.createFromDefinition(
      const CreateTaskTemplateDefinitionPayload(
        name: 'Zdublowana nazwa',
        title: 'Zadanie',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
      ),
    );

    expect(result, isA<TaskTemplateMutationFailure>());
    expect(
      (result as TaskTemplateMutationFailure).error.message,
      'Nazwa zajęta',
    );

    final state = cubit.state as TaskTemplatePickerReady;
    expect(state.templates.single.id, 'template-1');
    expect(state.isCreating, isFalse);
    expect(state.error, 'Nazwa zajęta');
    await cubit.close();
  });

  test(
    'konflikt 409 podczas edycji zwraca błąd i nie zamyka stanu edycji',
    () async {
      final details = _details();
      final repository = _TaskTemplateRepository()
        ..listResult = Right([_template('template-1')])
        ..defaultResult = const Right(DefaultTaskTemplateResponse())
        ..updateResult = const Left(
          ApiError(
            type: ApiErrorType.conflict,
            message: 'Wersja została zmieniona przez innego użytkownika',
          ),
        );
      final cubit = _cubit(repository);
      await cubit.load();

      final result = await cubit.updateDetails(
        templateId: details.id,
        payload: const UpdateTaskTemplatePayload(
          name: 'Zaktualizowana nazwa',
          status: ProjectTaskStatus.todo,
          priority: TaskPriority.normal,
          expectedVersion: 2,
        ),
      );

      expect(result, isA<TaskTemplateMutationFailure>());
      expect(
        (result as TaskTemplateMutationFailure).error.type,
        ApiErrorType.conflict,
      );
      final state = cubit.state as TaskTemplatePickerReady;
      expect(state.updatingTemplateId, isNull);
      expect(state.error, 'Wersja została zmieniona przez innego użytkownika');
      await cubit.close();
    },
  );

  test('cichy refresh nie emituje TaskTemplatePickerLoading', () async {
    final repository = _TaskTemplateRepository()
      ..listResult = Right([_template('template-1')])
      ..defaultResult = const Right(DefaultTaskTemplateResponse());
    final cubit = _cubit(repository);
    await cubit.load();

    final states = <TaskTemplatePickerState>[];
    final subscription = cubit.stream.listen(states.add);

    repository.listResult = Right([
      _template('template-1'),
      _template('template-2'),
    ]);
    await cubit.refresh();

    expect(states.any((s) => s is TaskTemplatePickerLoading), isFalse);
    final finalState = cubit.state as TaskTemplatePickerReady;
    expect(finalState.templates.length, 2);

    await subscription.cancel();
    await cubit.close();
  });

  test(
    'usunięcie domyślnego szablonu czyści natychmiast preferencję w UI',
    () async {
      final repository = _TaskTemplateRepository()
        ..listResult = Right([_template('template-1')])
        ..defaultResult = const Right(
          DefaultTaskTemplateResponse(taskTemplateId: 'template-1'),
        );
      final cubit = _cubit(repository);
      await cubit.load();

      expect(
        (cubit.state as TaskTemplatePickerReady).defaultTemplateId,
        'template-1',
      );

      repository.listResult = const Right([]);
      repository.defaultResult = const Right(DefaultTaskTemplateResponse());
      final deleteResult = await cubit.delete('template-1');

      expect(deleteResult, isA<TaskTemplateMutationSuccess>());
      final state = cubit.state as TaskTemplatePickerReady;
      expect(state.defaultTemplateId, isNull);
      await cubit.close();
    },
  );
}
