import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_shell_harness.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late _MockStorageRepository repository;

  setUpAll(registerStorageFallbacks);

  setUp(() {
    repository = _MockStorageRepository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right([storageTestFolder()]));
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

  testWidgets('kompozycja read-only nie pokazuje akcji mutujących', (
    tester,
  ) async {
    await pumpStorageShell(
      tester,
      repository: repository,
      capabilities: StorageShellCapabilities.readOnly,
      onOpenFileDetails: (_) {},
    );

    // Przeglądanie zostaje: folder i plik są na liście, a szczegóły pliku nadal
    // są dostępne.
    expect(find.text('Dokumenty'), findsOneWidget);
    expect(find.text('dokument.pdf'), findsOneWidget);
    expect(find.byKey(const ValueKey('file-details-file-1')), findsOneWidget);

    // Web/BFF nie ma bezpiecznego źródła Bearera dla transferów, więc nie
    // pokazuje akcji, których nie umie wykonać. Brak flagi oznacza akcję
    // ukrytą, a nie akcję, która kończy się błędem po kliknięciu.
    expect(find.byKey(const ValueKey('storage_create_menu')), findsNothing);
    expect(find.byKey(const ValueKey('storage_upload_action')), findsNothing);
    expect(find.byKey(const ValueKey('download-file-file-1')), findsNothing);
    expect(find.byKey(const ValueKey('move-file-file-1')), findsNothing);
    expect(find.byKey(const ValueKey('share-file-file-1')), findsNothing);
  });

  testWidgets('kompozycja desktop pokazuje akcje tworzenia, transferu i zmiany', (
    tester,
  ) async {
    await pumpStorageShell(tester, repository: repository);

    expect(find.byKey(const ValueKey('storage_create_menu')), findsOneWidget);
    expect(find.byKey(const ValueKey('storage_upload_action')), findsOneWidget);
    expect(find.byKey(const ValueKey('download-file-file-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('move-file-file-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('share-file-file-1')), findsOneWidget);
  });

  testWidgets('ACL pliku wyłącza akcję, choćby kompozycja ją dopuszczała', (
    tester,
  ) async {
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
        CursorPageResponse<StorageFileResponse>(
          items: [
            storageTestFile(
              flags: const StorageFileAccessFlags(
                canShare: false,
                canDelete: false,
              ),
            ),
          ],
        ),
      ),
    );

    await pumpStorageShell(tester, repository: repository);
    await tester.longPress(find.text('dokument.pdf'));
    await tester.pumpAndSettle();

    // Uprawnienie pliku jest sprawdzane niezależnie od flag kompozycji:
    // desktop ma prawo kasować, ale ten plik nie pozwala tego zrobić.
    expect(find.byKey(const ValueKey('storage_bulk_bar')), findsOneWidget);
    expect(find.byKey(const ValueKey('storage_bulk_delete')), findsNothing);
    expect(find.byKey(const ValueKey('share-file-file-1')), findsNothing);
  });

  testWidgets('typed 403 pokazuje powierzchnię odmowy, nie pustą listę', (
    tester,
  ) async {
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.badResponse,
          message: 'Brak uprawnień do tego zakresu.',
          statusCode: 403,
        ),
      ),
    );

    await pumpStorageShell(
      tester,
      repository: repository,
      scope: const StorageScope.workspace('w-1'),
    );

    // Brak dostępu nie jest pustym folderem: użytkownik musi wiedzieć, że nie
    // widzi zawartości, bo nie ma do niej prawa.
    expect(find.text('Brak uprawnień do tego zakresu.'), findsOneWidget);
    expect(find.text('dokument.pdf'), findsNothing);
  });
}
