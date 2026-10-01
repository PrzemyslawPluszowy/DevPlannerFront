import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_action_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Coordinates explicit download actions initiated from an active preview.
final class StoragePreviewActionCubit extends Cubit<StoragePreviewActionState> {
  StoragePreviewActionCubit({
    required this._download,
    required this._fallbackErrorMessage,
  }) : super(const StoragePreviewActionReady());

  final Future<ApiError?> Function() _download;
  final String _fallbackErrorMessage;
  int _generation = 0;

  Future<void> download() async {
    if (isClosed || state is StoragePreviewActionDownloading) return;
    final generation = ++_generation;
    emit(const StoragePreviewActionDownloading());

    ApiError? error;
    try {
      error = await _download();
    } catch (_) {
      error = ApiError(
        type: ApiErrorType.unknown,
        message: _fallbackErrorMessage,
      );
    }

    if (isClosed || generation != _generation) return;
    emit(
      error == null
          ? const StoragePreviewActionReady()
          : StoragePreviewActionFailed(error),
    );
  }
}
