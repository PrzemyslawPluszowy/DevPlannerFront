import 'dart:async';

import 'package:dartz/dartz.dart' show Either, Left;
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  testWidgets(
    'Office failure displays contract diagnostics inside the editor',
    (tester) async {
      when(() => repository.getOfficeSession('file-1')).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'No document access',
            statusCode: 403,
            apiCode: 'office_denied',
            contractCode: 'storage_denied',
            traceId: 'office-trace',
            fields: {
              'fileId': ['Access revoked'],
            },
          ),
        ),
      );
      await _pumpEditor(tester, repository);
      for (final text in [
        'No document access',
        'office_denied',
        'storage_denied',
        'office-trace',
        'Access revoked',
        '403',
      ]) {
        expect(find.textContaining(text), findsWidgets);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rebuild preserves the same Office host controller', (
    tester,
  ) async {
    final revision = ValueNotifier<int>(0);
    addTearDown(revision.dispose);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('pl'),
        home: ValueListenableBuilder<int>(
          valueListenable: revision,
          builder: (context, value, _) =>
              StorageOfficeEditorDialog(file: _file, repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final first = tester
        .widget<StorageOfficeEditorView>(find.byType(StorageOfficeEditorView))
        .hostController;
    revision.value++;
    await tester.pumpAndSettle();
    final after = tester
        .widget<StorageOfficeEditorView>(find.byType(StorageOfficeEditorView))
        .hostController;
    expect(after, same(first));
    verify(() => repository.getOfficeSession('file-1')).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('repository replacement closes the old Office session owner', (
    tester,
  ) async {
    final pending = Completer<Either<ApiError, OnlyOfficeSessionResponse>>();
    when(() => repository.getOfficeSession('file-1'))
        .thenAnswer((_) => pending.future);
    final next = _MockStorageRepository();
    when(() => next.getOfficeSession('file-1')).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.connection, message: 'next scope error'),
      ),
    );
    final source = ValueNotifier<StorageRepository>(repository);
    addTearDown(source.dispose);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ValueListenableBuilder<StorageRepository>(
          valueListenable: source,
          builder: (context, value, _) =>
              StorageOfficeEditorDialog(file: _file, repository: value),
        ),
      ),
    );
    await tester.pump();
    final oldOwner = tester
        .element(find.byType(StorageOfficeEditorView))
        .read<StorageOfficeCubit>();
    source.value = next;
    await tester.pumpAndSettle();
    expect(oldOwner.isClosed, isTrue);
    pending.complete(
      const Left(
        ApiError(type: ApiErrorType.connection, message: 'old scope error'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('next scope error'), findsOneWidget);
    expect(find.textContaining('old scope error'), findsNothing);
    verify(() => next.getOfficeSession('file-1')).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('inherited repository replacement closes the old Office owner', (
    tester,
  ) async {
    final pending = Completer<Either<ApiError, OnlyOfficeSessionResponse>>();
    when(() => repository.getOfficeSession('file-1'))
        .thenAnswer((_) => pending.future);
    final next = _MockStorageRepository();
    when(() => next.getOfficeSession('file-1')).thenAnswer(
      (_) async => const Left(
        ApiError(
          type: ApiErrorType.connection,
          message: 'next inherited error',
        ),
      ),
    );
    final source = ValueNotifier<StorageRepository>(repository);
    addTearDown(source.dispose);
    final dialog = StorageOfficeEditorDialog(file: _file);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ValueListenableBuilder<StorageRepository>(
          valueListenable: source,
          builder: (context, value, _) =>
              RepositoryProvider<StorageRepository>.value(
                value: value,
                child: dialog,
              ),
        ),
      ),
    );
    await tester.pump();
    final oldOwner = tester
        .element(find.byType(StorageOfficeEditorView))
        .read<StorageOfficeCubit>();
    final oldHost = tester
        .widget<StorageOfficeEditorView>(find.byType(StorageOfficeEditorView))
        .hostController;
    source.value = next;
    await tester.pump();
    await tester.pump();
    expect(oldOwner.isClosed, isTrue);
    expect(
      tester
          .widget<StorageOfficeEditorView>(find.byType(StorageOfficeEditorView))
          .hostController,
      isNot(same(oldHost)),
    );
    pending.complete(
      const Left(
        ApiError(type: ApiErrorType.connection, message: 'old inherited error'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('next inherited error'), findsOneWidget);
    expect(find.textContaining('old inherited error'), findsNothing);
    verify(() => next.getOfficeSession('file-1')).called(1);
    expect(tester.takeException(), isNull);
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
