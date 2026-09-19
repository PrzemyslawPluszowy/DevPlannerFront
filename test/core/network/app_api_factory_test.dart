import 'package:devplanner/core/config/app_api_module.dart';
import 'package:devplanner/core/network/app_api_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker/talker.dart';

void main() {
  group('AppApiFactory', () {
    test('createDio dokleja Authorization gdy token jest dostepny', () async {
      final dio = AppApiFactory.createDio(
        baseUrl: 'https://example.com',
        module: AppApiModule.workspaces,
        accessTokenProvider: () => 'abc123token',
        enableLogging: false,
      );

      RequestOptions? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response<void>(
                requestOptions: options,
                statusCode: 200,
              ),
            );
          },
        ),
      );

      await dio.get<void>('/workspaces');

      expect(captured, isNotNull);
      expect(captured!.headers['Authorization'], 'Bearer abc123token');
      expect(captured!.extra[AppApiFactory.requestModuleKey], 'workspaces');
    });

    test('createAuthDio nie dokleja Authorization', () async {
      final dio = AppApiFactory.createAuthDio(
        baseUrl: 'https://example.com',
        module: AppApiModule.auth,
        enableLogging: false,
      );

      RequestOptions? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response<void>(
                requestOptions: options,
                statusCode: 200,
              ),
            );
          },
        ),
      );

      await dio.post<void>('/api/v1/auth/login');

      expect(captured, isNotNull);
      expect(captured!.headers.containsKey('Authorization'), isFalse);
      expect(captured!.extra[AppApiFactory.requestModuleKey], 'auth');
    });

    test('Talker nie loguje surowego tokenu Authorization', () async {
      const accessToken = 'super-secret-access-token';
      final talker = Talker();
      final dio = AppApiFactory.createDio(
        baseUrl: 'https://example.com',
        module: AppApiModule.workspaces,
        accessToken: accessToken,
        talker: talker,
      );
      final originalDebugPrint = debugPrint;
      final debugMessages = <String>[];
      debugPrint = (message, {wrapWidth}) {
        if (message != null) debugMessages.add(message);
      };

      try {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.resolve(
              Response<void>(requestOptions: options, statusCode: 200),
            ),
          ),
        );

        await dio.get<void>('/workspaces');

        final loggedMessages = talker.history
            .map((entry) => entry.generateTextMessage())
            .join('\n');
        final debugOutput = debugMessages.join('\n');
        expect(loggedMessages, isNot(contains(accessToken)));
        expect(debugOutput, isNot(contains(accessToken)));
        expect(debugOutput, contains('Bearer super-...oken'));
      } finally {
        debugPrint = originalDebugPrint;
      }
    });
  });
}
