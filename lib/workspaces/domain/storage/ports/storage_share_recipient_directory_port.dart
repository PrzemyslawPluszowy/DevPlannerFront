import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';

/// Odbiorcy udostępnienia z dostępnego zalogowanym katalogu bez adresów e-mail.
/// Nie korzysta z administracyjnego katalogu zaproszeń ani filtra właściciela.
// ignore: one_member_abstracts
abstract interface class StorageShareRecipientDirectoryPort {
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String query,
  });
}
