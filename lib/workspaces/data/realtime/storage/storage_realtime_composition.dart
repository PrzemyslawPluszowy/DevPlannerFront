import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/realtime/storage/storage_realtime_client_adapter.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';

/// Fabryka kanału zmian plików dla klienta z samodzielnym API.
///
/// Zwraca `null`, gdy transport nie ujawnia tokenu dla SignalR — webowy BFF
/// zostaje bez kanału, dokładnie jak moduł Zadania, bo cookie nie jest tokenem
/// dla huba. Brak kanału nie odbiera ekranowi listy ani odświeżania; wyłącza
/// tylko odświeżenia na żywo.
StorageRealtimeClientFactory? storageRealtimeClientFactory(
  DevPlannerHttpTransport? transport,
) {
  if (transport == null || !transport.supportsStandaloneApiClients) {
    return null;
  }
  final accessTokenProvider = transport.realtimeAccessTokenProvider;
  if (accessTokenProvider == null) return null;
  final url = '${transport.baseUrl}/api/v1/realtime/storage';
  return () => StorageRealtimeClientAdapter(
    WorkspaceSignalRClient(
      url,
      WorkspaceRealtimeCredentials.bearer(accessTokenProvider),
    ),
  );
}
