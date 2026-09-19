import 'dart:convert';

import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
  static const surfaceKey = Key('fake-onlyoffice-surface');

  VoidCallback? _onPageFinished;
  ValueChanged<String>? _onMainFrameError;
  ValueChanged<OnlyOfficeDownload>? _onDownloadRequested;
  ValueChanged<OnlyOfficeSaveAs>? _onSaveAsRequested;
  VoidCallback? _onPrintRequested;
  int loadCount = 0;
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
  }) async {
    _onDownloadRequested = onDownloadRequested;
    _onSaveAsRequested = onSaveAsRequested;
    _onPrintRequested = onPrintRequested;
    _onPageFinished = onPageFinished;
    _onMainFrameError = onMainFrameError;
  }

  @override
  Future<void> loadHtml(String html, {required String baseUrl}) async {
    loadCount += 1;
    lastHtml = html;
    lastBaseUrl = baseUrl;
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
