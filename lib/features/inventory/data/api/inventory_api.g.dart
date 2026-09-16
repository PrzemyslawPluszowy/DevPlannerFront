// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _InventoryApi implements InventoryApi {
  _InventoryApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<DataResponse<GetInwentaryzacjeResponseData>> getInwentaryzacje({
    int? firma,
    int? status,
    String? numer,
    String? dataOdFrom,
    String? dataOdTo,
    String? sortBy,
    String? sortDir,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'firma': firma,
      r'status': status,
      r'numer': numer,
      r'data_od_from': dataOdFrom,
      r'data_od_to': dataOdTo,
      r'sort_by': sortBy,
      r'sort_dir': sortDir,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<DataResponse<GetInwentaryzacjeResponseData>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetInwentaryzacjeResponseData> _value;
    try {
      _value = DataResponse<GetInwentaryzacjeResponseData>.fromJson(
        _result.data!,
        (json) => GetInwentaryzacjeResponseData.fromJson(
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
  Future<DataResponse<PostInwentaryzacjaResponseData>> createInwentaryzacja(
    PostInwentaryzacjaQuery body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<DataResponse<PostInwentaryzacjaResponseData>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<PostInwentaryzacjaResponseData> _value;
    try {
      _value = DataResponse<PostInwentaryzacjaResponseData>.fromJson(
        _result.data!,
        (json) => PostInwentaryzacjaResponseData.fromJson(
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
  Future<DataResponse<GetInwentaryzacjaDetailsResponseData>>
  getInwentaryzacjaDetails(int inwentaryzacjaId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<DataResponse<GetInwentaryzacjaDetailsResponseData>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetInwentaryzacjaDetailsResponseData> _value;
    try {
      _value = DataResponse<GetInwentaryzacjaDetailsResponseData>.fromJson(
        _result.data!,
        (json) => GetInwentaryzacjaDetailsResponseData.fromJson(
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
  Future<DataResponse<GetInwentaryzacjaSearchArkuszeResponseData>>
  searchInwentaryzacjaArkusze(
    int inwentaryzacjaId, {
    String? q,
    String? sortBy,
    String? sortDir,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'q': q,
      r'sort_by': sortBy,
      r'sort_dir': sortDir,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<
          DataResponse<GetInwentaryzacjaSearchArkuszeResponseData>
        >(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}/search/arkusze',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetInwentaryzacjaSearchArkuszeResponseData> _value;
    try {
      _value =
          DataResponse<GetInwentaryzacjaSearchArkuszeResponseData>.fromJson(
            _result.data!,
            (json) => GetInwentaryzacjaSearchArkuszeResponseData.fromJson(
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
  Future<DataResponse<GetInwentaryzacjaTreeProgressResponseData>>
  getInwentaryzacjaTreeProgress(int inwentaryzacjaId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<DataResponse<GetInwentaryzacjaTreeProgressResponseData>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}/arkusze/tree-progress',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetInwentaryzacjaTreeProgressResponseData> _value;
    try {
      _value = DataResponse<GetInwentaryzacjaTreeProgressResponseData>.fromJson(
        _result.data!,
        (json) => GetInwentaryzacjaTreeProgressResponseData.fromJson(
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
  Future<DataResponse<GetInwentaryzacjaPresenceConflictsResponseData>>
  getInwentaryzacjaPresenceConflicts(int inwentaryzacjaId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<
          DataResponse<GetInwentaryzacjaPresenceConflictsResponseData>
        >(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}/presence-conflicts',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetInwentaryzacjaPresenceConflictsResponseData> _value;
    try {
      _value =
          DataResponse<GetInwentaryzacjaPresenceConflictsResponseData>.fromJson(
            _result.data!,
            (json) => GetInwentaryzacjaPresenceConflictsResponseData.fromJson(
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
  Future<DataResponse<GetInwentaryzacjaSurplusConflictsResponseData>>
  getInwentaryzacjaSurplusConflicts(int inwentaryzacjaId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<
          DataResponse<GetInwentaryzacjaSurplusConflictsResponseData>
        >(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}/surplus-conflicts',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetInwentaryzacjaSurplusConflictsResponseData> _value;
    try {
      _value =
          DataResponse<GetInwentaryzacjaSurplusConflictsResponseData>.fromJson(
            _result.data!,
            (json) => GetInwentaryzacjaSurplusConflictsResponseData.fromJson(
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
  Future<DataResponse<GetInwentaryzacjaReportResponseData>>
  getInwentaryzacjaReport(
    int inwentaryzacjaId,
    String reportType, {
    String? includeSummary,
    String? sortBy,
    String? sortDir,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'include_summary': includeSummary,
      r'sort_by': sortBy,
      r'sort_dir': sortDir,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<DataResponse<GetInwentaryzacjaReportResponseData>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}/raporty/${reportType}',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetInwentaryzacjaReportResponseData> _value;
    try {
      _value = DataResponse<GetInwentaryzacjaReportResponseData>.fromJson(
        _result.data!,
        (json) => GetInwentaryzacjaReportResponseData.fromJson(
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
  Future<DataResponse<DeleteInwentaryzacjaResponseData>> deleteInwentaryzacja(
    int inwentaryzacjaId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<DataResponse<DeleteInwentaryzacjaResponseData>>(
          Options(method: 'DELETE', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<DeleteInwentaryzacjaResponseData> _value;
    try {
      _value = DataResponse<DeleteInwentaryzacjaResponseData>.fromJson(
        _result.data!,
        (json) => DeleteInwentaryzacjaResponseData.fromJson(
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
  Future<DataResponse<KomisjaUpdateData>> updateInwentaryzacjaKomisja(
    int inwentaryzacjaId,
    UpdateKomisjaRequest body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<DataResponse<KomisjaUpdateData>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/${inwentaryzacjaId}/komisja',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<KomisjaUpdateData> _value;
    try {
      _value = DataResponse<KomisjaUpdateData>.fromJson(
        _result.data!,
        (json) => KomisjaUpdateData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<PatchInwentaryzacjaStatusResponseData>>
  closeInwentaryzacja(int inwentaryzacjaId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<DataResponse<PatchInwentaryzacjaStatusResponseData>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}/close',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<PatchInwentaryzacjaStatusResponseData> _value;
    try {
      _value = DataResponse<PatchInwentaryzacjaStatusResponseData>.fromJson(
        _result.data!,
        (json) => PatchInwentaryzacjaStatusResponseData.fromJson(
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
  Future<DataResponse<PatchInwentaryzacjaResponseData>> updateInwentaryzacja(
    int inwentaryzacjaId,
    PatchInwentaryzacjaRequest body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<DataResponse<PatchInwentaryzacjaResponseData>>(
          Options(method: 'PATCH', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<PatchInwentaryzacjaResponseData> _value;
    try {
      _value = DataResponse<PatchInwentaryzacjaResponseData>.fromJson(
        _result.data!,
        (json) => PatchInwentaryzacjaResponseData.fromJson(
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
  Future<DataResponse<PostArkuszResponseData>> createArkusz(
    int inwentaryzacjaId,
    PostArkuszQuery body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<DataResponse<PostArkuszResponseData>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/${inwentaryzacjaId}/arkusze',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<PostArkuszResponseData> _value;
    try {
      _value = DataResponse<PostArkuszResponseData>.fromJson(
        _result.data!,
        (json) => PostArkuszResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<GetArkuszDetailsResponseData>> getArkuszDetails(
    int arkuszId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<GetArkuszDetailsResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/arkusze/${arkuszId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetArkuszDetailsResponseData> _value;
    try {
      _value = DataResponse<GetArkuszDetailsResponseData>.fromJson(
        _result.data!,
        (json) =>
            GetArkuszDetailsResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<UpdateArkuszResponseData>> updateArkusz(
    int arkuszId,
    UpdateArkuszRequest body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<DataResponse<UpdateArkuszResponseData>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/arkusze/${arkuszId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<UpdateArkuszResponseData> _value;
    try {
      _value = DataResponse<UpdateArkuszResponseData>.fromJson(
        _result.data!,
        (json) =>
            UpdateArkuszResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<UpdateArkuszNumerResponseData>> updateArkuszNumer(
    int arkuszId,
    UpdateArkuszNumerRequest body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<DataResponse<UpdateArkuszNumerResponseData>>(
          Options(method: 'PATCH', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/arkusze/${arkuszId}/numer',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<UpdateArkuszNumerResponseData> _value;
    try {
      _value = DataResponse<UpdateArkuszNumerResponseData>.fromJson(
        _result.data!,
        (json) => UpdateArkuszNumerResponseData.fromJson(
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
  Future<DataResponse<DeleteArkuszResponseData>> deleteArkusz(
    int arkuszId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<DeleteArkuszResponseData>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/arkusze/${arkuszId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<DeleteArkuszResponseData> _value;
    try {
      _value = DataResponse<DeleteArkuszResponseData>.fromJson(
        _result.data!,
        (json) =>
            DeleteArkuszResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<KomisjaUpdateData>> updateArkuszKomisja(
    int arkuszId,
    UpdateKomisjaRequest body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<DataResponse<KomisjaUpdateData>>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/arkusze/${arkuszId}/komisja',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<KomisjaUpdateData> _value;
    try {
      _value = DataResponse<KomisjaUpdateData>.fromJson(
        _result.data!,
        (json) => KomisjaUpdateData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<PatchArkuszElementResponseData>> updateArkuszElement(
    int arkuszId,
    int elementId,
    PatchArkuszElementQuery body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options = _setStreamType<DataResponse<PatchArkuszElementResponseData>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/arkusze/${arkuszId}/elementy/${elementId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<PatchArkuszElementResponseData> _value;
    try {
      _value = DataResponse<PatchArkuszElementResponseData>.fromJson(
        _result.data!,
        (json) => PatchArkuszElementResponseData.fromJson(
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
  Future<DataResponse<DeleteArkuszElementResponseData>> deleteArkuszElement(
    int arkuszId,
    int elementId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<DeleteArkuszElementResponseData>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/arkusze/${arkuszId}/elementy/${elementId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<DeleteArkuszElementResponseData> _value;
    try {
      _value = DataResponse<DeleteArkuszElementResponseData>.fromJson(
        _result.data!,
        (json) => DeleteArkuszElementResponseData.fromJson(
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
  Future<DataResponse<PostArkuszElementyResponseData>> addArkuszNadwyzka(
    int arkuszId,
    PostArkuszElementyQuery body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<DataResponse<PostArkuszElementyResponseData>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/arkusze/${arkuszId}/elementy',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<PostArkuszElementyResponseData> _value;
    try {
      _value = DataResponse<PostArkuszElementyResponseData>.fromJson(
        _result.data!,
        (json) => PostArkuszElementyResponseData.fromJson(
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
  Future<DataResponse<CreateArkuszElementByNrewidResponseData>>
  createArkuszElementByNrewid(
    int arkuszId,
    CreateArkuszElementByNrewidRequest body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<DataResponse<CreateArkuszElementByNrewidResponseData>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/arkusze/${arkuszId}/elementy/nrewid',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<CreateArkuszElementByNrewidResponseData> _value;
    try {
      _value = DataResponse<CreateArkuszElementByNrewidResponseData>.fromJson(
        _result.data!,
        (json) => CreateArkuszElementByNrewidResponseData.fromJson(
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
  Future<DataResponse<GetFirmyResponseData>> getFirmy() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<GetFirmyResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/firmy',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetFirmyResponseData> _value;
    try {
      _value = DataResponse<GetFirmyResponseData>.fromJson(
        _result.data!,
        (json) => GetFirmyResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<DeleteFirmaResponseData>> deleteFirma(int firmaId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<DeleteFirmaResponseData>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/firmy/${firmaId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<DeleteFirmaResponseData> _value;
    try {
      _value = DataResponse<DeleteFirmaResponseData>.fromJson(
        _result.data!,
        (json) =>
            DeleteFirmaResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<DeleteStanStResponseData>> deleteStanSt(
    int stanStId, {
    required String confirmNrewid,
    required String confirmNazwa,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'confirm_nrewid': confirmNrewid,
      r'confirm_nazwa': confirmNazwa,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<DeleteStanStResponseData>>(
      Options(method: 'DELETE', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/stan_st/${stanStId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<DeleteStanStResponseData> _value;
    try {
      _value = DataResponse<DeleteStanStResponseData>.fromJson(
        _result.data!,
        (json) =>
            DeleteStanStResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<GetMiejscaResponseData>> getMiejsca({int? firma}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'firma': firma};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<GetMiejscaResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/miejsca',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetMiejscaResponseData> _value;
    try {
      _value = DataResponse<GetMiejscaResponseData>.fromJson(
        _result.data!,
        (json) => GetMiejscaResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<GetStanStResponseData>> getStanSt({
    int? firma,
    String? baza,
    int? idmiejsce,
    String? stan,
    String? q,
    int? limit,
    int? offset,
    String? nazwa,
    String? nrewid,
    String? kodKreskowy,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'firma': firma,
      r'baza': baza,
      r'idmiejsce': idmiejsce,
      r'stan': stan,
      r'q': q,
      r'limit': limit,
      r'offset': offset,
      r'nazwa': nazwa,
      r'nrewid': nrewid,
      r'kod_kreskowy': kodKreskowy,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponse<GetStanStResponseData>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/inwentaryzacja/stan_st',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetStanStResponseData> _value;
    try {
      _value = DataResponse<GetStanStResponseData>.fromJson(
        _result.data!,
        (json) => GetStanStResponseData.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<GetStanStDuplicatesResponseData>>
  getStanStDuplicates() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<DataResponse<GetStanStDuplicatesResponseData>>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/stan_st/duplicates',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<GetStanStDuplicatesResponseData> _value;
    try {
      _value = DataResponse<GetStanStDuplicatesResponseData>.fromJson(
        _result.data!,
        (json) => GetStanStDuplicatesResponseData.fromJson(
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
  Future<PostSnapshotRefreshResponseData> refreshSnapshot(
    Options options,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'POST',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path:
          'https://b2b8100.excellent.com.pl/api/v1/inwentaryzacja/snapshot/refresh',
    )..data = _data;
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PostSnapshotRefreshResponseData _value;
    try {
      _value = PostSnapshotRefreshResponseData.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataResponse<SkanujInwentaryzacjaResponseData>> skanujInwentaryzacja(
    int inwentaryzacjaId,
    SkanujInwentaryzacjaRequest body,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<DataResponse<SkanujInwentaryzacjaResponseData>>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/v1/inwentaryzacja/${inwentaryzacjaId}/skanuj',
                queryParameters: queryParameters,
                data: _data,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponse<SkanujInwentaryzacjaResponseData> _value;
    try {
      _value = DataResponse<SkanujInwentaryzacjaResponseData>.fromJson(
        _result.data!,
        (json) => SkanujInwentaryzacjaResponseData.fromJson(
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
  Future<DataResponseList<GetReadyUsersSearchItem>> searchReadyUsers({
    required String q,
    int? limit,
    int? offset,
    bool? includeInactive,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'q': q,
      r'limit': limit,
      r'offset': offset,
      r'include_inactive': includeInactive,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DataResponseList<GetReadyUsersSearchItem>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/v1/ready/users/search',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataResponseList<GetReadyUsersSearchItem> _value;
    try {
      _value = DataResponseList<GetReadyUsersSearchItem>.fromJson(
        _result.data!,
        (json) =>
            GetReadyUsersSearchItem.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions newRequestOptions(Object? options) {
    if (options is RequestOptions) {
      return options;
    }
    if (options is Options) {
      return RequestOptions(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        contentType: options.contentType?.toString(),
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        path: '',
      );
    }
    return RequestOptions(path: '');
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
