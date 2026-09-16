import 'package:equatable/equatable.dart';

sealed class StoragePublicShareState extends Equatable {
  const StoragePublicShareState();

  @override
  List<Object?> get props => [];
}

final class StoragePublicShareInitial extends StoragePublicShareState {
  const StoragePublicShareInitial();
}

final class StoragePublicShareLoading extends StoragePublicShareState {
  const StoragePublicShareLoading();
}

final class StoragePublicShareSuccess extends StoragePublicShareState {
  const StoragePublicShareSuccess(this.fileName);

  final String fileName;

  @override
  List<Object?> get props => [fileName];
}

final class StoragePublicShareFailure extends StoragePublicShareState {
  const StoragePublicShareFailure({required this.message, required this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}
