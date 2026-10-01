import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements StorageRepository {}

void main() {
  test('closed Office owner never starts another request', () async {
    final repository = _Repository();
    final cubit = StorageOfficeCubit(fileId: 'file', repository: repository);
    await cubit.close();
    await cubit.initSession();
    verifyNever(() => repository.getOfficeSession(any()));
  });

  test(
    'Office failure retains full API error and blocks early retry',
    () async {
      final repository = _Repository();
      final error = ApiError(
        type: ApiErrorType.server,
        message: 'Busy office',
        statusCode: 503,
        apiCode: 'office_busy',
        contractCode: 'storage_office_busy',
        traceId: 'office-trace',
        fields: const {
          'fileId': ['Still processing'],
        },
        retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 1)),
      );
      when(() => repository.getOfficeSession('file'))
          .thenAnswer((_) async => Left(error));
      final cubit = StorageOfficeCubit(fileId: 'file', repository: repository);
      addTearDown(cubit.close);
      await cubit.initSession();
      expect((cubit.state as StorageOfficeFailure).error, same(error));
      await cubit.initSession();
      verify(() => repository.getOfficeSession('file')).called(1);
    },
  );

  test('closeSession invalidates a pending session result', () async {
    final repository = _Repository();
    final pending = Completer<Either<ApiError, OnlyOfficeSessionResponse>>();
    when(() => repository.getOfficeSession('file'))
        .thenAnswer((_) => pending.future);
    final cubit = StorageOfficeCubit(fileId: 'file', repository: repository);
    addTearDown(cubit.close);
    final request = cubit.initSession();
    cubit.closeSession();
    pending.complete(
      const Left(ApiError(type: ApiErrorType.connection, message: 'late')),
    );
    await request;
    expect(cubit.state, isA<StorageOfficeInitial>());
  });

  test('older Office request cannot replace a later session failure', () async {
    final repository = _Repository();
    final old = Completer<Either<ApiError, OnlyOfficeSessionResponse>>();
    final next = Completer<Either<ApiError, OnlyOfficeSessionResponse>>();
    var calls = 0;
    when(() => repository.getOfficeSession('file'))
        .thenAnswer((_) => ++calls == 1 ? old.future : next.future);
    final cubit = StorageOfficeCubit(fileId: 'file', repository: repository);
    addTearDown(cubit.close);
    final first = cubit.initSession();
    cubit.closeSession();
    final second = cubit.initSession();
    next.complete(
      const Left(ApiError(type: ApiErrorType.forbidden, message: 'current')),
    );
    await second;
    old.complete(
      const Left(ApiError(type: ApiErrorType.connection, message: 'stale')),
    );
    await first;
    expect((cubit.state as StorageOfficeFailure).message, 'current');
  });
}
