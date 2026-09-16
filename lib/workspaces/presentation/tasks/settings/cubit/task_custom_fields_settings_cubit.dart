import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';

sealed class TaskCustomFieldsSettingsState {
  const TaskCustomFieldsSettingsState();
}

final class TaskCustomFieldsSettingsInitial
    extends TaskCustomFieldsSettingsState {
  const TaskCustomFieldsSettingsInitial();
}

final class TaskCustomFieldsSettingsLoading
    extends TaskCustomFieldsSettingsState {
  const TaskCustomFieldsSettingsLoading();
}

final class TaskCustomFieldsSettingsFailure
    extends TaskCustomFieldsSettingsState {
  const TaskCustomFieldsSettingsFailure(this.message);

  final String message;
}

final class TaskCustomFieldsSettingsReady
    extends TaskCustomFieldsSettingsState {
  const TaskCustomFieldsSettingsReady({
    required this.fields,
    this.isSaving = false,
    this.error,
  });

  final List<TaskCustomFieldResponse> fields;
  final bool isSaving;
  final String? error;

  TaskCustomFieldsSettingsReady copyWith({
    List<TaskCustomFieldResponse>? fields,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => TaskCustomFieldsSettingsReady(
    fields: fields ?? this.fields,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Katalog definicji pól własnych projektu, niezależny od wartości tasków.
final class TaskCustomFieldsSettingsCubit
    extends Cubit<TaskCustomFieldsSettingsState> {
  TaskCustomFieldsSettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskCustomFieldsSettingsInitial());

  final TaskMetadataRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const TaskCustomFieldsSettingsLoading());
    final result = await repository.listCustomFields(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskCustomFieldsSettingsFailure(error.message)),
      (fields) => emit(TaskCustomFieldsSettingsReady(fields: _sorted(fields))),
    );
  }

  Future<bool> save({
    TaskCustomFieldResponse? existing,
    required String name,
    required TaskCustomFieldType type,
    required bool isRequired,
    required List<String> options,
  }) async {
    final current = state;
    final normalizedName = name.trim();
    final normalizedOptions = _normalizeOptions(options);
    if (current is! TaskCustomFieldsSettingsReady ||
        current.isSaving ||
        normalizedName.isEmpty ||
        !_areOptionsValid(type, normalizedOptions)) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final position = existing?.position ?? _nextPosition(current.fields);
    final result = existing == null
        ? await repository.createCustomField(
            workspaceId: workspaceId,
            projectId: projectId,
            payload: CreateTaskCustomFieldPayload(
              name: normalizedName,
              type: type,
              isRequired: isRequired,
              position: position,
              options: _optionsFor(type, normalizedOptions),
            ),
          )
        : await repository.updateCustomField(
            workspaceId: workspaceId,
            projectId: projectId,
            fieldId: existing.id,
            payload: UpdateTaskCustomFieldPayload(
              name: normalizedName,
              isRequired: isRequired,
              position: position,
              options: _optionsFor(existing.type, normalizedOptions),
            ),
          );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (field) {
        final fields = [
          for (final item in current.fields)
            if (item.id != field.id) item,
          field,
        ];
        emit(TaskCustomFieldsSettingsReady(fields: _sorted(fields)));
        return true;
      },
    );
  }

  Future<bool> archive(TaskCustomFieldResponse field) async {
    final current = state;
    if (current is! TaskCustomFieldsSettingsReady || current.isSaving) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.archiveCustomField(
      workspaceId: workspaceId,
      projectId: projectId,
      fieldId: field.id,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        emit(
          TaskCustomFieldsSettingsReady(
            fields: current.fields
                .where((item) => item.id != field.id)
                .toList(),
          ),
        );
        return true;
      },
    );
  }

  /// Zmienia kolejność pola w projekcie, aktualizując jego pozycję na backendzie.
  Future<bool> moveField(int oldIndex, int newIndex) async {
    final current = state;
    if (current is! TaskCustomFieldsSettingsReady || current.isSaving) {
      return false;
    }
    if (oldIndex < 0 ||
        oldIndex >= current.fields.length ||
        newIndex < 0 ||
        newIndex >= current.fields.length ||
        oldIndex == newIndex) {
      return false;
    }

    final list = List<TaskCustomFieldResponse>.from(current.fields);
    final movedItem = list.removeAt(oldIndex);
    list.insert(newIndex, movedItem);

    int newPosition;
    if (newIndex == 0) {
      newPosition = (list[1].position / 2).floor();
      if (newPosition <= 0) newPosition = 500;
    } else if (newIndex == list.length - 1) {
      newPosition = list[newIndex - 1].position + 1000;
    } else {
      final prev = list[newIndex - 1].position;
      final next = list[newIndex + 1].position;
      newPosition = ((prev + next) / 2).floor();
      if (newPosition == prev || newPosition == next) {
        newPosition = prev + 500;
      }
    }

    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.updateCustomField(
      workspaceId: workspaceId,
      projectId: projectId,
      fieldId: movedItem.id,
      payload: UpdateTaskCustomFieldPayload(
        name: movedItem.name,
        isRequired: movedItem.isRequired,
        position: newPosition,
        options: movedItem.options,
      ),
    );

    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (savedField) {
        final fields = [
          for (final f in list)
            if (f.id == savedField.id) savedField else f,
        ];
        emit(TaskCustomFieldsSettingsReady(fields: _sorted(fields)));
        return true;
      },
    );
  }

  static bool supportsOptions(TaskCustomFieldType type) =>
      type == TaskCustomFieldType.singleSelect ||
      type == TaskCustomFieldType.multiSelect;

  static List<String> _normalizeOptions(List<String> options) {
    final seen = <String>{};
    return [
      for (final option in options.map((value) => value.trim()))
        if (option.isNotEmpty && seen.add(option)) option,
    ];
  }

  static bool _areOptionsValid(
    TaskCustomFieldType type,
    List<String> options,
  ) => !supportsOptions(type) || options.isNotEmpty;

  static List<String>? _optionsFor(
    TaskCustomFieldType type,
    List<String> options,
  ) => supportsOptions(type) ? options : null;

  static int _nextPosition(List<TaskCustomFieldResponse> fields) =>
      fields.fold(
        0,
        (highest, field) => field.position > highest ? field.position : highest,
      ) +
      1;

  static List<TaskCustomFieldResponse> _sorted(
    List<TaskCustomFieldResponse> fields,
  ) =>
      [...fields]
        ..sort((left, right) => left.position.compareTo(right.position));
}
