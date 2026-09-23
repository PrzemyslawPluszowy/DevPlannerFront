import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/standalone/devplanner_storage_composition.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('web BFF composes authenticated tickets and isolated presigned PUT', () {
    final transport = DevPlannerHttpTransport(
      dio: Dio(),
      baseUrl: 'https://devnote.flutter-dev.pl',
      isWeb: true,
    );

    expect(transport.isBffCookieTransport, isTrue);
    final composition = DevPlannerStorageComposition.resolve(
      transport: transport,
    );

    expect(composition.repository, isA<StorageRepositoryImpl>());
    expect(composition.uploadTransport, isA<PresignedUploadTransport>());
  });

  test('transport without a supported session cannot compose Storage', () {
    final transport = DevPlannerHttpTransport(
      dio: Dio(),
      baseUrl: 'https://devnote.flutter-dev.pl',
      isWeb: true,
      tokenProvider: () async => null,
    );

    final composition = DevPlannerStorageComposition.resolve(
      transport: transport,
    );

    expect(composition.repository, isNull);
    expect(composition.uploadTransport, isNull);
  });
}
