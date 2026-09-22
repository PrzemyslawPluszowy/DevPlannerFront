// Żywy test współedycji jednego dokumentu przez dwóch użytkowników.
//
// Sprawdza na uruchomionym stacku: dwie sesje edytora tego samego dokumentu
// (rejestr nie nadpisuje pierwszego edytora), zapis bez jednoznacznego autora
// (wersja powstaje, autorem technicznym jest właściciel, a druga sesja nie
// znika) oraz zapis z jednoznacznym `actions.userid` (autorem jest wskazany
// edytor). Dodatkowo sesja A obserwuje kanał realtime i musi dostać zdarzenie
// nowej wersji, czyli sygnał, po którym odświeża listę.
//
// Plik leży poza `test/`, więc nie wchodzi do domyślnego przebiegu:
//
//   LIVE_BASE=http://127.0.0.1:5073 LIVE_WORKSPACE=<uuid> \\
//   LIVE_TOKEN_A_FILE=/tmp/live/token_a.json LIVE_TOKEN_B_FILE=/tmp/live/token_b.json \\
//   LIVE_ONLYOFFICE_SECRET=change-me-onlyoffice-jwt-secret-min-32-chars \\
//   flutter test test_live/storage_onlyoffice_two_editors_live_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/realtime/storage/storage_realtime_client_adapter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:flutter_test/flutter_test.dart';

final String _base = Platform.environment['LIVE_BASE'] ?? '';
final String _workspaceId = Platform.environment['LIVE_WORKSPACE'] ?? '';
final String _tokenAFile = Platform.environment['LIVE_TOKEN_A_FILE'] ?? '';
final String _tokenBFile = Platform.environment['LIVE_TOKEN_B_FILE'] ?? '';
final String _secret = Platform.environment['LIVE_ONLYOFFICE_SECRET'] ?? '';
final bool _configured = [
  _base,
  _workspaceId,
  _tokenAFile,
  _tokenBFile,
  _secret,
].every((value) => value.isNotEmpty);

void main() {
  test(
    'dwóch edytujących: zapis bez autora i zapis z autorem',
    () async {
      final tokenA = _readToken(_tokenAFile);
      final tokenB = _readToken(_tokenBFile);
      final userA = await _me(tokenA);
      final userB = await _me(tokenB);

      // 0. Sesja A obserwuje kanał zmian, żeby złapać zdarzenie nowej wersji.
      final client = StorageRealtimeClientAdapter(
        WorkspaceSignalRClient(
          '$_base/api/v1/realtime/storage',
          WorkspaceRealtimeCredentials.bearer(() async => tokenA),
        ),
      );
      final events = <StorageRealtimeEvent>[];
      final subscription = client.events.listen(events.add);
      addTearDown(client.dispose);
      await client.start(StorageRealtimeTarget.workspace(_workspaceId));
      await Future<void>.delayed(const Duration(seconds: 2));

      // 1. Dokument biurowy właściciela A.
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final document = await _createDocument(
        token: tokenA,
        body: {
          'name': 'Wspoledycja $stamp',
          'format': 'Docx',
          'module': 'Workspaces',
          'resourceType': 'Document',
          'workspaceId': _workspaceId,
        },
      );
      expect(document.statusCode, 201, reason: document.body);
      final fileId = document.fileId!;

      // 2. Obie sesje otwierają ten sam dokument: ten sam klucz sesji.
      final sessionA = await _openOfficeSession(tokenA, fileId);
      final sessionB = await _openOfficeSession(tokenB, fileId);
      expect(sessionA['documentKey'], sessionB['documentKey']);
      expect(sessionA['canEdit'], isTrue);
      final documentKey = sessionA['documentKey'] as String;

      // 3. Rejestr zna dwa otwarte edytory. Licznika sesji nie odczytamy przez
      // API admina: lokalny token OpenIddict nie niesie claimu `permission`
      // wymaganego przez SuperAdmina (pochodzi z Core). Dlatego stan rejestru
      // rozstrzygamy po autorze zapisu niżej: B otwiera sesję jako drugi, więc
      // przy jednej-sesji-na-dokument autorem zostałby B, a nie właściciel.

      // 4. Serwer treści, z którego backend pobierze „zapisany” dokument.
      // Port stały: backend dopuszcza pobranie tylko z zaufanego adresu
      // OnlyOffice, który w tej instancji wskazuje na ten serwer treści.
      final contentPort =
          int.tryParse(Platform.environment['LIVE_CONTENT_PORT'] ?? '') ?? 8099;
      final server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        contentPort,
      );
      addTearDown(() => server.close(force: true));
      var served = 'wersja 1 z edytora współdzielonego';
      server.listen((request) async {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.text
          ..write(served);
        await request.response.close();
      });
      final contentUrl = 'http://127.0.0.1:${server.port}/doc';

      // 5. Zapis bez jednoznacznego autora: dwie osoby na liście `users`,
      // brak akcji wskazującej autora, więc autor jest nieznany.
      final firstSave = await _callback(
        secret: _secret,
        body: {
          'key': documentKey,
          'status': 6,
          'url': contentUrl,
          'users': [userA, userB],
          'lastsave': '2026-09-20T15:00:00Z',
        },
      );
      expect(firstSave.statusCode, 200, reason: firstSave.body);
      expect(jsonDecode(firstSave.body), {'error': 0});

      var versions = await _versions(tokenA, fileId);
      expect(versions.length, greaterThanOrEqualTo(2));
      final unattributed = versions.firstWhere((item) => item['version'] == 2);
      // Brak atrybucji nie może wskazywać właściciela jako autora: autor jest
      // pusty, a właściciel pozostaje wyłącznie technicznym zapisującym.
      expect(
        unattributed['changedByUserId'],
        isNull,
        reason: 'wieloznaczny zapis nie przypisuje autorstwa',
      );
      expect(
        unattributed['createdByUserId'],
        userA,
        reason: 'właściciel pliku jest technicznym zapisującym',
      );

      // 6. Kolejny zapis z akcją wskazującą edytora B: autor jest jednoznaczny.
      //
      // Zapis wymuszony (status 6) z nowszym `lastsave` kontynuuje tę samą sesję,
      // więc obaj edytorzy nadal mają otwarty dokument. Zapis końcowy (status 2)
      // zamknąłby sesję edytora i dalsze zapisy wymagałyby nowego otwarcia.
      served = 'wersja 2 dopisana przez edytora B';
      final secondSave = await _callback(
        secret: _secret,
        body: {
          'key': documentKey,
          'status': 6,
          'url': contentUrl,
          'users': [userA, userB],
          'lastsave': '2026-09-20T15:05:00Z',
          'actions': [
            {'type': 0, 'userid': userB},
          ],
        },
      );
      expect(secondSave.statusCode, 200, reason: secondSave.body);
      expect(jsonDecode(secondSave.body), {'error': 0});

      versions = await _versions(tokenA, fileId);
      final attributed = versions.firstWhere((item) => item['version'] == 3);
      expect(
        attributed['changedByUserId'],
        userB,
        reason: 'akcja callbacku wskazuje autora zapisu',
      );

      // 8. Dokument nadal się zapisuje po zapisie B: sesja współedycji trwa,
      // więc kolejny zapis bez rozstrzygalnego autora znowu trafia na właściciela.
      served = 'wersja 3 po zapisie B';
      final afterClose = await _callback(
        secret: _secret,
        body: {
          'key': documentKey,
          'status': 6,
          'url': contentUrl,
          'users': [userA, userB],
          'lastsave': '2026-09-20T15:10:00Z',
        },
      );
      expect(afterClose.statusCode, 200, reason: afterClose.body);
      expect(jsonDecode(afterClose.body), {'error': 0});
      versions = await _versions(tokenA, fileId);
      final thirdSave = versions.firstWhere((item) => item['version'] == 4);
      expect(
        thirdSave['changedByUserId'],
        isNull,
        reason: 'kolejny zapis bez autora też nie przypisuje autorstwa',
      );
      expect(thirdSave['createdByUserId'], userA);

      // 7. Sesja A dostała zdarzenie nowej wersji: to sygnał odświeżenia listy.
      final unattributedEvent = await _waitFor(
        events,
        (event) =>
            event.type == StorageRealtimeEventType.versionCreated &&
            event.actorUserId == null,
      );
      expect(
        unattributedEvent,
        isNotNull,
        reason: 'zapis bez ustalonego autora nie ogłasza autora w zdarzeniu',
      );
      final attributedEvent = await _waitFor(
        events,
        (event) =>
            event.type == StorageRealtimeEventType.versionCreated &&
            event.actorUserId == userB,
      );
      expect(
        attributedEvent,
        isNotNull,
        reason: 'zapis z akcją wskazującą B publikuje zdarzenie z autorem B',
      );
      expect(
        events.where(
          (event) => event.type == StorageRealtimeEventType.versionCreated,
        ),
        hasLength(greaterThanOrEqualTo(3)),
        reason: 'każdy zapis z edytora publikuje zdarzenie nowej wersji',
      );

      await subscription.cancel();
    },
    skip: _configured
        ? false
        : 'Brak LIVE_* — żywy test wymaga uruchomionego stacku z OnlyOffice.',
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

String _readToken(String path) =>
    (jsonDecode(File(path).readAsStringSync())
            as Map<String, dynamic>)['access_token']
        as String;

Future<String> _me(String token) async {
  final payload = await _getMap(token, '/api/v1/me');
  return payload['userId'] as String;
}

Future<Map<String, dynamic>> _getMap(String token, String path) async {
  final decoded = await _get(token, path);
  if (decoded is! Map<String, dynamic>) {
    throw StateError(
      'GET $path zwrócił ${decoded.runtimeType}, oczekiwano obiektu.',
    );
  }
  return decoded;
}

Future<Object?> _get(String token, String path) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse('$_base$path'));
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw StateError('GET $path -> ${response.statusCode}: $body');
    }
    return jsonDecode(body);
  } finally {
    client.close(force: true);
  }
}

Future<Map<String, dynamic>> _openOfficeSession(
  String token,
  String fileId,
) => _getMap(token, '/api/v1/storage/files/$fileId/office-session');

Future<List<Map<String, dynamic>>> _versions(
  String token,
  String fileId,
) async {
  final decoded = await _get(token, '/api/v1/storage/files/$fileId/versions');
  if (decoded is! List) {
    throw StateError('Lista wersji nie jest tablicą (${decoded.runtimeType}).');
  }
  return decoded
      .whereType<Map<Object?, Object?>>()
      .map(Map<String, dynamic>.from)
      .toList();
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
      ..set(
        'Idempotency-Key',
        'live-office-${DateTime.now().microsecondsSinceEpoch}',
      )
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

/// Wysyła callback OnlyOffice z podpisanym tokenem, tak jak Document Server.
Future<({int statusCode, String body})> _callback({
  required String secret,
  required Map<String, Object?> body,
}) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(
      Uri.parse('$_base/api/v1/storage/office-callback'),
    );
    request.headers.contentType = ContentType.json;
    request.write(
      jsonEncode({...body, 'token': _signedCallbackToken(secret, body)}),
    );
    final response = await request.close();
    return (
      statusCode: response.statusCode,
      body: await response.transform(utf8.decoder).join(),
    );
  } finally {
    client.close(force: true);
  }
}

/// Mintuje HS256 z ładunkiem callbacku w claimie `payload`, jak OnlyOffice.
String _signedCallbackToken(String secret, Map<String, Object?> body) {
  String encode(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');
  final header = encode(
    utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})),
  );
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final payload = encode(
    utf8.encode(
      jsonEncode({
        'payload': jsonEncode(body),
        'iat': now,
        'exp': now + 300,
      }),
    ),
  );
  final signature = encode(
    Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode('$header.$payload')).bytes,
  );
  return '$header.$payload.$signature';
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
