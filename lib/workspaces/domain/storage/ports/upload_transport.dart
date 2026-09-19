import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

/// Callback raportujący postęp wysyłki pojedynczego pliku.
typedef OnStorageUploadProgress = void Function(int sentBytes, int totalBytes);

/// Platform-neutral cancellation handle owned by the upload port.
final class UploadCancellationToken {
  bool _isCancelled = false;
  final List<void Function()> _listeners = [];

  /// Whether cancellation has already been requested.
  bool get isCancelled => _isCancelled;

  /// Requests cancellation and notifies the transport adapter once.
  void cancel() {
    if (_isCancelled) return;
    _isCancelled = true;
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }

  /// Subscribes a transport adapter to cancellation.
  void addListener(void Function() listener) {
    if (_isCancelled) {
      listener();
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a transport adapter subscription.
  void removeListener(void Function() listener) => _listeners.remove(listener);
}

/// Abstrakcja transportu binarnych danych do S3/MinIO przez bilet presigned URL.
// ignore: one_member_abstracts
abstract interface class UploadTransport {
  /// Wysyła zawartość pliku do S3/MinIO z raportowaniem postępu i możliwością anulowania.
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required StorageUploadInput input,
    OnStorageUploadProgress? onProgress,
    UploadCancellationToken? cancelToken,
  });
}
