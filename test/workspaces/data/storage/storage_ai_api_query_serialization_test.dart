import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/ai/models/storage_ai_models.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _RejectingRecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(const <String, Object?>{'code': 'test.stop'}),
      400,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('enumy filtrów AI mają stabilne wartości kontraktu HTTP', () {
    expect(
      AiProviderKind.values.map((value) => value.apiValue),
      <String>[
        'disabled',
        'aifastApi',
        'openAi',
        'azureOpenAi',
        'anthropic',
        'ollama',
        'custom',
      ],
    );
    expect(
      AiOperationAuditEventType.values.map((value) => value.apiValue),
      <String>['started', 'completed', 'failed', 'reconciled'],
    );
    expect(
      StorageAnalysisFailureCode.values.map((value) => value.apiValue),
      everyElement(isNot(contains('StorageAnalysisFailureCode.'))),
    );
    expect(
      AiReportScheduleRunStatus.values.map((value) => value.apiValue),
      <String>['pending', 'reportCreated', 'completed', 'failed'],
    );
    expect(
      AiReportDeliveryChannel.values.map((value) => value.apiValue),
      <String>['email', 'inApp'],
    );
    expect(
      AiReportDeliveryStatus.values.map((value) => value.apiValue),
      <String>[
        'pending',
        'processing',
        'delivered',
        'failed',
        'skipped',
        'sentUnknown',
      ],
    );
  });

  test('DTO AI dekodują i kodują enumy z nazwami backendu', () {
    final dto = StorageFileAnalysisJobResponse.fromJson(
      const <String, dynamic>{
        'jobId': 'job-1',
        'fileId': 'file-1',
        'fileVersion': 1,
        'status': 'Completed',
        'attemptCount': 1,
        'maxAttempts': 1,
        'provider': 'OpenAi',
        'providerStatus': 'Healthy',
        'operationLifecycleStatus': 'FailedTerminal',
      },
    );

    expect(dto.provider, AiProviderKind.openAi);
    expect(dto.providerStatus, AiProviderStatus.healthy);
    expect(dto.operationLifecycleStatus, AiOperationStatus.failedTerminal);
    expect(dto.toJson()['provider'], 'OpenAi');
    expect(dto.toJson()['providerStatus'], 'Healthy');
    expect(dto.toJson()['operationLifecycleStatus'], 'FailedTerminal');
  });

  test('StorageApi wysyła filtry AI jako surowe wartości kontraktu', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    final adapter = _RejectingRecordingAdapter();
    dio.httpClientAdapter = adapter;
    final api = StorageApi(dio);

    await expectLater(
      api.listAiFileAnalysisAudit(
        workspaceId: 'workspace-1',
        eventType: AiOperationAuditEventType.reconciled.apiValue,
        provider: AiProviderKind.azureOpenAi.apiValue,
        failureCode: StorageAnalysisFailureCode.providerRateLimited.apiValue,
      ),
      throwsA(isA<DioException>()),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('eventType', 'reconciled'),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('provider', 'azureOpenAi'),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('failureCode', 'providerRateLimited'),
    );

    await expectLater(
      api.getAiUsageSummary(
        'workspace-1',
        provider: AiProviderKind.openAi.apiValue,
      ),
      throwsA(isA<DioException>()),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('provider', 'openAi'),
    );

    await expectLater(
      api.listAiReportAudit(
        'workspace-1',
        'project-1',
        eventType: AiOperationAuditEventType.completed.apiValue,
      ),
      throwsA(isA<DioException>()),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('eventType', 'completed'),
    );

    await expectLater(
      api.listAiReportScheduleRuns(
        'workspace-1',
        'project-1',
        'schedule-1',
        status: AiReportScheduleRunStatus.reportCreated.apiValue,
      ),
      throwsA(isA<DioException>()),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('status', 'reportCreated'),
    );

    await expectLater(
      api.listAiReportDeliveries(
        'workspace-1',
        'project-1',
        'schedule-1',
        channel: AiReportDeliveryChannel.inApp.apiValue,
        deliveryStatus: AiReportDeliveryStatus.sentUnknown.apiValue,
      ),
      throwsA(isA<DioException>()),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('channel', 'inApp'),
    );
    expect(
      adapter.requests.last.queryParameters,
      containsPair('deliveryStatus', 'sentUnknown'),
    );

    for (final request in adapter.requests) {
      expect(request.uri.query, isNot(contains(RegExp(r'[A-Z][A-Za-z]+\\.'))));
    }
  });
}
