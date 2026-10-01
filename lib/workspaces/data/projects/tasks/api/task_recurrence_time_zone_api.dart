import 'package:dio/dio.dart';

/// Pobiera katalog stref rozpoznawanych przez konkretny host Workspaces.
final class TaskRecurrenceTimeZoneApi {
  TaskRecurrenceTimeZoneApi(this._dio, {this.baseUrl});

  final Dio _dio;
  final String? baseUrl;

  Future<List<String>> listSupported({
    required String workspaceId,
    required String projectId,
  }) async {
    final path =
        '/api/v1/workspaces/$workspaceId/projects/$projectId/task-recurrence/time-zones';
    final response = await _dio.get<List<dynamic>>(
      '${(baseUrl ?? _dio.options.baseUrl).replaceFirst(RegExp(r'/+$'), '')}$path',
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Missing recurrence time zone response.');
    }
    return List<String>.unmodifiable(
      data.map((item) {
        if (item is! Map || item['id'] is! String) {
          throw const FormatException('Invalid recurrence time zone item.');
        }
        return item['id'] as String;
      }),
    );
  }
}
