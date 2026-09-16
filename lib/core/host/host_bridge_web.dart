import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/host/host_bridge.dart';
import 'package:ready_next/core/host/host_launch_route.dart';
import 'package:web/web.dart' as web;

const _launchContextStorageKey = 'ready_next_launch_context';
const _getContextRequestType = 'ready-next:get-context';
const _getContextResponseType = 'ready-next:context';
const _refreshTokenRequestType = 'ready-next:refresh-token';
const _refreshTokenResponseType = 'ready-next:refresh-token-response';

HostBridge createHostBridge() => const WebHostBridge();

/// Webowy most komunikacyjny z hostem osadzajacym aplikacje Flutter.
///
/// Kolejnosc pobierania danych startowych jest nastepujaca:
/// 1. Odczyt trasy startowej z URL, np. `/inventory`.
/// 2. Proba odczytu sesji z `sessionStorage`.
/// 3. Jesli storage jest pusty, proba pobrania danych od hosta przez
///    `postMessage`.
class WebHostBridge implements HostBridge {
  const WebHostBridge();

  static const web.EventStreamProvider<web.MessageEvent> _messageEvents =
      web.EventStreamProvider<web.MessageEvent>('message');
  @override
  Future<HostLaunchContext> getLaunchContext() async {
    final initialRoute = _readInitialRoute();
    final storageContext = _readLaunchContextFromStorage(
      initialRoute: initialRoute,
    );

    if (storageContext != null) {
      return storageContext;
    }

    final hostContext = await _requestLaunchContextFromHost(
      initialRoute: initialRoute,
    );

    return hostContext ??
        HostLaunchContext(
          initialRoute: initialRoute,
          userId: null,
          userDisplayName: null,
        );
  }

  @override
  Future<String?> refreshAccessToken() async {
    final completer = Completer<String?>();

    late final StreamSubscription<web.MessageEvent> subscription;
    subscription = _messageEvents.forTarget(web.window).listen((event) {
      if (!_isTrustedMessageEvent(event)) {
        return;
      }

      final data = _normalizeMessageData(event.data);

      if (data == null || data['type'] != _refreshTokenResponseType) {
        return;
      }

      if (!completer.isCompleted) {
        completer.complete(data['accessToken'] as String?);
      }
    });

    _postMessageToHost({'type': _refreshTokenRequestType});

    return completer.future
        .timeout(const Duration(seconds: 2), onTimeout: () => null)
        .whenComplete(subscription.cancel);
  }

  /// Odczytuje dane przekazane chwilowo przez hosta przed przejsciem po `href`.
  ///
  /// Ten wariant jest wygodny dla scenariusza:
  /// `Ready -> sessionStorage -> href -> Flutter`.
  HostLaunchContext? _readLaunchContextFromStorage({
    required String initialRoute,
  }) {
    final rawValue = web.window.sessionStorage.getItem(
      _launchContextStorageKey,
    );

    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(rawValue);

    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return HostLaunchContext.fromMap(decoded, initialRoute: initialRoute);
  }

  /// Prosi hosta o aktualny kontekst przez `postMessage`.
  ///
  /// To jest fallback dla osadzenia typu iframe, popup albo innego kontenera,
  /// gdzie host woli wysylac dane dynamicznie zamiast uzywac storage.
  Future<HostLaunchContext?> _requestLaunchContextFromHost({
    required String initialRoute,
  }) async {
    final completer = Completer<HostLaunchContext?>();

    late final StreamSubscription<web.MessageEvent> subscription;
    subscription = _messageEvents.forTarget(web.window).listen((event) {
      if (!_isTrustedMessageEvent(event)) {
        return;
      }

      final data = _normalizeMessageData(event.data);

      if (data == null || data['type'] != _getContextResponseType) {
        return;
      }

      if (!completer.isCompleted) {
        completer.complete(
          HostLaunchContext.fromMap(data, initialRoute: initialRoute),
        );
      }
    });

    _postMessageToHost({'type': _getContextRequestType});

    return completer.future
        .timeout(const Duration(milliseconds: 800), onTimeout: () => null)
        .whenComplete(subscription.cancel);
  }

  /// Czyta trase startowa z URL.
  ///
  /// Wspieramy:
  /// - nowy format bez `#`, np. `/ready-next/inventory`
  /// - stary format z `#`, np. `/ready-next/#/inventory`
  String _readInitialRoute() {
    return resolveWebLaunchLocation(
      path: Uri.base.path,
      query: Uri.base.query,
      fragment: Uri.base.fragment,
    );
  }

  /// Zamienia payload z JS na zwykla mape Darta.
  ///
  /// Host moze przyslac dane jako obiekt JS albo jako tekst JSON.
  Map<String, dynamic>? _normalizeMessageData(JSAny? value) {
    if (value == null) {
      return null;
    }

    final dartValue = value.dartify();

    if (dartValue is Map) {
      return Map<String, dynamic>.from(dartValue);
    }

    if (dartValue is String) {
      final decoded = jsonDecode(dartValue);

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }

    return null;
  }

  /// Akceptuje wiadomosci tylko z przewidywanego origin hosta.
  ///
  /// Dzieki temu przypadkowe lub zlosliwe `postMessage` z innych ramek
  /// nie zostana potraktowane jako odpowiedz hosta.
  bool _isTrustedMessageEvent(web.MessageEvent event) {
    final trustedOrigins = _trustedHostOrigins();

    if (trustedOrigins.isEmpty) {
      return event.origin == Uri.base.origin;
    }

    return trustedOrigins.contains(event.origin);
  }

  Set<String> _trustedHostOrigins() {
    final origins = <String>{Uri.base.origin};
    final referrer = web.document.referrer.trim();

    if (referrer.isNotEmpty) {
      final referrerUri = Uri.tryParse(referrer);
      final referrerOrigin = _originFromUri(referrerUri);

      if (referrerOrigin != null) {
        origins.add(referrerOrigin);
      }
    }

    return origins;
  }

  String? _resolveHostTargetOrigin() {
    final referrer = web.document.referrer.trim();

    if (referrer.isNotEmpty) {
      final referrerUri = Uri.tryParse(referrer);
      final referrerOrigin = _originFromUri(referrerUri);

      if (referrerOrigin != null) {
        return referrerOrigin;
      }
    }

    return Uri.base.origin;
  }

  String? _originFromUri(Uri? uri) {
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return null;
    }

    return uri.origin;
  }

  /// Wysyła wiadomosc do hosta osadzajacego aplikacje.
  ///
  /// Najpierw probujemy `parent`, bo to najczestszy przypadek dla iframa.
  /// Jesli go nie ma, probujemy `opener`, co wspiera okno otwarte przez hosta.
  void _postMessageToHost(Map<String, dynamic> message) {
    final payload = jsonEncode(message).toJS;
    final targetOrigin = _resolveHostTargetOrigin()?.toJS ?? '*'.toJS;

    final parentWindow = web.window.parent;
    if (parentWindow != null && parentWindow != web.window) {
      parentWindow.postMessage(payload, targetOrigin);
      return;
    }

    final openerWindow = web.window.opener;
    if (openerWindow != null) {
      (openerWindow as web.Window).postMessage(payload, targetOrigin);
    }
  }
}
