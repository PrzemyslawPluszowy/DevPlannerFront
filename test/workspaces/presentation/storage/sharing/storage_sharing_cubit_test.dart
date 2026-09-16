import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';

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
}
