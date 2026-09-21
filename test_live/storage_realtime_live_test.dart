// Żywy test kanału zmian modułu Pliki na uruchomionym stacku.
//
// Używa prawdziwego klienta (`StorageRealtimeClientAdapter`) i prawdziwego
// transportu SignalR przeciwko działającemu API, więc sprawdza kontrakt
// end-to-end: subskrypcję grupy, zdarzenie live wywołane mutacją innego
// użytkownika oraz odtworzenie historii po ponownym połączeniu.
//
// Plik leży poza `test/`, więc nie wchodzi do domyślnego przebiegu. Uruchamia
// się go jawnie, z tokenami dwóch sesji (patrz dokumentacja pakietu):
//
//   LIVE_BASE=http://127.0.0.1:5073 \
//   LIVE_WORKSPACE=<uuid> LIVE_PROJECT=<uuid> \
//   LIVE_TOKEN_A_FILE=/tmp/live/token_a.json LIVE_TOKEN_B_FILE=/tmp/live/token_b.json \
//   flutter test test_live/storage_realtime_live_test.dart
//
// Bez tych zmiennych test jest pomijany, więc przypadkowe uruchomienie nie
// zgłasza fałszywego sukcesu ani porażki.

import 'dart:convert';
import 'dart:io';

import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/realtime/storage/storage_realtime_client_adapter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:flutter_test/flutter_test.dart';

final String _base = Platform.environment['LIVE_BASE'] ?? '';
final String _workspaceId = Platform.environment['LIVE_WORKSPACE'] ?? '';
final String _projectId = Platform.environment['LIVE_PROJECT'] ?? '';
final String _tokenAFile = Platform.environment['LIVE_TOKEN_A_FILE'] ?? '';
final String _tokenBFile = Platform.environment['LIVE_TOKEN_B_FILE'] ?? '';
final bool _configured = [
  _base,
  _workspaceId,
  _projectId,
  _tokenAFile,
  _tokenBFile,
].every((value) => value.isNotEmpty);

void main() {
  test(
    'dwie sesje: zdarzenie live odświeża listę, historia obejmuje projekt',
    () async {
      final tokenA = _readToken(_tokenAFile);
      final tokenB = _readToken(_tokenBFile);
      final client = StorageRealtimeClientAdapter(
        WorkspaceSignalRClient(
          '$_base/api/v1/realtime/storage',
          () async => tokenA,
        ),
      );
      final events = <StorageRealtimeEvent>[];
      final subscription = client.events.listen(events.add);
      addTearDown(client.dispose);

      // 1. Sesja A podłącza kanał workspace i nadrabia historię.
      await client.start(StorageRealtimeTarget.workspace(_workspaceId));
      await Future<void>.delayed(const Duration(seconds: 2));

      // 2. Mutacja innego użytkownika w tym samym workspace.
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final workspaceDocument = await _createDocument(
        token: tokenB,
        body: {
          'name': 'Live workspace $stamp',
          'format': 'Txt',
          'module': 'Workspaces',
          'resourceType': 'Document',
          'workspaceId': _workspaceId,
        },
      );
      expect(
        workspaceDocument.statusCode,
        201,
        reason: 'B tworzy dokument workspace: ${workspaceDocument.body}',
      );

      final liveEvent = await _waitFor(
        events,
        (event) => event.type == StorageRealtimeEventType.fileCreated,
      );
      expect(
        liveEvent,
        isNotNull,
        reason: 'A ma dostać zdarzenie live po mutacji B',
      );

      // 3. Lista czytana przez A pokazuje ten sam plik: to jest stan, który
      // odświeża widok po zdarzeniu.
      final listing = await _listWorkspaceFiles(token: tokenA);
      expect(
        listing,
        contains(workspaceDocument.fileId),
        reason: 'lista A zawiera dokument utworzony przez B',
      );

      // 4. Rozłączenie A, mutacja w projekcie tego workspace.
      await client.stop();
      events.clear();
      final projectDocument = await _createDocument(
        token: tokenB,
        body: {
          'name': 'Live projekt $stamp',
          'format': 'Txt',
          'module': 'Workspaces',
          'resourceType': 'Project',
          'workspaceId': _workspaceId,
          'projectId': _projectId,
        },
      );
      expect(
        projectDocument.statusCode,
        201,
        reason: 'B tworzy dokument projektowy: ${projectDocument.body}',
      );

      // 5. A wraca: historia workspace musi obejmować zdarzenie projektowe,
      // inaczej klient zostałby ze starą listą po reconnect.
      await client.start(StorageRealtimeTarget.workspace(_workspaceId));
      final catchUp = await _waitFor(
        events,
        (event) =>
            event.isReplay &&
            event.type == StorageRealtimeEventType.fileCreated &&
            event.fileId == projectDocument.fileId,
      );
      expect(
        catchUp,
        isNotNull,
        reason: 'odtworzenie historii workspace obejmuje zdarzenie z projektu',
      );

      // 6. Kanał działa dalej po nadrobieniu.
      events.clear();
      final afterCatchUp = await _createDocument(
        token: tokenB,
        body: {
          'name': 'Live po powrocie $stamp',
          'format': 'Txt',
          'module': 'Workspaces',
          'resourceType': 'Document',
          'workspaceId': _workspaceId,
        },
      );
      expect(afterCatchUp.statusCode, 201, reason: afterCatchUp.body);
      expect(
        await _waitFor(
          events,
          (event) => event.type == StorageRealtimeEventType.fileCreated,
        ),
        isNotNull,
        reason: 'po nadrobieniu kolejne zdarzenie live też dociera',
      );

      await subscription.cancel();
    },
    skip: _configured ? false : 'Brak LIVE_* — żywy test wymaga uruchomionego stacku.',
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

String _readToken(String path) {
  final decoded = jsonDecode(File(path).readAsStringSync());
  return (decoded as Map<String, dynamic>)['access_token'] as String;
}

Future<StorageRealtimeEvent?> _waitFor(
  List<StorageRealtimeEvent> events,
  bool Function(StorageRealtimeEvent) matches, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    for (final event in events) {
      if (matches(event)) return event;
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
  return null;
}

Future<({int statusCode, String body, String? fileId})> _createDocument({
  required String token,
  required Map<String, Object?> body,
}) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(
      Uri.parse('$_base/api/v1/storage/files/create'),
    );
    request.headers
      ..set(HttpHeaders.authorizationHeader, 'Bearer $token')
      // Endpoint tworzenia dokumentu wymaga klucza idempotencji.
      ..set('Idempotency-Key', 'live-check-${DateTime.now().microsecondsSinceEpoch}')
      ..contentType = ContentType.json;
    request.write(jsonEncode(body));
    final response = await request.close();
    final payload = await response.transform(utf8.decoder).join();
    String? fileId;
    try {
      fileId = (jsonDecode(payload) as Map<String, dynamic>)['id'] as String?;
    } catch (_) {
      fileId = null;
    }
    return (statusCode: response.statusCode, body: payload, fileId: fileId);
  } finally {
    client.close(force: true);
  }
}

Future<List<String>> _listWorkspaceFiles({required String token}) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse('$_base/api/v1/storage/files').replace(
      queryParameters: {
        'folderType': 'Workspace',
        'workspaceId': _workspaceId,
        'limit': '50',
      },
    );
    final request = await client.getUrl(uri);
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    final response = await request.close();
    final payload = jsonDecode(await response.transform(utf8.decoder).join());
    final items = (payload as Map<String, dynamic>)['items'] as List<dynamic>;
    return items
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toList();
  } finally {
    client.close(force: true);
  }
}
