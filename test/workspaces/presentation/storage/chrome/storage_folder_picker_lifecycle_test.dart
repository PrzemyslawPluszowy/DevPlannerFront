import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _PickerApp extends StatelessWidget {
  const _PickerApp({required this.repository, this.scaled = false});

  final StorageRepository repository;
  final bool scaled;

  static StorageFolderResponse folder(String id, String name) =>
      StorageFolderResponse(
        id: id,
        name: name,
        folderType: StorageFolderType.personal,
        itemCount: 0,
        updatedAtUtc: DateTime.utc(2026, 10),
        accessLevel: StorageEffectiveAccessLevel.owner,
        canRead: true,
        canComment: true,
        canEdit: true,
        canShare: true,
        canDelete: true,
      );

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: MaterialTheme.crm().light(),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(scaled ? 2 : 1),
      ),
      child: child!,
    ),
    home: Scaffold(
      body: StorageFolderPickerDialog(
        repository: repository,
        scope: const StorageScope.personal(),
      ),
    ),
  );
}

void main() {
  setUpAll(() => registerFallbackValue(const StorageScope.personal()));

  testWidgets(
    'replacement repository owns folder reads and stale result is ignored',
    (
      tester,
    ) async {
      final first = _Repository();
      final replacement = _Repository();
      final pending =
          Completer<Either<ApiError, List<StorageFolderResponse>>>();
      when(
        () => first.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) => pending.future);
      when(
        () => replacement.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer(
        (_) async => right([_PickerApp.folder('current', 'Current folder')]),
      );

      await tester.pumpWidget(_PickerApp(repository: first));
      await tester.pump();
      await tester.pumpWidget(_PickerApp(repository: replacement));
      await tester.pump();
      pending.complete(right([_PickerApp.folder('old', 'Old owner folder')]));
      await tester.pumpAndSettle();

      expect(find.text('Current folder'), findsOneWidget);
      expect(find.text('Old owner folder'), findsNothing);
      verify(
        () => replacement.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).called(1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'late child response cannot replace the current parent folder list',
    (
      tester,
    ) async {
      final repository = _Repository();
      final child = Completer<Either<ApiError, List<StorageFolderResponse>>>();
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((invocation) {
        if (invocation.namedArguments[#parentFolderId] == 'parent') {
          return child.future;
        }
        return Future.value(
          right([_PickerApp.folder('parent', 'Parent folder')]),
        );
      });
      await tester.pumpWidget(_PickerApp(repository: repository));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('storage_picker_folder-parent')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('storage_picker_up')));
      await tester.pump();
      child.complete(right([_PickerApp.folder('stale', 'Stale child folder')]));
      await tester.pumpAndSettle();

      expect(find.text('Parent folder'), findsOneWidget);
      expect(find.text('Stale child folder'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('folder picker keeps confirm and cancel visible at 200 percent', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _Repository();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer(
      (_) async => right([
        _PickerApp.folder(
          'long',
          'Folder with a long name for desktop document storage',
        ),
      ]),
    );
    await tester.pumpWidget(_PickerApp(repository: repository, scaled: true));
    await tester.pumpAndSettle();

    expect(find.text('Cancel').hitTestable(), findsOneWidget);
    expect(
      find.byKey(const ValueKey('storage_picker_confirm')).hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
  test(
    'typed thrown error retains diagnostics and prevents cooldown bypass',
    () async {
      final repository = _Repository();
      final deadline = DateTime.now().toUtc().add(const Duration(minutes: 1));
      final error = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Limit folder reads',
        statusCode: 429,
        contractCode: 'rate_limit.exceeded',
        traceId: 'folder-trace',
        fields: const {
          'scope': ['Wait before reading'],
        },
        retryAfterUtc: deadline,
      );
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenThrow(error);
      final cubit = StorageFolderPickerCubit(
        repository: repository,
        scope: const StorageScope.personal(),
      );
      addTearDown(cubit.close);
      await cubit.load();
      expect(cubit.state.error, error);
      expect(cubit.state.loading, false);
      await cubit.load();
      await cubit.open(_PickerApp.folder('new', 'New folder'));
      verify(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).called(1);
      expect(cubit.state.path, isEmpty);
    },
  );

  test('closing the owner ignores pending results', () async {
    final repository = _Repository();
    final pending = Completer<Either<ApiError, List<StorageFolderResponse>>>();
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) => pending.future);
    final cubit = StorageFolderPickerCubit(
      repository: repository,
      scope: const StorageScope.personal(),
    );
    final operation = cubit.load();
    await cubit.close();
    pending.complete(right([_PickerApp.folder('late', 'Late folder')]));
    await operation;
    expect(cubit.state.folders, isEmpty);
    expect(cubit.isClosed, true);
  });
}
