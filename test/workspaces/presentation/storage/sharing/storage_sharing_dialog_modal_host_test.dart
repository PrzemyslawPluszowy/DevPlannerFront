import 'package:dartz/dartz.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Atrapa kontraktu Storage używana wyłącznie do izolacji widgetowego testu
/// polityki prezentacji modalu.
class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  testWidgets(
    'dialog udostępniania używa rootowego hosta i blokuje tło nested route',
    (tester) async {
      final storageRepository = _MockStorageRepository();
      final rootNavigatorKey = GlobalKey<NavigatorState>();
      final nestedNavigatorKey = GlobalKey<NavigatorState>();
      var underlayTaps = 0;

      when(
        () => storageRepository.listFileShares('file-1'),
      ).thenAnswer((_) async => const Right([]));

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<StorageRepository>.value(
              value: storageRepository,
            ),
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
                  builder: (context) => Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () => underlayTaps++,
                          child: const Text('Tło'),
                        ),
                      ),
                      Center(
                        child: FilledButton(
                          onPressed: () => StorageSharingDialog.show(
                            context,
                            file: _sampleFile,
                            repository: storageRepository,
                          ),
                          child: const Text('Udostępnij'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Udostępnij'));
      await tester.pumpAndSettle();

      expect(find.byType(StorageSharingDialog), findsOneWidget);
      expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
      expect(rootNavigatorKey.currentState!.canPop(), isTrue);
      expect(nestedNavigatorKey.currentState!.canPop(), isFalse);

      await tester.tapAt(const Offset(16, 16));
      await tester.pumpAndSettle();

      expect(underlayTaps, 0);
      expect(find.byType(StorageSharingDialog), findsNothing);

      await tester.tap(find.text('Udostępnij'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(StorageSharingDialog), findsNothing);
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
);
