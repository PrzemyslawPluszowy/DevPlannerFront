import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ready_next/app/ready_next_app.dart';
import 'package:ready_next/core/config/app_env.dart';
import 'package:ready_next/core/host/host_bridge_factory.dart';
import 'package:ready_next/core/network/app_api_factory.dart';
import 'package:ready_next/core/storage/hive_helper.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';
import 'package:ready_next/features/settings/data/repositories/local_settings_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Wspolny start aplikacji niezaleznie od platformy.
///
/// Tutaj spinamy trzy rzeczy:
/// - pobranie danych startowych od hosta,
/// - zbudowanie prostej sesji uzytkownika,
/// - uruchomienie glownego widgetu aplikacji.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await HiveHelper.init();
  await StockFilterStorage().init();
  final initialSettings = await HiveLocalSettingsRepository().getSettings();

  final hostBridge = createHostBridge();
  final launchContext = await hostBridge.getLaunchContext();
  final app = ReadyNextApp(
    launchContext: launchContext,
    initialSettings: initialSettings,
  );
  final sentryDsn = AppEnv.sentryDsn.trim();

  if (sentryDsn.isEmpty || !kReleaseMode) {
    runApp(app);
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;
      options.sendDefaultPii = false;
      options.captureFailedRequests = true;
      options.tracesSampleRate = 1.0;
      options.maxRequestBodySize = MaxRequestBodySize.small;
      options.maxResponseBodySize = MaxResponseBodySize.small;
      options.debug = kDebugMode;
      options.addEventProcessor(_HttpModuleEventProcessor());
      options.beforeSend = (event, _) => _sanitizeSensitiveHttpData(event);
    },
    appRunner: () => runApp(SentryWidget(child: app)),
  );
}

SentryEvent _sanitizeSensitiveHttpData(SentryEvent event) {
  final sanitizedRequest = switch (event.request) {
    final SentryRequest request => request.copyWith(
      headers: _sanitizeHeaders(request.headers),
    ),
    _ => null,
  };

  final response = event.contexts.response;
  final sanitizedContexts = switch (response) {
    final SentryResponse value => event.contexts.copyWith(
      response: value.copyWith(headers: _sanitizeHeaders(value.headers)),
    ),
    _ => event.contexts,
  };

  return event.copyWith(request: sanitizedRequest, contexts: sanitizedContexts);
}

Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
  const sensitiveHeaderNames = {
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
    'proxy-authorization',
  };

  return Map<String, String>.fromEntries(
    headers.entries.map((entry) {
      final isSensitive = sensitiveHeaderNames.contains(
        entry.key.toLowerCase(),
      );
      return MapEntry(entry.key, isSensitive ? '[Filtered]' : entry.value);
    }),
  );
}

class _HttpModuleEventProcessor implements EventProcessor {
  @override
  SentryEvent? apply(SentryEvent event, Hint hint) {
    if (event is SentryTransaction) {
      return event;
    }

    for (final exception in event.exceptions ?? const <SentryException>[]) {
      final throwable = exception.throwable;
      if (throwable is! DioException) {
        continue;
      }

      final moduleName = throwable
          .requestOptions
          .extra[AppApiFactory.requestModuleKey]
          ?.toString()
          .trim();
      if (moduleName == null || moduleName.isEmpty) {
        return event;
      }

      final tags = <String, String>{...?event.tags, 'http_module': moduleName};
      return event.copyWith(tags: tags);
    }

    return event;
  }
}
