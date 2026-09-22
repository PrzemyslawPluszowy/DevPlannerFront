import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/widgets.dart';

/// Rodzaj źródła rozmowy kontekstowej.
///
/// Rozmowa globalna, rozmowa pliku i rozmowa zadania mają odrębną semantykę
/// i nigdy nie są konwertowane jedna w drugą. Rozróżnienie jest typowane, żeby
/// przyszła integracja nie musiała zgadywać po `scopeKey`.
enum ChatContextSourceKind {
  /// Rozmowa powiązana z plikiem Storage.
  file,

  /// Rozmowa powiązana z zadaniem / kartą Kanbanu.
  task,
}

/// Widok pozycji listy rozmów kontekstowych.
///
/// Model jest gotowy pod przyszły kontrakt listy (tożsamość to
/// `conversationId` + rodzaj źródła + `resourceId`). Do czasu podłączenia API
/// żaden adapter nie tworzy tych pozycji z produkcyjnych danych.
final class ChatContextConversationView {
  /// Tworzy pozycję listy rozmów kontekstowych.
  const ChatContextConversationView({
    required this.conversationId,
    required this.resourceId,
    required this.kind,
    required this.title,
    this.secondaryLabel,
    this.breadcrumb,
    this.lastAuthorLabel,
    this.previewText,
    this.atUtc,
    this.unreadCount = 0,
    this.mentionedMe = false,
    this.sourceAvailable = true,
  });

  final String conversationId;
  final String resourceId;
  final ChatContextSourceKind kind;

  /// Nazwa pliku albo tytuł zadania; nigdy nie jest tożsamością pozycji.
  final String title;

  /// Opcjonalna nazwa rozmowy oraz klucz zadania.
  final String? secondaryLabel;

  /// Kontekst workspace/projekt/tablica.
  final String? breadcrumb;
  final String? lastAuthorLabel;
  final String? previewText;
  final DateTime? atUtc;
  final int unreadCount;

  /// Czy w podglądzie pozycja jest wzmianką o bieżącym użytkowniku.
  final bool mentionedMe;

  /// Czy źródło jest jeszcze dostępne; utrata dostępu daje stan niedostępności.
  final bool sourceAvailable;
}

/// Etykiety rodzaju źródła używane w nagłówku rozmowy i wierszach.
extension ChatContextSourceLabels on ChatContextSourceKind {
  /// Nazwa zakładki i etykieta źródła.
  String label(BuildContext context) => switch (this) {
    ChatContextSourceKind.file => context.l10n.chatPanelSectionFiles,
    ChatContextSourceKind.task => context.l10n.chatPanelSectionTasks,
  };
}
