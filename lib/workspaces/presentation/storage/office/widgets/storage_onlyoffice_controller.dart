part of 'storage_onlyoffice_host.dart';

/// Tworzy kontroler osadzonego hosta OnlyOffice.
// Fabryka jest celowym portem testowym; reguły Workspaces zabraniają globalnej
// funkcji tworzącej zależność platformową.
// ignore: one_member_abstracts
abstract interface class StorageOnlyOfficeControllerFactory {
  const StorageOnlyOfficeControllerFactory();

  /// Tworzy nową instancję kontrolera dla lifecycle widgetu.
  StorageOnlyOfficeController create();
}

/// Typowany port oddzielający lifecycle widgetu od implementacji WebView.
abstract interface class StorageOnlyOfficeController {
  /// Konfiguruje JavaScript i zdarzenia nawigacji hosta.
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
  });

  /// Ładuje podpisaną konfigurację edytora w lokalnym dokumencie HTML.
  Future<void> loadHtml(String html, {required String baseUrl});

  /// Wykonuje kod lifecycle w dokumencie hosta.
  Future<void> runJavaScript(String script);

  /// Buduje natywną lub webową powierzchnię osadzonego edytora.
  Widget buildWidget();
}

/// Kontroluje bezpieczne zakończenie osadzonej sesji OnlyOffice oraz eksport pliku.
final class StorageOnlyOfficeHostController {
  Completer<OnlyOfficeDownload>? _downloadCompletion;
  bool _exportUnavailable = false;

  void _downloadReceived(OnlyOfficeDownload download) {
    final pending = _downloadCompletion;
    if (pending != null && !pending.isCompleted) {
      pending.complete(download);
    } else if (_exportUnavailable) {
      // Spóźniona odpowiedź po timeoutcie nie może trafić do kolejnej akcji.
      _exportUnavailable = false;
    }
  }

  /// Eksportuje aktualną treść edytora do wybranego formatu (np. docx, pdf).
  Future<OnlyOfficeDownload> requestExport({String? format}) async {
    if (!_documentReady || _delegate == null) {
      throw StateError('editor_not_ready');
    }
    if (_downloadCompletion != null) {
      throw StateError('export_already_in_progress');
    }
    if (_exportUnavailable) {
      throw StateError('export_waiting_for_late_response');
    }
    final completion = Completer<OnlyOfficeDownload>();
    _downloadCompletion = completion;
    final script = format == null
        ? 'window.storageEditor.downloadAs();'
        : 'window.storageEditor.downloadAs(${jsonEncode(format)});';
    try {
      await _delegate!.runJavaScript(script);
      return await completion.future.timeout(const Duration(seconds: 30));
    } on TimeoutException {
      _exportUnavailable = true;
      rethrow;
    } finally {
      if (identical(_downloadCompletion, completion)) {
        _downloadCompletion = null;
      }
    }
  }

  /// Eksportuje aktualną treść edytora, nie ostatnią wersję z magazynu.
  Future<void> requestDownload({String? format}) =>
      requestExport(format: format);

  bool _documentReady = false;
  bool _approved = false;
  Completer<void>? _closeApproval;

  void _approveClose() {
    _approved = true;
    final pending = _closeApproval;
    if (pending != null && !pending.isCompleted) pending.complete();
  }

  StorageOnlyOfficeController? _delegate;

  void _attach(StorageOnlyOfficeController delegate) {
    _delegate = delegate;
    _documentReady = false;
    _approved = false;
    _exportUnavailable = false;
  }

  void _detach(StorageOnlyOfficeController? delegate) {
    if (identical(_delegate, delegate)) _delegate = null;
  }

  /// Niszczy instancję DocsAPI, co zgłasza Document Serverowi zamknięcie
  /// edytora i uruchamia końcowy callback zapisu.
  Future<void> closeEditor() async {
    if (_documentReady && !_approved) {
      _closeApproval = Completer<void>();
      await _delegate?.runJavaScript('window.storageEditor.requestClose();');
      await _closeApproval!.future;
    }
    await destroyEditor();
  }

  /// Niszczy edytor po uzyskaniu zgody lub świadomym wymuszeniu zamknięcia.
  Future<void> destroyEditor() async {
    await _delegate?.runJavaScript('''
if (window.storageEditor) {
  window.storageEditor.destroyEditor();
  window.storageEditor = null;
}
''');
  }
}

/// Produkcyjna fabryka adaptera `webview_all`.
final class WebViewStorageOnlyOfficeControllerFactory
    implements StorageOnlyOfficeControllerFactory {
  /// Tworzy fabrykę produkcyjnego kontrolera.
  const WebViewStorageOnlyOfficeControllerFactory();

  @override
  StorageOnlyOfficeController create() => _WebViewStorageOnlyOfficeController();
}

final class _WebViewStorageOnlyOfficeController
    implements StorageOnlyOfficeController {
  final WebViewController _controller = WebViewController();
  final Talker _talker = TalkerFlutter.init();
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
                '[storage.onlyoffice] Otrzymano niepoprawne dane eksportu: ${event?['data']}',
              );
            } else {
              debugPrint(
                '[storage.onlyoffice] Odebrano eksport dokumentu: ${download.url}',
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
                '[storage.onlyoffice] Otrzymano niepoprawne dane zapisu kopii: ${event?['data']}',
              );
            } else {
              debugPrint(
                '[storage.onlyoffice] Odebrano żądanie zapisu kopii w Storage: ${saveAs.url}',
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
              (target.scheme == 'about' ||
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
    return _controller.loadHtmlString(html, baseUrl: baseUrl);
  }

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
