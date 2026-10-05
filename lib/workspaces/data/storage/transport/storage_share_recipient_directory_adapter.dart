import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_share_recipient_directory_port.dart';

/// Ponownie używa bezpiecznego katalogu kont, bez tworzenia własnego HTTP.
final class StorageShareRecipientDirectoryAdapter
    implements StorageShareRecipientDirectoryPort {
  const StorageShareRecipientDirectoryAdapter(this._directory);
  final ChatDirectoryRepository _directory;

  @override
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String query,
  }) => _directory.search(term: query, limit: 20);
}
