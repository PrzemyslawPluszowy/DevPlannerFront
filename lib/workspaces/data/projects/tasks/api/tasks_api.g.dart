// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _TasksApi implements TasksApi {
  _TasksApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<TaskMutationResponse<ProjectTaskResponse>> createTask(
    String workspaceId,
    String projectId,
    CreateProjectTaskPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskMutationResponse<ProjectTaskResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<ProjectTaskResponse> _value;
    try {
      _value = TaskMutationResponse<ProjectTaskResponse>.fromJson(
        _result.data!,
        (json) => ProjectTaskResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<ProjectTaskResponse>> quickCreateTask(
    String workspaceId,
    String projectId,
    QuickCreateProjectTaskPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskMutationResponse<ProjectTaskResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/quick-create',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<ProjectTaskResponse> _value;
    try {
      _value = TaskMutationResponse<ProjectTaskResponse>.fromJson(
        _result.data!,
        (json) => ProjectTaskResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CursorPageResponse<ProjectTaskListItemResponse>> listTasks(
    String workspaceId,
    String projectId, {
    String? parentTaskId,
    bool includeArchived = false,
    int limit = 50,
    String? cursor,
    String? savedViewId,
    String? status,
    String? priority,
    String? assigneeUserId,
    String? myInvolvement,
    bool unassignedOnly = false,
    String? search,
    DateTime? dueFromUtc,
    DateTime? dueToUtc,
    bool pinnedOnly = false,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'parentTaskId': parentTaskId,
      r'includeArchived': includeArchived,
      r'limit': limit,
      r'cursor': cursor,
      r'savedViewId': savedViewId,
      r'status': status,
      r'priority': priority,
      r'assigneeUserId': assigneeUserId,
      r'myInvolvement': myInvolvement,
      r'unassignedOnly': unassignedOnly,
      r'search': search,
      r'dueFromUtc': dueFromUtc?.toIso8601String(),
      r'dueToUtc': dueToUtc?.toIso8601String(),
      r'pinnedOnly': pinnedOnly,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<CursorPageResponse<ProjectTaskListItemResponse>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CursorPageResponse<ProjectTaskListItemResponse> _value;
    try {
      _value = CursorPageResponse<ProjectTaskListItemResponse>.fromJson(
        _result.data!,
        (json) =>
            ProjectTaskListItemResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ProjectTaskGroupedListResponse> listTaskGroups(
    String workspaceId,
    String projectId, {
    String? groupBy,
    String? groupKey,
    String? parentTaskId,
    bool includeArchived = false,
    int limit = 50,
    String? cursor,
    String? savedViewId,
    String? status,
    String? priority,
    String? assigneeUserId,
    String? myInvolvement,
    bool unassignedOnly = false,
    String? search,
    DateTime? dueFromUtc,
    DateTime? dueToUtc,
    bool pinnedOnly = false,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'groupBy': groupBy,
      r'groupKey': groupKey,
      r'parentTaskId': parentTaskId,
      r'includeArchived': includeArchived,
      r'limit': limit,
      r'cursor': cursor,
      r'savedViewId': savedViewId,
      r'status': status,
      r'priority': priority,
      r'assigneeUserId': assigneeUserId,
      r'myInvolvement': myInvolvement,
      r'unassignedOnly': unassignedOnly,
      r'search': search,
      r'dueFromUtc': dueFromUtc?.toIso8601String(),
      r'dueToUtc': dueToUtc?.toIso8601String(),
      r'pinnedOnly': pinnedOnly,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ProjectTaskGroupedListResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/groups',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProjectTaskGroupedListResponse _value;
    try {
      _value = ProjectTaskGroupedListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskTimelineResponse> getTimeline(
    String workspaceId,
    String projectId, {
    required DateTime fromUtc,
    required DateTime toUtc,
    bool includeUndated = false,
    int limit = 500,
    String? cursor,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'fromUtc': fromUtc.toIso8601String(),
      r'toUtc': toUtc.toIso8601String(),
      r'includeUndated': includeUndated,
      r'limit': limit,
      r'cursor': cursor,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TaskTimelineResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-timeline/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskTimelineResponse _value;
    try {
      _value = TaskTimelineResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ProjectTaskDetailsResponse> getTask(
    String workspaceId,
    String projectId,
    String taskId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ProjectTaskDetailsResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProjectTaskDetailsResponse _value;
    try {
      _value = ProjectTaskDetailsResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskSelectionTokenResponse> createTaskSelectionToken(
    String workspaceId,
    String projectId,
    CreateTaskSelectionTokenPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskSelectionTokenResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/selection-token',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskSelectionTokenResponse _value;
    try {
      _value = TaskSelectionTokenResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BulkUpdateTaskSelectionResponse> bulkUpdateTaskSelection(
    String workspaceId,
    String projectId,
    BulkUpdateTaskSelectionPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<BulkUpdateTaskSelectionResponse>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/selection-token/bulk',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkUpdateTaskSelectionResponse _value;
    try {
      _value = BulkUpdateTaskSelectionResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<ProjectTaskResponse>> updateTask(
    String workspaceId,
    String projectId,
    String taskId,
    UpdateProjectTaskPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskMutationResponse<ProjectTaskResponse>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<ProjectTaskResponse> _value;
    try {
      _value = TaskMutationResponse<ProjectTaskResponse>.fromJson(
        _result.data!,
        (json) => ProjectTaskResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<ProjectTaskListItemResponse>> updateListItem(
    String workspaceId,
    String projectId,
    String taskId,
    UpdateTaskListItemPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<TaskMutationResponse<ProjectTaskListItemResponse>>(
          Options(method: 'PATCH', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/list-item',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<ProjectTaskListItemResponse> _value;
    try {
      _value = TaskMutationResponse<ProjectTaskListItemResponse>.fromJson(
        _result.data!,
        (json) =>
            ProjectTaskListItemResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MovedProjectTaskResponse> moveTask(
    String workspaceId,
    String projectId,
    String taskId,
    MoveProjectTaskPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<MovedProjectTaskResponse>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/move',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MovedProjectTaskResponse _value;
    try {
      _value = MovedProjectTaskResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<ProjectTaskResponse>> archiveTask(
    String workspaceId,
    String projectId,
    String taskId,
    int expectedVersion,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'expectedVersion': expectedVersion,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TaskMutationResponse<ProjectTaskResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/archive',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<ProjectTaskResponse> _value;
    try {
      _value = TaskMutationResponse<ProjectTaskResponse>.fromJson(
        _result.data!,
        (json) => ProjectTaskResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<ProjectTaskResponse>> restoreTask(
    String workspaceId,
    String projectId,
    String taskId,
    int expectedVersion,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'expectedVersion': expectedVersion,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TaskMutationResponse<ProjectTaskResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/restore',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<ProjectTaskResponse> _value;
    try {
      _value = TaskMutationResponse<ProjectTaskResponse>.fromJson(
        _result.data!,
        (json) => ProjectTaskResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<ReorderedTaskVersionResponse>> reorderTasks(
    String workspaceId,
    String projectId,
    ReorderProjectTasksPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<List<ReorderedTaskVersionResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/order',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<ReorderedTaskVersionResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => ReorderedTaskVersionResponse.fromJson(
              i as Map<String, dynamic>,
            ),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<TaskDependencyResponse>> listDependencies(
    String workspaceId,
    String projectId,
    String taskId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TaskDependencyResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/dependencies',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TaskDependencyResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
                TaskDependencyResponse.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskDependencyResponse>> createDependency(
    String workspaceId,
    String projectId,
    String taskId,
    CreateTaskDependencyPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskMutationResponse<TaskDependencyResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/dependencies',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<TaskDependencyResponse> _value;
    try {
      _value = TaskMutationResponse<TaskDependencyResponse>.fromJson(
        _result.data!,
        (json) => TaskDependencyResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskDependencyResponse>> updateDependency(
    String workspaceId,
    String projectId,
    String taskId,
    String dependencyId,
    UpdateTaskDependencyPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskMutationResponse<TaskDependencyResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/dependencies/${dependencyId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<TaskDependencyResponse> _value;
    try {
      _value = TaskMutationResponse<TaskDependencyResponse>.fromJson(
        _result.data!,
        (json) => TaskDependencyResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  deleteDependency(
    String workspaceId,
    String projectId,
    String taskId,
    String dependencyId,
    int expectedVersion,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'expectedVersion': expectedVersion,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<
          TaskMutationResponse<TaskMutationAcknowledgementResponse>
        >(
          Options(method: 'DELETE', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/dependencies/${dependencyId}',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<TaskMutationAcknowledgementResponse> _value;
    try {
      _value =
          TaskMutationResponse<TaskMutationAcknowledgementResponse>.fromJson(
            _result.data!,
            (json) => TaskMutationAcknowledgementResponse.fromJson(
              json as Map<String, dynamic>,
            ),
          );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
