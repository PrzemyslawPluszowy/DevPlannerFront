import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_delete_confirmation.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_feedback_host.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_browser_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_shell_harness.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _MockUploadTransport extends Mock implements UploadTransport {}

class _MockDownloadTransport extends Mock implements DownloadTransport {}

/// Liczba odczytów listy folderów.
///
/// Licznik jest w atrapie, a nie w `verify(...).captured`, bo weryfikacja
/// konsumuje dopasowane wywołania i drugi odczyt pokazywałby zero.
int folderReadCount = 0;

final input = StorageUploadInput(
  name: 'raport.txt',
  size: 4,
  bytes: Uint8List.fromList([1, 2, 3, 4]),
  mimeType: 'text/plain',
);

final ticket = StorageUploadTicketResponse(
  fileId: 'file-new',
  storageObjectKey: 'workspace/file-new',
  uploadUrl: 'https://storage.invalid/upload/file-new',
  expiresAtUtc: DateTime.utc(2026, 9, 20, 13),
  isAlreadyUploaded: false,
);

/// Pole tekstowe dialogu, a nie pole wyszukiwania w chrome.
Finder _dialogField() => find.descendant(
  of: find.byType(AlertDialog),
  matching: find.byType(TextField),
);

void main() {
  late _MockStorageRepository repository;
  late AppLocalizations l10n;

  setUpAll(() {
    registerStorageFallbacks();
    registerFallbackValue(UploadCancellationToken());
    registerFallbackValue(input);
    registerFallbackValue(
      StorageUploadTicketResponse(
        fileId: 'fallback-file',
        storageObjectKey: 'fallback',
        uploadUrl: 'https://storage.invalid/fallback',
        expiresAtUtc: DateTime.utc(2026, 9, 20),
        isAlreadyUploaded: false,
      ),
    );
    registerFallbackValue(
      const CreateStorageFileSharePayload(
        shareType: StorageShareType.workspace,
        accessLevel: StorageShareAccessLevel.reader,
      ),
    );
    registerFallbackValue(
      const StorageUploadTicketPayload(
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.document,
        fileName: 'fallback.txt',
        fileSizeBytes: 1,
      ),
    );
  });

  setUp(() async {
    repository = _MockStorageRepository();
    when(repository.listTrashFolders)
        .thenAnswer((_) async => right(<StorageFolderResponse>[]));
    l10n = await AppLocalizations.delegate.load(const Locale('pl'));
    folderReadCount = 0;
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async {
      folderReadCount++;
      return right([storageTestFolder()]);
    });
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        CursorPageResponse<StorageFileResponse>(items: [storageTestFile()]),
      ),
    );
  });

  testWidgets('utworzenie folderu odświeża listę dokładnie raz', (
    tester,
  ) async {
    when(
      () => repository.createFolder(
        scope: any(named: 'scope'),
        name: any(named: 'name'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(storageTestFolder(id: 'folder-2')));
    await pumpStorageShell(tester, repository: repository);

    await tester.tap(find.byKey(const ValueKey('storage_create_menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.storageNewFolder));
    await tester.pumpAndSettle();
    await tester.enterText(_dialogField(), 'Dokumenty');
    await tester.tap(find.text(l10n.storageCreateFolderButton));
    await tester.pumpAndSettle();

    verify(
      () => repository.createFolder(
        scope: any(named: 'scope'),
        name: 'Dokumenty',
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).called(1);
    // Jedno odświeżenie na udaną mutację: ponowne wczytanie w kółko zamazywałoby
    // efekt akcji i przewijało listę.
    expect(folderReadCount, 2);
  });

  testWidgets('zmiana nazwy folderu odświeża listę dokładnie raz', (
    tester,
  ) async {
    when(
      () => repository.updateFolder(
        folderId: any(named: 'folderId'),
        name: any(named: 'name'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer(
      (_) async => right(storageTestFolder(name: 'Nowa nazwa')),
    );
    await pumpStorageShell(tester, repository: repository);

    await tester.tap(find.byKey(const ValueKey('folder-actions-folder-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.storageRenameFolderDialogTitle));
    await tester.pumpAndSettle();
    await tester.enterText(_dialogField(), 'Nowa nazwa');
    await tester.pump();
    await tester.tap(find.text(l10n.save));
    await tester.pumpAndSettle();

    verify(
      () => repository.updateFolder(
        folderId: 'folder-1',
        name: 'Nowa nazwa',
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).called(1);
    expect(folderReadCount, 2);
  });

  testWidgets('usunięcie pliku wymaga potwierdzenia i odświeża raz', (
    tester,
  ) async {
    when(
      () => repository.deleteFile(any()),
    ).thenAnswer((_) async => right(unit));

    await pumpStorageShell(tester, repository: repository);
    await tester.longPress(find.text('dokument.pdf'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('storage_bulk_bar')), findsOneWidget);
    final readsBefore = folderReadCount;

    await tester.tap(find.byKey(const ValueKey('storage_bulk_delete')));
    await tester.pumpAndSettle();
    // Sam przycisk nie kasuje: najpierw dialog, więc przypadkowe kliknięcie
    // nie usuwa plików.
    expect(find.text(l10n.storageDeleteConfirmTitle), findsOneWidget);
    expect(folderReadCount, readsBefore);

    await tester.tap(find.text(l10n.delete));
    await tester.pumpAndSettle();

    // Zaznaczony plik kasuje się pojedynczym wywołaniem kontraktu: pasek
    // akcji masowych jest pętlą po plikach i folderach, nie osobnym API.
    verify(() => repository.deleteFile('file-1')).called(1);
    expect(folderReadCount, readsBefore + 1);
  });

  testWidgets('anulowanie potwierdzenia nie usuwa i nie odświeża', (
    tester,
  ) async {
    await pumpStorageShell(tester, repository: repository);
    await tester.longPress(find.text('dokument.pdf'));
    await tester.pumpAndSettle();
    final readsBefore = folderReadCount;

    await tester.tap(find.byKey(const ValueKey('storage_bulk_delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.cancel));
    await tester.pumpAndSettle();

    verifyNever(() => repository.deleteFile(any()));
    expect(folderReadCount, readsBefore);
  });

  testWidgets('spóźniony wynik bulk nie kasuje nowego zaznaczenia', (
    tester,
  ) async {
    final first = storageTestFile();
    final next = storageTestFile(id: 'file-2', name: 'nowe-zaznaczenie.pdf');
    final deletion = Completer<Either<ApiError, Unit>>();
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        CursorPageResponse<StorageFileResponse>(items: [first, next]),
      ),
    );
    when(() => repository.deleteFile('file-1')).thenAnswer(
      (_) => deletion.future,
    );
    await pumpStorageShell(tester, repository: repository);

    final context = tester.element(find.byType(StorageBrowserBody));
    final selection = context.read<StorageSelectionCubit>();
    final mutation = context.read<StorageFileMutationCubit>();
    selection.selectAll(files: [first], folders: const []);
    final result = mutation.bulkDelete(
      fileIds: ['file-1'],
    );
    await tester.pump();

    selection.selectAll(files: [next], folders: const []);
    deletion.complete(right(unit));
    await result;
    await tester.pumpAndSettle();

    expect(selection.state.selectedFileIds, {'file-2'});
  });

  testWidgets(
    'błędy bulk pokazują nazwy, pełną diagnostykę i pominięte pliki',
    (
      tester,
    ) async {
      final first = storageTestFile();
      final next = storageTestFile(id: 'file-2', name: 'umowa.docx');
      const error = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Limit żądań.',
        statusCode: 429,
        apiCode: 'storage.rate_limited',
        contractCode: 'storage.too_many_requests',
        traceId: 'bulk-rate-limit-trace',
        fields: {
          'fileId': ['Spróbuj później.'],
        },
      );
      when(() => repository.deleteFile('file-1')).thenAnswer(
        (_) async => left(error),
      );
      await pumpStorageShell(tester, repository: repository);

      final context = tester.element(find.byType(StorageBrowserBody));
      final selection = context.read<StorageSelectionCubit>();
      final mutation = context.read<StorageFileMutationCubit>();
      selection.selectAll(files: [first, next], folders: const []);
      await mutation.bulkDelete(
        fileIds: ['file-1', 'file-2'],
      );
      await tester.pumpAndSettle();

      verifyNever(() => repository.deleteFile('file-2'));
      expect(selection.state.selectedFileIds, {'file-1', 'file-2'});
      final storageBulkItemFailures = find.text(
        l10n.storageBulkItemFailures(1),
      );
      await tester.ensureVisible(storageBulkItemFailures);
      expect(storageBulkItemFailures.hitTestable(), findsOneWidget);
      await tester.tap(storageBulkItemFailures);
      await tester.pumpAndSettle();
      final storageBulkNotAttempted = find.text(
        l10n.storageBulkNotAttempted(1),
      );
      await tester.ensureVisible(storageBulkNotAttempted);
      expect(storageBulkNotAttempted.hitTestable(), findsOneWidget);
      await tester.tap(storageBulkNotAttempted);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(StorageMutationFeedbackHost),
          matching: find.text('dokument.pdf'),
        ),
        findsOneWidget,
      );
      expect(find.text('umowa.docx — file-2'), findsOneWidget);
      expect(find.text('file-1'), findsOneWidget);
      expect(find.textContaining('storage.rate_limited'), findsWidgets);
      expect(find.textContaining('storage.too_many_requests'), findsWidgets);
      expect(find.textContaining('bulk-rate-limit-trace'), findsWidgets);
      expect(find.textContaining('fileId: Spróbuj później.'), findsWidgets);
    },
  );

  testWidgets('wymiana providerów w trakcie potwierdzenia nie usuwa pliku', (
    tester,
  ) async {
    final replacementRepository = _MockStorageRepository();
    when(() => repository.deleteFile('file-1')).thenAnswer(
      (_) async => right(unit),
    );
    when(() => replacementRepository.deleteFile('file-1')).thenAnswer(
      (_) async => right(unit),
    );
    final key = GlobalKey<_DeleteConfirmationHarnessState>();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        home: _DeleteConfirmationHarness(
          key: key,
          initialRepository: repository,
          replacementRepository: replacementRepository,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('launch-delete-confirmation')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    key.currentState!.replaceProviders();
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(FilledButton),
      ),
    );
    await tester.pumpAndSettle();

    verifyNever(() => repository.deleteFile('file-1'));
    verifyNever(() => replacementRepository.deleteFile('file-1'));
  });

  testWidgets('usunięcie folderu z menu wymaga potwierdzenia i odświeża raz', (
    tester,
  ) async {
    when(
      () => repository.deleteFolder(any()),
    ).thenAnswer((_) async => right(unit));
    await pumpStorageShell(tester, repository: repository);
    final readsBefore = folderReadCount;

    await tester.tap(find.byKey(const ValueKey('folder-actions-folder-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.delete));
    await tester.pumpAndSettle();
    expect(find.text(l10n.storageDeleteConfirmTitle), findsOneWidget);

    await tester.tap(find.text(l10n.delete).last);
    await tester.pumpAndSettle();

    verify(() => repository.deleteFolder('folder-1')).called(1);
    expect(folderReadCount, readsBefore + 1);
  });

  testWidgets('pobranie pliku z wiersza bierze bilet i zapisuje plik', (
    tester,
  ) async {
    final transport = _RecordingDownloadTransport();
    when(() => repository.getDownloadTicket('file-1')).thenAnswer(
      (_) async => right(
        StorageDownloadTicketResponse(
          fileId: 'file-1',
          originalFileName: 'dokument.pdf',
          mimeType: 'application/pdf',
          fileSizeBytes: 1024,
          downloadUrl: 'https://minio.test/report',
          expiresAtUtc: DateTime.utc(2026, 9, 20, 12),
        ),
      ),
    );

    await pumpStorageShell(
      tester,
      repository: repository,
      downloadTransport: transport,
    );

    await tester.tap(find.byKey(const ValueKey('download-file-file-1')));
    await tester.pump();

    verify(() => repository.getDownloadTicket('file-1')).called(1);
    expect(transport.url, 'https://minio.test/report');
    expect(transport.fileName, 'dokument.pdf');
  });

  testWidgets('przywrócenie pliku z kosza odświeża listę dokładnie raz', (
    tester,
  ) async {
    when(
      () => repository.restoreFile(any()),
    ).thenAnswer((_) async => right(storageTestFile()));
    await pumpStorageShell(
      tester,
      repository: repository,
      scope: const StorageScope.trash(),
    );
    final readsBefore = folderReadCount;

    final shellContext = tester.element(find.byType(StorageBrowserBody));
    await shellContext.read<StorageFileMutationCubit>().restoreFile('file-1');
    await tester.pumpAndSettle();

    verify(() => repository.restoreFile('file-1')).called(1);
    expect(folderReadCount, readsBefore);
    verify(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).called(2);
  });

  testWidgets('udostępnienie z wiersza nadaje dostęp workspace’owi', (
    tester,
  ) async {
    when(
      () => repository.createFileShare(
        fileId: any(named: 'fileId'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => right(storageShare()));
    when(
      () => repository.listFileShares(any()),
    ).thenAnswer((_) async => right(const <StorageFileShareResponse>[]));

    await pumpStorageShell(
      tester,
      repository: repository,
      scope: const StorageScope.workspace('workspace-1'),
    );

    await tester.tap(find.byKey(const ValueKey('share-file-file-1')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.storageShareTitle('dokument.pdf')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('share-workspace')));
    await tester.pumpAndSettle();
    // Nadanie dostępu przechodzi przez potwierdzenie: klik nie wysyła grantu
    // w tle, użytkownik wie, komu otwiera plik.
    expect(find.text(l10n.storageShareAction), findsWidgets);
    await tester.tap(find.text(l10n.storageShareAction).last);
    await tester.pumpAndSettle();

    // Dialog nadaje dostęp przez ten sam kontrakt co reszta modułu: workspace
    // dostaje udział typu workspace, a nie prywatny link.
    final payload =
        verify(
              () => repository.createFileShare(
                fileId: 'file-1',
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as CreateStorageFileSharePayload;
    expect(payload.shareType, StorageShareType.workspace);
    expect(payload.sharedWithWorkspaceId, 'workspace-1');
  });

  testWidgets('zakończony upload odświeża listę Files', (tester) async {
    final transport = _MockUploadTransport();
    when(
      () => repository.requestUploadTicket(any()),
    ).thenAnswer((_) async => right(ticket));
    when(
      () => transport.upload(
        ticket: any(named: 'ticket'),
        input: any(named: 'input'),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) async => right(unit));
    when(
      () => repository.completeUpload(
        fileId: ticket.fileId,
        fileSizeBytes: input.size,
      ),
    ).thenAnswer((_) async => right(storageTestFile(id: 'file-new')));

    await pumpStorageShell(
      tester,
      repository: repository,
      uploadTransport: transport,
      filePicker: _OneFilePicker(),
      scope: const StorageScope.workspace('workspace-1'),
    );
    final readsBefore = folderReadCount;

    await tester.tap(find.byKey(const ValueKey('storage_upload_action')));
    for (var index = 0; index < 6; index++) {
      await tester.pump(const Duration(milliseconds: 30));
    }

    verify(
      () => repository.completeUpload(
        fileId: ticket.fileId,
        fileSizeBytes: input.size,
      ),
    ).called(1);
    // Lista pokazuje nowy plik dopiero po potwierdzonym zakończeniu wysyłki.
    expect(folderReadCount, readsBefore + 1);
  });
}

final class _DeleteConfirmationHarness extends StatefulWidget {
  const _DeleteConfirmationHarness({
    required this.initialRepository,
    required this.replacementRepository,
    super.key,
  });

  final StorageRepository initialRepository;
  final StorageRepository replacementRepository;

  @override
  State<_DeleteConfirmationHarness> createState() =>
      _DeleteConfirmationHarnessState();
}

final class _DeleteConfirmationHarnessState
    extends State<_DeleteConfirmationHarness> {
  final _owners = <_DeleteOwnerSet>[];
  late _DeleteOwnerSet _current;

  @override
  void initState() {
    super.initState();
    _install(widget.initialRepository);
  }

  void _install(StorageRepository repository) {
    final selection = StorageSelectionCubit()
      ..selectAll(files: [storageTestFile()], folders: const []);
    _current = _DeleteOwnerSet(
      selection: selection,
      browser: StorageBrowserCubit(repository: repository),
      mutation: StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _MockDownloadTransport(),
      ),
    );
    _owners.add(_current);
  }

  void replaceProviders() {
    setState(() => _install(widget.replacementRepository));
  }

  @override
  void dispose() {
    for (final owner in _owners) {
      unawaited(owner.selection.close());
      unawaited(owner.browser.close());
      unawaited(owner.mutation.close());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<StorageSelectionCubit>.value(value: _current.selection),
      BlocProvider<StorageBrowserCubit>.value(value: _current.browser),
      BlocProvider<StorageFileMutationCubit>.value(value: _current.mutation),
    ],
    child: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            key: const ValueKey('launch-delete-confirmation'),
            onPressed: () => unawaited(
              StorageDeleteConfirmation.show(
                context,
                _current.selection.state,
              ),
            ),
            child: const Text('Delete selected'),
          ),
        ),
      ),
    ),
  );
}

final class _DeleteOwnerSet {
  const _DeleteOwnerSet({
    required this.selection,
    required this.browser,
    required this.mutation,
  });

  final StorageSelectionCubit selection;
  final StorageBrowserCubit browser;
  final StorageFileMutationCubit mutation;
}

/// Picker zwracający jeden plik, żeby kolejka uploadu miała co wysłać.
final class _OneFilePicker extends Fake implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async => [input];
}

/// Transport pobierania, który zapisuje, co dostał — bez sieci i dysku.
final class _RecordingDownloadTransport implements DownloadTransport {
  String? url;
  String? fileName;

  @override
  Future<Either<ApiError, Unit>> downloadUrl({
    required String downloadUrl,
    required String fileName,
    Map<String, String>? headers,
  }) async {
    url = downloadUrl;
    this.fileName = fileName;
    return right(unit);
  }

  @override
  Future<Either<ApiError, Uint8List>> fetchBytes({
    required String downloadUrl,
    Map<String, String>? headers,
  }) async => right(Uint8List(0));

  @override
  Future<Either<ApiError, Unit>> saveBytes({
    required List<int> bytes,
    required String fileName,
  }) async => right(unit);
}

/// Udział zwracany przez atrapę repozytorium.
StorageFileShareResponse storageShare() => StorageFileShareResponse(
  id: 'share-1',
  fileId: 'file-1',
  shareType: StorageShareType.workspace,
  accessLevel: StorageShareAccessLevel.reader,
  sharedWithWorkspaceId: 'workspace-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026, 9, 20, 12),
  effectiveAccessLevel: StorageEffectiveAccessLevel.reader,
  canRead: true,
  canComment: false,
  canEdit: false,
  canShare: false,
  canDelete: false,
);
