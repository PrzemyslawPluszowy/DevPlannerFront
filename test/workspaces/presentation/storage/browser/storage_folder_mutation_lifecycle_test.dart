import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late _MockStorageRepository repository;
  final now = DateTime.utc(2026, 10);

  StorageFolderResponse folder({String name = 'Materiały'}) =>
      StorageFolderResponse(
        id: 'folder-1',
        name: name,
        folderType: StorageFolderType.workspace,
        workspaceId: 'workspace-1',
        canRead: true,
        canComment: true,
        canEdit: true,
        canShare: true,
        canDelete: true,
        itemCount: 0,
        updatedAtUtc: now,
        accessLevel: StorageEffectiveAccessLevel.owner,
      );

  setUp(() => repository = _MockStorageRepository());

  test('zachowuje pełny ApiError i blokuje REST do Retry-After', () async {
    final retryAfter = DateTime.now().toUtc().add(
      const Duration(milliseconds: 100),
    );
    final error = ApiError(
      type: ApiErrorType.conflict,
      message: 'Nazwa jest już zajęta.',
      statusCode: 409,
      backendCode: 44,
      apiCode: 'storage.folder_conflict',
      contractCode: 'storage.folder_conflict',
      fields: const {
        'name': ['Wybierz inną nazwę.'],
      },
      traceId: 'folder-trace-1',
      retryAfterUtc: retryAfter,
    );
    when(
      () => repository.updateFolder(folderId: 'folder-1', name: 'Nowa nazwa'),
    ).thenAnswer((_) async => Left(error));

    final cubit = StorageFolderMutationCubit(repository: repository);
    await cubit.renameFolder(folderId: 'folder-1', newName: ' Nowa nazwa ');
    final failure = cubit.state as StorageFolderMutationFailure;
    expect(failure.error, error);
    expect(failure.error.fields['name'], ['Wybierz inną nazwę.']);
    expect(failure.error.traceId, 'folder-trace-1');
    expect(cubit.canMutate, isFalse);

    await cubit.renameFolder(folderId: 'folder-1', newName: 'Nowa nazwa');
    verify(
      () => repository.updateFolder(folderId: 'folder-1', name: 'Nowa nazwa'),
    ).called(1);

    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(cubit.canMutate, isTrue);
    expect(
      (cubit.state as StorageFolderMutationFailure).retryEnabledRevision,
      1,
    );
    await cubit.close();
  });

  test('DioException zachowuje kontrakt, pola i traceId', () async {
    final request = RequestOptions(path: '/storage/folders/folder-1');
    final dioError = DioException(
      requestOptions: request,
      response: Response<Object?>(
        requestOptions: request,
        statusCode: 409,
        data: const {
          'code': 'storage.folder_conflict',
          'message': 'Konflikt nazwy.',
          'fields': {
            'name': ['Nazwa zajęta.'],
          },
          'traceId': 'folder-trace-dio',
        },
      ),
    );
    when(
      () => repository.updateFolder(folderId: 'folder-1', name: 'Konflikt'),
    ).thenThrow(dioError);

    final cubit = StorageFolderMutationCubit(repository: repository);
    await cubit.renameFolder(folderId: 'folder-1', newName: 'Konflikt');

    final error = (cubit.state as StorageFolderMutationFailure).error;
    expect(error.statusCode, 409);
    expect(error.contractCode, 'storage.folder_conflict');
    expect(error.fields['name'], ['Nazwa zajęta.']);
    expect(error.traceId, 'folder-trace-dio');
    await cubit.close();
  });

  test('druga mutacja w trakcie requestu nie wysyła drugiego REST', () async {
    final response = Completer<Either<ApiError, StorageFolderResponse>>();
    when(
      () => repository.updateFolder(folderId: 'folder-1', name: 'Nowa nazwa'),
    ).thenAnswer((_) => response.future);
    final cubit = StorageFolderMutationCubit(repository: repository);

    final first = cubit.renameFolder(
      folderId: 'folder-1',
      newName: 'Nowa nazwa',
    );
    expect(cubit.canMutate, isFalse);
    await cubit.renameFolder(folderId: 'folder-1', newName: 'Nowa nazwa');
    verify(
      () => repository.updateFolder(folderId: 'folder-1', name: 'Nowa nazwa'),
    ).called(1);

    response.complete(Right(folder(name: 'Nowa nazwa')));
    await first;
    expect(cubit.state, isA<StorageFolderMutationSuccess>());
    await cubit.close();
  });

  test('odpowiedź po close nie emituje stanu', () async {
    final response = Completer<Either<ApiError, StorageFolderResponse>>();
    when(
      () => repository.updateFolder(folderId: 'folder-1', name: 'Nowa nazwa'),
    ).thenAnswer((_) => response.future);
    final cubit = StorageFolderMutationCubit(repository: repository);

    final request = cubit.renameFolder(
      folderId: 'folder-1',
      newName: 'Nowa nazwa',
    );
    await cubit.close();
    response.complete(Right(folder(name: 'Nowa nazwa')));
    await request;

    expect(cubit.state, isA<StorageFolderMutationLoading>());
  });
}
