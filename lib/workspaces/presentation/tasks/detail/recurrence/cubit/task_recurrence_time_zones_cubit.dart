import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_detail_operation_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_time_zones_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wczytuje i wyszukuje katalog z dokładnego hosta API dla jednego projektu.
final class TaskRecurrenceTimeZonesCubit
    extends Cubit<TaskRecurrenceTimeZonesState> {
  TaskRecurrenceTimeZonesCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.currentId,
  }) : super(const TaskRecurrenceTimeZonesLoading());

  final TaskRecurrenceRepository repository;
  final String workspaceId;
  final String projectId;
  final String currentId;
  int _generation = 0;
  List<String> _allZones = const [];
  String _query = '';
  Timer? _retryTimer;
  bool _loading = false;

  Future<void> load() async {
    if (isClosed || _loading) return;
    if (state case TaskRecurrenceTimeZonesFailure(
      :final error,
      canRetry: false,
    )) {
      final deadline = error.retryAfterUtc;
      if (deadline != null && deadline.isAfter(DateTime.now().toUtc())) return;
    }
    _retryTimer?.cancel();
    final generation = ++_generation;
    _loading = true;
    emit(const TaskRecurrenceTimeZonesLoading());
    late final Either<ApiError, List<String>> result;
    ApiError? thrownError;
    try {
      result = await repository.listSupportedTimeZones(
        workspaceId: workspaceId,
        projectId: projectId,
      );
    } catch (error) {
      thrownError = _mapThrownError(error);
    } finally {
      if (!isClosed && generation == _generation) _loading = false;
    }
    if (isClosed || generation != _generation) return;
    if (thrownError case final error?) {
      _emitFailure(error, generation);
      return;
    }
    result.fold(
      (error) => _emitFailure(error, generation),
      (zones) {
        _allZones = List<String>.unmodifiable(zones.toList()..sort());
        _emitFiltered();
      },
    );
  }

  ApiError _mapThrownError(Object error) =>
      TaskDetailOperationErrorNormalizer.fromThrown(
        error,
        fallbackMessage: '',
        unknownApiCode: 'task_recurrence_time_zones_load_failed',
      );

  void _emitFailure(ApiError error, int generation) {
    final deadline = error.retryAfterUtc;
    if (deadline == null || !deadline.isAfter(DateTime.now().toUtc())) {
      emit(TaskRecurrenceTimeZonesFailure(error));
      return;
    }
    emit(TaskRecurrenceTimeZonesFailure(error, canRetry: false));
    _retryTimer = Timer(deadline.difference(DateTime.now().toUtc()), () {
      if (!isClosed && generation == _generation) {
        emit(TaskRecurrenceTimeZonesFailure(error));
      }
    });
  }

  void search(String rawQuery) {
    if (isClosed) return;
    _query = rawQuery.trim();
    if (state is TaskRecurrenceTimeZonesReady) _emitFiltered();
  }

  void _emitFiltered() {
    final normalizedQuery = _query.toLowerCase();
    final visible = normalizedQuery.isEmpty
        ? _allZones
        : _allZones
              .where((zone) => zone.toLowerCase().contains(normalizedQuery))
              .toList(growable: false);
    emit(
      TaskRecurrenceTimeZonesReady(
        allZones: _allZones,
        visibleZones: List<String>.unmodifiable(visible),
        query: _query,
        currentIdIsUnlisted: !_allZones.contains(currentId),
      ),
    );
  }

  @override
  Future<void> close() {
    _generation++;
    _retryTimer?.cancel();
    return super.close();
  }
}
