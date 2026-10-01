import 'dart:async';
import 'dart:convert';

import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'late old initialization failure cannot overwrite the active host',
    (tester) async {
      final pending = Completer<void>();
      final old = _FakeStorageOnlyOfficeController(initialization: pending);
      final next = _FakeStorageOnlyOfficeController();
      final factory = ValueNotifier<StorageOnlyOfficeControllerFactory>(
        _FakeControllerFactory(old),
      );
      addTearDown(factory.dispose);
      await tester.pumpWidget(
        _Harness(
          child: ValueListenableBuilder<StorageOnlyOfficeControllerFactory>(
            valueListenable: factory,
            builder: (_, value, _) => StorageOnlyOfficeHost(
              session: _Fixtures.session,
              controllerFactory: value,
            ),
          ),
        ),
      );
      await tester.pump();
      factory.value = _FakeControllerFactory(next);
      await tester.pump();
      expect(old.disposeCount, 1);
      next.finishPage();
      await tester.pump();
      pending.completeError(StateError('stale initialization failure'));
      await tester.pump();
      expect(find.textContaining('stale initialization failure'), findsNothing);
      expect(find.text('Ładowanie edytora OnlyOffice…'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      expect(next.disposeCount, 1);
    },
  );

  testWidgets('late old load failure cannot cancel the new host timeout', (
    tester,
  ) async {
    final pending = Completer<void>();
    final old = _FakeStorageOnlyOfficeController(loading: pending);
    final next = _FakeStorageOnlyOfficeController();
    final factory = ValueNotifier<StorageOnlyOfficeControllerFactory>(
      _FakeControllerFactory(old),
    );
    addTearDown(factory.dispose);
    await tester.pumpWidget(
      _Harness(
        child: ValueListenableBuilder<StorageOnlyOfficeControllerFactory>(
          valueListenable: factory,
          builder: (_, value, _) => StorageOnlyOfficeHost(
            session: _Fixtures.session,
            controllerFactory: value,
          ),
        ),
      ),
    );
    await tester.pump();
    factory.value = _FakeControllerFactory(next);
    await tester.pump();
    await tester.pump();
    pending.completeError(StateError('stale load failure'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 30));
    expect(find.textContaining('30 sekund'), findsOneWidget);
    expect(find.textContaining('stale load failure'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'replaced Office host ignores every callback from the previous controller',
    (tester) async {
      final old = _FakeStorageOnlyOfficeController();
      final next = _FakeStorageOnlyOfficeController();
      var events = 0;
      final value = ValueNotifier<StorageOnlyOfficeControllerFactory>(
        _FakeControllerFactory(old),
      );
      addTearDown(value.dispose);
      await tester.pumpWidget(
        _Harness(
          child: ValueListenableBuilder<StorageOnlyOfficeControllerFactory>(
            valueListenable: value,
            builder: (_, factory, _) => StorageOnlyOfficeHost(
              session: _Fixtures.session,
              controllerFactory: factory,
              onDocumentReady: () => events++,
              onDocumentStateChanged: (_) => events++,
              onPrintRequested: () => events++,
              onDownloadRequested: (_) => events++,
              onSaveAsRequested: (_) => events++,
            ),
          ),
        ),
      );
      await tester.pump();
      value.value = _FakeControllerFactory(next);
      await tester.pump();
      await tester.pump();
      old.emitDocumentReady();
      old.emitDocumentStateChanged(isModified: true);
      old.emitPrint();
      old.emitDownload((
        url: 'https://office.example/stale.pdf',
        fileType: 'pdf',
      ));
      old.emitSaveAs((
        url: 'https://office.example/stale.docx',
        fileType: 'docx',
        title: 'stale',
      ));
      expect(events, 0);
      next.emitDocumentReady();
      expect(events, 1);
    },
  );

  testWidgets('disposed Office host ignores editor callback', (tester) async {
    final controller = _FakeStorageOnlyOfficeController();
    var ready = 0;
    await tester.pumpWidget(
      _Harness(
        child: StorageOnlyOfficeHost(
          session: _Fixtures.session,
          controllerFactory: _FakeControllerFactory(controller),
          onDocumentReady: () => ready++,
        ),
      ),
    );
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    controller.emitDocumentReady();
    expect(ready, 0);
  });

  testWidgets('pokazuje loading, błąd głównej ramki i ponawia ładowanie', (
    tester,
  ) async {
    final controller = _FakeStorageOnlyOfficeController();

    await tester.pumpWidget(
      _Harness(
        child: StorageOnlyOfficeHost(
          session: _Fixtures.session,
          controllerFactory: _FakeControllerFactory(controller),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Ładowanie edytora OnlyOffice…'), findsOneWidget);
    expect(
      find.byKey(_FakeStorageOnlyOfficeController.surfaceKey),
      findsOneWidget,
    );
    expect(controller.loadCount, 1);
    expect(controller.lastBaseUrl, _Fixtures.session.documentServerUrl);
    expect(controller.lastHtml, contains('new DocsAPI.DocEditor'));

    controller.finishPage();
    await tester.pump();
    expect(find.text('Ładowanie edytora OnlyOffice…'), findsNothing);

    controller.failMainFrame('Serwer dokumentów jest niedostępny');
    await tester.pump();
    expect(
      find.text('Nie udało się załadować osadzonego edytora OnlyOffice.'),
      findsOneWidget,
    );
    expect(find.text('Serwer dokumentów jest niedostępny'), findsOneWidget);

    await tester.tap(find.text('Ponów próbę'));
    await tester.pump();

    expect(controller.loadCount, 2);
    expect(find.text('Ładowanie edytora OnlyOffice…'), findsOneWidget);

    controller.finishPage();
    await tester.pump();
    expect(find.text('Ładowanie edytora OnlyOffice…'), findsNothing);
    expect(
      find.byKey(_FakeStorageOnlyOfficeController.surfaceKey),
      findsOneWidget,
    );
  });

  testWidgets('kończenie hosta niszczy DocsAPI i inicjuje zapis sesji', (
    tester,
  ) async {
    final controller = _FakeStorageOnlyOfficeController();
    final hostController = StorageOnlyOfficeHostController();
    await tester.pumpWidget(
      _Harness(
        child: StorageOnlyOfficeHost(
          session: _Fixtures.session,
          controllerFactory: _FakeControllerFactory(controller),
          hostController: hostController,
        ),
      ),
    );
    await tester.pump();

    await hostController.closeEditor();

    expect(controller.lastScript, contains('destroyEditor'));
  });

  testWidgets('kończy nieskończony spinner komunikatem po 30 sekundach', (
    tester,
  ) async {
    final controller = _FakeStorageOnlyOfficeController();
    await tester.pumpWidget(
      _Harness(
        child: StorageOnlyOfficeHost(
          session: _Fixtures.session,
          controllerFactory: _FakeControllerFactory(controller),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 30));

    expect(find.textContaining('30 sekund'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('requestExport z formatem wywołuje downloadAs z parametrem', (
    tester,
  ) async {
    final controller = _FakeStorageOnlyOfficeController();
    final hostController = StorageOnlyOfficeHostController();
    await tester.pumpWidget(
      _Harness(
        child: StorageOnlyOfficeHost(
          session: _Fixtures.session,
          controllerFactory: _FakeControllerFactory(controller),
          hostController: hostController,
        ),
      ),
    );
    await tester.pump();
    controller.finishPage();
    await tester.pump();

    final exportFuture = hostController.requestExport(format: 'pdf');
    expect(controller.lastScript, 'window.storageEditor.downloadAs("pdf");');

    const expectedDownload = (
      url: 'https://office.example/cache/doc.pdf',
      fileType: 'pdf',
    );
    controller.emitDownload(expectedDownload);

    final result = await exportFuture;
    expect(result, expectedDownload);
  });

  testWidgets('zdarzenie onPrintRequested jest przekazywane z kontrolera', (
    tester,
  ) async {
    final controller = _FakeStorageOnlyOfficeController();
    var printCalled = false;
    await tester.pumpWidget(
      _Harness(
        child: StorageOnlyOfficeHost(
          session: _Fixtures.session,
          controllerFactory: _FakeControllerFactory(controller),
          onPrintRequested: () => printCalled = true,
        ),
      ),
    );
    await tester.pump();
    controller.finishPage();
    await tester.pump();

    controller.emitPrint();
    expect(printCalled, isTrue);
  });

  testWidgets('zdarzenie onSaveAsRequested jest przekazywane z kontrolera', (
    tester,
  ) async {
    final controller = _FakeStorageOnlyOfficeController();
    OnlyOfficeSaveAs? received;

    await tester.pumpWidget(
      _Harness(
        child: StorageOnlyOfficeHost(
          session: _Fixtures.session,
          controllerFactory: _FakeControllerFactory(controller),
          onSaveAsRequested: (saveAs) => received = saveAs,
        ),
      ),
    );
    await tester.pump();

    controller.emitSaveAs((
      url: 'https://office.example/cache/copy.docx',
      fileType: 'docx',
      title: 'Raport (kopia).docx',
    ));
    expect(received?.url, 'https://office.example/cache/copy.docx');
    expect(received?.fileType, 'docx');
    expect(received?.title, 'Raport (kopia).docx');
  });
}

final class _Harness extends StatelessWidget {
  const _Harness({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pl'),
      home: Scaffold(body: child),
    );
  }
}

final class _FakeControllerFactory
    implements StorageOnlyOfficeControllerFactory {
  const _FakeControllerFactory(this.controller);

  final StorageOnlyOfficeController controller;

  @override
  StorageOnlyOfficeController create() => controller;
}

final class _FakeStorageOnlyOfficeController
    implements StorageOnlyOfficeController {
  _FakeStorageOnlyOfficeController({this.initialization, this.loading});
  @override
  void dispose() => disposeCount++;
  int disposeCount = 0;
  final Completer<void>? initialization;
  final Completer<void>? loading;
  static const surfaceKey = Key('fake-onlyoffice-surface');

  VoidCallback? _onPageFinished;
  ValueChanged<String>? _onMainFrameError;
  ValueChanged<OnlyOfficeDownload>? _onDownloadRequested;
  ValueChanged<OnlyOfficeSaveAs>? _onSaveAsRequested;
  VoidCallback? _onPrintRequested;
  int loadCount = 0;
  VoidCallback? _onDocumentReady;
  ValueChanged<bool>? _onDocumentStateChanged;
  String? lastHtml;
  String? lastBaseUrl;
  String? lastScript;

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
    _onDownloadRequested = onDownloadRequested;
    _onSaveAsRequested = onSaveAsRequested;
    _onPrintRequested = onPrintRequested;
    _onPageFinished = onPageFinished;
    _onMainFrameError = onMainFrameError;
    _onDocumentReady = onDocumentReady;
    _onDocumentStateChanged = onDocumentStateChanged;
    if (initialization != null) await initialization!.future;
  }

  /// Zgłasza gotowość dokumentu tak, jak robi to osadzony edytor.
  void emitDocumentReady() => _onDocumentReady?.call();

  /// Zgłasza stan dokumentu tak, jak robi to osadzony edytor.
  void emitDocumentStateChanged({required bool isModified}) =>
      _onDocumentStateChanged?.call(isModified);

  @override
  Future<void> loadHtml(String html, {required String baseUrl}) async {
    loadCount += 1;
    lastHtml = html;
    lastBaseUrl = baseUrl;
    if (loading != null) await loading!.future;
  }

  @override
  Future<void> runJavaScript(String script) async => lastScript = script;

  void emitDownload(OnlyOfficeDownload download) =>
      _onDownloadRequested?.call(download);

  void emitSaveAs(OnlyOfficeSaveAs saveAs) => _onSaveAsRequested?.call(saveAs);

  void emitPrint() => _onPrintRequested?.call();

  @override
  Widget buildWidget() => const ColoredBox(
    key: surfaceKey,
    color: Colors.transparent,
  );

  void finishPage() => _onPageFinished?.call();

  void failMainFrame(String description) =>
      _onMainFrameError?.call(description);
}

final class _Fixtures {
  const _Fixtures._();

  static final session = OnlyOfficeSessionResponse(
    fileId: 'file-1',
    documentType: 'word',
    documentServerUrl: 'https://office.example/',
    documentKey: 'key-1',
    token: 'header.${_payload()}.signature',
    canEdit: true,
  );

  static String _payload() => base64Url
      .encode(
        utf8.encode(
          jsonEncode({
            'documentType': 'word',
            'document': {
              'key': 'key-1',
              'url': 'https://storage.example/file-1',
            },
            'editorConfig': {'mode': 'edit'},
          }),
        ),
      )
      .replaceAll('=', '');
}
