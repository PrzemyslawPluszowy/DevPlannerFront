import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late _MockStorageRepository repository;

  setUpAll(() {
    registerFallbackValue(
      const CreateStorageFileSharePayload(
        shareType: StorageShareType.user,
        accessLevel: StorageShareAccessLevel.reader,
      ),
    );
  });

  setUp(() {
    repository = _MockStorageRepository();
  });

  final now = DateTime.utc(2026, 9, 9, 12);
  final sampleShare = StorageFileShareResponse(
    id: 'share-1',
    fileId: 'file-1',
    shareType: StorageShareType.user,
    accessLevel: StorageShareAccessLevel.editor,
    sharedWithUserId: 'user-2',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    effectiveAccessLevel: StorageEffectiveAccessLevel.editor,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: false,
  );

  test('loadShares emituje Ready z listą grantów', () async {
    when(() => repository.listFileShares('file-1'))
        .thenAnswer((_) async => Right([sampleShare]));

    final cubit = StorageSharingCubit(fileId: 'file-1', repository: repository);
    await cubit.loadShares();

    expect(cubit.state, isA<StorageSharingReady>());
    final state = cubit.state as StorageSharingReady;
    expect(state.shares.length, equals(1));
    expect(state.shares.first.id, equals('share-1'));

    await cubit.close();
  });

  test('shareWithUser dodaje grant do listy', () async {
    when(() => repository.listFileShares('file-1'))
        .thenAnswer((_) async => const Right([]));
    when(
      () => repository.createFileShare(
        fileId: 'file-1',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => Right(sampleShare));

    final cubit = StorageSharingCubit(fileId: 'file-1', repository: repository);
    await cubit.loadShares();

    final success = await cubit.shareWithUser(
      targetUserId: 'user-2',
      accessLevel: StorageShareAccessLevel.editor,
    );

    expect(success, isTrue);
    final state = cubit.state as StorageSharingReady;
    expect(state.shares.length, equals(1));

    await cubit.close();
  });

  test('revokeShare usuwa grant z listy', () async {
    when(() => repository.listFileShares('file-1'))
        .thenAnswer((_) async => Right([sampleShare]));
    when(
      () => repository.deleteFileShare(
        fileId: 'file-1',
        shareId: 'share-1',
      ),
    ).thenAnswer((_) async => const Right(unit));

    final cubit = StorageSharingCubit(fileId: 'file-1', repository: repository);
    await cubit.loadShares();

    final success = await cubit.revokeShare('share-1');
    expect(success, isTrue);

    final state = cubit.state as StorageSharingReady;
    expect(state.shares, isEmpty);

    await cubit.close();
  });

  test(
    'błąd mutacji zachowuje dane API i blokuje powtórzenie w cooldownie',
    () async {
      final retryAfter = DateTime.now().toUtc().add(
        const Duration(milliseconds: 120),
      );
      final error = ApiError(
        type: ApiErrorType.validation,
        message: 'Nieprawidłowa relacja.',
        statusCode: 429,
        backendCode: 91,
        apiCode: 'share.denied',
        contractCode: 'share.denied',
        fields: const {
          'accessLevel': ['Niedozwolony poziom.'],
        },
        traceId: 'trace-share-1',
        retryAfterUtc: retryAfter,
      );
      when(() => repository.listFileShares('file-1')).thenAnswer(
        (_) async => Right([sampleShare]),
      );
      when(
        () => repository.createFileShare(
          fileId: 'file-1',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async => Left(error));

      final cubit = StorageSharingCubit(
        fileId: 'file-1',
        repository: repository,
      );
      await cubit.loadShares();
      final first = await cubit.shareWithUser(
        targetUserId: 'user-2',
        accessLevel: StorageShareAccessLevel.editor,
      );
      final second = await cubit.shareWithUser(
        targetUserId: 'user-2',
        accessLevel: StorageShareAccessLevel.editor,
      );

      expect(first, isFalse);
      expect(second, isFalse);
      final state = cubit.state as StorageSharingReady;
      expect(state.shares.single.id, 'share-1');
      expect(state.mutationError, error);
      expect(state.mutationError?.fields['accessLevel'], [
        'Niedozwolony poziom.',
      ]);
      expect(state.mutationError?.traceId, 'trace-share-1');
      verify(
        () => repository.createFileShare(
          fileId: 'file-1',
          payload: any(named: 'payload'),
        ),
      ).called(1);

      await Future<void>.delayed(const Duration(milliseconds: 140));
      when(
        () => repository.createFileShare(
          fileId: 'file-1',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async => Right(sampleShare));
      expect(
        await cubit.shareWithUser(
          targetUserId: 'user-2',
          accessLevel: StorageShareAccessLevel.editor,
        ),
        isTrue,
      );
      await cubit.close();
    },
  );

  test(
    'loadShares respektuje Retry-After również przy bezpośrednim wywołaniu',
    () async {
      var loads = 0;
      final retryAfter = DateTime.now().toUtc().add(
        const Duration(milliseconds: 100),
      );
      when(() => repository.listFileShares('file-1')).thenAnswer((_) async {
        loads++;
        if (loads == 1) {
          return Left(
            ApiError(
              type: ApiErrorType.server,
              message: 'Poczekaj przed kolejnym odczytem.',
              statusCode: 503,
              retryAfterUtc: retryAfter,
            ),
          );
        }
        return const Right(<StorageFileShareResponse>[]);
      });

      final cubit = StorageSharingCubit(
        fileId: 'file-1',
        repository: repository,
      );
      await cubit.loadShares();
      await cubit.loadShares();
      expect(loads, 1);

      await Future<void>.delayed(const Duration(milliseconds: 120));
      await cubit.loadShares();
      expect(loads, 2);
      expect(cubit.state, isA<StorageSharingReady>());
      await cubit.close();
    },
  );
}
