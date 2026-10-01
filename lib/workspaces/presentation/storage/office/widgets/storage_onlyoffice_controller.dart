import 'dart:async';
import 'dart:convert';

import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:flutter/material.dart';

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
  Completer<void> _scopeEnded = Completer<void>();
  int _generation = 0;

  void downloadReceived(OnlyOfficeDownload download) {
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
    final delegate = _delegate!;
    final generation = _generation;
    final scopeEnded = _scopeEnded.future;
    final completion = Completer<OnlyOfficeDownload>();
    _downloadCompletion = completion;
    final timeout = Completer<OnlyOfficeDownload>();
    final timer = Timer(const Duration(seconds: 30), () {
      timeout.completeError(TimeoutException('editor_export_timeout'));
    });
    final script = format == null
        ? 'window.storageEditor.downloadAs();'
        : 'window.storageEditor.downloadAs(${jsonEncode(format)});';
    try {
      return await Future.any<OnlyOfficeDownload>([
        _dispatchExport(delegate, script, completion.future),
        scopeEnded.then<OnlyOfficeDownload>(
          (_) => throw StateError('editor_scope_closed'),
        ),
        timeout.future,
      ]);
    } on TimeoutException {
      if (generation == _generation) _exportUnavailable = true;
      rethrow;
    } finally {
      timer.cancel();
      if (identical(_downloadCompletion, completion)) {
        _downloadCompletion = null;
      }
    }
  }

  Future<OnlyOfficeDownload> _dispatchExport(
    StorageOnlyOfficeController delegate,
    String script,
    Future<OnlyOfficeDownload> response,
  ) async {
    await delegate.runJavaScript(script);
    return response;
  }

  /// Eksportuje aktualną treść edytora, nie ostatnią wersję z magazynu.
  Future<void> requestDownload({String? format}) =>
      requestExport(format: format);

  void markDocumentReady(bool value) => _documentReady = value;

  bool _documentReady = false;
  bool _approved = false;
  Completer<void>? _closeApproval;

  void approveClose() {
    _approved = true;
    final pending = _closeApproval;
    if (pending != null && !pending.isCompleted) pending.complete();
  }

  StorageOnlyOfficeController? _delegate;

  void attach(StorageOnlyOfficeController delegate) {
    _endScope();
    _scopeEnded = Completer<void>();
    _delegate = delegate;
    _documentReady = false;
    _approved = false;
    _exportUnavailable = false;
  }

  void detach(StorageOnlyOfficeController? delegate) {
    if (!identical(_delegate, delegate)) return;
    _endScope();
    _delegate = null;
  }

  void _endScope() {
    _generation++;
    if (!_scopeEnded.isCompleted) _scopeEnded.complete();
    _downloadCompletion = null;
    _closeApproval = null;
    _documentReady = false;
  }

  /// Niszczy instancję DocsAPI, co zgłasza Document Serverowi zamknięcie
  /// edytora i uruchamia końcowy callback zapisu.
  Future<void> closeEditor() async {
    final delegate = _delegate;
    if (delegate == null) return;
    final generation = _generation;
    final scopeEnded = _scopeEnded.future;
    if (_documentReady && !_approved) {
      if (_closeApproval != null) throw StateError('close_already_in_progress');
      final approval = Completer<void>();
      _closeApproval = approval;
      try {
        await Future.any<void>([
          _requestCloseApproval(delegate, approval.future),
          scopeEnded.then<void>((_) => throw StateError('editor_scope_closed')),
        ]);
      } finally {
        if (identical(_closeApproval, approval)) _closeApproval = null;
      }
    }
    if (generation != _generation || !identical(_delegate, delegate)) {
      throw StateError('editor_scope_closed');
    }
    await _destroy(delegate);
  }

  Future<void> _requestCloseApproval(
    StorageOnlyOfficeController delegate,
    Future<void> approval,
  ) async {
    await delegate.runJavaScript('window.storageEditor.requestClose();');
    await approval;
  }

  /// Niszczy edytor po uzyskaniu zgody lub świadomym wymuszeniu zamknięcia.
  Future<void> destroyEditor() async {
    final delegate = _delegate;
    if (delegate != null) await _destroy(delegate);
  }

  Future<void> _destroy(StorageOnlyOfficeController delegate) async {
    await delegate.runJavaScript('''
if (window.storageEditor) {
  window.storageEditor.destroyEditor();
  window.storageEditor = null;
}
''');
  }
}
