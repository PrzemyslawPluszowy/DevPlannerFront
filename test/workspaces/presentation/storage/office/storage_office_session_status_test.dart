import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_close_confirmation.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_status_label.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('stan sesji edytora', () {
    late StorageOfficeEditorActionsCubit cubit;

    setUp(() {
      cubit = StorageOfficeEditorActionsCubit(
        _sampleFile,
        _NoopRepository(),
        _NoopDownloadTransport(),
        _NoopUploadTransport(),
        StorageOnlyOfficeHostController(),
      );
    });

    tearDown(() => cubit.close());

    test('startuje bez połączenia i bez zmian', () {
      expect(cubit.state.isSessionReady, isFalse);
      expect(cubit.state.hasUnsavedChanges, isFalse);
      expect(cubit.state.hasSavedChanges, isFalse);
    });

    test('gotowość dokumentu oznacza połączoną sesję', () {
      cubit.sessionReady();

      expect(cubit.state.isSessionReady, isTrue);
      expect(cubit.state.hasUnsavedChanges, isFalse);
    });

    test('brak lokalnych zmian czeka na potwierdzenie, nie ogłasza zapisu', () {
      cubit.sessionReady();

      cubit.documentStateChanged(isModified: true);
      expect(cubit.state.hasUnsavedChanges, isTrue);
      expect(cubit.state.hasSavedChanges, isFalse);

      // Edytor nie ma już lokalnych zmian, ale to nie dowód zapisu: wersję
      // potwierdza backend, więc stan to oczekiwanie, a nie „zapisano”.
      cubit.documentStateChanged(isModified: false);
      expect(cubit.state.hasUnsavedChanges, isFalse);
      expect(
        cubit.state.saveConfirmation,
        StorageOfficeSaveConfirmation.awaitingServer,
      );
      expect(cubit.state.hasSavedChanges, isFalse);
    });

    test('zapis potwierdza dopiero wyższa wersja pliku z backendu', () async {
      final repository = _VersionedRepository(initialVersion: 4);
      cubit = StorageOfficeEditorActionsCubit(
        _sampleFileForVersion(4),
        repository,
        _NoopDownloadTransport(),
        _NoopUploadTransport(),
        StorageOnlyOfficeHostController(),
        confirmationInterval: const Duration(milliseconds: 5),
      );

      cubit.sessionReady();
      cubit.documentStateChanged(isModified: true);
      cubit.documentStateChanged(isModified: false);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      // Backend nadal widzi starą wersję, więc zapis nie może być ogłoszony.
      expect(cubit.state.hasSavedChanges, isFalse);

      repository.version = 5;
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(
        cubit.state.saveConfirmation,
        StorageOfficeSaveConfirmation.confirmed,
      );
      expect(cubit.state.confirmedVersion, 5);
      expect(cubit.state.hasSavedChanges, isTrue);
    });

    test(
      'drugi zapis w tej samej sesji wymaga własnej, nowszej wersji',
      () async {
        final repository = _VersionedRepository(initialVersion: 4);
        cubit = StorageOfficeEditorActionsCubit(
          _sampleFileForVersion(4),
          repository,
          _NoopDownloadTransport(),
          _NoopUploadTransport(),
          StorageOnlyOfficeHostController(),
          confirmationInterval: const Duration(milliseconds: 5),
        );

        // Pierwszy zapis: edytor bez zmian, backend potwierdza wersję 5.
        cubit.sessionReady();
        cubit.documentStateChanged(isModified: true);
        cubit.documentStateChanged(isModified: false);
        repository.version = 5;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        expect(cubit.state.confirmedVersion, 5);

        // Druga edycja i drugi zapis: dopóki backend nie utworzy wersji 6,
        // stara wersja 5 nie może potwierdzać nowej treści.
        cubit.documentStateChanged(isModified: true);
        cubit.documentStateChanged(isModified: false);
        await Future<void>.delayed(const Duration(milliseconds: 30));
        expect(
          cubit.state.saveConfirmation,
          StorageOfficeSaveConfirmation.awaitingServer,
          reason: 'wersja 5 potwierdza tylko pierwszy zapis',
        );

        repository.version = 6;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        expect(cubit.state.confirmedVersion, 6);
        expect(
          cubit.state.saveConfirmation,
          StorageOfficeSaveConfirmation.confirmed,
        );
      },
    );

    test(
      'oczekiwanie na potwierdzenie kończy się wynikiem dla wołającego',
      () async {
        final repository = _VersionedRepository(initialVersion: 4);
        cubit = StorageOfficeEditorActionsCubit(
          _sampleFileForVersion(4),
          repository,
          _NoopDownloadTransport(),
          _NoopUploadTransport(),
          StorageOnlyOfficeHostController(),
          confirmationInterval: const Duration(milliseconds: 5),
          confirmationTimeout: const Duration(milliseconds: 200),
        );

        cubit.sessionReady();
        cubit.documentStateChanged(isModified: true);
        cubit.documentStateChanged(isModified: false);
        repository.version = 5;

        // Zamknięcie modala czeka na wynik, zamiast kończyć kontrolę wcześniej.
        expect(await cubit.waitForConfirmedSave(), isTrue);

        // Druga edycja bez potwierdzenia: oczekiwanie kończy się po oknie kontroli
        // i mówi wprost, że zapis nie został potwierdzony.
        cubit.documentStateChanged(isModified: true);
        cubit.documentStateChanged(isModified: false);
        expect(await cubit.waitForConfirmedSave(), isFalse);
        expect(
          cubit.state.saveConfirmation,
          StorageOfficeSaveConfirmation.unconfirmed,
        );
      },
    );

    test(
      'brak potwierdzenia kończy się jawnym stanem, nie fałszywym zapisem',
      () async {
        cubit = StorageOfficeEditorActionsCubit(
          _sampleFileForVersion(4),
          _VersionedRepository(initialVersion: 4),
          _NoopDownloadTransport(),
          _NoopUploadTransport(),
          StorageOnlyOfficeHostController(),
          confirmationInterval: const Duration(milliseconds: 5),
          confirmationTimeout: const Duration(milliseconds: 15),
        );

        cubit.sessionReady();
        cubit.documentStateChanged(isModified: true);
        cubit.documentStateChanged(isModified: false);
        await Future<void>.delayed(const Duration(milliseconds: 60));

        expect(
          cubit.state.saveConfirmation,
          StorageOfficeSaveConfirmation.unconfirmed,
        );
        expect(cubit.state.hasSavedChanges, isFalse);
      },
    );

    test('zapis wcześniejszy nie ginie przy kolejnej edycji', () async {
      final repository = _VersionedRepository(initialVersion: 4);
      cubit = StorageOfficeEditorActionsCubit(
        _sampleFileForVersion(4),
        repository,
        _NoopDownloadTransport(),
        _NoopUploadTransport(),
        StorageOnlyOfficeHostController(),
        confirmationInterval: const Duration(milliseconds: 5),
      );

      cubit.sessionReady();
      cubit.documentStateChanged(isModified: true);
      cubit.documentStateChanged(isModified: false);
      repository.version = 5;
      await Future<void>.delayed(const Duration(milliseconds: 30));
      cubit.documentStateChanged(isModified: true);

      // Po potwierdzonym zapisie lista plików wymaga odświeżenia, nawet gdy
      // użytkownik zaczął już kolejną edycję.
      expect(cubit.state.hasSavedChanges, isTrue);
      expect(cubit.state.hasUnsavedChanges, isTrue);
      expect(
        cubit.state.saveConfirmation,
        StorageOfficeSaveConfirmation.none,
      );
    });
  });

  group('wskaźnik stanu', () {
    Future<void> pump(
      WidgetTester tester,
      StorageOfficeEditorActionsState state,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Scaffold(body: StorageOfficeStatusLabel(actions: state)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('przed połączeniem pokazuje łączenie', (tester) async {
      await pump(tester, const StorageOfficeEditorActionsState());

      expect(find.text('Łączenie…'), findsOneWidget);
    });

    testWidgets('połączenie bez zmian nie ogłasza zapisu', (tester) async {
      await pump(
        tester,
        const StorageOfficeEditorActionsState(isSessionReady: true),
      );

      // Backend nie potwierdził wersji, więc etykieta mówi o połączeniu,
      // a nie o zapisie.
      expect(find.text('Połączono'), findsOneWidget);
      expect(find.text('Zapisano'), findsNothing);
    });

    testWidgets('oczekiwanie na serwer ma własną etykietę', (tester) async {
      await pump(
        tester,
        const StorageOfficeEditorActionsState(
          isSessionReady: true,
          saveConfirmation: StorageOfficeSaveConfirmation.awaitingServer,
        ),
      );

      expect(find.text('Oczekiwanie na zapis…'), findsOneWidget);
      expect(find.text('Zapisano'), findsNothing);
    });

    testWidgets('potwierdzona wersja pokazuje zapis', (tester) async {
      await pump(
        tester,
        const StorageOfficeEditorActionsState(
          isSessionReady: true,
          hasSavedChanges: true,
          saveConfirmation: StorageOfficeSaveConfirmation.confirmed,
          confirmedVersion: 2,
        ),
      );

      expect(find.text('Zapisano'), findsOneWidget);
    });

    testWidgets('brak potwierdzenia sygnalizuje ostrzeżenie', (tester) async {
      await pump(
        tester,
        const StorageOfficeEditorActionsState(
          isSessionReady: true,
          saveConfirmation: StorageOfficeSaveConfirmation.unconfirmed,
        ),
      );

      expect(find.text('Zapis niepotwierdzony'), findsOneWidget);
      expect(find.text('Zapisano'), findsNothing);
    });

    testWidgets('zmiany czekające na zapis mają własną etykietę', (
      tester,
    ) async {
      await pump(
        tester,
        const StorageOfficeEditorActionsState(
          isSessionReady: true,
          hasUnsavedChanges: true,
        ),
      );

      expect(find.text('Niezapisane zmiany'), findsOneWidget);
    });
  });

  group('potwierdzenie zamknięcia', () {
    /// Buduje ekran z przyciskiem, który pyta o zamknięcie, i zwraca odczyt
    /// decyzji po jej podjęciu.
    Future<Future<void> Function()> pumpConfirmButton(
      WidgetTester tester, {
      required bool hasUnsavedChanges,
      required void Function(bool) onResult,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async => onResult(
                  await confirmStorageOfficeClose(
                    context,
                    hasUnsavedChanges: hasUnsavedChanges,
                  ),
                ),
                child: const Text('Zamknij'),
              ),
            ),
          ),
        ),
      );
      return () async {
        await tester.tap(find.text('Zamknij'));
        await tester.pumpAndSettle();
      };
    }

    testWidgets('bez zmian zamyka bez pytania', (tester) async {
      bool? decision;
      final press = await pumpConfirmButton(
        tester,
        hasUnsavedChanges: false,
        onResult: (value) => decision = value,
      );

      await press();
      await tester.pumpAndSettle();

      expect(find.text('Zamknąć bez zapisu?'), findsNothing);
      expect(decision, isTrue);
    });

    testWidgets('przy zmianach pyta i domyślnie nie zamyka', (tester) async {
      bool? decision;
      final press = await pumpConfirmButton(
        tester,
        hasUnsavedChanges: true,
        onResult: (value) => decision = value,
      );

      await press();
      expect(find.text('Zamknąć bez zapisu?'), findsOneWidget);

      await tester.tap(find.text('Anuluj'));
      await tester.pumpAndSettle();

      expect(decision, isFalse);
    });

    testWidgets('przy zmianach pozwala zamknąć po potwierdzeniu', (
      tester,
    ) async {
      bool? decision;
      final press = await pumpConfirmButton(
        tester,
        hasUnsavedChanges: true,
        onResult: (value) => decision = value,
      );

      await press();
      await tester.tap(find.text('Zamknij').last);
      await tester.pumpAndSettle();

      expect(decision, isTrue);
    });
  });
  group('zamknięcie przy oczekiwaniu na zapis', () {
    Future<bool?> pumpClose(
      WidgetTester tester, {
      required bool hasUnsavedChanges,
      required bool isAwaitingSaveConfirmation,
    }) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    result = await confirmStorageOfficeClose(
                      context,
                      hasUnsavedChanges: hasUnsavedChanges,
                      isAwaitingSaveConfirmation: isAwaitingSaveConfirmation,
                    );
                  },
                  child: const Text('Zamknij'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Zamknij'));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('brak zmian i brak oczekiwania zamyka od razu', (tester) async {
      await pumpClose(
        tester,
        hasUnsavedChanges: false,
        isAwaitingSaveConfirmation: false,
      );
      // Bez zmian i bez oczekiwania żaden dialog nie ma prawa się pojawić.
      expect(find.text('Zamknąć bez zapisu?'), findsNothing);
    });

    testWidgets('oczekiwanie na zapis ma własny komunikat', (tester) async {
      await pumpClose(
        tester,
        hasUnsavedChanges: false,
        isAwaitingSaveConfirmation: true,
      );

      // Sam brak lokalnych zmian nie znaczy, że treść jest utrwalona.
      expect(find.text('Poczekać na potwierdzenie zapisu?'), findsOneWidget);
      expect(find.text('Zamknąć bez zapisu?'), findsNothing);
    });

    testWidgets('„Poczekaj” wstrzymuje zamknięcie', (tester) async {
      await pumpClose(
        tester,
        hasUnsavedChanges: false,
        isAwaitingSaveConfirmation: true,
      );

      await tester.tap(
        find.byKey(const ValueKey('storage_office_wait_for_save')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Poczekać na potwierdzenie zapisu?'), findsNothing);
    });

    testWidgets('„Zamknij” w oczekiwaniu nadal pozwala wyjść', (tester) async {
      await pumpClose(
        tester,
        hasUnsavedChanges: false,
        isAwaitingSaveConfirmation: true,
      );

      await tester.tap(
        find.byKey(const ValueKey('storage_office_close_anyway')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Poczekać na potwierdzenie zapisu?'), findsNothing);
    });
  });
}

final _sampleFile = StorageFileResponse(
  id: 'file-1',
  module: StorageModule.workspaces,
  resourceType: StorageResourceType.document,
  originalFileName: 'dokument.docx',
  extension: '.docx',
  mimeType:
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  fileSizeBytes: 100,
  version: 1,
  ownerUserId: 'user-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  isDeleted: false,
  processingStatus: StorageProcessingStatus.ready,
  scanStatus: StorageScanStatus.clean,
  aiStatus: StorageAiStatus.none,
);

/// Atrapy portów wystarczające do złożenia Cubita: ten test nie wykonuje I/O.
final class _NoopRepository extends Mock implements StorageRepository {}

final class _NoopDownloadTransport extends Mock implements DownloadTransport {}

final class _NoopUploadTransport extends Mock implements UploadTransport {}

/// Repozytorium raportujące wskazaną wersję pliku.
final class _VersionedRepository extends _NoopRepository {
  _VersionedRepository({required int initialVersion})
    : version = initialVersion;

  int version;

  @override
  Future<Either<ApiError, StorageFileDetailsResponse>> getFileDetails(
    String fileId,
  ) async => right(
    StorageFileDetailsResponse(
      file: _sampleFileForVersion(version),
      versions: const [],
      canEdit: true,
      canDelete: true,
      isOfficeDocument: true,
      permissions: const StorageFilePermissionsResponse(
        accessLevel: StorageEffectiveAccessLevel.owner,
        canRead: true,
        canComment: true,
        canEdit: true,
        canShare: true,
        canDelete: true,
      ),
    ),
  );
}

/// Plik testowy o wskazanej wersji, używany też jako baseline sesji.
StorageFileResponse _sampleFileForVersion(int version) =>
    _sampleFile.copyWith(version: version);
