import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';

import 'package:ready_next/workspaces/presentation/storage/cubit/storage_file_details_state.dart';

/// Ładuje szczegóły jednego pliku Storage dla trasy deep-link.
final class StorageFileDetailsCubit extends Cubit<StorageFileDetailsState> {
  StorageFileDetailsCubit({
    required this._repository,
    required this.fileId,
  }) : super(const StorageFileDetailsInitial());

  final StorageRepository _repository;
  final String fileId;

  /// Pobiera dane ponownie po błędzie lub odświeżeniu widoku.
  Future<void> load() async {
    emit(const StorageFileDetailsLoading());
    final result = await _repository.getFileDetails(fileId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        StorageFileDetailsFailure(
          message: error.message,
          backendCode: error.backendCode,
        ),
      ),
      (details) => emit(StorageFileDetailsLoaded(details)),
    );
  }
}
