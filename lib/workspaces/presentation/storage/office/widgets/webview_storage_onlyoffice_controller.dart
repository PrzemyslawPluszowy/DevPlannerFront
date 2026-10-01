import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/onlyoffice_host_document.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_controller.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:webview_all/webview_all.dart';

/// Produkcyjna fabryka adaptera `webview_all`.
final class WebViewStorageOnlyOfficeControllerFactory
    implements StorageOnlyOfficeControllerFactory {
  /// Tworzy fabrykę produkcyjnego kontrolera.
  const WebViewStorageOnlyOfficeControllerFactory();

  @override
  StorageOnlyOfficeController create() => WebViewStorageOnlyOfficeController();
}

final class WebViewStorageOnlyOfficeController
    implements StorageOnlyOfficeController {
  final WebViewController _controller = WebViewController();
  final Talker _talker = TalkerFlutter.init();
  final OnlyOfficeHostDocument _hostDocument = OnlyOfficeHostDocument();
  Uri? _server;
  bool _hostPageLoaded = false;

  @override
  Future<void> initialize({
    required ValueChanged<OnlyOfficeDownload> onDownloadRequested,
    ValueChanged<OnlyOfficeSaveAs>? onSaveAsRequested,
    VoidCallback? onCloseRequested,
    VoidCallback? onPrintRequested,
    required VoidCallback onPageFinished,
    required ValueChanged<String> onMainFrameError,
    VoidCallback? onAppReady,
    VoidCallback? onUserActionRequired,
    VoidCallback? onDocumentReady,
    ValueChanged<bool>? onDocumentStateChanged,
  }) async {
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.addJavaScriptChannel(
      'storageBridge',
      onMessageReceived: (message) {
        final event = OnlyOfficeBridge.decode(message.message);
        switch (event?['type']) {
          case 'appReady':
            _talker.info('[storage.onlyoffice] Aplikacja edytora gotowa.');
            onAppReady?.call();
          case 'userActionRequired':
            _talker.info(
              '[storage.onlyoffice] Edytor oczekuje na wybór użytkownika.',
            );
            onUserActionRequired?.call();
          case 'editorCreated':
            final data = event?['data'];
            final details = data is Map<String, dynamic>
                ? data
                : const <String, dynamic>{};
            _talker.info(
              '[storage.onlyoffice] Instancja edytora utworzona; '
              'hostOrigin=${details['hostOrigin'] == 'web' ? 'web' : 'opaque'}.',
            );
          case 'ready':
            debugPrint('[storage.onlyoffice] Dokument gotowy.');
            onDocumentReady?.call();
            onPageFinished();
          case 'modified':
            // OnlyOffice raportuje stan dokumentu: 1 to zmiany jeszcze
            // niepotwierdzone zapisem, 0 to stan zapisany.
            onDocumentStateChanged?.call(event?['data'] == '1');
          case 'close':
            onCloseRequested?.call();
          case 'print':
            debugPrint(
              '[storage.onlyoffice] Odebrano żądanie wydruku z edytora.',
            );
            onPrintRequested?.call();
          case 'download':
            final server = _server;
            final download = server == null
                ? null
                : OnlyOfficeBridge.download(event?['data'], server);
            if (download == null) {
              debugPrint(
                '[storage.onlyoffice] Otrzymano niepoprawne dane eksportu.',
              );
            } else {
              debugPrint(
                '[storage.onlyoffice] Odebrano eksport dokumentu.',
              );
              onDownloadRequested(download);
            }
          case 'saveAs':
            final server = _server;
            final saveAs = server == null
                ? null
                : OnlyOfficeBridge.saveAs(event?['data'], server);
            if (saveAs == null) {
              debugPrint(
                '[storage.onlyoffice] Otrzymano niepoprawne dane zapisu kopii.',
              );
            } else {
              debugPrint(
                '[storage.onlyoffice] Odebrano żądanie zapisu kopii w Storage.',
              );
              onSaveAsRequested?.call(saveAs);
            }
          case 'error':
            final code = event?['data'];
            final safeCode = code is int ? code.toString() : 'editor_error';
            debugPrint('[storage.onlyoffice] Błąd edytora: $safeCode');
            onMainFrameError('OnlyOffice: $safeCode');
          case 'warning':
            debugPrint('[storage.onlyoffice] Ostrzeżenie edytora.');
          case 'apiLoaded':
            _talker.info(
              '[storage.onlyoffice] Skrypt ONLYOFFICE api.js załadowany.',
            );
          case 'apiLoadError':
            _talker.error(
              '[storage.onlyoffice] Nie udało się pobrać skryptu ONLYOFFICE api.js.',
            );
          case 'runtimeError':
            _talker.error(
              '[storage.onlyoffice][JS error] '
              '${_sanitizeDiagnosticText(event?['data']?.toString() ?? 'Nieznany błąd JavaScript.')}',
            );
        }
      },
    );
    await _controller.setOnConsoleMessage((message) {
      if (message.level == JavaScriptLogLevel.error ||
          message.level == JavaScriptLogLevel.warning) {
        _talker.log(
          '[storage.onlyoffice][JS ${message.level.name}] '
          '${_sanitizeDiagnosticText(message.message)}',
          logLevel: message.level == JavaScriptLogLevel.error
              ? LogLevel.error
              : LogLevel.warning,
        );
      }
    });
    await _controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          if (!request.isMainFrame) return NavigationDecision.navigate;
          final target = Uri.tryParse(request.url);
          final server = _server;
          final isHostNavigation =
              target != null &&
              (_hostDocument.owns(target) ||
                  target.scheme == 'about' ||
                  target.scheme == 'data' ||
                  ((target.scheme == 'https' || target.scheme == 'http') &&
                      server != null &&
                      target.origin == server.origin));
          if (_hostPageLoaded || !isHostNavigation) {
            _talker.warning(
              '[storage.onlyoffice] Zablokowano nawigację poza osadzonym edytorem.',
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (_) {
          _hostPageLoaded = true;
          debugPrint(
            '[storage.onlyoffice] Strona hosta gotowa; oczekiwanie na dokument.',
          );
        },
        onWebResourceError: (error) {
          final url = _safeResourceUrl(error.url);
          _talker.error(
            '[storage.onlyoffice][WEBVIEW] Błąd zasobu: '
            'mainFrame=${error.isForMainFrame}, code=${error.errorCode}, '
            'type=${error.errorType?.name ?? 'unknown'}, '
            'url=$url, opis=${_sanitizeDiagnosticText(error.description)}',
          );
          if (error.isForMainFrame != false) {
            onMainFrameError(error.description);
          }
        },
      ),
    );
  }

  @override
  Future<void> loadHtml(String html, {required String baseUrl}) {
    _server = Uri.parse(baseUrl);
    _hostPageLoaded = false;
    final documentUrl = _hostDocument.create(html);
    if (documentUrl != null) return _controller.loadRequest(documentUrl);
    return _controller.loadHtmlString(html, baseUrl: baseUrl);
  }

  @override
  void dispose() => _hostDocument.dispose();

  @override
  Future<void> runJavaScript(String script) =>
      _controller.runJavaScript(script);

  @override
  Widget buildWidget() => WebViewWidget(controller: _controller);

  static String _safeResourceUrl(String? rawUrl) {
    final uri = Uri.tryParse(rawUrl ?? '');
    if (uri == null || !uri.hasAuthority) return '<unknown-url>';
    final path = uri.host.contains('office.') ? uri.path : '/<path-redacted>';
    return '${uri.scheme}://${uri.authority}$path';
  }

  static String _sanitizeDiagnosticText(String message) => message
      .replaceAll(RegExp(r"""https?://[^\s"']+"""), '<url-redacted>')
      .replaceAll(
        RegExp(
          r'(token|secret|authorization)=([^&\s]+)',
          caseSensitive: false,
        ),
        r'$1=<redacted>',
      );
}
