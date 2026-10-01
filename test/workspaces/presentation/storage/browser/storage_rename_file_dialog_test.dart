import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_rename_file_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _DownloadTransport extends Mock implements DownloadTransport {}

final class _RenameApp extends StatefulWidget {
  const _RenameApp({
    required this.repository,
    this.locale = const Locale('pl'),
    this.dark = false,
    this.scale = 1,
    super.key,
  });

  final StorageRepository repository;
  final Locale locale;
  final bool dark;
  final double scale;

  @override
  State<_RenameApp> createState() => _RenameAppState();
}

final class _RenameAppState extends State<_RenameApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final StorageFileMutationCubit _first = _newMutation();
  late final StorageFileMutationCubit _replacement = _newMutation();
  bool _useReplacement = false;

  StorageFileMutationCubit _newMutation() => StorageFileMutationCubit(
    repository: widget.repository,
    downloadTransport: _DownloadTransport(),
  );

  StorageFileMutationCubit get _active =>
      _useReplacement ? _replacement : _first;

  StorageFileMutationCubit get mutation => _active;

  void replaceMutationOwner() => setState(() => _useReplacement = true);

  void replaceTopRoute() {
    _navigatorKey.currentState!.pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Replacement route')),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_first.close());
    unawaited(_replacement.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _active,
    child: MaterialApp(
      navigatorKey: _navigatorKey,
      theme: widget.dark
          ? MaterialTheme.crm().dark()
          : MaterialTheme.crm().light(),
      locale: widget.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(widget.scale),
        ),
        child: child!,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: Column(
            children: [
              TextButton(
                key: const ValueKey('replace_rename_owner'),
                onPressed: replaceMutationOwner,
                child: const Text('Replace owner'),
              ),
              TextButton(
                key: const ValueKey('open_rename_dialog'),
                onPressed: () => unawaited(
                  StorageRenameFileDialog.show(context, _file),
                ),
                child: const Text('Rename file'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  static final _file = StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'plan.txt',
    extension: '.txt',
    mimeType: 'text/plain',
    fileSizeBytes: 12,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: DateTime.utc(2026, 10),
    updatedAtUtc: DateTime.utc(2026, 10),
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    canEdit: true,
    concurrencyToken: 'file-v1',
  );
}

void main() {
  final linux = TargetPlatformVariant.only(TargetPlatform.linux);

  testWidgets(
    'pusty rdzeń nazwy pokazuje błąd inline i nie wywołuje API',
    (tester) async {
      final repository = _Repository();
      await _pumpApp(tester, repository);
      await _openDialog(tester);
      await tester.enterText(
        find.byKey(const ValueKey('storage_rename_file_name')),
        '   ',
      );
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      final l10n = await AppLocalizations.delegate.load(const Locale('pl'));
      expect(find.text(l10n.workspacesNameRequiredError), findsOneWidget);
      verifyNever(
        () => repository.renameFile(
          fileId: 'file-1',
          fileName: any(named: 'fileName'),
          expectedConcurrencyToken: 'file-v1',
        ),
      );
    },
    variant: linux,
  );

  testWidgets(
    '409 zachowuje szkic i pokazuje pełne metadane w PL/light',
    (tester) async => _runConflictScenario(
      tester,
      locale: const Locale('pl'),
      dark: false,
      scale: 2,
    ),
    variant: linux,
  );

  testWidgets(
    '409 zachowuje szkic i pokazuje pełne metadane w EN/dark przy 200%',
    (tester) async => _runConflictScenario(
      tester,
      locale: const Locale('en'),
      dark: true,
      scale: 2,
    ),
    variant: linux,
  );

  testWidgets(
    'zmiana właściciela przed zapisem zamyka dialog bez REST',
    (tester) async {
      final repository = _Repository();
      final key = GlobalKey<_RenameAppState>();
      await _pumpApp(tester, repository, key: key);
      await _openDialog(tester);
      await tester.enterText(
        find.byKey(const ValueKey('storage_rename_file_name')),
        'Nowy plan',
      );
      await tester.pump();
      key.currentState!.replaceMutationOwner();
      await tester.pumpAndSettle();
      final save = find.byKey(const ValueKey('storage_rename_file_save'));
      expect(save, findsOneWidget);
      await tester.tap(save);
      await tester.pumpAndSettle();

      expect(find.text('Zmień nazwę pliku'), findsNothing);
      verifyNever(
        () => repository.renameFile(
          fileId: 'file-1',
          fileName: any(named: 'fileName'),
          expectedConcurrencyToken: 'file-v1',
        ),
      );
    },
    variant: linux,
  );

  testWidgets(
    'Retry-After blokuje zapis do deadline i nie uruchamia automatycznego REST',
    (tester) async {
      final repository = _Repository();
      final retryAfter = DateTime.now().toUtc().add(const Duration(seconds: 3));
      when(
        () => repository.renameFile(
          fileId: 'file-1',
          fileName: 'Oczekujący.txt',
          expectedConcurrencyToken: 'file-v1',
        ),
      ).thenAnswer(
        (_) async => Left(
          ApiError(
            type: ApiErrorType.badResponse,
            message: 'Zbyt wiele żądań. Spróbuj później.',
            statusCode: 429,
            apiCode: 'storage.rate_limited',
            retryAfterUtc: retryAfter,
          ),
        ),
      );
      final key = GlobalKey<_RenameAppState>();
      await _pumpApp(tester, repository, key: key);
      await _openDialog(tester);
      await tester.enterText(
        find.byKey(const ValueKey('storage_rename_file_name')),
        'Oczekujący',
      );
      await tester.pump();
      final save = find.byKey(const ValueKey('storage_rename_file_save'));
      expect(key.currentState!.mutation.canMutate, isTrue);
      expect(tester.widget<FilledButton>(save).onPressed, isNotNull);
      await tester.tap(save);
      await tester.pumpAndSettle();

      verify(
        () => repository.renameFile(
          fileId: 'file-1',
          fileName: 'Oczekujący.txt',
          expectedConcurrencyToken: 'file-v1',
        ),
      ).called(1);
      expect(key.currentState!.mutation.canMutate, isFalse);
      expect(save.hitTestable(), findsOneWidget);
      expect(tester.widget<FilledButton>(save).onPressed, isNull);
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(seconds: 4)),
      );
      await tester.pump(const Duration(seconds: 4));

      expect(key.currentState!.mutation.canMutate, isTrue);
      expect(tester.widget<FilledButton>(save).onPressed, isNotNull);
    },
    variant: linux,
  );

  testWidgets(
    'spóźniona odpowiedź po zamknięciu właściciela nie używa starego kontekstu',
    (tester) async {
      final repository = _Repository();
      final response = Completer<Either<ApiError, StorageFileResponse>>();
      when(
        () => repository.renameFile(
          fileId: 'file-1',
          fileName: 'Zamknięty.txt',
          expectedConcurrencyToken: 'file-v1',
        ),
      ).thenAnswer((_) => response.future);
      await _pumpApp(tester, repository);
      await _openDialog(tester);
      await tester.enterText(
        find.byKey(const ValueKey('storage_rename_file_name')),
        'Zamknięty',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('storage_rename_file_save')));
      await tester.pump();
      verify(
        () => repository.renameFile(
          fileId: 'file-1',
          fileName: 'Zamknięty.txt',
          expectedConcurrencyToken: 'file-v1',
        ),
      ).called(1);

      await tester.pumpWidget(const SizedBox.shrink());
      response.complete(Right(_RenameAppState._file));
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
    variant: linux,
  );

  testWidgets(
    'spóźniony sukces podczas reverse transition nie zamyka nowej trasy',
    (tester) async {
      final repository = _Repository();
      final appKey = GlobalKey<_RenameAppState>();
      final response = Completer<Either<ApiError, StorageFileResponse>>();
      when(
        () => repository.renameFile(
          fileId: 'file-1',
          fileName: 'Po zmianie.txt',
          expectedConcurrencyToken: 'file-v1',
        ),
      ).thenAnswer((_) => response.future);
      await _pumpApp(tester, repository, key: appKey);
      await _openDialog(tester);
      await tester.enterText(
        find.byKey(const ValueKey('storage_rename_file_name')),
        'Po zmianie',
      );
      await tester.tap(find.byKey(const ValueKey('storage_rename_file_save')));
      await tester.pump();

      appKey.currentState!.replaceTopRoute();
      await tester.pump();
      response.complete(Right(_RenameAppState._file));
      await tester.pump();
      expect(find.text('Replacement route'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      expect(find.text('Replacement route'), findsOneWidget);
    },
    variant: linux,
  );
}

Future<void> _pumpApp(
  WidgetTester tester,
  StorageRepository repository, {
  GlobalKey<_RenameAppState>? key,
  Locale locale = const Locale('pl'),
  bool dark = false,
  double scale = 1,
}) async {
  tester.view.physicalSize = const Size(420, 600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    _RenameApp(
      repository: repository,
      locale: locale,
      dark: dark,
      scale: scale,
      key: key,
    ),
  );
}

Future<void> _openDialog(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('open_rename_dialog')));
  await tester.pumpAndSettle();
  expect(
    find.byKey(const ValueKey('storage_rename_file_name')),
    findsOneWidget,
  );
}

Future<void> _runConflictScenario(
  WidgetTester tester, {
  required Locale locale,
  required bool dark,
  double scale = 1,
}) async {
  final repository = _Repository();
  const error = ApiError(
    type: ApiErrorType.conflict,
    message:
        'Nazwa pliku została zmieniona w innym miejscu.\nSpróbuj ponownie.',
    statusCode: 409,
    apiCode: 'storage.file_conflict',
    contractCode: 'storage.file_version_conflict',
    backendCode: 73,
    fields: {
      'fileName': ['Nazwa zajęta'],
    },
    traceId: 'rename-409-trace',
  );
  when(
    () => repository.renameFile(
      fileId: 'file-1',
      fileName: 'Nowy plan.txt',
      expectedConcurrencyToken: 'file-v1',
    ),
  ).thenAnswer((_) async => const Left(error));
  final key = GlobalKey<_RenameAppState>();
  await _pumpApp(
    tester,
    repository,
    key: key,
    locale: locale,
    dark: dark,
    scale: scale,
  );
  await _openDialog(tester);
  final field = find.byKey(const ValueKey('storage_rename_file_name'));
  await tester.enterText(field, 'Nowy plan');
  await tester.pump();
  final save = find.byKey(const ValueKey('storage_rename_file_save'));
  expect(tester.widget<TextField>(field).controller!.text, 'Nowy plan');
  expect(key.currentState!.mutation.canMutate, isTrue);
  expect(tester.widget<FilledButton>(save).onPressed, isNotNull);
  await tester.ensureVisible(save);
  expect(save.hitTestable(), findsOneWidget);
  await tester.tap(save);
  await tester.pumpAndSettle();

  expect(find.text('Nowy plan'), findsOneWidget);
  expect(find.textContaining('Nazwa pliku została zmieniona'), findsOneWidget);
  final diagnostics = tester
      .widgetList<SelectableText>(find.byType(SelectableText))
      .map((widget) => widget.data ?? '')
      .join('\n');
  expect(diagnostics, contains('storage.file_conflict'));
  expect(diagnostics, contains('storage.file_version_conflict'));
  expect(diagnostics, contains('rename-409-trace'));
  verify(
    () => repository.renameFile(
      fileId: 'file-1',
      fileName: 'Nowy plan.txt',
      expectedConcurrencyToken: 'file-v1',
    ),
  ).called(1);
}
