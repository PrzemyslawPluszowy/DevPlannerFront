import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/projects/tasks/api/task_templates_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'zapis szablonu przekazuje projekt źródłowego zadania w query',
    () async {
      final adapter = _RecordingAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      final api = TaskTemplatesApi(dio, baseUrl: 'https://api.example.test');
      await api.create(
        'workspace-1',
        'task-1',
        'project-1',
        const CreateTaskTemplatePayload(name: 'QA szablon'),
      );
      expect(adapter.request?.method, 'POST');
      expect(
        adapter.request?.uri.path,
        '/api/v1/workspaces/workspace-1/task-templates/from-task/task-1',
      );
      expect(adapter.request?.queryParameters['projectId'], 'project-1');
      expect(jsonDecode(utf8.decode(adapter.body)), {'name': 'QA szablon'});
      dio.close(force: true);
    },
  );
}

final class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;
  final List<int> body = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    if (requestStream != null) await requestStream.forEach(body.addAll);
    return ResponseBody.fromString(
      '{"id":"template-1","workspaceId":"workspace-1","name":"QA szablon","updatedAtUtc":"2026-10-02T00:00:00Z","version":1}',
      201,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
