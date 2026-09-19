import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/task_labels_settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MetadataRepository implements TaskMetadataRepository {
  List<TaskLabelResponse> labels = [_label('label-1', 'Pilne', '#D63031')];
  CreateTaskLabelPayload? createPayload;
  UpdateTaskLabelPayload? updatePayload;
  String? archivedId;

  @override
  Future<Either<ApiError, List<TaskLabelResponse>>> listLabels({
    required String workspaceId,
    required String projectId,
  }) async => Right(labels);

  @override
  Future<Either<ApiError, TaskLabelResponse>> createLabel({
    required String workspaceId,
    required String projectId,
    required CreateTaskLabelPayload payload,
  }) async {
    createPayload = payload;
    final label = _label('label-2', payload.name, payload.color);
    labels = [...labels, label];
    return Right(label);
  }

  @override
  Future<Either<ApiError, TaskLabelResponse>> updateLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
    required UpdateTaskLabelPayload payload,
  }) async {
    updatePayload = payload;
    final label = _label(labelId, payload.name, payload.color);
    labels = [
      for (final item in labels)
        if (item.id != labelId) item,
      label,
    ];
    return Right(label);
  }

  @override
  Future<Either<ApiError, Unit>> archiveLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
  }) async {
    archivedId = labelId;
    labels = labels.where((label) => label.id != labelId).toList();
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> createCustomField({
    required String workspaceId,
    required String projectId,
    required CreateTaskCustomFieldPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> updateCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
    required UpdateTaskCustomFieldPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> archiveCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
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

TaskLabelResponse _label(String id, String name, String color) =>
    TaskLabelResponse(
      id: id,
      name: name,
      color: color,
      createdAtUtc: DateTime.utc(2026),
    );

void main() {
  late _MetadataRepository repository;
  late TaskLabelsSettingsCubit cubit;

  setUp(() {
    repository = _MetadataRepository();
    cubit = TaskLabelsSettingsCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
  });

  tearDown(() => cubit.close());

  test('tworzy etykietę z oczyszczoną nazwą i kolorem', () async {
    await cubit.load();

    final saved = await cubit.save(name: '  Backend  ', color: '#0984e3');

    expect(saved, isTrue);
    expect(repository.createPayload?.name, 'Backend');
    expect(repository.createPayload?.color, '#0984E3');
    expect((cubit.state as TaskLabelsSettingsReady).labels, hasLength(2));
  });

  test('odrzuca pustą nazwę i kolor poza formatem #RRGGBB', () async {
    await cubit.load();

    expect(await cubit.save(name: ' ', color: '#0984E3'), isFalse);
    expect(await cubit.save(name: 'Nowa', color: 'blue'), isFalse);
    expect(repository.createPayload, isNull);
  });

  test(
    'aktualizuje i archiwizuje etykietę lokalnie po sukcesie backendu',
    () async {
      await cubit.load();
      final original = (cubit.state as TaskLabelsSettingsReady).labels.single;

      expect(
        await cubit.save(
          existing: original,
          name: 'Zmienione',
          color: '#00A884',
        ),
        isTrue,
      );
      expect(repository.updatePayload?.name, 'Zmienione');
      final updated = (cubit.state as TaskLabelsSettingsReady).labels.single;
      expect(await cubit.archive(updated), isTrue);
      expect(repository.archivedId, 'label-1');
      expect((cubit.state as TaskLabelsSettingsReady).labels, isEmpty);
    },
  );
}
