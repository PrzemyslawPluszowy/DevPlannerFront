import 'package:equatable/equatable.dart';

/// Rodzaj rozmowy tworzonej w globalnym komunikatorze.
enum ChatConversationKind {
  /// Rozmowa 1:1 między dwiema lokalnymi tożsamościami.
  direct('Direct'),

  /// Grupa prywatna od 2 do 50 uczestników.
  group('Group'),

  /// Kanał publikowany przez uprawnionych członków.
  channel('Channel'),

  /// Ogłoszenia publikowane wyłącznie przez Owner/Moderator.
  broadcast('Broadcast');

  const ChatConversationKind(this.wireValue);

  /// Wartość wysyłana do backendu.
  final String wireValue;
}

/// Granica dostępu rozmowy; globalny komunikator używa `global`.
enum ChatConversationScope {
  /// Rozmowa dostępna dla wskazanych lokalnych użytkowników.
  global('Global'),

  /// Kanał istniejący w granicy workspace.
  workspace('Workspace'),

  /// Kanał istniejący w granicy projektu.
  project('Project');

  const ChatConversationScope(this.wireValue);

  /// Wartość wysyłana do backendu.
  final String wireValue;
}

/// Polecenie utworzenia albo rozwiązania rozmowy.
///
/// Polecenie nie zawiera identyfikatorów transportu poza wartościami, które są
/// częścią kontraktu backendu. Backend pozostaje właścicielem kanonicznego
/// klucza rozmowy 1:1, więc UI nie może utworzyć drugiej rozmowy tej samej pary.
final class ChatConversationCreateCommand extends Equatable {
  /// Tworzy polecenie utworzenia rozmowy.
  const ChatConversationCreateCommand({
    required this.kind,
    required this.scope,
    required this.scopeKey,
    this.name,
    this.userIds = const <String>[],
    this.workspaceId,
    this.projectId,
    this.discussionRootMessageId,
    this.postingPermission = 'Everyone',
  });

  final ChatConversationKind kind;
  final ChatConversationScope scope;

  /// Etykieta zakresu; dla rozmów 1:1 backend wylicza klucz pary samodzielnie.
  final String scopeKey;
  final String? name;
  final List<String> userIds;
  final String? workspaceId;
  final String? projectId;
  final String? discussionRootMessageId;

  /// Polityka publikacji wybrana w kreatorze: `Everyone` albo `AdminsOnly`.
  ///
  /// Backend ponownie egzekwuje politykę; pole jedynie przenosi decyzję
  /// użytkownika przez command i adapter do kontraktu transportu.
  final String postingPermission;

  @override
  List<Object?> get props => [
    kind,
    scope,
    scopeKey,
    name,
    userIds,
    workspaceId,
    projectId,
    discussionRootMessageId,
    postingPermission,
  ];
}
