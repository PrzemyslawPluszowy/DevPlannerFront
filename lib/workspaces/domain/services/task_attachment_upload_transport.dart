import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';

/// Wysyła bajty wyłącznie pod jednorazowy bilet wygenerowany przez backend.
// ignore: one_member_abstracts
abstract interface class TaskAttachmentUploadTransport {
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
  });
}
