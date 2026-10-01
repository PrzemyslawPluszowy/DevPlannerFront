import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskDetailConversationState {
  const TaskDetailConversationState();
}

final class TaskDetailConversationLoading extends TaskDetailConversationState {
  const TaskDetailConversationLoading();
}

final class TaskDetailConversationReady extends TaskDetailConversationState {
  const TaskDetailConversationReady(this.conversation);

  final ChatConversation conversation;
}

final class TaskDetailConversationDenied extends TaskDetailConversationState {
  const TaskDetailConversationDenied();
}

final class TaskDetailConversationFailure extends TaskDetailConversationState {
  const TaskDetailConversationFailure(
    this.error, {
    this.exception,
    this.retryRevision = 0,
  });

  final ApiError? error;
  final Object? exception;
  final int retryRevision;
}

/// Resolves the ACL-protected task conversation and rejects stale responses.
final class TaskDetailConversationCubit
    extends Cubit<TaskDetailConversationState> {
  TaskDetailConversationCubit(this._repository)
    : super(const TaskDetailConversationLoading());

  final ResourceChatRepository? _repository;
  String? _taskId;
  String? _workspaceId;
  String? _projectId;
  int _generation = 0;
  bool _resolving = false;
  DateTime? _retryAfterUtc;
  Timer? _retryTimer;

  bool get canRetry =>
      !isClosed &&
      !_resolving &&
      (_retryAfterUtc == null ||
          !DateTime.now().toUtc().isBefore(_retryAfterUtc!));

  void resolve({
    required String taskId,
    required String workspaceId,
    required String projectId,
  }) {
    if (isClosed) return;
    final sameScope =
        _taskId == taskId &&
        _workspaceId == workspaceId &&
        _projectId == projectId;
    if (sameScope && !canRetry) return;
    if (!sameScope) {
      _retryTimer?.cancel();
      _retryAfterUtc = null;
    }
    _taskId = taskId;
    _workspaceId = workspaceId;
    _projectId = projectId;
    unawaited(_resolve(++_generation));
  }

  void retry() {
    if (!canRetry ||
        _taskId == null ||
        _workspaceId == null ||
        _projectId == null) {
      return;
    }
    unawaited(_resolve(++_generation));
  }

  Future<void> _resolve(int generation) async {
    if (!_isCurrent(generation)) return;
    _resolving = true;
    emit(const TaskDetailConversationLoading());
    final repository = _repository;
    if (repository == null) {
      if (!_isCurrent(generation)) return;
      _resolving = false;
      emit(const TaskDetailConversationFailure(null));
      return;
    }
    try {
      final result = await repository.resolveTaskConversation(
        taskId: _taskId!,
        workspaceId: _workspaceId!,
        projectId: _projectId!,
      );
      if (!_isCurrent(generation)) return;
      result.fold<void>(
        _publishError,
        (conversation) => emit(TaskDetailConversationReady(conversation)),
      );
    } on Object catch (error) {
      if (!_isCurrent(generation)) return;
      _publishError(switch (error) {
        final ApiError apiError => apiError,
        final DioException dioError => ApiError.fromDioException(
          dioError,
          fallbackMessage: '',
        ),
        _ => const ApiError(
          type: ApiErrorType.unknown,
          message: '',
          apiCode: 'chat.resolve_failed',
        ),
      });
    } finally {
      if (_isCurrent(generation)) _resolving = false;
    }
  }

  void _publishError(ApiError error) {
    if (_isDenied(error)) {
      emit(const TaskDetailConversationDenied());
      return;
    }
    final deadline = error.retryAfterUtc?.toUtc();
    _retryTimer?.cancel();
    _retryAfterUtc = deadline;
    if (deadline != null) {
      final delay = deadline.difference(DateTime.now().toUtc());
      if (delay > Duration.zero) _retryTimer = Timer(delay, _enableRetry);
    }
    emit(TaskDetailConversationFailure(error));
  }

  void _enableRetry() {
    _retryTimer = null;
    _retryAfterUtc = null;
    if (isClosed) return;
    final current = state;
    if (current is TaskDetailConversationFailure) {
      emit(
        TaskDetailConversationFailure(
          current.error,
          retryRevision: current.retryRevision + 1,
        ),
      );
    }
  }

  bool _isCurrent(int generation) => !isClosed && generation == _generation;

  bool _isDenied(ApiError error) =>
      error.type == ApiErrorType.unauthorized ||
      error.type == ApiErrorType.forbidden ||
      error.type == ApiErrorType.notFound;

  @override
  Future<void> close() {
    _generation++;
    _retryTimer?.cancel();
    return super.close();
  }
}
