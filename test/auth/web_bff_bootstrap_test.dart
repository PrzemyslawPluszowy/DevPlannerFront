import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_client_ports.dart';
import 'package:devplanner/bootstrap/web_bff_bootstrap.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buduje wyłącznie webową kompozycję BFF bez Bearera', () {
    final transport = DevPlannerHttpTransport(
      dio: Dio(),
      baseUrl: 'http://localhost:5072',
      isWeb: true,
    );

    final auth = const DevPlannerWebBffBootstrap().compose(transport);

    expect(auth.client?.clientKind, AuthClientKind.webBff);
    expect(auth.session.snapshot.isAuthenticated, isFalse);
    expect(auth.client, isA<WebBffAuthPort>());
  });

  test('odrzuca transport z Bearerem jako webowy root', () {
    final transport = DevPlannerHttpTransport(
      dio: Dio(),
      baseUrl: 'http://localhost:5072',
      isWeb: true,
      tokenProvider: () async => 'must-not-be-used',
    );

    expect(
      () => const DevPlannerWebBffBootstrap().compose(transport),
      throwsStateError,
    );
  });
}
