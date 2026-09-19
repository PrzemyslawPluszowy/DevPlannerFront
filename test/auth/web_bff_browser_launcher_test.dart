import 'dart:typed_data';

import 'package:devplanner/auth/data/adapters/web_bff_auth_adapter.dart';
import 'package:devplanner/auth/data/adapters/web_bff_browser_launcher.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('platformowy launcher poza Web pozostaje fail-closed', () async {
    const launcher = PlatformWebBffBrowserLauncher();

    expect(launcher.returnsAfterNavigation, isFalse);
    expect(
      () => launcher.open(Uri.parse('http://localhost:5072/bff/auth/start')),
      throwsStateError,
    );
  });

  test(
    'redirect lifecycle nie wykonuje synchronicznego restore po nawigacji',
    () async {
      final adapter = _RecordingAdapter();
      final transport = DevPlannerHttpTransport(
        dio: Dio()..httpClientAdapter = adapter,
        baseUrl: 'http://localhost:5072',
        isWeb: true,
      );
      final launcher = _RedirectingLauncher();
      final auth = HttpWebBffSessionTransport(
        httpTransport: transport,
        browserLauncher: launcher,
      );

      await expectLater(
        auth.signIn(
          const LoginCredentials(login: 'ignored', password: 'ignored'),
        ),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.code,
            'code',
            'auth.bff.redirect_started',
          ),
        ),
      );
      expect(adapter.requests, isEmpty);
      expect(launcher.opened, hasLength(1));
    },
  );
}

final class _RedirectingLauncher implements WebBffBrowserLauncher {
  final opened = <Uri>[];

  @override
  bool get returnsAfterNavigation => false;

  @override
  Future<void> open(Uri authorizationUri) async => opened.add(authorizationUri);
}

final class _RecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString('{}', 500);
  }

  @override
  void close({bool force = false}) {}
}
