import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

/// Atrapowy transport izoluje kontrakt SignalR od prawdziwego połączenia.
final class ChatRealtimeTestTransport implements WorkspaceSignalRTransport {
  final BehaviorSubject<WorkspaceSignalRConnectionState> _states =
      BehaviorSubject.seeded(WorkspaceSignalRConnectionState.disconnected);
  final Map<String, MethodInvocationFunc> _handlers =
      <String, MethodInvocationFunc>{};
  final List<(String, List<Object>?)> invocations = <(String, List<Object>?)>[];
  Object? replayResult;
  bool isDisposed = false;

  @override
  Stream<WorkspaceSignalRConnectionState> get states => _states.stream;

  @override
  void on(String methodName, MethodInvocationFunc handler) {
    _handlers[methodName] = handler;
  }

  @override
  Future<void> connect() async {
    _states.add(WorkspaceSignalRConnectionState.connected);
  }

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    invocations.add((methodName, args));
    return methodName == 'GetConversationEvents' ? replayResult : null;
  }

  @override
  Future<void> disconnect() async {
    _states.add(WorkspaceSignalRConnectionState.disconnected);
  }

  @override
  void dispose() {
    isDisposed = true;
    unawaited(_states.close());
  }

  /// Emuluje poprawnie zakończony reconnect tego samego połączenia.
  void reconnect() => _states.add(WorkspaceSignalRConnectionState.connected);

  /// Emuluje stan transportu bez otwierania prawdziwego połączenia SignalR.
  void emitConnectionState(WorkspaceSignalRConnectionState state) =>
      _states.add(state);

  /// Dostarcza rzeczywisty envelope eventu do zarejestrowanej metody huba.
  void emit(String method, Map<String, dynamic> payload) {
    _handlers[method]?.call(<Object?>[payload]);
  }
}

/// Buduje kompletne payloady zgodne z obecnym modelem wygenerowanego API.
abstract final class ChatRealtimeTestPayload {
  /// Tworzy payload create/update z wszystkimi polami wymaganymi przez mapper.
  static Map<String, dynamic> message({
    required String eventId,
    required int sequence,
    String text = 'Treść',
    int version = 1,
  }) => <String, dynamic>{
    'eventId': eventId,
    'sequence': sequence,
    'id': 'message-1',
    'conversationId': 'conversation-1',
    'authorUserId': 'user-1',
    'clientMessageId': 'client-1',
    'text': text,
    'payloadHash': 'HASH',
    'version': version,
    'createdAtUtc': '2026-09-13T10:00:00.000Z',
    'isDeleted': false,
    'isEdited': version > 1,
  };

  /// Tworzy minimalny, udokumentowany envelope usunięcia wiadomości.
  static Map<String, dynamic> deletion({
    required String eventId,
    required int sequence,
  }) => <String, dynamic>{
    'eventId': eventId,
    'sequence': sequence,
    'conversationId': 'conversation-1',
    'messageId': 'message-1',
    'version': 3,
  };

  /// Opakowuje payload jako odpowiedź `GetConversationEvents` backendu.
  static Map<String, dynamic> replay({
    required String eventId,
    required int sequence,
  }) => <String, dynamic>{
    'items': <Object?>[
      <String, dynamic>{
        'eventId': eventId,
        'sequence': sequence,
        'conversationId': 'conversation-1',
        'eventType': 'chat.message.created',
        'payloadJson': '{"id":"message-1","conversationId":"conversation-1","authorUserId":"user-1","clientMessageId":"client-1","text":"Treść","payloadHash":"HASH","version":1,"createdAtUtc":"2026-09-13T10:00:00.000Z","isDeleted":false,"isEdited":false}',
      },
    ],
  };

  /// Opróżnia kolejkę mikro-zadań używaną przez strumienie RxDart.
  static Future<void> flush() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }
}
