import 'package:devplanner/auth/data/adapters/desktop_pkce_session_transport_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final status in [400, 401, 429, 500]) {
    for (final error in ['invalid_grant', 'temporarily_unavailable']) {
      test('$status/$error discards only a confirmed invalid grant', () async {
        final dio = Dio();
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              handler.reject(
                DioException(
                  requestOptions: request,
                  response: Response(
                    requestOptions: request,
                    statusCode: status,
                    data: <String, dynamic>{'error': error},
                  ),
                  type: DioExceptionType.badResponse,
                ),
              );
            },
          ),
        );
        final transport = PlatformDesktopPkceSessionTransport(
          baseUrl: 'https://example.test',
          dio: dio,
        );
        final result = transport.restoreSession(
          refreshToken: 'secret-sentinel',
        );
        if (status == 400 && error == 'invalid_grant') {
          expect(await result, isNull);
        } else {
          await expectLater(
            result,
            throwsA(isA<DesktopPkceProtocolException>()),
          );
        }
        dio.close();
      });
    }
  }
  for (final invalid in <Map<String, dynamic>>[
    {'access_token': ''},
    {'refresh_token': ' '},
    {'expires_in': 0},
    {'expires_in': 86401},
    {'access_token': 123},
    {'token_type': 'unknown'},
  ]) {
    test(
      'malformed token response is rejected: ${invalid.keys.single}',
      () async {
        final dio = Dio();
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: request,
                  data: {
                    'access_token': 'access',
                    'refresh_token': 'refresh',
                    'expires_in': 600,
                    'token_type': 'Bearer',
                    ...invalid,
                  },
                ),
              );
            },
          ),
        );
        final transport = PlatformDesktopPkceSessionTransport(
          baseUrl: 'https://example.test',
          dio: dio,
        );
        await expectLater(
          transport.restoreSession(refreshToken: 'secret-sentinel'),
          throwsA(isA<DesktopPkceProtocolException>()),
        );
        dio.close();
      },
    );
  }
}
