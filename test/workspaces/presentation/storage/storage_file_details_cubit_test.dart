import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/features/settings/application/current_user_avatar_cubit.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/cubit/storage_file_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/cubit/storage_file_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _StorageRepository implements StorageRepository {
  _StorageRepository(this.result, {this.avatarResult});

  final Either<ApiError, StorageFileDetailsResponse> result;
  final Either<ApiError, StorageFileResponse>? avatarResult;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<ApiError, StorageFileDetailsResponse>> getFileDetails(
    String fileId,
  ) async => result;

  @override
  Future<Either<ApiError, StorageFileResponse>> completeUpload({
    required String fileId,
    required int fileSizeBytes,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> deleteCurrentUserAvatar() =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, StorageFileResponse>> getCurrentUserAvatar() =>
      Future.value(avatarResult ?? (throw UnimplementedError()));

  @override
  Future<Either<ApiError, StorageDownloadTicketResponse>> getDownloadTicket(
    String fileId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, StorageUploadTicketResponse>>
  requestAvatarUploadTicket(StorageUploadTicketItemPayload payload) =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, StorageFileResponse>> setCurrentUserAvatar(
    String fileId,
  ) => throw UnimplementedError();
}

class _UploadTransport implements TaskAttachmentUploadTransport {
  @override
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
  }) => throw UnimplementedError();
}

void main() {
  blocTest<StorageFileDetailsCubit, StorageFileDetailsState>(
    'pokazuje kod backendu zamiast ukrywać błąd deep-linku pliku',
    build: () => StorageFileDetailsCubit(
      repository: _StorageRepository(
        const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'Brak dostępu do pliku.',
            backendCode: 403,
          ),
        ),
      ),
      fileId: 'file-1',
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<StorageFileDetailsLoading>(),
      isA<StorageFileDetailsFailure>().having(
        (state) => state.backendCode,
        'backendCode',
        403,
      ),
    ],
  );

  blocTest<CurrentUserAvatarCubit, CurrentUserAvatarState>(
    'brak avatara przełącza profil na bezpieczny fallback inicjałów',
    build: () => CurrentUserAvatarCubit(
      storageRepository: _StorageRepository(
        const Left(
          ApiError(
            type: ApiErrorType.unknown,
            message: 'Nie dotyczy tego testu.',
          ),
        ),
        avatarResult: const Left(
          ApiError(type: ApiErrorType.notFound, message: 'Brak avatara.'),
        ),
      ),
      uploadTransport: _UploadTransport(),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<CurrentUserAvatarLoading>(),
      isA<CurrentUserAvatarReady>().having(
        (state) => state.avatarUrl,
        'avatarUrl',
        isNull,
      ),
    ],
  );

  blocTest<CurrentUserAvatarCubit, CurrentUserAvatarState>(
    'czyści stan avatara podczas zakończenia sesji',
    build: () => CurrentUserAvatarCubit(
      storageRepository: _StorageRepository(
        const Left(
          ApiError(
            type: ApiErrorType.unknown,
            message: 'Nie dotyczy tego testu.',
          ),
        ),
        avatarResult: const Left(
          ApiError(type: ApiErrorType.notFound, message: 'Brak avatara.'),
        ),
      ),
      uploadTransport: _UploadTransport(),
    ),
    act: (cubit) async {
      await cubit.load();
      cubit.clear();
    },
    expect: () => [
      isA<CurrentUserAvatarLoading>(),
      isA<CurrentUserAvatarReady>(),
      isA<CurrentUserAvatarInitial>(),
    ],
  );
}
