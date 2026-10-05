import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_share_recipient_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_share_directory_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Debounce i generation należą do wyszukiwania, nie do cyklu build dialogu.
final class StorageShareDirectoryCubit
    extends Cubit<StorageShareDirectoryState> {
  StorageShareDirectoryCubit({
    required this.directory,
  }) : super(const StorageShareDirectoryIdle());

  final StorageShareRecipientDirectoryPort directory;
  Timer? _debounce;
  int _generation = 0;
  int? _loadingGeneration;
  String _query = '';
  DateTime? _retryAfterUtc;
  ApiError? _retryAfterError;

  void search(String value) {
    if (isClosed) return;
    _query = value.trim();
    final generation = ++_generation;
    _debounce?.cancel();
    if (_query.length < 2) {
      emit(const StorageShareDirectoryIdle());
      return;
    }
    if (_isCoolingDown) {
      emit(
        StorageShareDirectoryFailure(
          query: _query,
          error: _retryAfterError ?? _unexpectedError(),
        ),
      );
      return;
    }
    emit(StorageShareDirectoryLoading(_query));
    _debounce = Timer(const Duration(milliseconds: 250), () {
      unawaited(_load(_query, generation));
    });
  }

  Future<void> retry() {
    if (isClosed || _query.length < 2 || _isCoolingDown) {
      return Future<void>.value();
    }
    _debounce?.cancel();
    final generation = ++_generation;
    emit(StorageShareDirectoryLoading(_query));
    return _load(_query, generation);
  }

  Future<void> _load(String query, int generation) async {
    if (!_isCurrent(generation) || _loadingGeneration == generation) return;
    if (_isCoolingDown) {
      emit(
        StorageShareDirectoryFailure(
          query: query,
          error: _retryAfterError ?? _unexpectedError(),
        ),
      );
      return;
    }
    _loadingGeneration = generation;
    try {
      final result = await directory.search(
        query: query,
      );
      final responseError = result.fold<ApiError?>(
        (error) => error,
        (_) => null,
      );
      _recordRetryAfter(responseError);
      if (!_isCurrent(generation)) return;
      result.fold(
        (error) =>
            emit(StorageShareDirectoryFailure(query: query, error: error)),
        (users) => emit(StorageShareDirectoryReady(query: query, users: users)),
      );
    } on Object catch (error) {
      final apiError = _errorFromThrown(error);
      _recordRetryAfter(apiError);
      if (!_isCurrent(generation)) return;
      emit(
        StorageShareDirectoryFailure(
          query: query,
          error: apiError,
        ),
      );
    } finally {
      if (_loadingGeneration == generation) _loadingGeneration = null;
    }
  }

  bool _isCurrent(int generation) =>
      !isClosed && generation == _generation && _query.length >= 2;

  bool get _isCoolingDown {
    final deadline = _retryAfterUtc;
    return deadline != null && DateTime.now().toUtc().isBefore(deadline);
  }

  void _recordRetryAfter(ApiError? error) {
    final deadline = error?.retryAfterUtc?.toUtc();
    if (deadline == null || !deadline.isAfter(DateTime.now().toUtc())) return;
    final current = _retryAfterUtc;
    if (current != null && !deadline.isAfter(current)) return;
    _retryAfterUtc = deadline;
    _retryAfterError = error;
  }

  ApiError _errorFromThrown(Object error) => switch (error) {
    final ApiError apiError => apiError,
    final DioException dioError => ApiError.fromDioException(
      dioError,
      fallbackMessage: '',
    ),
    _ => _unexpectedError(),
  };

  ApiError _unexpectedError() => const ApiError(
    type: ApiErrorType.unknown,
    message: '',
    apiCode: 'storage.directory_unexpected_error',
  );

  @override
  Future<void> close() {
    _generation++;
    _debounce?.cancel();
    return super.close();
  }
}
