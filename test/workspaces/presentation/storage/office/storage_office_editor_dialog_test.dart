import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late _MockStorageRepository repository;

  setUp(() {
    repository = _MockStorageRepository();
    when(() => repository.getOfficeSession('file-1')).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.connection, message: 'Brak połączenia'),
      ),
    );
  });

  testWidgets('zamknięcie z przycisku zawsze opuszcza edytor', (tester) async {
    await _pumpEditor(tester, repository);

    expect(find.byTooltip('Zamknij'), findsAtLeastNWidgets(1));
    await tester.tap(find.byTooltip('Zamknij').first);
    await tester.pumpAndSettle();

    expect(find.text('dokument.docx'), findsNothing);
  });

  testWidgets('Escape zamyka modalny edytor także po błędzie sesji', (
    tester,
  ) async {
    await _pumpEditor(tester, repository);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('dokument.docx'), findsNothing);
  });

  testWidgets('systemowy Back zamyka modalny edytor', (tester) async {
    await _pumpEditor(tester, repository);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    expect(find.text('dokument.docx'), findsNothing);
  });

  testWidgets(
    'wyświetla przyciski Zapisz kopię w Storage, Drukuj i Pobierz w AppBarze',
    (tester) async {
      await _pumpEditor(tester, repository);

      expect(find.byTooltip('Zapisz kopię w Storage'), findsOneWidget);
      expect(find.byTooltip('Drukuj'), findsOneWidget);
      expect(find.byTooltip('Pobierz'), findsOneWidget);
    },
  );
}

Future<void> _pumpEditor(
  WidgetTester tester,
  StorageRepository repository,
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
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => StorageOfficeEditorDialog.show(
              context,
              file: _file,
              repository: repository,
            ),
            child: const Text('Otwórz'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Otwórz'));
  await tester.pumpAndSettle();
}

final _file = StorageFileResponse(
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
