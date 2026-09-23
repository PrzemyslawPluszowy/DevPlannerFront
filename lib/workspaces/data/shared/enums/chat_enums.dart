import 'package:json_annotation/json_annotation.dart';

/// Rodzaj rozmowy Chat.
@JsonEnum()
enum ChatConversationType {
  @JsonValue('Direct')
  direct,
  @JsonValue('Group')
  group,
  @JsonValue('Channel')
  channel,
  @JsonValue('Broadcast')
  broadcast,
  @JsonValue('Discussion')
  discussion,
}

/// Granica dostępu rozmowy Chat.
@JsonEnum()
enum ChatScopeKind {
  @JsonValue('Global')
  global,
  @JsonValue('Workspace')
  workspace,
  @JsonValue('Project')
  project,
  @JsonValue('Resource')
  resource,
}

/// Osobista polityka powiadomień rozmowy.
@JsonEnum()
enum ChatNotificationPreference {
  @JsonValue('All')
  all,
  @JsonValue('MentionsOnly')
  mentionsOnly,
  @JsonValue('Muted')
  muted,
  @JsonValue('HighOnly')
  highOnly,
}

/// Status zaproszenia do rozmowy.
@JsonEnum(fieldRename: FieldRename.pascal)
enum ChatInvitationStatus { pending, accepted, expired, cancelled }

/// Stan dostarczenia wiadomości.
@JsonEnum(fieldRename: FieldRename.pascal)
enum ChatMessageDeliveryStatus { sending, sent, delivered, read, failed }
