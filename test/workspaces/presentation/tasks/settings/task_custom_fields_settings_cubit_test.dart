import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/task_custom_fields_settings_cubit.dart';

final class _MetadataRepository implements TaskMetadataRepository {
  List<TaskCustomFieldResponse> fields = [_field('field-1', 'Faza', 3)];
  CreateTaskCustomFieldPayload? createPayload;
  UpdateTaskCustomFieldPayload? updatePayload;
  String? archivedId;

  @override
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  }) async => Right(fields);

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> createCustomField({
    required String workspaceId,
    required String projectId,
    required CreateTaskCustomFieldPayload payload,
  }) async {
    createPayload = payload;
    final field = TaskCustomFieldResponse(
      id: 'field-2',
      name: payload.name,
      type: payload.type,
      isRequired: payload.isRequired,
      position: payload.position,
      options: payload.options,
    );
    fields = [...fields, field];
    return Right(field);
  }

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> updateCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
    required UpdateTaskCustomFieldPayload payload,
  }) async {
    updatePayload = payload;
    final previous = fields.singleWhere((field) => field.id == fieldId);
    final updated = previous.copyWith(
      name: payload.name,
      isRequired: payload.isRequired,
      options: payload.options,
    );
    fields = [
      for (final field in fields)
        if (field.id == fieldId) updated else field,
    ];
    return Right(updated);
  }

  @override
  Future<Either<ApiError, Unit>> archiveCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
  }) async {
    archivedId = fieldId;
    fields = fields.where((field) => field.id != fieldId).toList();
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, List<TaskLabelResponse>>> listLabels({
    required String workspaceId,
    required String projectId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskLabelResponse>> createLabel({
    required String workspaceId,
    required String projectId,
    required CreateTaskLabelPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskLabelResponse>> updateLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
    required UpdateTaskLabelPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> archiveLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskMutationResponse<List<TaskLabelResponse>>>>
  replaceLabels({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskLabelsPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<
    Either<ApiError, TaskMutationResponse<List<TaskCustomFieldValueResponse>>>
  >
  replaceCustomFieldValues({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskCustomFieldValuesPayload payload,
  }) => throw UnimplementedError();
}

TaskCustomFieldResponse _field(String id, String name, int position) =>
    TaskCustomFieldResponse(
      id: id,
      name: name,
      type: TaskCustomFieldType.singleSelect,
      isRequired: false,
      position: position,
      options: ['Planowanie', 'Realizacja'],
    );

void main() {
  late _MetadataRepository repository;
  late TaskCustomFieldsSettingsCubit cubit;

  setUp(() {
    repository = _MetadataRepository();
    cubit = TaskCustomFieldsSettingsCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
  });

  tearDown(() => cubit.close());

  test('tworzy select z oczyszczonymi, unikalnymi opcjami', () async {
    await cubit.load();

    expect(
      await cubit.save(
        name: '  Etap  ',
        type: TaskCustomFieldType.singleSelect,
        isRequired: true,
        options: [' Planowanie ', '', 'Realizacja', 'Planowanie'],
      ),
      isTrue,
    );

    expect(repository.createPayload?.name, 'Etap');
    expect(repository.createPayload?.position, 4);
    expect(repository.createPayload?.options, ['Planowanie', 'Realizacja']);
  });

  test('odrzuca select bez opcji bez wywoływania backendu', () async {
    await cubit.load();

    expect(
      await cubit.save(
        name: 'Etap',
        type: TaskCustomFieldType.multiSelect,
        isRequired: false,
        options: ['', ' '],
      ),
      isFalse,
    );
    expect(repository.createPayload, isNull);
  });

  test('aktualizuje bez zmiany typu i archiwizuje definicję', () async {
    await cubit.load();
    final original =
        (cubit.state as TaskCustomFieldsSettingsReady).fields.single;

    expect(
      await cubit.save(
        existing: original,
        name: 'Faza projektu',
        type: TaskCustomFieldType.text,
        isRequired: true,
        options: ['Analiza', 'Wdrożenie'],
      ),
      isTrue,
    );
    expect(repository.updatePayload?.name, 'Faza projektu');
    expect(repository.updatePayload?.options, ['Analiza', 'Wdrożenie']);

    final updated =
        (cubit.state as TaskCustomFieldsSettingsReady).fields.single;
    expect(await cubit.archive(updated), isTrue);
    expect(repository.archivedId, 'field-1');
    expect((cubit.state as TaskCustomFieldsSettingsReady).fields, isEmpty);
  });
}
