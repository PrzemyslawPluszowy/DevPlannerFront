import 'dart:convert';

import 'package:dio/dio.dart';

/// Bezpieczny logger całego ruchu wykonywanego przez sesyjny transport Dio.
///
/// Pokazuje metodę, URL z query, status, czas, nagłówki oraz ograniczony kształt
/// body. Sekrety i pola zawierające dane użytkownika są zawsze redagowane.
final class DevPlannerHttpDiagnosticsInterceptor extends Interceptor {
  DevPlannerHttpDiagnosticsInterceptor(this._write);

  static const _startedAtKey = '_devplanner.diagnostics_started_at';
  static const _redacted = '<redacted>';
  static const _sensitiveNames = <String>{
    'authorization',
    'cookie',
    'set-cookie',
    'x-devplanner-csrf',
    'password',
    'currentpassword',
    'newpassword',
    'token',
    'accesstoken',
    'refreshtoken',
    'idtoken',
    'clientsecret',
    'secret',
    'email',
    'login',
    'q',
    'query',
    'search',
    'returnto',
  };

  final void Function(String message) _write;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now().microsecondsSinceEpoch;
    _write(
      '[HTTP][REQUEST] ${options.method} ${_safeUri(options)} '
      '| headers=${_safeMap(options.headers)} '
      '| body=${_safeBody(options.data)}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _write(
      '[HTTP][RESPONSE] ${response.requestOptions.method} '
      '${_safeUri(response.requestOptions)} | status=${response.statusCode} '
      '| durationMs=${_durationMs(response.requestOptions)} '
      '| headers=${_safeResponseHeaders(response.headers)} '
      '| body=${_safeBody(response.data, responseStatus: response.statusCode)}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    _write(
      '[HTTP][ERROR] ${err.requestOptions.method} '
      '${_safeUri(err.requestOptions)} | type=${err.type.name} '
      '| status=${response?.statusCode} '
      '| durationMs=${_durationMs(err.requestOptions)} '
      '| headers=${_safeResponseHeaders(response?.headers)} '
      '| body=${_safeBody(response?.data, responseStatus: response?.statusCode)}',
    );
    handler.next(err);
  }

  static String _safeUri(RequestOptions options) {
    final query = <String, dynamic>{};
    for (final entry in options.queryParameters.entries) {
      query[entry.key] = _isSensitiveQuery(entry.key) ? _redacted : entry.value;
    }
    final uri = options.uri;
    final path = uri.hasAuthority
        ? '${uri.scheme}://${uri.authority}${uri.path}'
        : uri.path;
    return query.isEmpty
        ? path
        : '$path?${Uri(queryParameters: query.map((key, value) => MapEntry(key, value?.toString() ?? ''))).query}';
  }

  static String _safeResponseHeaders(Headers? headers) {
    if (headers == null) return '{}';
    final values = <String, dynamic>{};
    headers.forEach((name, items) => values[name] = items);
    return _safeMap(values);
  }

  static String _safeMap(Map<dynamic, dynamic> source) {
    final safe = <String, dynamic>{};
    for (final entry in source.entries) {
      final key = entry.key.toString();
      safe[key] = _isSensitive(key) ? _redacted : _truncate(entry.value);
    }
    return jsonEncode(safe);
  }

  static String _safeBody(Object? body, {int? responseStatus}) {
    if (body == null) return 'null';
    if (body is FormData) {
      return '<multipart fields=${body.fields.length} files=${body.files.length}>';
    }
    if (body is List<int>) return '<bytes length=${body.length}>';
    if (body is Map) {
      if (responseStatus != null && responseStatus >= 400) {
        final error = <String, dynamic>{};
        for (final key in const ['code', 'message', 'traceId']) {
          if (body.containsKey(key)) error[key] = _truncate(body[key]);
        }
        final fields = body['fields'];
        if (fields is Map) {
          error['fields'] = fields.keys.map((key) => key.toString()).toList();
        }
        return jsonEncode(error);
      }
      return '<object fields=${body.keys.take(16).join(',')}>';
    }
    if (body is Iterable) return '<list length=${body.length}>';
    if (body is String) return '<text length=${body.length}>';
    return '<${body.runtimeType}>';
  }

  static Object? _truncate(Object? value) {
    if (value is String && value.length > 160) {
      return '${value.substring(0, 160)}…';
    }
    if (value is Iterable) return value.take(12).toList(growable: false);
    return value;
  }

  static bool _isSensitive(String name) {
    final normalized = name
        .replaceAll(RegExp('[^a-zA-Z0-9]'), '')
        .toLowerCase();
    return _sensitiveNames.contains(normalized) ||
        normalized.endsWith('token') ||
        normalized.endsWith('secret') ||
        normalized.endsWith('password');
  }

  static bool _isSensitiveQuery(String name) {
    final normalized = name
        .replaceAll(RegExp('[^a-zA-Z0-9]'), '')
        .toLowerCase();
    return normalized == 'code' || _isSensitive(name);
  }

  static int? _durationMs(RequestOptions options) {
    final startedAt = options.extra[_startedAtKey];
    if (startedAt is! int) return null;
    return (DateTime.now().microsecondsSinceEpoch - startedAt) ~/ 1000;
  }
}
