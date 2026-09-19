import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_repository_impl.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';

/// Composition boundary for the migrated standalone Chat contract.
///
/// Presentation receives only [ChatRepository]. The authenticated HTTP
/// transport and generated Retrofit client never cross into widgets/Cubits.
abstract final class DevPlannerChatRuntime {
  /// Creates a Chat repository only when the session transport can carry the
  /// standalone credentials required by DevPlanner.
  static ChatRepository? fromTransport(DevPlannerHttpTransport? transport) {
    if (transport == null || !transport.supportsStandaloneApiClients) {
      return null;
    }
    return ChatRepositoryImpl(
      ChatApi(transport.apiDio, baseUrl: transport.baseUrl),
    );
  }
}
