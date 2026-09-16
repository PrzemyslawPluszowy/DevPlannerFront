import 'package:json_annotation/json_annotation.dart';

/// Rodzaj rozmowy Chat.
@JsonEnum()
enum ChatConversationType { direct, group, channel, broadcast, discussion }

/// Granica dostępu rozmowy Chat.
@JsonEnum()
enum ChatScopeKind { global, workspace, project, resource }

/// Osobista polityka powiadomień rozmowy.
@JsonEnum()
enum ChatNotificationPreference { all, mentionsOnly, muted, highOnly }

/// Status zaproszenia do rozmowy.
@JsonEnum()
enum ChatInvitationStatus { pending, accepted, expired, cancelled }

/// Stan dostarczenia wiadomości.
@JsonEnum()
enum ChatMessageDeliveryStatus { sending, sent, delivered, read, failed }
