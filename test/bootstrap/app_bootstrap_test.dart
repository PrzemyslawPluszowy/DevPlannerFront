import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/app/devplanner_app.dart';
import 'package:devplanner/app/shell/devplanner_shell.dart';
import 'package:devplanner/auth/data/adapters/web_bff_auth_adapter.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/presentation/auth_route_page.dart';
import 'package:devplanner/bootstrap/app_bootstrap.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bootstrap przekazuje aktywną sesję do standalone app', (
    tester,
  ) async {
    final auth = _webAuth(authenticated: true);
    auth.session.setSignedIn(
      const AuthUser(
        userId: 'bootstrap-user',
        login: 'bootstrap',
        displayName: 'Bootstrap User',
      ),
    );
    final transport = _webTransport(authenticated: true);

    await bootstrap(auth: auth, httpTransport: transport);
    await tester.pumpAndSettle();

    final app = tester.widget<DevPlannerApp>(find.byType(DevPlannerApp));
    expect(app.auth, same(auth));
    expect(app.httpTransport, same(transport));
    expect(find.byType(DevPlannerShellRoute), findsOneWidget);
    expect(find.byType(AuthRoutePage), findsNothing);
  });

  testWidgets('bootstrap utrzymuje nieaktywną sesję fail-closed', (
    tester,
  ) async {
    final auth = _webAuth(authenticated: false);
    final transport = _webTransport(authenticated: false);

    await bootstrap(auth: auth, httpTransport: transport);
    await tester.pumpAndSettle();

    final app = tester.widget<DevPlannerApp>(find.byType(DevPlannerApp));
    expect(app.auth, same(auth));
    expect(app.httpTransport, same(transport));
    expect(find.byType(AuthRoutePage), findsOneWidget);
    expect(find.byType(DevPlannerShellRoute), findsNothing);
  });
}

AuthComposition _webAuth({required bool authenticated}) =>
    AuthComposition.webBff(
      httpTransport: _webTransport(authenticated: authenticated),
      browserLauncher: _NoopBrowserLauncher(),
    );

DevPlannerHttpTransport _webTransport({required bool authenticated}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://planner.example.test'))
    ..httpClientAdapter = _BootstrapAdapter(authenticated: authenticated);
  return DevPlannerHttpTransport(dio: dio, isWeb: true);
}

final class _BootstrapAdapter implements HttpClientAdapter {
  _BootstrapAdapter({required this.authenticated});

  final bool authenticated;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final body = options.path == '/bff/session'
        ? <String, Object>{
            'authenticated': authenticated,
            'csrfTokenAvailable': authenticated,
          }
        : <String, Object>{
            'code': 'auth.unauthorized',
            'message': 'Unauthorized',
          };
    return ResponseBody.fromString(
      jsonEncode(body),
      authenticated || options.path == '/bff/session' ? 200 : 401,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

final class _NoopBrowserLauncher implements WebBffBrowserLauncher {
  @override
  bool get returnsAfterNavigation => true;

  @override
  Future<void> open(Uri authorizationUri) async {}
}
