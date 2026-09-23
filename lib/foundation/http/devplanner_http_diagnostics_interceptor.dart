import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

/// Bezpieczny logger całego ruchu wykonywanego przez sesyjny transport Dio.
///
/// Pokazuje metodę, URL z query, status, czas, nagłówki oraz sanitizowane JSON
/// requestu/odpowiedzi. Sekrety i pola zawierające dane użytkownika są redagowane.
final class DevPlannerHttpDiagnosticsInterceptor extends Interceptor {
  DevPlannerHttpDiagnosticsInterceptor(
    this._talker, {
    this._write,
  });

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
    'name',
    'displayname',
    'title',
    'filename',
    'originalfilename',
    'q',
    'query',
    'search',
    'returnto',
  };

  final Talker _talker;
  final void Function(String)? _write;

  void _emit(String message, String key) {
    _talker.logCustom(_HttpDiagnosticLog(message, key));
    _write?.call(message);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now().microsecondsSinceEpoch;
    _emit(
      '[HTTP][REQUEST] ${options.method} ${_safeUri(options)} '
      '| headers=${_safeMap(options.headers)} '
      '| body=${_safeBody(options.data)}',
      TalkerKey.httpRequest,
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _emit(
      '[HTTP][RESPONSE] ${response.requestOptions.method} '
      '${_safeUri(response.requestOptions)} | status=${response.statusCode} '
      '| durationMs=${_durationMs(response.requestOptions)} '
      '| headers=${_safeResponseHeaders(response.headers)} '
      '| body=${_safeBody(response.data, responseStatus: response.statusCode)}',
      response.statusCode != null && response.statusCode! >= 400
          ? TalkerKey.httpError
          : TalkerKey.httpResponse,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    _emit(
      '[HTTP][ERROR] ${err.requestOptions.method} '
      '${_safeUri(err.requestOptions)} | type=${err.type.name} '
      '| status=${response?.statusCode} '
      '| durationMs=${_durationMs(err.requestOptions)} '
      '| headers=${_safeResponseHeaders(response?.headers)} '
      '| body=${_safeBody(response?.data, responseStatus: response?.statusCode)}',
      TalkerKey.httpError,
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
      return jsonEncode(_safeJsonValue(body));
    }
    if (body is Iterable) return jsonEncode(_safeJsonValue(body));
    if (body is String) return '<text length=${body.length}>';
    return '<${body.runtimeType}>';
  }

  static Object? _safeJsonValue(Object? value, {String? key}) {
    if (key != null && _isSensitive(key)) return _redacted;
    if (value is Map) {
      return <String, Object?>{
        for (final entry in value.entries.take(40))
          entry.key.toString(): _safeJsonValue(
            entry.value,
            key: entry.key.toString(),
          ),
      };
    }
    if (value is Iterable) {
      return value.take(12).map(_safeJsonValue).toList(growable: false);
    }
    if (value is String) {
      if (key != null && (key.toLowerCase().endsWith('url') || key == 'url')) {
        final uri = Uri.tryParse(value);
        if (uri != null && uri.hasAuthority) {
          return '${uri.scheme}://${uri.authority}${uri.path}';
        }
      }
      return _truncate(value);
    }
    return value;
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

final class _HttpDiagnosticLog extends TalkerLog {
  _HttpDiagnosticLog(super.message, String key)
    : super(key: key, logLevel: LogLevel.info);
}
