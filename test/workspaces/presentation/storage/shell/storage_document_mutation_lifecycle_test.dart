import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_context_row.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_listeners.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_shell_harness.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _Uploads extends Fake implements UploadTransport {}

final class _ShellOwners {
  _ShellOwners(StorageRepository repository, StorageScope scope)
    : browser = StorageBrowserCubit(
        repository: repository,
        initialScope: scope,
      ),
      document = StorageDocumentMutationCubit(repository: repository),
      folder = StorageFolderMutationCubit(repository: repository),
      preview = StoragePreviewCubit(repository: repository),
      upload = StorageUploadCubit(
        repository: repository,
        uploadTransport: _Uploads(),
      );

  final StorageBrowserCubit browser;
  final StorageDocumentMutationCubit document;
  final StorageFolderMutationCubit folder;
  final StoragePreviewCubit preview;
  final StorageUploadCubit upload;

  Future<void> close() async {
    await Future.wait([
      browser.close(),
      document.close(),
      folder.close(),
      preview.close(),
      upload.close(),
    ]);
  }
}

Widget _host({
  required ValueNotifier<_ShellOwners> owners,
  required ValueNotifier<StorageScope> scope,
  required ValueChanged<StorageMutationError> onError,
  Widget? child,
}) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  locale: const Locale('pl'),
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: ValueListenableBuilder<_ShellOwners>(
      valueListenable: owners,
      builder: (context, currentOwners, _) =>
          ValueListenableBuilder<StorageScope>(
            valueListenable: scope,
            builder: (context, currentScope, _) => MultiBlocProvider(
              providers: [
                BlocProvider<StorageBrowserCubit>.value(
                  value: currentOwners.browser,
                ),
                BlocProvider<StorageDocumentMutationCubit>.value(
                  value: currentOwners.document,
                ),
                BlocProvider<StorageFolderMutationCubit>.value(
                  value: currentOwners.folder,
                ),
                BlocProvider<StoragePreviewCubit>.value(
                  value: currentOwners.preview,
                ),
                BlocProvider<StorageUploadCubit>.value(
                  value: currentOwners.upload,
                ),
              ],
              child: StorageShellListeners(
                routedScope: currentScope,
                viewPreferenceStore: null,
                onMutationError: onError,
                onScopeChanged: (_) {},
                child: child ?? const Center(child: Text('Storage')),
              ),
            ),
          ),
    ),
  ),
);

void _stubBrowserReads(_Repository repository) {
  when(
    () => repository.listFolders(
      scope: any(named: 'scope'),
      parentFolderId: any(named: 'parentFolderId'),
    ),
  ).thenAnswer((_) async => right([]));
  when(
    () => repository.listFiles(
      scope: any(named: 'scope'),
      folderId: any(named: 'folderId'),
      cursor: any(named: 'cursor'),
      limit: any(named: 'limit'),
      filter: any(named: 'filter'),
      query: any(named: 'query'),
    ),
  ).thenAnswer(
    (_) async =>
        right(const CursorPageResponse<StorageFileResponse>(items: [])),
  );
}

void main() {
  setUpAll(() {
    registerStorageFallbacks();
    registerFallbackValue(StorageDocumentFormat.docx);
  });

  testWidgets('otwarty dialog odrzuca zapis po zmianie scope', (tester) async {
    final repository = _Repository();
    final replacementRepository = _Repository();
    _stubBrowserReads(repository);
    _stubBrowserReads(replacementRepository);
    var createCalls = 0;
    when(
      () => repository.createStorageDocument(
        scope: any(named: 'scope'),
        name: any(named: 'name'),
        format: any(named: 'format'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async {
      createCalls++;
      return right(storageTestFile());
    });
    const initialScope = StorageScope.personal();
    const changedScope = StorageScope.workspace('workspace-2');
    final owners = _ShellOwners(repository, initialScope);
    final currentOwners = ValueNotifier(owners);
    final currentScope = ValueNotifier<StorageScope>(initialScope);
    final errors = <StorageMutationError>[];
    addTearDown(() async {
      currentOwners.dispose();
      currentScope.dispose();
      await owners.close();
    });

    await tester.pumpWidget(
      _host(
        owners: currentOwners,
        scope: currentScope,
        onError: errors.add,
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => unawaited(
              runStorageChromeAction(
                context,
                StorageChromeAction.newDocument,
              ),
            ),
            child: const Text('Create document'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Create document'));
    await tester.pumpAndSettle();

    await owners.browser.setScope(changedScope);
    currentScope.value = changedScope;
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'stary-dokument');
    await tester.tap(find.text('Utwórz'));
    await tester.pumpAndSettle();

    expect(createCalls, 0);
    expect(errors, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dialog odrzuca zapis po podmianie providerów przed submit', (
    tester,
  ) async {
    final repository = _Repository();
    final replacementRepository = _Repository();
    _stubBrowserReads(repository);
    _stubBrowserReads(replacementRepository);
    var oldCalls = 0;
    var newCalls = 0;
    when(
      () => repository.createStorageDocument(
        scope: any(named: 'scope'),
        name: any(named: 'name'),
        format: any(named: 'format'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async {
      oldCalls++;
      return right(storageTestFile(id: 'old-provider'));
    });
    when(
      () => replacementRepository.createStorageDocument(
        scope: any(named: 'scope'),
        name: any(named: 'name'),
        format: any(named: 'format'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async {
      newCalls++;
      return right(storageTestFile(id: 'new-provider'));
    });
    const scope = StorageScope.personal();
    final oldOwners = _ShellOwners(repository, scope);
    final newOwners = _ShellOwners(replacementRepository, scope);
    final owners = ValueNotifier(oldOwners);
    final currentScope = ValueNotifier<StorageScope>(scope);
    final errors = <StorageMutationError>[];
    addTearDown(() async {
      owners.dispose();
      currentScope.dispose();
      await oldOwners.close();
      await newOwners.close();
    });
    await tester.pumpWidget(
      _host(
        owners: owners,
        scope: currentScope,
        onError: errors.add,
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => unawaited(
              runStorageChromeAction(
                context,
                StorageChromeAction.newDocument,
              ),
            ),
            child: const Text('Open dialog'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'stale');

    owners.value = newOwners;
    await tester.pumpAndSettle();
    await tester.tap(find.text('Utwórz'));
    await tester.pumpAndSettle();

    expect(oldCalls, 0);
    expect(newCalls, 0);
    expect(errors, isEmpty);
    expect(tester.takeException(), isNull);
  });

  for (final succeeds in [true, false]) {
    testWidgets(
      'spóźniony wynik create po zmianie scope jest ignorowany: $succeeds',
      (
        tester,
      ) async {
        final repository = _Repository();
        _stubBrowserReads(repository);
        final result = Completer<Either<ApiError, StorageFileResponse>>();
        var changedScopeReads = 0;
        when(
          () => repository.createStorageDocument(
            scope: any(named: 'scope'),
            name: any(named: 'name'),
            format: any(named: 'format'),
            idempotencyKey: any(named: 'idempotencyKey'),
          ),
        ).thenAnswer((_) => result.future);
        const initialScope = StorageScope.personal();
        const changedScope = StorageScope.workspace('workspace-2');
        when(
          () => repository.listFolders(
            scope: changedScope,
            parentFolderId: any(named: 'parentFolderId'),
          ),
        ).thenAnswer((_) async {
          changedScopeReads++;
          return right(const <StorageFolderResponse>[]);
        });
        final owners = _ShellOwners(repository, initialScope);
        final currentOwners = ValueNotifier(owners);
        final currentScope = ValueNotifier<StorageScope>(initialScope);
        final errors = <StorageMutationError>[];
        addTearDown(() async {
          currentOwners.dispose();
          currentScope.dispose();
          await owners.close();
        });
        await tester.pumpWidget(
          _host(
            owners: currentOwners,
            scope: currentScope,
            onError: errors.add,
          ),
        );

        final operation = owners.document.createDocument(
          scope: initialScope,
          name: 'stary-dokument',
          format: StorageDocumentFormat.docx,
        );
        await tester.pump();
        await owners.browser.setScope(changedScope);
        currentScope.value = changedScope;
        await tester.pumpAndSettle();
        final readsAtNewScope = changedScopeReads;

        result.complete(
          succeeds
              ? right(storageTestFile(id: 'created-in-old-scope'))
              : const Left(
                  ApiError(
                    type: ApiErrorType.conflict,
                    statusCode: 409,
                    message: 'Konflikt starego scope.',
                    apiCode: 'storage.document_conflict',
                  ),
                ),
        );
        await operation;
        await tester.pumpAndSettle();

        expect(errors, isEmpty);
        expect(find.byType(StoragePreviewDialog), findsNothing);
        expect(changedScopeReads, readsAtNewScope);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('stary retry nie uruchamia nowej operacji tego samego Cubita', (
    tester,
  ) async {
    final repository = _Repository();
    _stubBrowserReads(repository);
    final idempotencyKeys = <String>[];
    when(
      () => repository.createStorageDocument(
        scope: any(named: 'scope'),
        name: any(named: 'name'),
        format: any(named: 'format'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((invocation) async {
      idempotencyKeys.add(
        invocation.namedArguments[#idempotencyKey] as String,
      );
      return const Left(
        ApiError(
          type: ApiErrorType.conflict,
          statusCode: 409,
          message: 'Konflikt.',
          apiCode: 'storage.document_conflict',
        ),
      );
    });
    const scope = StorageScope.personal();
    final owners = _ShellOwners(repository, scope);
    final currentOwners = ValueNotifier(owners);
    final currentScope = ValueNotifier<StorageScope>(scope);
    final errors = <StorageMutationError>[];
    addTearDown(() async {
      currentOwners.dispose();
      currentScope.dispose();
      await owners.close();
    });
    await tester.pumpWidget(
      _host(
        owners: currentOwners,
        scope: currentScope,
        onError: errors.add,
      ),
    );

    await owners.document.createDocument(
      scope: scope,
      name: 'pierwszy',
      format: StorageDocumentFormat.docx,
    );
    await tester.pump();
    final staleRetry = errors.single.onRetry!;
    await owners.document.createDocument(
      scope: scope,
      name: 'drugi',
      format: StorageDocumentFormat.docx,
    );
    await tester.pump();
    expect(idempotencyKeys, hasLength(2));

    staleRetry();
    await tester.pumpAndSettle();
    expect(idempotencyKeys, hasLength(2));
    expect(errors.last.onRetry, isNotNull);

    errors.last.onRetry!();
    await tester.pumpAndSettle();
    expect(idempotencyKeys, hasLength(3));
    expect(idempotencyKeys[1], idempotencyKeys[2]);
  });

  testWidgets('wynik starego providera nie trafia do nowych providerów', (
    tester,
  ) async {
    final repository = _Repository();
    _stubBrowserReads(repository);
    final result = Completer<Either<ApiError, StorageFileResponse>>();
    when(
      () => repository.createStorageDocument(
        scope: any(named: 'scope'),
        name: any(named: 'name'),
        format: any(named: 'format'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) => result.future);
    const scope = StorageScope.personal();
    final oldOwners = _ShellOwners(repository, scope);
    final newOwners = _ShellOwners(repository, scope);
    final currentOwners = ValueNotifier(oldOwners);
    final currentScope = ValueNotifier<StorageScope>(scope);
    final errors = <StorageMutationError>[];
    var oldClosed = false;
    addTearDown(() async {
      currentOwners.dispose();
      currentScope.dispose();
      if (!oldClosed) await oldOwners.close();
      await newOwners.close();
    });
    await tester.pumpWidget(
      _host(owners: currentOwners, scope: currentScope, onError: errors.add),
    );
    final operation = oldOwners.document.createDocument(
      scope: scope,
      name: 'stary-dokument',
      format: StorageDocumentFormat.docx,
    );
    await tester.pump();

    currentOwners.value = newOwners;
    await tester.pump();
    await oldOwners.close();
    oldClosed = true;
    result.complete(right(storageTestFile(id: 'old-provider-file')));
    await operation;
    await tester.pumpAndSettle();

    expect(errors, isEmpty);
    expect(find.byType(StoragePreviewDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test(
    'busy create odrzuca duplikat, a retry po sukcesie nie wysyła POST',
    () async {
      final repository = _Repository();
      final result = Completer<Either<ApiError, StorageFileResponse>>();
      var calls = 0;
      when(
        () => repository.createStorageDocument(
          scope: any(named: 'scope'),
          name: any(named: 'name'),
          format: any(named: 'format'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) {
        calls++;
        return result.future;
      });
      final cubit = StorageDocumentMutationCubit(repository: repository);
      addTearDown(cubit.close);
      const scope = StorageScope.personal();
      final first = cubit.createDocument(
        scope: scope,
        name: 'dokument',
        format: StorageDocumentFormat.docx,
      );
      await cubit.createDocument(
        scope: scope,
        name: 'inny',
        format: StorageDocumentFormat.docx,
      );
      expect(calls, 1);
      final operationId = cubit.state.operationId!;
      result.complete(right(storageTestFile()));
      await first;
      await cubit.retry(operationId: operationId);
      expect(calls, 1);
      expect(cubit.state, isA<StorageDocumentMutationSuccess>());
    },
  );

  test('Retry-After blokuje create i retry bez dodatkowego POST', () async {
    final repository = _Repository();
    var calls = 0;
    when(
      () => repository.createStorageDocument(
        scope: any(named: 'scope'),
        name: any(named: 'name'),
        format: any(named: 'format'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async {
      calls++;
      return Left(
        ApiError(
          type: ApiErrorType.badResponse,
          statusCode: 429,
          message: 'Za dużo żądań',
          apiCode: 'storage.rate_limited',
          retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 1)),
        ),
      );
    });
    final cubit = StorageDocumentMutationCubit(repository: repository);
    addTearDown(cubit.close);
    const scope = StorageScope.personal();
    await cubit.createDocument(
      scope: scope,
      name: 'dokument',
      format: StorageDocumentFormat.docx,
    );
    final operationId = cubit.state.operationId!;

    await cubit.retry(operationId: operationId);
    await cubit.createDocument(
      scope: scope,
      name: 'kolejny dokument',
      format: StorageDocumentFormat.docx,
    );

    expect(calls, 1);
    expect(cubit.state, isA<StorageDocumentMutationFailure>());
  });
}
