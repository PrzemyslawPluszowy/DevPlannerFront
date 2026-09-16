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

  void _downloadReceived(OnlyOfficeDownload download) {
    final pending = _downloadCompletion;
    if (pending != null && !pending.isCompleted) pending.complete(download);
  }

  /// Eksportuje aktualną treść edytora do wybranego formatu (np. docx, pdf).
  Future<OnlyOfficeDownload> requestExport({String? format}) async {
    if (!_documentReady || _delegate == null) {
      throw StateError('editor_not_ready');
    }
    _downloadCompletion = Completer<OnlyOfficeDownload>();
    final script = format == null
        ? 'window.storageEditor.downloadAs();'
        : 'window.storageEditor.downloadAs(${jsonEncode(format)});';
    await _delegate!.runJavaScript(script);
    return _downloadCompletion!.future;
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
  Uri? _server;

  @override
  Future<void> initialize({
    required ValueChanged<OnlyOfficeDownload> onDownloadRequested,
    ValueChanged<OnlyOfficeSaveAs>? onSaveAsRequested,
    VoidCallback? onCloseRequested,
    VoidCallback? onPrintRequested,
    required VoidCallback onPageFinished,
    required ValueChanged<String> onMainFrameError,
  }) async {
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.addJavaScriptChannel(
      'storageBridge',
      onMessageReceived: (message) {
        final event = OnlyOfficeBridge.decode(message.message);
        switch (event?['type']) {
          case 'ready':
            debugPrint('[storage.onlyoffice] Dokument gotowy.');
            onPageFinished();
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
        }
      },
    );
    await _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) => debugPrint(
          '[storage.onlyoffice] Strona hosta gotowa; oczekiwanie na dokument.',
        ),
        onWebResourceError: (error) {
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
    return _controller.loadHtmlString(html, baseUrl: baseUrl);
  }

  @override
  Future<void> runJavaScript(String script) =>
      _controller.runJavaScript(script);

  @override
  Widget buildWidget() => WebViewWidget(controller: _controller);
}
