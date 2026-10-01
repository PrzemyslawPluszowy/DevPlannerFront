import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _MockDownloadTransport extends Mock implements DownloadTransport {}

void main() {
  late _MockStorageRepository repository;
  late StorageFileMutationCubit cubit;

  const fileId = 'file-1';
  const sourceFolderId = 'folder-source';
  const targetFolderId = 'folder-target';

  StorageFilePlacementResponse placement({int? version}) =>
      StorageFilePlacementResponse(
        id: 'placement-1',
        fileId: fileId,
        folderId: sourceFolderId,
        createdAtUtc: DateTime.utc(2026, 9, 20),
        version: version,
      );

  ApiError conflict() => const ApiError(
    type: ApiErrorType.badResponse,
    message: 'Placement pliku został zmieniony przez innego użytkownika.',
    statusCode: 409,
    apiCode: 'storage.placement_conflict',
  );

  setUpAll(() {
    registerFallbackValue(
      const MoveStorageFilePlacementPayload(
        targetFolderId: 'fallback',
        expectedVersion: 1,
      ),
    );
  });

  setUp(() {
    repository = _MockStorageRepository();
    cubit = StorageFileMutationCubit(
      repository: repository,
      downloadTransport: _MockDownloadTransport(),
    );
  });

  tearDown(() => cubit.close());

  void stubPlacements(
    Either<ApiError, List<StorageFilePlacementResponse>> result,
  ) {
    when(() => repository.listFolderPlacements(any())).thenAnswer(
      (_) async => result,
    );
  }

  test(
    'przenosi placement folderu z jego wersją i kluczem idempotencji',
    () async {
      stubPlacements(Right([placement(version: 7)]));
      when(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => Right(placement(version: 8)));

      await cubit.moveFileToFolder(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
      );

      expect(cubit.state, isA<StorageFileMutationSuccess>());
      expect(
        (cubit.state as StorageFileMutationSuccess).type,
        StorageFileMutationType.moved,
      );

      final captured = verify(
        () => repository.moveFilePlacement(
          placementId: captureAny(named: 'placementId'),
          targetFolderId: captureAny(named: 'targetFolderId'),
          expectedVersion: captureAny(named: 'expectedVersion'),
          idempotencyKey: captureAny(named: 'idempotencyKey'),
        ),
      ).captured;
      expect(captured[0], 'placement-1');
      expect(captured[1], targetFolderId);
      // Wersja pochodzi z placementu, więc backend porówna ją atomowo.
      expect(captured[2], 7);
      expect(
        captured[3],
        isA<String>().having((key) => key.isNotEmpty, 'niepusty', isTrue),
      );
      verifyNever(
        () => repository.createFilePlacement(
          fileId: any(named: 'fileId'),
          folderId: any(named: 'folderId'),
        ),
      );
    },
  );

  test(
    'plik na poziomie zakresu trafia do folderu jako nowa referencja',
    () async {
      when(
        () => repository.createFilePlacement(
          fileId: any(named: 'fileId'),
          folderId: any(named: 'folderId'),
        ),
      ).thenAnswer((_) async => Right(placement()));

      await cubit.moveFileToFolder(
        fileId: fileId,
        targetFolderId: targetFolderId,
      );

      expect(
        (cubit.state as StorageFileMutationSuccess).type,
        StorageFileMutationType.placementCreated,
      );
      verifyNever(() => repository.listFolderPlacements(any()));
      verifyNever(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
    },
  );

  test(
    'brak placementu w folderze źródłowym tworzy referencję, nie przenosi',
    () async {
      stubPlacements(const Right(<StorageFilePlacementResponse>[]));
      when(
        () => repository.createFilePlacement(
          fileId: any(named: 'fileId'),
          folderId: any(named: 'folderId'),
        ),
      ).thenAnswer((_) async => Right(placement()));

      await cubit.moveFileToFolder(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
      );

      expect(
        (cubit.state as StorageFileMutationSuccess).type,
        StorageFileMutationType.placementCreated,
      );
    },
  );

  test('konflikt wersji jest zgłaszany ze stabilnym kodem', () async {
    stubPlacements(Right([placement(version: 7)]));
    when(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => Left(conflict()));

    await cubit.moveFileToFolder(
      fileId: fileId,
      targetFolderId: targetFolderId,
      sourceFolderId: sourceFolderId,
    );

    final failure = cubit.state as StorageFileMutationFailure;
    expect(failure.apiCode, 'storage.placement_conflict');
    expect(failure.messageCode, StorageFileMutationMessage.placementConflict);
    expect(failure.statusCode, 409);
  });

  test('Retry-After blocks explicit placement retry before deadline', () async {
    final limited = ApiError(
      type: ApiErrorType.badResponse,
      message: 'Poczekaj przed ponowieniem.',
      statusCode: 429,
      apiCode: 'storage.rate_limited',
      retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 2)),
    );
    stubPlacements(Right([placement(version: 7)]));
    when(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => Left(limited));

    await cubit.moveFileToFolder(
      fileId: fileId,
      targetFolderId: targetFolderId,
      sourceFolderId: sourceFolderId,
    );
    await cubit.retryPlacementMove();

    expect((cubit.state as StorageFileMutationFailure).apiError, limited);
    verify(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).called(1);
  });

  test('ponowienie używa tego samego klucza idempotencji', () async {
    stubPlacements(Right([placement(version: 7)]));
    when(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => Left(conflict()));

    await cubit.moveFileToFolder(
      fileId: fileId,
      targetFolderId: targetFolderId,
      sourceFolderId: sourceFolderId,
    );
    await cubit.retryPlacementMove();

    final keys = verify(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: captureAny(named: 'idempotencyKey'),
      ),
    ).captured;
    // Powtórka tej samej intencji nie może wyglądać na drugie przeniesienie.
    expect(keys, hasLength(2));
    expect(keys[0], keys[1]);
  });

  test('nowa intencja dostaje nowy klucz idempotencji', () async {
    stubPlacements(Right([placement(version: 7)]));
    when(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => Right(placement(version: 8)));

    await cubit.moveFileToFolder(
      fileId: fileId,
      targetFolderId: targetFolderId,
      sourceFolderId: sourceFolderId,
    );
    await cubit.moveFileToFolder(
      fileId: fileId,
      targetFolderId: 'folder-inny',
      sourceFolderId: sourceFolderId,
    );

    final keys = verify(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: captureAny(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: captureAny(named: 'idempotencyKey'),
      ),
    ).captured;
    // captured: target, key, target, key
    expect(keys[0], isNot(equals(keys[2])));
    expect(keys[1], isNot(equals(keys[3])));
  });

  test(
    'placement bez wersji jest konfliktem, a nie cichym utworzeniem duplikatu',
    () async {
      stubPlacements(Right([placement()]));

      await cubit.moveFileToFolder(
        fileId: fileId,
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
      );

      final failure = cubit.state as StorageFileMutationFailure;
      expect(failure.messageCode, StorageFileMutationMessage.placementConflict);
      verifyNever(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
      verifyNever(
        () => repository.createFilePlacement(
          fileId: any(named: 'fileId'),
          folderId: any(named: 'folderId'),
        ),
      );
    },
  );

  test('błąd odczytu placementów przerywa przenoszenie', () async {
    stubPlacements(
      const Left(
        ApiError(type: ApiErrorType.connection, message: 'Brak sieci.'),
      ),
    );

    await cubit.moveFileToFolder(
      fileId: fileId,
      targetFolderId: targetFolderId,
      sourceFolderId: sourceFolderId,
    );

    expect(cubit.state, isA<StorageFileMutationFailure>());
    expect(
      (cubit.state as StorageFileMutationFailure).message,
      'Brak sieci.',
    );
    verifyNever(
      () => repository.createFilePlacement(
        fileId: any(named: 'fileId'),
        folderId: any(named: 'folderId'),
      ),
    );
  });

  test('przeniesienie częściowe zachowuje pełny błąd API', () async {
    final error = ApiError(
      type: ApiErrorType.conflict,
      message: 'Konflikt wersji placementu.',
      statusCode: 409,
      backendCode: 54,
      apiCode: 'storage.placement_conflict',
      contractCode: 'storage.placement_conflict',
      fields: const {
        'version': ['Odśwież folder.'],
      },
      traceId: 'placement-partial-trace',
      retryAfterUtc: DateTime.utc(2026, 10, 1, 12),
    );
    when(() => repository.listFolderPlacements(any())).thenAnswer(
      (_) async => Right([
        placement(version: 7),
        StorageFilePlacementResponse(
          id: 'placement-2',
          fileId: 'file-2',
          folderId: sourceFolderId,
          createdAtUtc: DateTime.utc(2026, 9, 20),
          version: 9,
        ),
      ]),
    );
    when(
      () => repository.moveFilePlacement(
        placementId: any(named: 'placementId'),
        targetFolderId: any(named: 'targetFolderId'),
        expectedVersion: any(named: 'expectedVersion'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((invocation) async {
      final id = invocation.namedArguments[#placementId] as String;
      return id == 'placement-1' ? Right(placement(version: 8)) : Left(error);
    });

    await cubit.moveFilesToFolder(
      fileIds: [fileId, 'file-2'],
      targetFolderId: targetFolderId,
      sourceFolderId: sourceFolderId,
    );

    final state = cubit.state;
    expect(state, isA<StorageFileMutationPartialSuccess>());
    final partial = state as StorageFileMutationPartialSuccess;
    expect(partial.succeededIds, [fileId]);
    expect(partial.failedIds, ['file-2']);
    expect(partial.apiError, error);
    expect(partial.apiError?.contractCode, error.contractCode);
    expect(partial.apiError?.fields, error.fields);
    expect(partial.apiError?.traceId, error.traceId);
    expect(partial.apiError?.retryAfterUtc, error.retryAfterUtc);
  });

  test(
    '429 bez Retry-After zatrzymuje batch i oznacza pominięte pliki',
    () async {
      const error = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Limit żądań.',
        statusCode: 429,
        apiCode: 'storage.rate_limited',
        traceId: 'rate-limit-trace',
      );
      when(() => repository.listFolderPlacements(any())).thenAnswer(
        (_) async => Right([
          placement(version: 1),
          StorageFilePlacementResponse(
            id: 'placement-2',
            fileId: 'file-2',
            folderId: sourceFolderId,
            createdAtUtc: DateTime.utc(2026, 9, 20),
            version: 1,
          ),
          StorageFilePlacementResponse(
            id: 'placement-3',
            fileId: 'file-3',
            folderId: sourceFolderId,
            createdAtUtc: DateTime.utc(2026, 9, 20),
            version: 1,
          ),
        ]),
      );
      when(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => const Left(error));

      await cubit.moveFilesToFolder(
        fileIds: [fileId, 'file-2', 'file-3'],
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
      );

      final failure = cubit.state as StorageFileMutationFailure;
      expect(failure.apiErrorsById, {fileId: error});
      expect(failure.notAttemptedIds, ['file-2', 'file-3']);
      verify(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).called(1);
    },
  );

  test(
    'future Retry-After preserves prior success and remaining IDs',
    () async {
      final error = ApiError(
        type: ApiErrorType.badResponse,
        message: 'Poczekaj przed kolejnym żądaniem.',
        statusCode: 503,
        apiCode: 'storage.temporarily_unavailable',
        traceId: 'retry-after-trace',
        retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 2)),
      );
      when(() => repository.listFolderPlacements(any())).thenAnswer(
        (_) async => Right([
          placement(version: 1),
          StorageFilePlacementResponse(
            id: 'placement-2',
            fileId: 'file-2',
            folderId: sourceFolderId,
            createdAtUtc: DateTime.utc(2026, 9, 20),
            version: 1,
          ),
          StorageFilePlacementResponse(
            id: 'placement-3',
            fileId: 'file-3',
            folderId: sourceFolderId,
            createdAtUtc: DateTime.utc(2026, 9, 20),
            version: 1,
          ),
        ]),
      );
      when(
        () => repository.moveFilePlacement(
          placementId: any(named: 'placementId'),
          targetFolderId: any(named: 'targetFolderId'),
          expectedVersion: any(named: 'expectedVersion'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((invocation) async {
        final id = invocation.namedArguments[#placementId] as String;
        return id == 'placement-1' ? Right(placement(version: 2)) : Left(error);
      });

      await cubit.moveFilesToFolder(
        fileIds: [fileId, 'file-2', 'file-3'],
        targetFolderId: targetFolderId,
        sourceFolderId: sourceFolderId,
      );

      final partial = cubit.state as StorageFileMutationPartialSuccess;
      expect(partial.succeededIds, [fileId]);
      expect(partial.failedIds, ['file-2']);
      expect(partial.notAttemptedIds, ['file-3']);
      expect(partial.apiErrorsById, {'file-2': error});
    },
  );
  test('thrown API error preserves completed move and remaining IDs', () async {
    final error = ApiError(
      type: ApiErrorType.badResponse,
      message: 'Serwer wymaga odczekania.',
      statusCode: 503,
      contractCode: 'storage.temporarily_unavailable',
      traceId: 'thrown-move-trace',
      fields: const {
        'targetFolderId': ['Spróbuj później'],
      },
      retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 2)),
    );
    when(
      () => repository.createFilePlacement(
        fileId: any(named: 'fileId'),
        folderId: any(named: 'folderId'),
      ),
    ).thenAnswer((invocation) async {
      if (invocation.namedArguments[#fileId] == fileId) {
        return Right(placement(version: 2));
      }
      return Future.error(error);
    });
    await cubit.moveFilesToFolder(
      fileIds: [fileId, 'file-2', 'file-3'],
      targetFolderId: targetFolderId,
    );
    expect(cubit.state, isA<StorageFileMutationPartialSuccess>());
    final partial = cubit.state as StorageFileMutationPartialSuccess;
    expect(partial.succeededIds, [fileId]);
    expect(partial.failedIds, ['file-2']);
    expect(partial.notAttemptedIds, ['file-3']);
    expect(partial.apiErrorsById, {'file-2': error});
    verifyNever(
      () => repository.createFilePlacement(
        fileId: 'file-3',
        folderId: any(named: 'folderId'),
      ),
    );
  });
}
