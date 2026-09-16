// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_operations_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _TaskOperationsApi implements TaskOperationsApi {
  _TaskOperationsApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<TaskMutationResponse<ProjectTaskResponse>> replaceAssignees(
    String workspaceId,
    String projectId,
    String taskId,
    UpdateTaskAssigneesPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskMutationResponse<ProjectTaskResponse>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/assignees',
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
  Future<TaskMutationResponse<TaskChecklistItemResponse>> addChecklistItem(
    String workspaceId,
    String projectId,
    String taskId,
    CreateTaskChecklistItemPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<TaskMutationResponse<TaskChecklistItemResponse>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/checklist',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<TaskChecklistItemResponse> _value;
    try {
      _value = TaskMutationResponse<TaskChecklistItemResponse>.fromJson(
        _result.data!,
        (json) =>
            TaskChecklistItemResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskChecklistItemResponse>> updateChecklistItem(
    String workspaceId,
    String projectId,
    String taskId,
    String itemId,
    UpdateTaskChecklistItemPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<TaskMutationResponse<TaskChecklistItemResponse>>(
          Options(method: 'PATCH', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/checklist/${itemId}',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<TaskChecklistItemResponse> _value;
    try {
      _value = TaskMutationResponse<TaskChecklistItemResponse>.fromJson(
        _result.data!,
        (json) =>
            TaskChecklistItemResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  deleteChecklistItem(
    String workspaceId,
    String projectId,
    String taskId,
    String itemId,
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
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/checklist/${itemId}',
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

  @override
  Future<List<TaskWatcherResponse>> listWatchers(
    String workspaceId,
    String projectId,
    String taskId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TaskWatcherResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/watchers',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TaskWatcherResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
                TaskWatcherResponse.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>> followTask(
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
    final _options =
        _setStreamType<
          TaskMutationResponse<TaskMutationAcknowledgementResponse>
        >(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/watchers/me',
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

  @override
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  unfollowTask(
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
    final _options =
        _setStreamType<
          TaskMutationResponse<TaskMutationAcknowledgementResponse>
        >(
          Options(method: 'DELETE', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/watchers/me',
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

  @override
  Future<List<TaskAcceptanceCriterionResponse>> listAcceptanceCriteria(
    String workspaceId,
    String projectId,
    String taskId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TaskAcceptanceCriterionResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/acceptance-criteria',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TaskAcceptanceCriterionResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => TaskAcceptanceCriterionResponse.fromJson(
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
  Future<TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  createAcceptanceCriterion(
    String workspaceId,
    String projectId,
    String taskId,
    CreateTaskAcceptanceCriterionPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<TaskMutationResponse<TaskAcceptanceCriterionResponse>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/acceptance-criteria',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<TaskAcceptanceCriterionResponse> _value;
    try {
      _value = TaskMutationResponse<TaskAcceptanceCriterionResponse>.fromJson(
        _result.data!,
        (json) => TaskAcceptanceCriterionResponse.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  updateAcceptanceCriterion(
    String workspaceId,
    String projectId,
    String taskId,
    String criterionId,
    UpdateTaskAcceptanceCriterionPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<TaskMutationResponse<TaskAcceptanceCriterionResponse>>(
          Options(method: 'PATCH', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/acceptance-criteria/${criterionId}',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<TaskAcceptanceCriterionResponse> _value;
    try {
      _value = TaskMutationResponse<TaskAcceptanceCriterionResponse>.fromJson(
        _result.data!,
        (json) => TaskAcceptanceCriterionResponse.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  deleteAcceptanceCriterion(
    String workspaceId,
    String projectId,
    String taskId,
    String criterionId,
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
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/acceptance-criteria/${criterionId}',
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

  @override
  Future<void> updateTaskPreference(
    String workspaceId,
    String projectId,
    String taskId,
    UpdateTaskUserPreferencePayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<void>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/preference',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<List<StorageFileResponse>> listTaskAttachments(
    String workspaceId,
    String projectId,
    String taskId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<StorageFileResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/attachments',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<StorageFileResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
                StorageFileResponse.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BulkStorageUploadTicketResponse> requestBulkAttachmentTickets(
    String workspaceId,
    String projectId,
    String taskId,
    BulkTaskUploadTicketPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<BulkStorageUploadTicketResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/attachments/bulk-tickets',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkStorageUploadTicketResponse _value;
    try {
      _value = BulkStorageUploadTicketResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BulkCompleteUploadResponse> completeBulkAttachments(
    String workspaceId,
    String projectId,
    String taskId,
    BulkCompleteUploadPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<BulkCompleteUploadResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/attachments/bulk-complete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BulkCompleteUploadResponse _value;
    try {
      _value = BulkCompleteUploadResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<TaskLabelResponse>> listLabels(
    String workspaceId,
    String projectId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TaskLabelResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-labels/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TaskLabelResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
                TaskLabelResponse.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskLabelResponse> createLabel(
    String workspaceId,
    String projectId,
    CreateTaskLabelPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskLabelResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-labels/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskLabelResponse _value;
    try {
      _value = TaskLabelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskLabelResponse> updateLabel(
    String workspaceId,
    String projectId,
    String labelId,
    UpdateTaskLabelPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskLabelResponse>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-labels/${labelId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskLabelResponse _value;
    try {
      _value = TaskLabelResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> archiveLabel(
    String workspaceId,
    String projectId,
    String labelId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-labels/${labelId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<TaskMutationResponse<List<TaskLabelResponse>>> replaceLabels(
    String workspaceId,
    String projectId,
    String taskId,
    ReplaceTaskLabelsPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskMutationResponse<List<TaskLabelResponse>>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/labels',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<List<TaskLabelResponse>> _value;
    try {
      _value = TaskMutationResponse<List<TaskLabelResponse>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<TaskLabelResponse>(
                    (i) =>
                        TaskLabelResponse.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<TaskCustomFieldResponse>> listCustomFields(
    String workspaceId,
    String projectId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<TaskCustomFieldResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-custom-fields/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<TaskCustomFieldResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
                TaskCustomFieldResponse.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskCustomFieldResponse> createCustomField(
    String workspaceId,
    String projectId,
    CreateTaskCustomFieldPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskCustomFieldResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-custom-fields/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskCustomFieldResponse _value;
    try {
      _value = TaskCustomFieldResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TaskCustomFieldResponse> updateCustomField(
    String workspaceId,
    String projectId,
    String fieldId,
    UpdateTaskCustomFieldPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<TaskCustomFieldResponse>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-custom-fields/${fieldId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskCustomFieldResponse _value;
    try {
      _value = TaskCustomFieldResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> archiveCustomField(
    String workspaceId,
    String projectId,
    String fieldId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<void>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/workspaces/${workspaceId}/projects/${projectId}/task-custom-fields/${fieldId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<TaskMutationResponse<List<TaskCustomFieldValueResponse>>>
  replaceCustomFieldValues(
    String workspaceId,
    String projectId,
    String taskId,
    ReplaceTaskCustomFieldValuesPayload body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<
          TaskMutationResponse<List<TaskCustomFieldValueResponse>>
        >(
          Options(method: 'PUT', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/workspaces/${workspaceId}/projects/${projectId}/tasks/${taskId}/custom-fields',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TaskMutationResponse<List<TaskCustomFieldValueResponse>> _value;
    try {
      _value =
          TaskMutationResponse<List<TaskCustomFieldValueResponse>>.fromJson(
            _result.data!,
            (json) => json is List<dynamic>
                ? json
                      .map<TaskCustomFieldValueResponse>(
                        (i) => TaskCustomFieldValueResponse.fromJson(
                          i as Map<String, dynamic>,
                        ),
                      )
                      .toList()
                : List.empty(),
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
