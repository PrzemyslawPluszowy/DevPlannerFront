import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';

/// Status pojedynczego elementu w kolejce uploadu.
enum StorageUploadItemStatus {
  /// Oczekuje w kolejce na wolny slot wysyłki.
  queued,

  /// Trwa binarny transfer danych do S3/MinIO.
  uploading,

  /// Trwa rejestracja i zatwierdzanie pliku w backendzie.
  completing,

  /// Plik został pomyślnie wysłany i zatwierdzony.
  done,

  /// Wystąpił błąd podczas wysyłki lub zatwierdzania.
  failed,

  /// Wysyłka została anulowana przez użytkownika.
  cancelled,
}

/// Lokalizowalny komunikat wygenerowany przez klienta kolejki uploadu.
enum StorageUploadMessage {
  fileTooLarge,
  cancelledByUser,
  uploadCancelled,
  unsupportedScope,
  ticketReservationFailed,
  transferFailed,
  completionFailed,
  placementFailed,
}

/// Element kolejki uploadu plików.
class StorageUploadQueueItem extends Equatable {
  /// Tworzy element kolejki uploadu.
  const StorageUploadQueueItem({
    required this.id,
    required this.input,
    this.status = StorageUploadItemStatus.queued,
    this.progress = 0.0,
    this.bytesSent = 0,
    this.totalBytes = 0,
    this.uploadedFile,
    this.errorMessage,
    this.errorCode,
    this.cancelToken,
  });

  /// Lokalny identyfikator wpisu w kolejce.
  final String id;

  /// Dane wejściowe pliku.
  final StorageUploadInput input;

  /// Aktualny status wysyłki.
  final StorageUploadItemStatus status;

  /// Postęp od 0.0 do 1.0.
  final double progress;

  /// Liczba przesłanych bajtów.
  final int bytesSent;

  /// Łączny rozmiar w bajtach.
  final int totalBytes;

  /// Zatwierdzony plik zwrócony przez backend po zakończeniu.
  final StorageFileResponse? uploadedFile;

  /// Komunikat błędu, jeśli status to failed.
  final String? errorMessage;

  /// Kod komunikatu klienta; komunikaty backendu pozostają w `errorMessage`.
  final StorageUploadMessage? errorCode;

  /// Token anulowania powiązany z transferem Dio.
  final CancelToken? cancelToken;

  /// Czy element jest w trakcie aktywnej wysyłki.
  bool get isActive =>
      status == StorageUploadItemStatus.queued ||
      status == StorageUploadItemStatus.uploading ||
      status == StorageUploadItemStatus.completing;

  /// Kopia z zaktualizowanymi polami.
  StorageUploadQueueItem copyWith({
    StorageUploadItemStatus? status,
    double? progress,
    int? bytesSent,
    int? totalBytes,
    StorageFileResponse? uploadedFile,
    String? errorMessage,
    StorageUploadMessage? errorCode,
    CancelToken? cancelToken,
    bool clearCancelToken = false,
  }) => StorageUploadQueueItem(
    id: id,
    input: input,
    status: status ?? this.status,
    progress: progress ?? this.progress,
    bytesSent: bytesSent ?? this.bytesSent,
    totalBytes: totalBytes ?? this.totalBytes,
    uploadedFile: uploadedFile ?? this.uploadedFile,
    errorMessage: errorMessage ?? this.errorMessage,
    errorCode: errorCode ?? this.errorCode,
    cancelToken: clearCancelToken ? null : (cancelToken ?? this.cancelToken),
  );

  @override
  List<Object?> get props => [
    id,
    status,
    progress,
    bytesSent,
    totalBytes,
    uploadedFile,
    errorMessage,
    errorCode,
  ];
}

/// Stan kolejki uploadu w module Storage.
class StorageUploadState extends Equatable {
  /// Tworzy stan kolejki.
  const StorageUploadState({
    this.items = const [],
    this.isExpanded = false,
  });

  /// Wszystkie elementy w kolejce.
  final List<StorageUploadQueueItem> items;

  /// Czy panel kolejki jest rozwinięty w UI.
  final bool isExpanded;

  /// Liczba aktywnych uploadów.
  int get activeCount => items.where((i) => i.isActive).length;

  /// Liczba pomyślnie wysłanych plików.
  int get completedCount =>
      items.where((i) => i.status == StorageUploadItemStatus.done).length;

  /// Liczba nieudanych plików.
  int get failedCount =>
      items.where((i) => i.status == StorageUploadItemStatus.failed).length;

  /// Czy kolejka zawiera jakiekolwiek elementy.
  bool get hasItems => items.isNotEmpty;

  /// Czy cokolwiek jest aktywnie wysyłane.
  bool get isUploading => activeCount > 0;

  /// Zbiorczy postęp całej kolejki (0.0 do 1.0).
  double get totalProgress {
    if (items.isEmpty) return 0.0;
    final total = items.fold<double>(0.0, (sum, item) => sum + item.progress);
    return (total / items.length).clamp(0.0, 1.0);
  }

  /// Tworzy kopię z zaktualizowanymi polami.
  StorageUploadState copyWith({
    List<StorageUploadQueueItem>? items,
    bool? isExpanded,
  }) => StorageUploadState(
    items: items ?? this.items,
    isExpanded: isExpanded ?? this.isExpanded,
  );

  @override
  List<Object?> get props => [items, isExpanded];
}
