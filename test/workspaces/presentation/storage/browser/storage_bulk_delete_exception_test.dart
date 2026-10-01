import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

final class _Download extends Mock implements DownloadTransport {}

void main() {
  for (final isFolder in [false, true]) {
    test(
      'bulk delete retains successes after thrown API error: folder=$isFolder',
      () async {
        final repository = _Repository();
        final error = ApiError(
          type: ApiErrorType.badResponse,
          message: 'Serwer wymaga odczekania.',
          statusCode: 503,
          contractCode: 'storage.temporarily_unavailable',
          traceId: 'delete-trace',
          fields: const {
            'fileId': ['Spróbuj później'],
          },
          retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 1)),
        );
        when(() => repository.deleteFile(any())).thenAnswer((invocation) {
          final id = invocation.positionalArguments.single;
          return id == 'first'
              ? Future.value(const Right(unit))
              : Future.error(error);
        });
        when(() => repository.deleteFolder(any())).thenAnswer((invocation) {
          final id = invocation.positionalArguments.single;
          return id == 'first'
              ? Future.value(const Right(unit))
              : Future.error(error);
        });
        final cubit = StorageFileMutationCubit(
          repository: repository,
          downloadTransport: _Download(),
        );
        addTearDown(cubit.close);
        await cubit.bulkDelete(
          fileIds: isFolder
              ? const []
              : const ['first', 'failure', 'remaining'],
          folderIds: isFolder
              ? const ['first', 'failure', 'remaining']
              : const [],
        );
        expect(cubit.state, isA<StorageFileMutationPartialSuccess>());
        final state = cubit.state as StorageFileMutationPartialSuccess;
        expect(state.succeededIds, ['first']);
        expect(state.failedIds, ['failure']);
        expect(state.notAttemptedIds, ['remaining']);
        expect(state.apiErrorsById, {'failure': error});
        verifyNever(() => repository.deleteFile('remaining'));
        verifyNever(() => repository.deleteFolder('remaining'));
      },
    );
  }

  test(
    'uncertain transport failure stops batch without hiding prior success',
    () async {
      final repository = _Repository();
      when(() => repository.deleteFile(any())).thenAnswer((invocation) {
        if (invocation.positionalArguments.single == 'first') {
          return Future.value(const Right(unit));
        }
        return Future.error(
          DioException(
            requestOptions: RequestOptions(path: '/files/failure'),
            type: DioExceptionType.receiveTimeout,
          ),
        );
      });
      final cubit = StorageFileMutationCubit(
        repository: repository,
        downloadTransport: _Download(),
      );
      addTearDown(cubit.close);
      await cubit.bulkDelete(fileIds: const ['first', 'failure', 'remaining']);
      expect(cubit.state, isA<StorageFileMutationPartialSuccess>());
      final state = cubit.state as StorageFileMutationPartialSuccess;
      expect(state.succeededIds, ['first']);
      expect(state.failedIds, ['failure']);
      expect(state.notAttemptedIds, ['remaining']);
      expect(state.apiError?.type, ApiErrorType.receiveTimeout);
      verifyNever(() => repository.deleteFile('remaining'));
    },
  );
}
