import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';

/// Widoczne dane rozmowy wyliczane wyłącznie z bieżącego snapshotu inboxa.
///
/// Brak wpisu w inboxie nie tworzy nazw, awatarów ani uprawnień lokalnie.
final class ChatPanelConversationPresentation {
  const ChatPanelConversationPresentation({
    required this.conversation,
    required this.inboxItem,
  });

  final ChatConversation conversation;
  final ChatInboxItem? inboxItem;

  bool get _isDirect => conversation.type == 'direct';

  /// Etykiety autorów wiadomości; DM nie pokazuje prefiksu autora.
  Map<String, String> get participantLabels {
    final item = inboxItem;
    if (_isDirect || item == null) return const <String, String>{};
    return <String, String>{
      for (final participant in item.participants)
        participant.userId: participant.label,
    };
  }

  /// Nazwy używane przez wskaźnik pisania, także dla rozmówcy DM.
  Map<String, String> get typingParticipantLabels {
    final item = inboxItem;
    if (item == null) return const <String, String>{};
    final participants = _isDirect ? item.otherParticipants : item.participants;
    return <String, String>{
      for (final participant in participants)
        participant.userId: participant.label,
    };
  }

  /// Zdjęcia autorów grupowych wiadomości z ACL-owanego katalogu.
  Map<String, String?> get participantAvatarUrls {
    final item = inboxItem;
    if (_isDirect || item == null) return const <String, String?>{};
    return <String, String?>{
      for (final participant in item.participants)
        participant.userId: participant.avatarUrl,
    };
  }

  /// DM używa profilu drugiego uczestnika, pozostałe rozmowy awatara grupy.
  String? get headerAvatarUserId {
    final others = inboxItem?.otherParticipants;
    return _isDirect && others != null && others.isNotEmpty
        ? others.first.userId
        : null;
  }

  String? get headerAvatarUrl {
    final others = inboxItem?.otherParticipants;
    return _isDirect && others != null && others.isNotEmpty
        ? others.first.avatarUrl
        : null;
  }

  /// Nagłówek DM pokazuje etykietę z directory, nigdy `scopeKey`.
  String? get title {
    final others = inboxItem?.otherParticipants;
    if (!_isDirect || others == null || others.isEmpty) return null;
    return others.map((participant) => participant.label).join(', ');
  }

  int get participantCount =>
      _isDirect ? 0 : (inboxItem?.participantCount ?? 0);

  /// Backend nadal egzekwuje rolę; interfejs nie oferuje niedozwolonego @all.
  bool get mentionAllEnabled {
    final type = conversation.type;
    if (type != 'group' && type != 'channel' && type != 'broadcast') {
      return false;
    }
    final role = inboxItem?.role;
    return role == 'Owner' || role == 'Moderator';
  }
}
