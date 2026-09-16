import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:ready_next/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:ready_next/workspaces/data/storage/transport/onlyoffice_editor_html_builder.dart';
import 'package:webview_all/webview_all.dart';

part 'storage_onlyoffice_controller.dart';

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

  @override
  State<StorageOnlyOfficeHost> createState() => _StorageOnlyOfficeHostState();
}

class _StorageOnlyOfficeHostState extends State<StorageOnlyOfficeHost> {
  StorageOnlyOfficeController? _controller;
  Object? _initializationError;
  bool _isLoading = true;
  Timer? _loadTimeout;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  @override
  void didUpdateWidget(StorageOnlyOfficeHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controllerFactory != widget.controllerFactory) {
      unawaited(_initialize());
    } else if (oldWidget.session != widget.session) {
      unawaited(_loadSession());
    }
  }

  Future<void> _initialize() async {
    developer.log('Inicjalizacja WebView.', name: 'storage.onlyoffice');
    try {
      final controller = widget.controllerFactory.create();
      widget.hostController?._attach(controller);
      await controller
          .initialize(
            onCloseRequested: () {
              widget.hostController?._approveClose();
              widget.onCloseRequested?.call();
            },
            onPrintRequested: widget.onPrintRequested,
            onSaveAsRequested: (saveAs) {
              developer.log(
                'OnlyOffice przekazał plik do zapisu kopii w Storage.',
                name: 'storage.onlyoffice',
              );
              widget.onSaveAsRequested?.call(saveAs);
            },
            onDownloadRequested: (url) {
              widget.hostController?._downloadReceived(url);
              developer.log(
                'OnlyOffice przekazał plik do pobrania.',
                name: 'storage.onlyoffice',
              );
              widget.onDownloadRequested?.call(url);
            },
            onPageFinished: () {
              if (mounted && identical(_controller, controller)) {
                widget.hostController?._documentReady = true;
                _loadTimeout?.cancel();
                developer.log(
                  'Dokument zakończył ładowanie.',
                  name: 'storage.onlyoffice',
                );
                setState(() => _isLoading = false);
              }
            },
            onMainFrameError: (description) {
              if (mounted && identical(_controller, controller)) {
                _loadTimeout?.cancel();
                developer.log(
                  'Błąd głównej ramki: $description',
                  name: 'storage.onlyoffice',
                  level: 1000,
                );
                setState(() {
                  _initializationError = description;
                  _isLoading = false;
                });
              }
            },
          )
          .timeout(const Duration(seconds: 30));
      if (!mounted) return;
      setState(() => _controller = controller);
      await _loadSession();
    } on Object catch (error) {
      developer.log(
        'Nie udało się zainicjalizować WebView.',
        name: 'storage.onlyoffice',
        error: error,
        level: 1000,
      );
      if (!mounted) return;
      setState(() {
        _initializationError = error;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _loadTimeout?.cancel();
    widget.hostController?._detach(_controller);
    super.dispose();
  }

  Future<void> _loadSession() async {
    final controller = _controller;
    if (controller == null) return;
    widget.hostController?._documentReady = false;
    if (mounted) {
      setState(() {
        _initializationError = null;
        _isLoading = true;
      });
    }
    _loadTimeout?.cancel();
    _loadTimeout = Timer(const Duration(seconds: 30), () {
      if (!mounted || !_isLoading) return;
      developer.log(
        'Przekroczono 30 s oczekiwania na dokument.',
        name: 'storage.onlyoffice',
        level: 1000,
      );
      setState(() {
        _initializationError = TimeoutException(
          'OnlyOffice nie zakończył ładowania w ciągu 30 sekund.',
        );
        _isLoading = false;
      });
    });
    debugPrint('[storage.onlyoffice] Ładowanie dokumentu.');
    try {
      await controller.loadHtml(
        OnlyOfficeEditorHtmlBuilder.build(widget.session),
        baseUrl: widget.session.documentServerUrl,
      );
    } on Object catch (error) {
      _loadTimeout?.cancel();
      developer.log(
        'Nie udało się załadować sesji.',
        name: 'storage.onlyoffice',
        error: error,
        level: 1000,
      );
      if (!mounted) return;
      setState(() {
        _initializationError = error;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationError case final error?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.alertCircle, size: 48, color: context.colors.error),
              const SizedBox(height: 12),
              Text(
                context.l10n.storageOfficeHostFailure,
                style: context.text.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SelectableText(error.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadSession,
                icon: const Icon(AppIcons.refresh, size: 16),
                label: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final controller = _controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (controller != null) controller.buildWidget(),
        if (_isLoading)
          ColoredBox(
            color: context.colors.surface,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(height: 12),
                  Text(context.l10n.storageOfficeHostLoading),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
