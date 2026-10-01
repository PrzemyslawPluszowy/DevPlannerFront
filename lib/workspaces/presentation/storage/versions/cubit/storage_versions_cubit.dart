import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wczytuje historię wersji pliku i obsługuje jej operacje.
final class StorageVersionsCubit extends Cubit<StorageVersionsState> {
  StorageVersionsCubit({
    required this.fileId,
    required this.fileName,
    required this.expectedVersion,
    required this.repository,
    required this.downloadTransport,
  }) : super(const StorageVersionsInitial());

  final String fileId;
  final String fileName;
  final int expectedVersion;
  final StorageRepository repository;
  final DownloadTransport downloadTransport;
  int _generation = 0;

  Future<void> load() async {
    if (isClosed || _isBusyOrRefreshing || _retryWindowClosed(state)) return;
    final generation = ++_generation;
    final current = state;
    if (current case final StorageVersionsReady ready) {
      emit(ready.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(const StorageVersionsLoading());
    }

    final result = await _request(() => repository.listFileVersions(fileId));
    if (isClosed || generation != _generation) return;
    result.fold(
      (error) {
        if (current case final StorageVersionsReady ready) {
          emit(
            ready.copyWith(
              isRefreshing: false,
              apiError: error,
              errorOperation: StorageVersionsErrorOperation.load,
            ),
          );
        } else {
          emit(StorageVersionsFailure(error.message, apiError: error));
        }
      },
      (versions) => emit(StorageVersionsReady(versions: versions)),
    );
  }

  Future<void> download(int version) async {
    await downloadWithFeedback(version);
  }

  /// Pobiera wersję i zwraca typowany błąd dla aktywnego podglądu.
  Future<ApiError?> downloadWithFeedback(int version) async {
    if (isClosed) return _localError('storage.action_canceled');
    final current = _readyForAction();
    if (current == null) {
      return _retryError(state) ?? _localError('storage.action_busy');
    }
    final generation = ++_generation;
    emit(current.copyWith(busyVersion: version, clearError: true));

    final ticketResult = await _request(
      () => repository.getFileVersionDownloadTicket(
        fileId: fileId,
        version: version,
      ),
    );
    if (isClosed || generation != _generation) {
      return _localError('storage.action_canceled');
    }
    final ticket = ticketResult.fold(
      (error) => error,
      (value) => value,
    );
    if (ticket is ApiError) {
      _emitOperationError(
        current,
        ticket,
        StorageVersionsErrorOperation.download,
      );
      return ticket;
    }

    if (ticket is! StorageFileVersionDownloadTicketResponse) {
      final error = _localError('storage.action_failed');
      _emitOperationError(
        current,
        error,
        StorageVersionsErrorOperation.download,
      );
      return error;
    }
    final result = await _request(
      () => downloadTransport.downloadUrl(
        downloadUrl: ticket.downloadUrl,
        fileName: 'v$version-$fileName',
      ),
    );
    if (isClosed || generation != _generation) {
      return _localError('storage.action_canceled');
    }
    return result.fold(
      (error) {
        _emitOperationError(
          current,
          error,
          StorageVersionsErrorOperation.download,
        );
        return error;
      },
      (_) {
        emit(current.copyWith(clearBusy: true, clearError: true));
        return null;
      },
    );
  }

  Future<bool> restore(int version) async {
    final current = _readyForAction();
    if (current == null) return false;
    final generation = ++_generation;
    emit(current.copyWith(busyVersion: version, clearError: true));
    final result = await _request(
      () => repository.restoreFileVersion(
        fileId: fileId,
        version: version,
        expectedVersion: expectedVersion,
      ),
    );
    if (isClosed || generation != _generation) return false;
    return result.fold(
      (error) {
        _emitOperationError(
          current,
          error,
          StorageVersionsErrorOperation.restore,
        );
        return false;
      },
      (_) {
        emit(current.copyWith(clearBusy: true, clearError: true));
        return true;
      },
    );
  }

  Future<bool> delete(int version) async {
    final current = _readyForAction();
    if (current == null) return false;
    final generation = ++_generation;
    emit(current.copyWith(busyVersion: version, clearError: true));
    final result = await _request(
      () => repository.deleteFileVersion(
        fileId: fileId,
        version: version,
        expectedVersion: expectedVersion,
      ),
    );
    if (isClosed || generation != _generation) return false;
    final deleted = result.fold(
      (error) {
        _emitOperationError(
          current,
          error,
          StorageVersionsErrorOperation.delete,
        );
        return false;
      },
      (_) {
        emit(current.copyWith(clearBusy: true, clearError: true));
        return true;
      },
    );
    if (deleted) await load();
    return deleted;
  }

  ApiError _localError(String code) => ApiError(
    type: code == 'storage.action_canceled'
        ? ApiErrorType.canceled
        : ApiErrorType.unknown,
    message: code,
    apiCode: code,
    contractCode: code,
  );

  /// Każda gałąź normalizuje wyjątek przed aktualizacją lokalnego stanu.
  Future<Either<ApiError, T>> _request<T>(
    Future<Either<ApiError, T>> Function() action,
  ) async {
    try {
      return await action();
    } on ApiError catch (error) {
      return Left(error);
    } on DioException catch (error) {
      return Left(
        ApiError.fromDioException(
          error,
          fallbackMessage: 'Nie udało się wykonać operacji na wersjach pliku.',
        ),
      );
    } catch (_) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się potwierdzić wyniku operacji. Odśwież historię wersji.',
          apiCode: 'storage.action_failed',
          contractCode: 'storage.action_failed',
        ),
      );
    }
  }

  StorageVersionsReady? _readyForAction() {
    if (isClosed) return null;
    final current = state;
    return current is StorageVersionsReady &&
            current.busyVersion == null &&
            !current.isRefreshing &&
            !_retryWindowClosed(current)
        ? current
        : null;
  }

  bool get _isBusyOrRefreshing {
    final current = state;
    return current is StorageVersionsLoading ||
        (current is StorageVersionsReady &&
            (current.busyVersion != null || current.isRefreshing));
  }

  bool _retryWindowClosed(StorageVersionsState state) {
    final error = switch (state) {
      StorageVersionsReady(:final apiError) => apiError,
      StorageVersionsFailure(:final apiError) => apiError,
      _ => null,
    };
    final retryAfter = error?.retryAfterUtc;
    return retryAfter != null && retryAfter.isAfter(DateTime.now().toUtc());
  }

  ApiError? _retryError(StorageVersionsState state) => switch (state) {
    StorageVersionsReady(:final apiError) => apiError,
    StorageVersionsFailure(:final apiError) => apiError,
    _ => null,
  };

  void _emitOperationError(
    StorageVersionsReady current,
    ApiError error,
    StorageVersionsErrorOperation operation,
  ) {
    emit(
      current.copyWith(
        clearBusy: true,
        apiError: error,
        errorOperation: operation,
      ),
    );
  }
}
