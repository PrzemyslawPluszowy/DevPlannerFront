import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';

/// Jawne stany szczegółu pliku, bez ukrywania błędów backendu.
sealed class StorageFileDetailsState {
  const StorageFileDetailsState();
}

final class StorageFileDetailsInitial extends StorageFileDetailsState {
  const StorageFileDetailsInitial();
}

final class StorageFileDetailsLoading extends StorageFileDetailsState {
  const StorageFileDetailsLoading();
}

final class StorageFileDetailsLoaded extends StorageFileDetailsState {
  const StorageFileDetailsLoaded(this.details);

  final StorageFileDetailsResponse details;
}

final class StorageFileDetailsFailure extends StorageFileDetailsState {
  const StorageFileDetailsFailure({required this.message, this.backendCode});

  final String message;
  final Object? backendCode;
}
