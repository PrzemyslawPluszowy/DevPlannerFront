import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';

/// Wysyła bajty wyłącznie pod jednorazowy bilet wygenerowany przez backend.
// ignore: one_member_abstracts
abstract interface class TaskAttachmentUploadTransport {
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
  });
}
