import 'dart:async';
import 'dart:developer' as developer;

import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_editor_html_builder.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_controller.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host_surface.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/webview_storage_onlyoffice_controller.dart';
import 'package:flutter/material.dart';

export 'storage_onlyoffice_controller.dart';
export 'webview_storage_onlyoffice_controller.dart';

/// Cross-platform in-app host for a backend-signed OnlyOffice session.
///
/// The package implementation uses js-interop on Web, WKWebView on macOS,
/// WebView2 on Windows and WebKitGTK on Linux. Storage owns this adapter so
/// presentation and state management do not depend on a WebView vendor.
class StorageOnlyOfficeHost extends StatefulWidget {
  const StorageOnlyOfficeHost({
    required this.session,
    this.controllerFactory = const WebViewStorageOnlyOfficeControllerFactory(),
    this.hostController,
    this.onDownloadRequested,
    this.onSaveAsRequested,
    this.onPrintRequested,
    this.onCloseRequested,
    this.onDocumentReady,
    this.onDocumentStateChanged,
    super.key,
  });

  final OnlyOfficeSessionResponse session;

  /// Fabryka adaptera hosta, wstrzykiwana w testach bez uruchamiania WebView.
  final StorageOnlyOfficeControllerFactory controllerFactory;

  /// Kontroler lifecycle używany przez modal do poprawnego zamknięcia edytora.
  final StorageOnlyOfficeHostController? hostController;

  /// Przekazuje wygenerowany przez OnlyOffice URL do natywnego downloadera.
  final ValueChanged<OnlyOfficeDownload>? onDownloadRequested;

  /// Przekazuje żądanie utworzenia kopii pliku w Storage z OnlyOffice.
  final ValueChanged<OnlyOfficeSaveAs>? onSaveAsRequested;

  /// Wywoływane gdy edytor zgłasza żądanie drukowania (np. Ctrl+P lub menu edytora).
  final VoidCallback? onPrintRequested;

  final VoidCallback? onCloseRequested;

  /// Wywoływane, gdy dokument jest gotowy i sesja jest połączona.
  final VoidCallback? onDocumentReady;

  /// Wywoływane przy zmianie stanu dokumentu: `true` to zmiany niepotwierdzone
  /// zapisem, `false` to stan zapisany.
  final ValueChanged<bool>? onDocumentStateChanged;

  @override
  State<StorageOnlyOfficeHost> createState() => _StorageOnlyOfficeHostState();
}

class _StorageOnlyOfficeHostState extends State<StorageOnlyOfficeHost> {
  final _viewState = ValueNotifier<StorageOnlyOfficeHostViewState>(
    const StorageOnlyOfficeHostViewState(),
  );
  Timer? _loadTimeout;
  int _generation = 0;
  StorageOnlyOfficeController? _activeController;
  bool _appReady = false;
  bool _documentReady = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  @override
  void didUpdateWidget(StorageOnlyOfficeHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controllerFactory != widget.controllerFactory ||
        oldWidget.session != widget.session ||
        !identical(oldWidget.hostController, widget.hostController)) {
      oldWidget.hostController?.detach(_activeController);
      unawaited(_initialize());
    }
  }

  bool _isCurrent(StorageOnlyOfficeController controller, int generation) =>
      mounted &&
      generation == _generation &&
      identical(_activeController, controller);

  Future<void> _initialize() async {
    if (!mounted) return;
    final generation = ++_generation;
    _loadTimeout?.cancel();
    widget.hostController?.detach(_activeController);
    developer.log('Inicjalizacja WebView.', name: 'storage.onlyoffice');
    _activeController?.dispose();
    try {
      final controller = widget.controllerFactory.create();
      _activeController = controller;
      _viewState.value = StorageOnlyOfficeHostViewState(controller: controller);
      widget.hostController?.attach(controller);
      await controller
          .initialize(
            onDocumentReady: () {
              if (_isCurrent(controller, generation)) {
                widget.onDocumentReady?.call();
              }
            },
            onDocumentStateChanged: (modified) {
              if (_isCurrent(controller, generation)) {
                widget.onDocumentStateChanged?.call(modified);
              }
            },
            onCloseRequested: () {
              if (!_isCurrent(controller, generation)) return;
              widget.hostController?.approveClose();
              widget.onCloseRequested?.call();
            },
            onPrintRequested: () {
              if (_isCurrent(controller, generation)) {
                widget.onPrintRequested?.call();
              }
            },
            onSaveAsRequested: (saveAs) {
              if (!_isCurrent(controller, generation)) return;
              developer.log(
                'OnlyOffice przekazał plik do zapisu kopii w Storage.',
                name: 'storage.onlyoffice',
              );
              widget.onSaveAsRequested?.call(saveAs);
            },
            onDownloadRequested: (url) {
              if (!_isCurrent(controller, generation)) return;
              widget.hostController?.downloadReceived(url);
              developer.log(
                'OnlyOffice przekazał plik do pobrania.',
                name: 'storage.onlyoffice',
              );
              widget.onDownloadRequested?.call(url);
            },
            onAppReady: () {
              if (!_isCurrent(controller, generation)) {
                return;
              }
              _appReady = true;
              _viewState.value = _viewState.value.copyWith(isLoading: false);
            },
            onUserActionRequired: () {
              if (!_isCurrent(controller, generation)) {
                return;
              }
              _appReady = true;
              _loadTimeout?.cancel();
              _viewState.value = _viewState.value.copyWith(
                isLoading: false,
                documentTimedOut: false,
              );
            },
            onPageFinished: () {
              if (_isCurrent(controller, generation)) {
                _documentReady = true;
                widget.hostController?.markDocumentReady(true);
                _loadTimeout?.cancel();
                developer.log(
                  'Dokument zakończył ładowanie.',
                  name: 'storage.onlyoffice',
                );
                _viewState.value = _viewState.value.copyWith(
                  isLoading: false,
                  documentTimedOut: false,
                );
              }
            },
            onMainFrameError: (description) {
              if (_isCurrent(controller, generation)) {
                _loadTimeout?.cancel();
                developer.log(
                  'Błąd głównej ramki edytora.',
                  name: 'storage.onlyoffice',
                  level: 1000,
                );
                _viewState.value = _viewState.value.copyWith(
                  initializationError: description,
                  isLoading: false,
                );
              }
            },
          )
          .timeout(const Duration(seconds: 30));
      if (!_isCurrent(controller, generation)) return;
      await _loadSession();
    } on Object catch (error) {
      developer.log(
        'Nie udało się zainicjalizować WebView.',
        name: 'storage.onlyoffice',
        level: 1000,
      );
      if (!mounted || generation != _generation) return;
      _viewState.value = _viewState.value.copyWith(
        initializationError: error,
        isLoading: false,
      );
    }
  }

  @override
  void dispose() {
    _generation++;
    _loadTimeout?.cancel();
    widget.hostController?.detach(_activeController);
    _activeController?.dispose();
    _activeController = null;
    _viewState.dispose();
    super.dispose();
  }

  Future<void> _loadSession() async {
    final controller = _activeController;
    final generation = _generation;
    final session = widget.session;
    if (controller == null || !_isCurrent(controller, generation)) return;
    _appReady = false;
    _documentReady = false;
    widget.hostController?.markDocumentReady(false);
    if (mounted) {
      _viewState.value = _viewState.value.copyWith(
        clearInitializationError: true,
        isLoading: true,
        documentTimedOut: false,
      );
    }
    _loadTimeout?.cancel();
    _loadTimeout = Timer(const Duration(seconds: 30), () {
      if (!_isCurrent(controller, generation) || _documentReady) return;
      developer.log(
        'Przekroczono 30 s oczekiwania na dokument; appReady=$_appReady.',
        name: 'storage.onlyoffice',
        level: 1000,
      );
      _viewState.value = _viewState.value.copyWith(
        initializationError: _appReady
            ? null
            : TimeoutException(
                'OnlyOffice nie zakończył ładowania w ciągu 30 sekund.',
              ),
        documentTimedOut: _appReady,
        isLoading: false,
      );
    });
    debugPrint('[storage.onlyoffice] Ładowanie dokumentu.');
    try {
      await controller.loadHtml(
        OnlyOfficeEditorHtmlBuilder.build(session),
        baseUrl: session.documentServerUrl,
      );
    } on Object catch (error) {
      if (!_isCurrent(controller, generation)) return;
      _loadTimeout?.cancel();
      developer.log(
        'Nie udało się załadować sesji.',
        name: 'storage.onlyoffice',
        level: 1000,
      );
      if (!mounted || generation != _generation) return;
      _viewState.value = _viewState.value.copyWith(
        initializationError: error,
        isLoading: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<StorageOnlyOfficeHostViewState>(
        valueListenable: _viewState,
        builder: (_, state, _) =>
            StorageOnlyOfficeHostSurface(state: state, onRetry: _initialize),
      );
}
