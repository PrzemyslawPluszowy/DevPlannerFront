import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_state.dart';
import 'package:dio/dio.dart';

/// Debounces typed server search and discards responses from older queries.
final class TasksGlobalSearchCubit extends Cubit<TasksGlobalSearchState> {
  TasksGlobalSearchCubit({
    required this.repository,
  }) : super(const TasksGlobalSearchState());

  static const int pageSize = 20;
  static const int minimumQueryLength = 2;
  static const Duration debounceDuration = Duration(milliseconds: 250);
  static const Duration cooldownTick = Duration(milliseconds: 250);

  final TaskViewRepository repository;
  Timer? _debounce;
  Timer? _cooldownTimer;
  int _generation = 0;

  void updateQuery(String rawQuery) {
    if (isClosed) return;
    final query = rawQuery.trim();
    _debounce?.cancel();
    final generation = ++_generation;
    final remaining = _remainingCooldownSeconds();
    if (query.length < minimumQueryLength) {
      _emitForQuery(query, remaining);
      return;
    }
    if (remaining > 0) {
      _emitForQuery(query, remaining);
      return;
    }
    emit(TasksGlobalSearchState(query: query, isLoading: true));
    _debounce = Timer(debounceDuration, () {
      unawaited(_load(query: query, generation: generation));
    });
  }

  void retry() {
    if (isClosed) return;
    if (state.failure == null || state.query.length < minimumQueryLength) {
      return;
    }
    if (_blockForCooldown()) return;
    _debounce?.cancel();
    final generation = ++_generation;
    final cursor = state.items.isNotEmpty ? state.nextCursor : null;
    emit(
      state.copyWith(
        isLoading: cursor == null,
        isLoadingMore: cursor != null,
        clearFailure: true,
        clearCooldown: true,
      ),
    );
    unawaited(
      _load(query: state.query, generation: generation, cursor: cursor),
    );
  }

  Future<void> loadMore() async {
    if (isClosed) return;
    if (_blockForCooldown()) return;
    final cursor = state.nextCursor;
    if (cursor == null ||
        state.isLoading ||
        state.isLoadingMore ||
        state.query.length < minimumQueryLength) {
      return;
    }
    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, clearFailure: true));
    await _load(query: state.query, generation: generation, cursor: cursor);
  }

  Future<void> _load({
    required String query,
    required int generation,
    String? cursor,
  }) async {
    if (isClosed || generation != _generation) return;
    if (_blockForCooldown()) return;
    late final Either<
      ApiError,
      CursorPageResponse<GlobalTaskSearchItemResponse>
    >
    result;
    try {
      result = await repository.searchTasks(
        query: query,
        limit: pageSize,
        cursor: cursor,
      );
    } catch (error) {
      result = Left(switch (error) {
        final ApiError apiError => apiError,
        final DioException dioError => ApiError.fromDioException(
          dioError,
          fallbackMessage: '',
        ),
        _ => const ApiError(
          type: ApiErrorType.unknown,
          message: '',
          apiCode: 'tasks.search_failed',
        ),
      });
    }
    if (isClosed) return;
    if (generation != _generation || state.query != query) {
      final staleFailure = result.fold<ApiError?>(
        (failure) => failure,
        (_) => null,
      );
      if (staleFailure != null &&
          staleFailure.retryAfterUtc?.isAfter(DateTime.now().toUtc()) == true) {
        _applyStaleCooldown(staleFailure);
      }
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          isLoading: false,
          isLoadingMore: false,
          cooldownUntilUtc: _extendedCooldown(failure.retryAfterUtc),
          retryWaitSeconds: _remainingCooldownSeconds(
            candidate: failure.retryAfterUtc,
          ),
        ),
      ),
      (page) {
        final items = <String, GlobalTaskSearchItemResponse>{
          for (final item in state.items) item.id: item,
          for (final item in page.items) item.id: item,
        };
        emit(
          state.copyWith(
            items: List.unmodifiable(items.values),
            nextCursor: page.nextCursor,
            clearCursor: page.nextCursor == null,
            clearFailure: _remainingCooldownSeconds() == 0,
            isLoading: false,
            isLoadingMore: false,
          ),
        );
      },
    );
    final deadline = state.cooldownUntilUtc;
    if (deadline != null && state.retryWaitSeconds > 0) {
      _startCooldownTimer(deadline);
    }
  }

  void _applyStaleCooldown(ApiError failure) {
    if (isClosed) return;
    final deadline = _extendedCooldown(failure.retryAfterUtc);
    if (deadline == null || !deadline.isAfter(DateTime.now().toUtc())) return;
    _debounce?.cancel();
    emit(
      state.copyWith(
        failure: state.failure ?? failure,
        cooldownUntilUtc: deadline,
        retryWaitSeconds: _remainingCooldownSeconds(candidate: deadline),
        isLoading: false,
        isLoadingMore: false,
      ),
    );
    _startCooldownTimer(deadline);
  }

  void _emitForQuery(String query, int remaining) {
    final deadline = remaining > 0 ? state.cooldownUntilUtc : null;
    emit(
      TasksGlobalSearchState(
        query: query,
        failure: remaining > 0 ? state.failure : null,
        cooldownUntilUtc: deadline,
        retryWaitSeconds: remaining,
      ),
    );
  }

  bool _blockForCooldown() {
    if (isClosed) return true;
    final remaining = _remainingCooldownSeconds();
    if (remaining > 0) {
      if (remaining != state.retryWaitSeconds ||
          state.isLoading ||
          state.isLoadingMore) {
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            retryWaitSeconds: remaining,
          ),
        );
      }
      return true;
    }
    if (state.cooldownUntilUtc != null) {
      _cooldownTimer?.cancel();
      _cooldownTimer = null;
      emit(state.copyWith(clearCooldown: true));
    }
    return false;
  }

  int _remainingCooldownSeconds({DateTime? candidate}) {
    final current = state.cooldownUntilUtc;
    final deadline =
        current == null || (candidate != null && candidate.isAfter(current))
        ? candidate
        : current;
    if (deadline == null) return 0;
    final milliseconds = deadline
        .difference(DateTime.now().toUtc())
        .inMilliseconds;
    return milliseconds <= 0 ? 0 : (milliseconds / 1000).ceil();
  }

  DateTime? _extendedCooldown(DateTime? candidate) {
    final current = state.cooldownUntilUtc;
    if (candidate == null || !candidate.isAfter(DateTime.now().toUtc())) {
      return current;
    }
    if (current == null || candidate.isAfter(current)) return candidate;
    return current;
  }

  void _startCooldownTimer(DateTime deadline) {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(cooldownTick, (timer) {
      if (isClosed || state.cooldownUntilUtc != deadline) {
        timer.cancel();
        return;
      }
      final remaining = _remainingCooldownSeconds();
      if (remaining == 0) {
        timer.cancel();
        _cooldownTimer = null;
        emit(state.copyWith(retryWaitSeconds: 0));
      } else if (remaining != state.retryWaitSeconds) {
        emit(state.copyWith(retryWaitSeconds: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _generation++;
    _debounce?.cancel();
    _cooldownTimer?.cancel();
    _debounce = null;
    _cooldownTimer = null;
    return super.close();
  }
}
