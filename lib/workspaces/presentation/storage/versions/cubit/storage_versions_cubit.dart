import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ładuje, pobiera i przywraca wersje jednego pliku.
final class StorageVersionsCubit extends Cubit<StorageVersionsState> {
  StorageVersionsCubit({
    required this.fileId,
    required this.fileName,
    required this.expectedVersion,
    required this._repository,
    required this._downloadTransport,
  }) : super(const StorageVersionsInitial());

  final String fileId;
  final String fileName;
  final int expectedVersion;
  final StorageRepository _repository;
  final DownloadTransport _downloadTransport;

  Future<void> load() async {
    emit(const StorageVersionsLoading());
    final result = await _repository.listFileVersions(fileId);
    if (isClosed) return;
    result.fold(
      (error) => emit(StorageVersionsFailure(error.message)),
      (versions) => emit(StorageVersionsReady(versions: versions)),
    );
  }

  Future<void> download(int version) async {
    final current = state;
    if (current is! StorageVersionsReady || current.busyVersion != null) return;
    emit(current.copyWith(busyVersion: version));
    final ticketResult = await _repository.getFileVersionDownloadTicket(
      fileId: fileId,
      version: version,
    );
    if (isClosed) return;
    final ticket = ticketResult.fold(
      (error) {
        emit(StorageVersionsFailure(error.message));
        return null;
      },
      (value) => value,
    );
    if (ticket == null || isClosed) return;
    final result = await _downloadTransport.downloadUrl(
      downloadUrl: ticket.downloadUrl,
      fileName: 'v$version-$fileName',
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(StorageVersionsFailure(error.message)),
      (_) => emit(current.copyWith(clearBusy: true)),
    );
  }

  Future<bool> restore(int version) async {
    final current = state;
    if (current is! StorageVersionsReady || current.busyVersion != null) {
      return false;
    }
    emit(current.copyWith(busyVersion: version));
    final result = await _repository.restoreFileVersion(
      fileId: fileId,
      version: version,
      expectedVersion: expectedVersion,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(StorageVersionsFailure(error.message));
        return false;
      },
      (_) {
        emit(current.copyWith(clearBusy: true));
        return true;
      },
    );
  }
}
