import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/storage/ports/download_transport.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/grid/storage_file_grid.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';

/// Atrapa kontraktu Storage potrzebna wyłącznie do utworzenia lokalnych Cubitów.
class _MockStorageRepository extends Mock implements StorageRepository {}

/// Atrapa transportu pobierania, nieuruchamiana w teście warstwy modalu.
class _MockDownloadTransport extends Mock implements DownloadTransport {}

void main() {
  void stubPreviewTicket(_MockStorageRepository repository) {
    when(() => repository.getDownloadTicket(any())).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.connection, message: 'Brak sieci.'),
      ),
    );
  }

  testWidgets(
    'menu pliku używa rootowego bottom sheeta i blokuje nested route',
    (tester) async {
      final repository = _MockStorageRepository();
      stubPreviewTicket(repository);
      final browserCubit = StorageBrowserCubit(repository: repository);
      final mutationCubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _MockDownloadTransport(),
      );
      final selectionCubit = StorageSelectionCubit();
      final rootNavigatorKey = GlobalKey<NavigatorState>();
      final nestedNavigatorKey = GlobalKey<NavigatorState>();
      var underlayTaps = 0;

      addTearDown(browserCubit.close);
      addTearDown(mutationCubit.close);
      addTearDown(selectionCubit.close);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<StorageBrowserCubit>.value(value: browserCubit),
            BlocProvider<StorageFileMutationCubit>.value(value: mutationCubit),
            BlocProvider<StorageSelectionCubit>.value(value: selectionCubit),
          ],
          child: MaterialApp(
            navigatorKey: rootNavigatorKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('pl'),
            home: Scaffold(
              body: Navigator(
                key: nestedNavigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute<void>(
                  builder: (_) => Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () => underlayTaps++,
                          child: const Text('Tło'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: StorageFileGrid(files: [_sampleFile]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Więcej opcji'));
      await tester.pumpAndSettle();

      expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
      expect(rootNavigatorKey.currentState!.canPop(), isTrue);
      expect(nestedNavigatorKey.currentState!.canPop(), isFalse);

      await tester.tapAt(const Offset(16, 16));
      await tester.pump();

      expect(underlayTaps, 0);
      expect(find.text('Udostępnij'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Udostępnij'), findsNothing);
      expect(rootNavigatorKey.currentState!.canPop(), isFalse);
    },
  );

  testWidgets(
    'preview pliku używa rootowego dialogu i Escape nie zmienia nested route',
    (tester) async {
      final repository = _MockStorageRepository();
      stubPreviewTicket(repository);
      final browserCubit = StorageBrowserCubit(repository: repository);
      final mutationCubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _MockDownloadTransport(),
      );
      final previewCubit = StoragePreviewCubit(repository: repository);
      final selectionCubit = StorageSelectionCubit();
      final rootNavigatorKey = GlobalKey<NavigatorState>();
      final nestedNavigatorKey = GlobalKey<NavigatorState>();
      var underlayTaps = 0;

      addTearDown(browserCubit.close);
      addTearDown(mutationCubit.close);
      addTearDown(previewCubit.close);
      addTearDown(selectionCubit.close);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<StorageBrowserCubit>.value(value: browserCubit),
            BlocProvider<StorageFileMutationCubit>.value(value: mutationCubit),
            BlocProvider<StoragePreviewCubit>.value(value: previewCubit),
            BlocProvider<StorageSelectionCubit>.value(value: selectionCubit),
          ],
          child: MaterialApp(
            navigatorKey: rootNavigatorKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('pl'),
            home: Scaffold(
              body: Navigator(
                key: nestedNavigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute<void>(
                  builder: (_) => Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () => underlayTaps++,
                          child: const Text('Tło'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: StorageFileGrid(files: [_sampleFile]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('umowa.pdf'));
      await tester.pumpAndSettle();

      expect(find.byType(StoragePreviewDialog), findsOneWidget);
      expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
      expect(rootNavigatorKey.currentState!.canPop(), isTrue);
      expect(nestedNavigatorKey.currentState!.canPop(), isFalse);

      await tester.tapAt(const Offset(16, 16));
      await tester.pump();
      expect(underlayTaps, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(StoragePreviewDialog), findsNothing);
      expect(rootNavigatorKey.currentState!.canPop(), isFalse);
      expect(nestedNavigatorKey.currentState!.canPop(), isFalse);
    },
  );
}

final _sampleFile = StorageFileResponse(
  id: 'file-1',
  module: StorageModule.workspaces,
  resourceType: StorageResourceType.document,
  originalFileName: 'umowa.pdf',
  extension: '.pdf',
  mimeType: 'application/pdf',
  fileSizeBytes: 1024,
  version: 1,
  ownerUserId: 'user-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026, 9, 13),
  updatedAtUtc: DateTime.utc(2026, 9, 13),
  isDeleted: false,
  processingStatus: StorageProcessingStatus.ready,
  scanStatus: StorageScanStatus.clean,
  aiStatus: StorageAiStatus.none,
  canRead: true,
  canShare: true,
  canDelete: true,
);
